From: Julia Lawall <Julia.Lawall@lip6.fr>
Subject: [PATCH 6/10] hpsa: use safer test on the result of find_first_zero_bit
Date: Wed,  4 Jun 2014 11:07:56 +0200
Message-ID: <1401872880-23685-7-git-send-email-Julia.Lawall@lip6.fr>
References: <1401872880-23685-1-git-send-email-Julia.Lawall@lip6.fr>
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1401872880-23685-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
To: "Stephen M. Cameron" <scameron@beardog.cce.hp.com>
Cc: kernel-janitors@vger.kernel.org, "James E.J. Bottomley" <JBottomley@parallels.com>, iss_storagedev@hp.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Find_first_zero_bit considers BITS_PER_LONG bits at a time, and thus may
return a larger number than the maximum position argument if that position
is not a multiple of BITS_PER_LONG.

The semantic match that finds this problem is as follows:
(http://coccinelle.lip6.fr/)

// <smpl>
@@
expression e1,e2,e3;
statement S1,S2;
@@

e1 = find_first_zero_bit(e2,e3)
...
if (e1 
- ==
+ >=
  e3)
S1 else S2
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/scsi/hpsa.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff -u -p a/drivers/scsi/hpsa.c b/drivers/scsi/hpsa.c
--- a/drivers/scsi/hpsa.c
+++ b/drivers/scsi/hpsa.c
@@ -4703,7 +4703,7 @@ static struct CommandList *cmd_alloc(str
 	spin_lock_irqsave(&h->lock, flags);
 	do {
 		i = find_first_zero_bit(h->cmd_pool_bits, h->nr_cmds);
-		if (i == h->nr_cmds) {
+		if (i >= h->nr_cmds) {
 			spin_unlock_irqrestore(&h->lock, flags);
 			return NULL;
 		}
