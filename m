From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: [PATCH] lpfc: Destroy lpfc_hba_index IDR on module exit
Date: Wed,  8 Jul 2015 17:19:57 +0200
Message-ID: <1436368797-30934-1-git-send-email-jthumshirn@suse.de>
Return-path: <linux-kernel-owner@vger.kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
To: James Smart <james.smart@avagotech.com>, Dick Kennedy <dick.kennedy@avagotech.com>, "James E.J. Bottomley" <JBottomley@odin.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Johannes Thumshirn <jthumshirn@suse.de>
List-Id: linux-scsi@vger.kernel.org

Destroy lpfc_hba_index IDR on module exit, reclaiming the allocated memory.

This was detected by the following semantic patch (written by Luis Rodriguez
<mcgrof@suse.com>)
<SmPL>
@ defines_module_init @
declarer name module_init, module_exit;
declarer name DEFINE_IDR;
identifier init;
@@

module_init(init);

@ defines_module_exit @
identifier exit;
@@

module_exit(exit);

@ declares_idr depends on defines_module_init && defines_module_exit @
identifier idr;
@@

DEFINE_IDR(idr);

@ on_exit_calls_destroy depends on declares_idr && defines_module_exit @
identifier declares_idr.idr, defines_module_exit.exit;
@@

exit(void)
{
 ...
 idr_destroy(&idr);
 ...
}

@ missing_module_idr_destroy depends on declares_idr && defines_module_exit && !on_exit_calls_destroy @
identifier declares_idr.idr, defines_module_exit.exit;
@@

exit(void)
{
 ...
 +idr_destroy(&idr);
}
</SmPL>

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/lpfc/lpfc_init.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index f962118..4bedb06 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -11477,6 +11477,7 @@ lpfc_exit(void)
 		free_pages((unsigned long)_dump_buf_dif, _dump_buf_dif_order);
 	}
 	kfree(lpfc_used_cpu);
+	idr_destroy(&lpfc_hba_index);
 }
 
 module_init(lpfc_init);
-- 
2.4.3
