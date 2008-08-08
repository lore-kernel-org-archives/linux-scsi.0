From: "Adel Gadllah" <adel.gadllah@gmail.com>
Subject: [PATCH v3] cmdfilter: clean up sysfs interface
Date: Fri, 8 Aug 2008 20:46:55 +0200
Message-ID: <6cf6b73e0808081146n42a2b59bm1a55cc5f0cef41bb@mail.gmail.com>
References: <6cf6b73e0808020819x4501aa1cud4e6c3c9ae77558b@mail.gmail.com>
	 <20080808160629H.fujita.tomonori@lab.ntt.co.jp>
	 <6cf6b73e0808080047i550f2e6bt71d4e213f81fea87@mail.gmail.com>
	 <20080808174508Z.fujita.tomonori@lab.ntt.co.jp>
	 <6cf6b73e0808080505v5989bd3bm7beedea2b443bc55@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rv-out-0506.google.com ([209.85.198.239]:45138 "EHLO
	rv-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185AbYHHSq4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Aug 2008 14:46:56 -0400
Received: by rv-out-0506.google.com with SMTP id k40so1164729rvb.1
        for <linux-scsi@vger.kernel.org>; Fri, 08 Aug 2008 11:46:56 -0700 (PDT)
In-Reply-To: <6cf6b73e0808080505v5989bd3bm7beedea2b443bc55@mail.gmail.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org, jens.axboe@oracle.com, viro@zeniv.linux.org.uk, matthew@wil.cx, pjones@redhat.com, dougg@torque.net, James.Bottomley@hansenpartnership.com, dan.j.williams@intel.com

v3 clean up parsing.

-----------------------------------

This patch changes the interface of the cmd filter to use a +/- notation like:
echo -- +0x02 +0x03 -0x08
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

 block/cmd-filter.c |   53 ++++++++++++++++++++++++++++++---------------------
 1 files changed, 31 insertions(+), 22 deletions(-)

diff --git a/block/cmd-filter.c b/block/cmd-filter.c
index eec4404..f838d04 100644
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
@@ -111,32 +111,41 @@ static ssize_t rcf_writecmds_show(struct
blk_scsi_cmd_filter *filter,
 static ssize_t rcf_cmds_store(struct blk_scsi_cmd_filter *filter,
 			      const char *page, size_t count, int rw)
 {
-	ssize_t ret = 0;
 	unsigned long okbits[BLK_SCSI_CMD_PER_LONG], *target_okbits;
-	int cmd, status, len;
-	substring_t ss;
-
-	memset(&okbits, 0, sizeof(okbits));
-
-	for (len = strlen(page); len > 0; len -= 3) {
-		if (len < 2)
-			break;
-		ss.from = (char *) page + ret;
-		ss.to = (char *) page + ret + 2;
-		ret += 3;
-		status = match_hex(&ss, &cmd);
+	int cmd, set;
+	char *p, *status;
+
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
+
+		if (p[0] == '+')
+			p++;
+
+		cmd = simple_strtol(p, &status, 16);
+
 		/* either of these cases means invalid input, so do nothing. */
-		if (status || cmd >= BLK_SCSI_MAX_CMDS)
+		if ((status == p) || cmd >= BLK_SCSI_MAX_CMDS)
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
