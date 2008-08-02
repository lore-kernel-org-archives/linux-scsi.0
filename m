From: "Adel Gadllah" <adel.gadllah@gmail.com>
Subject: [PATCH] cmdfilter: clean up sysfs interface
Date: Sat, 2 Aug 2008 15:22:07 +0200
Message-ID: <6cf6b73e0808020622t2165ca0dmdbf60856eb600ad5@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fg-out-1718.google.com ([72.14.220.155]:5557 "EHLO
	fg-out-1718.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753089AbYHBNWJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 2 Aug 2008 09:22:09 -0400
Received: by fg-out-1718.google.com with SMTP id 19so707605fgg.17
        for <linux-scsi@vger.kernel.org>; Sat, 02 Aug 2008 06:22:08 -0700 (PDT)
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org
Cc: Jens Axboe <jens.axboe@oracle.com>, viro@zeniv.linux.org.uk, Matthew Wilcox <matthew@wil.cx>, Peter Jones <pjones@redhat.com>, dougg@torque.net, James.Bottomley@hansenpartnership.com, dan.j.williams@intel.com

This patch adds the user interface as discussed in the "cmd filter
fixes" thread.
This patch depends on the cmdfilter fixes sent by Fujita.
I have done tests with this patch ontop of his patchset and everything
works as expected.

--------------
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

block/cmd-filter.c |   45 +++++++++++++++++++++++++--------------------
 1 files changed, 25 insertions(+), 20 deletions(-)

diff --git a/block/cmd-filter.c b/block/cmd-filter.c
index eec4404..72a6e5e 100644
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
@@ -111,33 +111,38 @@ static ssize_t rcf_writecmds_show(struct
blk_scsi_cmd_filter *filter,
 static ssize_t rcf_cmds_store(struct blk_scsi_cmd_filter *filter,
 			      const char *page, size_t count, int rw)
 {
-	ssize_t ret = 0;
-	unsigned long okbits[BLK_SCSI_CMD_PER_LONG], *target_okbits;
-	int cmd, status, len;
+	unsigned long  *target_okbits;
+	int cmd, status, set;
 	substring_t ss;
+	char *p;

-	memset(&okbits, 0, sizeof(okbits));
+	if (rw == READ)
+		target_okbits = filter->read_ok;
+	else
+		target_okbits = filter->write_ok;
+
+	while ((p = strsep(&page, " ")) != NULL) {
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
-
-		__set_bit(cmd, okbits);
+		if (set)
+			set_bit(cmd, target_okbits);
+		else
+			clear_bit(cmd, target_okbits);
 	}

-	if (rw == READ)
-		target_okbits = filter->read_ok;
-	else
-		target_okbits = filter->write_ok;
-
-	memmove(target_okbits, okbits, sizeof(okbits));
 	return count;
 }
