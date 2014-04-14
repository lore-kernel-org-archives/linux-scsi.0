From: Christoph Hellwig <hch@infradead.org>
Subject: Re: 3.15-mw:  Oops Workqueue: writeback bdi_writeback_workfn
 (flush-8:16)  RIP: e030:[<ffffffff814c6bc1>]  [<ffffffff814c6bc1>]
 kobject_put+0x11/0x70
Date: Mon, 14 Apr 2014 04:30:15 -0700
Message-ID: <20140414113015.GA4765@infradead.org>
References: <1299097701.20140412133431@eikelenboom.it>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1299097701.20140412133431@eikelenboom.it>
Sender: linux-kernel-owner@vger.kernel.org
To: Sander Eikelenboom <linux@eikelenboom.it>
Cc: linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sat, Apr 12, 2014 at 01:34:31PM +0200, Sander Eikelenboom wrote:
> Hi,
> 
> I just ran into the oops belowafter some uptime.

Classic use after free introduced by my recent changes, sorry.

This should fix it:

---
From: Christoph Hellwig <hch@lst.de>
Subject: scsi: don't reference freed command in scsi_init_sgtable

When scsi_init_io fails we have to release our device reference, but
we do this trying to reference the just freed command.  Add a local
scsi_device pointer to fix this.

Reported-by: Sander Eikelenboom <linux@eikelenboom.it>
Signed-off-by: Christoph Hellwig <hch@lst.de>

diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
index 65a123d..54eff6a 100644
--- a/drivers/scsi/scsi_lib.c
+++ b/drivers/scsi/scsi_lib.c
@@ -1044,6 +1044,7 @@ static int scsi_init_sgtable(struct request *req, struct scsi_data_buffer *sdb,
  */
 int scsi_init_io(struct scsi_cmnd *cmd, gfp_t gfp_mask)
 {
+	struct scsi_device *sdev = cmd->device;
 	struct request *rq = cmd->request;
 
 	int error = scsi_init_sgtable(rq, &cmd->sdb, gfp_mask);
@@ -1091,7 +1092,7 @@ err_exit:
 	scsi_release_buffers(cmd);
 	cmd->request->special = NULL;
 	scsi_put_command(cmd);
-	put_device(&cmd->device->sdev_gendev);
+	put_device(&sdev->sdev_gendev);
 	return error;
 }
 EXPORT_SYMBOL(scsi_init_io);
