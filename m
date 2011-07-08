From: Nao Nishijima <nao.nishijima.xt@hitachi.com>
Subject: [RFC PATCH 3/4] fs: modify disk_name() for alias name
Date: Fri, 08 Jul 2011 17:46:16 +0900
Message-ID: <20110708084616.2091.69243.stgit@ltc197.sdl.hitachi.co.jp>
References: <20110708084547.2091.55262.stgit@ltc197.sdl.hitachi.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail4.hitachi.co.jp ([133.145.228.5]:39651 "EHLO
	mail4.hitachi.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754072Ab1GHIqe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Jul 2011 04:46:34 -0400
In-Reply-To: <20110708084547.2091.55262.stgit@ltc197.sdl.hitachi.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, kay.sievers@vrfy.org, jcm@redhat.com, greg@kroah.com, dle-develop@lists.sourceforge.net, Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>, yrl.pp-manager.tt@hitachi.com, dgilbert@interlog.com, stefanr@s5r6.in-berlin.de, hare@suse.de, Nao Nishijima <nao.nishijima.xt@hitachi.com>

Make disk_name() return alais_name instead of disk_name when alias_name is set.
disk_name() is used in /proc/{partitions, diskstats}. Therefore, those files
show alias_name.

Signed-off-by: Nao Nishijima <nao.nishijima.xt@hitachi.com>
Reviewed-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
---

 Documentation/ABI/testing/sysfs-block |    8 ++++----
 fs/partitions/check.c                 |    6 +++---
 2 files changed, 7 insertions(+), 7 deletions(-)

diff --git a/Documentation/ABI/testing/sysfs-block b/Documentation/ABI/testing/sysfs-block
index 07c4fcd..432140c 100644
--- a/Documentation/ABI/testing/sysfs-block
+++ b/Documentation/ABI/testing/sysfs-block
@@ -217,7 +217,7 @@ Description:
 		instead of raw device name. However, kernel doesn't show those
 		persistent names on its message (e.g. dmesg).
 		This file can store an alias name of the disk and it would be
-		appeared in kernel messages if it is set. A disk can have an
-		alias name which length is up to 255bytes. Users can use
-		use alphabets, numbers, "-" and "_" in alias name and can
-		change it anytime.
+		appeared in kernel messages and procfs if it is set. A disk
+		can have an alias name which length is up to 255bytes. Users
+		can use use alphabets, numbers, "-" and "_" in alias name and
+		can change it anytime.
diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index d545e97..d0bfe56 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -125,11 +125,11 @@ static int (*check_part[])(struct parsed_partitions *) = {
 char *disk_name(struct gendisk *hd, int partno, char *buf)
 {
 	if (!partno)
-		snprintf(buf, BDEVNAME_SIZE, "%s", hd->disk_name);
+		snprintf(buf, BDEVNAME_SIZE, "%s", alias_name(hd));
 	else if (isdigit(hd->disk_name[strlen(hd->disk_name)-1]))
-		snprintf(buf, BDEVNAME_SIZE, "%sp%d", hd->disk_name, partno);
+		snprintf(buf, BDEVNAME_SIZE, "%sp%d", alias_name(hd), partno);
 	else
-		snprintf(buf, BDEVNAME_SIZE, "%s%d", hd->disk_name, partno);
+		snprintf(buf, BDEVNAME_SIZE, "%s%d", alias_name(hd), partno);
 
 	return buf;
 }

