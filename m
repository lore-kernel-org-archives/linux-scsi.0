From: james.smart@avagotech.com (James Smart)
Subject: [PATCH 04/14] lpfc: Destroy lpfc_hba_index IDR on module exit
Date: Mon, 31 Aug 2015 16:48:11 -0400
Message-ID: <55e4bd8b.S1L7J0rkKcaxN5EV%james.smart@avagotech.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f169.google.com ([209.85.220.169]:34378 "EHLO
	mail-qk0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751631AbbHaUs1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 31 Aug 2015 16:48:27 -0400
Received: by qkct7 with SMTP id t7so16740880qkc.1
        for <linux-scsi@vger.kernel.org>; Mon, 31 Aug 2015 13:48:27 -0700 (PDT)
Received: from myfc17 (c-75-67-235-135.hsd1.nh.comcast.net. [75.67.235.135])
        by smtp.gmail.com with ESMTPSA id 197sm9429605qhc.49.2015.08.31.13.48.25
        for <linux-scsi@vger.kernel.org>
        (version=TLSv1 cipher=RC4-SHA bits=128/128);
        Mon, 31 Aug 2015 13:48:25 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org


From: Johannes Thumshirn <jthumshirn@suse.de>

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
Signed-off-by: James Smart <james.smart@avagotech.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
---
 drivers/scsi/lpfc/lpfc_init.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/scsi/lpfc/lpfc_init.c b/drivers/scsi/lpfc/lpfc_init.c
index 81bfb2d..eaf121a 100644
--- a/drivers/scsi/lpfc/lpfc_init.c
+++ b/drivers/scsi/lpfc/lpfc_init.c
@@ -11476,6 +11476,7 @@ lpfc_exit(void)
 		free_pages((unsigned long)_dump_buf_dif, _dump_buf_dif_order);
 	}
 	kfree(lpfc_used_cpu);
+	idr_destroy(&lpfc_hba_index);
 }
 
 module_init(lpfc_init);
-- 
1.7.11.7

