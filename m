From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: Bug in the scsi_id (0.9 version) utility
Date: Tue, 18 Mar 2008 13:15:37 -0700
Message-ID: <20080318201537.GA23225@us.ibm.com>
References: <alpine.LRH.1.00.0803130824450.30028@ss.netgate.net> <20080314060831.GA18884@linux.vnet.ibm.com> <1205501914.2904.9.camel@localhost.localdomain> <alpine.LRH.1.00.0803171135420.30028@ss.netgate.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from over.ny.us.ibm.com ([32.97.182.150]:52160 "EHLO
	over.ny.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753695AbYCSTb1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Mar 2008 15:31:27 -0400
Content-Disposition: inline
In-Reply-To: <alpine.LRH.1.00.0803171135420.30028@ss.netgate.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: brooks@netgate.net
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Mike Anderson <andmike@linux.vnet.ibm.com>, linux-hotplug@vger.kernel.org, Brian.Fehling@citrix.com, xen@netgate.net, cases.634568.7962_21175.de8b732451@cases.netsuite.com, linux-scsi <linux-scsi@vger.kernel.org>

Hi all ...

On Mon, Mar 17, 2008 at 11:38:41AM -0700, brooks@netgate.net wrote:

>>> That said we are not required to be checking the reserved fields for zero
>>> but in this case we are doing so to work around another device issue.
>>>
>>> Instead of adding yet another device work around to the "if" which
>>> makes it hard to rework the code in the future as you do not know how many
>>> vendor, models are running through certain non compliant checks (i.e. more
>>> than the intend models may exhibit like behavior).
>>>
>>> We possible should look at updating how we handle not compliant behavior.
>>> scsi_id.config is available but that must not be useful in all cases as

Note Mike meant the file /etc/scsi_id.config, this file can already be
used to blacklist devices for scsi_id. But, the scsi_id blacklist doesn't
currently know about the transport or bus type (like USB, FCP, etc), and
relies mainly on SCSI vendor and product names, so USB devices can't be
easily blacklisted.

udev doesn't have problems for scsi_id and USB persistent names as it
won't call scsi_id for USB devices, see the 60-persistent-storage.rules

[btw it looks like a failure in usb_id would allow scsi_id to be called
for udev.]

>>> the standard page 83 code has a check for the pre-spc3-83 case even though
>>> it is selectable through the config file and command line.

In hindsight that sucks here :-( we probably should have (somehow) made it
use a black list. AFAIR the issue is that the vendor + product (AFAIR
it's always EMC Symmetrix ... Mike as you know that all too well!) is the
same for EMC devices that give different behaviour.

>> Some type of blacklist might work: we're already starting to find USB
>> devices that aren't too happy with VPD inquiries.

Per above comment, udev should be OK. For other users (like multipath) it
would be simplest if they do not call scsi_id at all for USB devices, and
then (hopefully not for multipath!) have white lists for properly
functioning USB devices 

> That makes sense.  Please let me know what you decide, and if there's 
> anything more I can do to help.

Best is if you can get the device fixed ;-)

If you can't get a fix, something like the following should be OK.
Actually this is probably nice anyway, in case other devices hit the
issue. [I think someone else reported this problem some time ago ...]

With this, you would have to run your device with -p 0x83 (manually for
testing, and then eventually via some blacklist rules, assuming page 0x83
works correctly for the device), and then that blacklist rule will live
on forever ...

Also note that the version id in scsi_id has not been maintained, you need
to specify the udev version for people to know what version you're using.

Untested patch (and not easy to properly test without the actual borken
device) on top of current udev git view:

--- git-udev/extras/scsi_id/scsi_serial.c	2008-03-18 09:24:46.000000000 -0700
+++ udev/extras/scsi_id/scsi_serial.c	2008-03-18 12:16:38.000000000 -0700
@@ -544,7 +544,8 @@ static int check_fill_0x83_prespc3(struc
 
 /* Get device identification VPD page */
 static int do_scsi_page83_inquiry(struct sysfs_device *dev_scsi, int fd,
-				  char *serial, char *serial_short, int len)
+				  char *serial, char *serial_short, int len,
+				  int page_code)
 {
 	int retval;
 	unsigned int id_ind, j;
@@ -590,7 +591,7 @@ static int do_scsi_page83_inquiry(struct
 	 * 0x006048.
 	 */
 	
-	if (page_83[6] != 0) 
+	if ((page_code == 0x00) && (page_83[6] != 0))
 		return check_fill_0x83_prespc3(dev_scsi, page_83, id_search_list,
 					       serial, serial_short, len);
 
@@ -793,7 +794,7 @@ int scsi_get_serial (struct sysfs_device
 			goto completed;
 		}
 	} else if (page_code == PAGE_83) {
-		if (do_scsi_page83_inquiry(dev_scsi, fd, serial, serial_short, len)) {
+		if (do_scsi_page83_inquiry(dev_scsi, fd, serial, serial_short, len, page_code)) {
 			retval = 1;
 			goto completed;
 		} else  {
@@ -809,7 +810,7 @@ int scsi_get_serial (struct sysfs_device
 			 * conform to pre-SPC3 expectations.
 			 */
 			if (retval == 2) {
-				if (do_scsi_page83_inquiry(dev_scsi, fd, serial, serial_short, len)) {
+				if (do_scsi_page83_inquiry(dev_scsi, fd, serial, serial_short, len, 0x00)) {
 					retval = 1;
 					goto completed;
 				} else  {
@@ -849,7 +850,8 @@ int scsi_get_serial (struct sysfs_device
 	for (ind = 4; ind <= page0[3] + 3; ind++)
 		if (page0[ind] == PAGE_83)
 			if (!do_scsi_page83_inquiry(dev_scsi, fd,
-						    serial, serial_short, len)) {
+						    serial, serial_short,
+						    len, 0x00)) {
 				/*
 				 * Success
 				 */
