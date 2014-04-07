From: Andy Grover <agrover@redhat.com>
Subject: [PATCH] target/tcm_fc: Fix use-after-free of ft_tpg
Date: Mon,  7 Apr 2014 12:11:44 -0700
Message-ID: <1396897904-20306-1-git-send-email-agrover@redhat.com>
References: <1396825176.31010.5.camel@haakon3.risingtidesystems.com>
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1396825176.31010.5.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: target-devel@vger.kernel.org
Cc: linux-scsi@vger.kernel.org, fcoe-devel@open-fcoe.org
List-Id: linux-scsi@vger.kernel.org

This can happen:

- lport created, tport (our per-lport, per-provider context) is allocated.
  tport->tpg = NULL
- tpg created
- a PRLI is received. ft_tport_create is called, tpg is found and
  tport->tpg is set
- tpg removed. ft_tpg is freed in ft_del_tpg. Since tpg->tport was not
  set, tport->tpg is not cleared and points at freed memory
- Future calls to ft_tport_create return tport via first conditional,
  instead of searching for new tpg by calling ft_lport_find_tpg.
  tport->tpg is still invalid, and will access freed memory.

This patch sets tpg->tport in ft_tport_create, because that's what
ft_del_tpg checks, and is the only way to get back to the tport to
clear tport->tpg.

see https://bugzilla.redhat.com/show_bug.cgi?id=1071340

Cc: stable@vger.kernel.org
Signed-off-by: Andy Grover <agrover@redhat.com>
---
 drivers/target/tcm_fc/tfc_sess.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/target/tcm_fc/tfc_sess.c b/drivers/target/tcm_fc/tfc_sess.c
index 0475142..1329726 100644
--- a/drivers/target/tcm_fc/tfc_sess.c
+++ b/drivers/target/tcm_fc/tfc_sess.c
@@ -68,6 +68,7 @@ static struct ft_tport *ft_tport_create(struct fc_lport *lport)
 
 	if (tport) {
 		tport->tpg = tpg;
+		tpg->tport = tport;
 		return tport;
 	}
 
-- 
1.9.0
