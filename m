From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [PATCH] block: fix residual byte count handling
Date: Tue, 4 Mar 2008 20:25:51 +0100
Message-ID: <20080304192551.GU6704@kernel.dk>
References: <20080304093536.GH6704@kernel.dk> <1204634238.5997.5.camel@homer.simson.net> <47CD4355.4050401@gmail.com> <20080304223006A.tomof@acm.org> <47CD53BA.5040908@gmail.com> <47CD7611.2030606@gmail.com> <47CD7C05.1080707@gmail.com> <1204656328.6598.1.camel@homer.simson.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1204656328.6598.1.camel@homer.simson.net>
Sender: linux-ide-owner@vger.kernel.org
To: Mike Galbraith <efault@gmx.de>
Cc: Tejun Heo <htejun@gmail.com>, FUJITA Tomonori <tomof@acm.org>, fujita.tomonori@lab.ntt.co.jp, James.Bottomley@HansenPartnership.com, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, jgarzik@pobox.com, bzolnier@gmail.com
List-Id: linux-scsi@vger.kernel.org

On Tue, Mar 04 2008, Mike Galbraith wrote:
> 
> On Wed, 2008-03-05 at 01:42 +0900, Tejun Heo wrote:
> 
> > The following patch gets the writing going.
> 
> Bingo.

Pretty please test this on top of current -git?

I'll merge this up, it should do the trick. Would just be nice if you
could verify! :-)

diff --git a/drivers/scsi/scsi.c b/drivers/scsi/scsi.c
index fecba05..e5c6f6a 100644
--- a/drivers/scsi/scsi.c
+++ b/drivers/scsi/scsi.c
@@ -757,7 +757,7 @@ void scsi_finish_command(struct scsi_cmnd *cmd)
 				"Notifying upper driver of completion "
 				"(result %x)\n", cmd->result));
 
-	good_bytes = scsi_bufflen(cmd);
+	good_bytes = scsi_bufflen(cmd) + cmd->request->extra_len;
         if (cmd->request->cmd_type != REQ_TYPE_BLOCK_PC) {
 		drv = scsi_cmd_to_driver(cmd);
 		if (drv->done)

-- 
Jens Axboe

