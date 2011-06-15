From: Nao Nishijima <nao.nishijima.xt@hitachi.com>
Subject: [PATCH 3/3] [RFC] fs: print preferred name in procfs messages
Date: Wed, 15 Jun 2011 17:16:42 +0900
Message-ID: <20110615081642.2237.53583.stgit@ltc233.sdl.hitachi.co.jp>
References: <20110615081610.2237.44767.stgit@ltc233.sdl.hitachi.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20110615081610.2237.44767.stgit@ltc233.sdl.hitachi.co.jp>
Sender: linux-kernel-owner@vger.kernel.org
To: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: James.Bottomley@HansenPartnership.com, greg@kroah.com, kay.sievers@vrfy.org, jcm@redhat.com, hare@suse.de, stefanr@s5r6.in-berlin.de, yrl.pp-manager.tt@hitachi.com, Nao Nishijima <nao.nishijima.xt@hitachi.com>
List-Id: linux-scsi@vger.kernel.org

Make disk_name() return preferred name instead of disk_name
when preferred name is set. disk_name() is used in
/proc/{partitions, diskstats}. Therefore, those files show
preferred name.

Suggested-by: James Bottomley <James.Bottomley@HansenPartnership.com>
Signed-off-by: Nao Nishijima <nao.nishijima.xt@hitachi.com>
---

 fs/partitions/check.c |    8 +++++---
 1 files changed, 5 insertions(+), 3 deletions(-)

diff --git a/fs/partitions/check.c b/fs/partitions/check.c
index d545e97..4ffdcf4 100644
--- a/fs/partitions/check.c
+++ b/fs/partitions/check.c
@@ -125,11 +125,13 @@ static int (*check_part[])(struct parsed_partitions *) = {
 char *disk_name(struct gendisk *hd, int partno, char *buf)
 {
 	if (!partno)
-		snprintf(buf, BDEVNAME_SIZE, "%s", hd->disk_name);
+		snprintf(buf, BDEVNAME_SIZE, "%s", dev_name(disk_to_dev(hd)));
 	else if (isdigit(hd->disk_name[strlen(hd->disk_name)-1]))
-		snprintf(buf, BDEVNAME_SIZE, "%sp%d", hd->disk_name, partno);
+		snprintf(buf, BDEVNAME_SIZE, "%sp%d", dev_name(disk_to_dev(hd)),
+			partno);
 	else
-		snprintf(buf, BDEVNAME_SIZE, "%s%d", hd->disk_name, partno);
+		snprintf(buf, BDEVNAME_SIZE, "%s%d", dev_name(disk_to_dev(hd)),
+			partno);
 
 	return buf;
 }
