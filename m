From: "Adel Gadllah" <adel.gadllah@gmail.com>
Subject: [PATCH v2] cmdfilter: clean up sysfs interface
Date: Sat, 2 Aug 2008 17:19:18 +0200
Message-ID: <6cf6b73e0808020819x4501aa1cud4e6c3c9ae77558b@mail.gmail.com>
References: <6cf6b73e0808020622t2165ca0dmdbf60856eb600ad5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.153]:35119 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751057AbYHBPTV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 2 Aug 2008 11:19:21 -0400
Received: by fg-out-1718.google.com with SMTP id 19so720722fgg.17
        for <linux-scsi@vger.kernel.org>; Sat, 02 Aug 2008 08:19:18 -0700 (PDT)
In-Reply-To: <6cf6b73e0808020622t2165ca0dmdbf60856eb600ad5@mail.gmail.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>, viro@zeniv.linux.org.uk, Matthew Wilcox <matthew@wil.cx>, Peter Jones <pjones@redhat.com>, dougg@torque.net, James.Bottomley@hansenpartnership.com, dan.j.williams@intel.com

vs fix error handling and compiler warnings

----------------

This patch changes the interface of the cmd filter to use a +/- notation like
echo -- +0x02 +0x03 -0x08 .
If neither + or - is given it defaults to + (allow command).

Note: The interface was added in 2.6.17-rc1 and is unused
and undocumented so far so it's safe to change it.

Cc: matthew@wil.cx
Cc: fujita.tomonori@lab.ntt.co.jp,
Cc: jens.axboe@oracle.com
Cc: James.Bottomley@hansenpartnership.com
Cc: dan.j.williams@intel.com
Cc: pjones@redhat.com
Cc: viro@zeniv.linux.org.uk
Cc: dougg@torque.net
Signed-off-by: Adel Gadllah <adel.gadllah@gmail.com>

 block/cmd-filter.c |   44 +++++++++++++++++++++++++++-----------------
 1 files changed, 27 insertions(+), 17 deletions(-)

diff --git a/block/cmd-filter.c b/block/cmd-filter.c
index eec4404..cd33f7f 100644
--- a/block/cmd-filter.c
+++ b/block/cmd-filter.c
@@ -84,8 +84,8 @@ static ssize_t rcf_cmds_show(struct
blk_scsi_cmd_filter *filter, char *page,

 	for (i = 0; i < BLK_SCSI_MAX_CMDS; i++) {
 		if (test_bit(i, okbits)) {
-			sprintf(npage, "%02x", i);
-			npage += 2;
+			sprintf(npage, "0x%02x", i);
+			npage += 4;
 			if (i < BLK_SCSI_MAX_CMDS - 1)
 				sprintf(npage++, " ");
 		}
@@ -111,32 +111,42 @@ static ssize_t rcf_writecmds_show(struct
blk_scsi_cmd_filter *filter,
 static ssize_t rcf_cmds_store(struct blk_scsi_cmd_filter *filter,
 			      const char *page, size_t count, int rw)
 {
-	ssize_t ret = 0;
 	unsigned long okbits[BLK_SCSI_CMD_PER_LONG], *target_okbits;
-	int cmd, status, len;
+	int cmd, status, set;
 	substring_t ss;
+	char *p;

-	memset(&okbits, 0, sizeof(okbits));
+	if (rw == READ) {
+		memcpy(&okbits, filter->read_ok, sizeof(okbits));
+		target_okbits = filter->read_ok;
+	} else {
+		memcpy(&okbits, filter->write_ok, sizeof(okbits));
+		target_okbits = filter->write_ok;
+	}
+
+	while ((p = strsep((char **)&page, " ")) != NULL) {
+		set = 1;
+
+		if (p[0] == '-') {
+			set = 0;
+			p++;
+		}

-	for (len = strlen(page); len > 0; len -= 3) {
-		if (len < 2)
-			break;
-		ss.from = (char *) page + ret;
-		ss.to = (char *) page + ret + 2;
-		ret += 3;
+		if (p[0] == '+')
+			p++;
+		ss.from = (char *) p;
+		ss.to = (char *) p + 4;
 		status = match_hex(&ss, &cmd);
 		/* either of these cases means invalid input, so do nothing. */
 		if (status || cmd >= BLK_SCSI_MAX_CMDS)
 			return -EINVAL;

-		__set_bit(cmd, okbits);
+		if (set)
+			__set_bit(cmd, okbits);
+		else
+			__clear_bit(cmd, okbits);
 	}

-	if (rw == READ)
-		target_okbits = filter->read_ok;
-	else
-		target_okbits = filter->write_ok;
-
 	memmove(target_okbits, okbits, sizeof(okbits));
 	return count;
 }
