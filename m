From: Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 2/2] SCSI: fix bug in scsi_dev_info_list matching
Date: Mon, 3 Aug 2015 11:57:29 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1508031144150.1667-100000@iolanthe.rowland.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from iolanthe.rowland.org ([192.131.102.54]:43524 "HELO
	iolanthe.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753319AbbHCP5a (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Aug 2015 11:57:30 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Giulio Bernardi <ugilio@gmail.com>, SCSI development list <linux-scsi@vger.kernel.org>

The "compatible" matching algorithm used for looking up old-style
blacklist entries in a scsi_dev_info_list is buggy.  The core of the
algorithm looks like this:

		if (memcmp(devinfo->vendor, vendor,
			    min(max, strlen(devinfo->vendor))))
			/* not a match */

where max is the length of the device's vendor string after leading
spaces have been removed but trailing spaces have not.  Because of the
min() computation, either entry could be a proper substring of the
other and the code would still think that they match.

In the case originally reported, the device's vendor and product
strings were "Inateck " and "                ".  These matched against
the following entry in the global device list:

	{"", "Scanner", "1.80", BLIST_NOLUN}

because "" is a substring of "Inateck " and "" (the result of removing
leading spaces from the device's product string) is a substring of
"Scanner".  The mistaken match prevented the system from scanning and
finding the device's second Logical Unit.

This patch fixes the problem by making two changes.  First, the code
for leading-space removal is hoisted out of the loop.  (This means it
will sometimes run unnecessarily, but since a large percentage of all
lookups involve the "compatible" entries in global device list, this
should be an overall improvement.)  Second and more importantly, the
patch removes trailing spaces and adds a check to verify that the two
resulting strings are exactly the same length.  This prevents matches
where one entry is a proper substring of the other.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Reported-by: Giulio Bernardi <ugilio@gmail.com>
Tested-by: Giulio Bernardi <ugilio@gmail.com>

---


[as1783]


 drivers/scsi/scsi_devinfo.c |   69 ++++++++++++++++++++++----------------------
 1 file changed, 35 insertions(+), 34 deletions(-)

Index: usb-4.2/drivers/scsi/scsi_devinfo.c
===================================================================
--- usb-4.2.orig/drivers/scsi/scsi_devinfo.c
+++ usb-4.2/drivers/scsi/scsi_devinfo.c
@@ -407,51 +407,52 @@ static struct scsi_dev_info_list *scsi_d
 	struct scsi_dev_info_list *devinfo;
 	struct scsi_dev_info_list_table *devinfo_table =
 		scsi_devinfo_lookup_by_key(key);
+	size_t vmax, mmax;
+	const char *vskip, *mskip;
 
 	if (IS_ERR(devinfo_table))
 		return (struct scsi_dev_info_list *) devinfo_table;
 
+	/* Prepare for "compatible" matches */
+
+	/*
+	 * XXX why skip leading spaces? If an odd INQUIRY
+	 * value, that should have been part of the
+	 * scsi_static_device_list[] entry, such as "  FOO"
+	 * rather than "FOO". Since this code is already
+	 * here, and we don't know what device it is
+	 * trying to work with, leave it as-is.
+	 */
+	vmax = 8;	/* max length of vendor */
+	vskip = vendor;
+	while (vmax > 0 && *vskip == ' ') {
+		vmax--;
+		vskip++;
+	}
+	/* Also skip trailing spaces */
+	while (vmax > 0 && vskip[vmax - 1] == ' ')
+		--vmax;
+
+	mmax = 16;	/* max length of model */
+	mskip = model;
+	while (mmax > 0 && *mskip == ' ') {
+		mmax--;
+		mskip++;
+	}
+	while (mmax > 0 && mskip[mmax - 1] == ' ')
+		--mmax;
+
 	list_for_each_entry(devinfo, &devinfo_table->scsi_dev_info_list,
 			    dev_info_list) {
 		if (devinfo->compatible) {
 			/*
 			 * Behave like the older version of get_device_flags.
 			 */
-			size_t max;
-			/*
-			 * XXX why skip leading spaces? If an odd INQUIRY
-			 * value, that should have been part of the
-			 * scsi_static_device_list[] entry, such as "  FOO"
-			 * rather than "FOO". Since this code is already
-			 * here, and we don't know what device it is
-			 * trying to work with, leave it as-is.
-			 */
-			max = 8;	/* max length of vendor */
-			while ((max > 0) && *vendor == ' ') {
-				max--;
-				vendor++;
-			}
-			/*
-			 * XXX removing the following strlen() would be
-			 * good, using it means that for a an entry not in
-			 * the list, we scan every byte of every vendor
-			 * listed in scsi_static_device_list[], and never match
-			 * a single one (and still have to compare at
-			 * least the first byte of each vendor).
-			 */
-			if (memcmp(devinfo->vendor, vendor,
-				    min(max, strlen(devinfo->vendor))))
+			if (memcmp(devinfo->vendor, vskip, vmax) ||
+					devinfo->vendor[vmax])
 				continue;
-			/*
-			 * Skip spaces again.
-			 */
-			max = 16;	/* max length of model */
-			while ((max > 0) && *model == ' ') {
-				max--;
-				model++;
-			}
-			if (memcmp(devinfo->model, model,
-				   min(max, strlen(devinfo->model))))
+			if (memcmp(devinfo->model, mskip, mmax) ||
+					devinfo->model[mmax])
 				continue;
 			return devinfo;
 		} else {

