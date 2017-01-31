From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: scsi: BUG in scsi_init_io
Date: Tue, 31 Jan 2017 10:20:48 +0100
Message-ID: <20170131092048.GB3687@linux-x5ow.site>
References: <CACT4Y+YAX_SmwzsHenzkswM0kp=om5NivmLW8d9Js6EN3zKmGQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CACT4Y+YAX_SmwzsHenzkswM0kp=om5NivmLW8d9Js6EN3zKmGQ@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Dmitry Vyukov <dvyukov@google.com>
Cc: jejb@linux.vnet.ibm.com, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Al Viro <viro@zeniv.linux.org.uk>, syzkaller <syzkaller@googlegroups.com>, Hannes Reinecke <hare@suse.de>
List-Id: linux-scsi@vger.kernel.org

On Tue, Jan 31, 2017 at 09:55:52AM +0100, Dmitry Vyukov wrote:
> Hello,
> 
> The following program triggers BUG in scsi_init_io:

Well crashing a machine just because of an empty dma transfer is a bit harsh,
isn't it?

>From 86e6fa5f618fe588b98e923e032f33e075fcd4f4 Mon Sep 17 00:00:00 2001
From: Johannes Thumshirn <jthumshirn@suse.de>
Date: Tue, 31 Jan 2017 10:16:00 +0100
Subject: [PATCH] scsi: don't BUG_ON() empty DMA transfers

Don't crash the machine just because of an empty transfer. Use WARN_ON()
combined with returning an error.

Signed-off-by: Johannes Thumshirn <jthumshirn@suse.de>
---
 drivers/scsi/scsi_lib.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index e9e1e14..414588a 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1040,7 +1040,8 @@ int scsi_init_io(struct scsi_cmnd *cmd)
 	bool is_mq = (rq->mq_ctx != NULL);
 	int error;
 
-	BUG_ON(!blk_rq_nr_phys_segments(rq));
+	if (WARN_ON(!blk_rq_nr_phys_segments(rq)))
+		return -EINVAL;
 
 	error = scsi_init_sgtable(rq, &cmd->sdb);
 	if (error)
-- 
2.10.2


-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
