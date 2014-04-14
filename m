From: Joe Lawrence <joe.lawrence@stratus.com>
Subject: Re: 3.15-mw:  Oops Workqueue: writeback bdi_writeback_workfn
 (flush-8:16)  RIP: e030:[<ffffffff814c6bc1>]  [<ffffffff814c6bc1>]
 kobject_put+0x11/0x70
Date: Mon, 14 Apr 2014 14:57:00 -0400
Message-ID: <20140414145700.74825388@jlaw-desktop.mno.stratus.com>
References: <1299097701.20140412133431@eikelenboom.it>
	<20140414113015.GA4765@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from p01c12o143.mxlogic.net ([208.65.145.66]:52626 "EHLO
	p01c12o143.mxlogic.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754288AbaDNTHU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Apr 2014 15:07:20 -0400
In-Reply-To: <20140414113015.GA4765@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Sander Eikelenboom <linux@eikelenboom.it>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org

On Mon, 14 Apr 2014 04:30:15 -0700
Christoph Hellwig <hch@infradead.org> wrote:

> On Sat, Apr 12, 2014 at 01:34:31PM +0200, Sander Eikelenboom wrote:
> > Hi,
> > 
> > I just ran into the oops belowafter some uptime.
> 
> Classic use after free introduced by my recent changes, sorry.
> 
> This should fix it:
> 
> ---
> From: Christoph Hellwig <hch@lst.de>
> Subject: scsi: don't reference freed command in scsi_init_sgtable
> 
> When scsi_init_io fails we have to release our device reference, but
> we do this trying to reference the just freed command.  Add a local
> scsi_device pointer to fix this.
> 
> Reported-by: Sander Eikelenboom <linux@eikelenboom.it>
> Signed-off-by: Christoph Hellwig <hch@lst.de>
> 
> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> index 65a123d..54eff6a 100644
> --- a/drivers/scsi/scsi_lib.c
> +++ b/drivers/scsi/scsi_lib.c
> @@ -1044,6 +1044,7 @@ static int scsi_init_sgtable(struct request *req, struct scsi_data_buffer *sdb,
>   */
>  int scsi_init_io(struct scsi_cmnd *cmd, gfp_t gfp_mask)
>  {
> +	struct scsi_device *sdev = cmd->device;
>  	struct request *rq = cmd->request;
>  
>  	int error = scsi_init_sgtable(rq, &cmd->sdb, gfp_mask);
> @@ -1091,7 +1092,7 @@ err_exit:
>  	scsi_release_buffers(cmd);
>  	cmd->request->special = NULL;
>  	scsi_put_command(cmd);
> -	put_device(&cmd->device->sdev_gendev);
> +	put_device(&sdev->sdev_gendev);
>  	return error;
>  }
>  EXPORT_SYMBOL(scsi_init_io);

Hi Christoph,

I hit a similar crash last week on a franken-kernel here (3.14 + scsi
misc + qlogic patches + out of tree drivers + terriblethingsIknow).  I
think there is one other similar use-after-free that's been in place
for a while now:

int scsi_prep_return(struct request_queue *q, struct request *req, int ret)
{
	struct scsi_device *sdev = q->queuedata;

	switch (ret) {
	case BLKPREP_KILL:
		req->errors = DID_NO_CONNECT << 16;
		/* release the command and kill it */
		if (req->special) {
			struct scsi_cmnd *cmd = req->special;
			scsi_release_buffers(cmd);
			scsi_put_command(cmd);                    <<
			put_device(&cmd->device->sdev_gendev);    <<
			req->special = NULL;
		}
		break;
	...

and the backtrace looked like:

general protection fault: 0000 [#1] SMP 
Modules linked in: ccmod(POF) ftmod(OF) ipmi_devintf ipmi_msghandler bonding sg x86_pkg_temp_thermal coretemp crct10dif_pclmul crc32_pclmul crc32c_intel ghash_clmulni_intel ixgbe(OF) aesni_intel igb(OF) ptp lrw pps_core gf128mul glue_helper i2c_algo_bit mdio ablk_helper cryptd pcspkr dca ntb i2c_core matroxfb(OF) videosw(OF) nfsd auth_rpcgss nfs_acl lockd sunrpc xfs libcrc32c dm_service_time sd_mod(OF) crc_t10dif crct10dif_common qla2xxx(OF) scsi_transport_fc mpt2sas(OF) raid_class scsi_tgt scsi_transport_sas dm_mirror dm_region_hash dm_log dm_multipath dm_mod
CPU: 8 PID: 23976 Comm: systemd-udevd Tainted: PF       W  O 3.14.0+ #2
Hardware name: Stratus ftServer 6400/G7LAY, BIOS BIOS Version 6.3:57 12/25/2013
task: ffff880420b3d7c0 ti: ffff880729138000 task.ti: ffff880729138000
RIP: 0010:[<ffffffff812e2a2d>]  [<ffffffff812e2a2d>] kobject_put+0xd/0x60
RSP: 0018:ffff880729139a80  EFLAGS: 00010002
RAX: 0000000000000000 RBX: 6b6b6b6b6b6b6ce3 RCX: 00000001002e0003
RDX: 000000000000002e RSI: ffffea0021370400 RDI: 6b6b6b6b6b6b6ce3
RBP: ffff880729139a88 R08: ffff88084dc16300 R09: 00000001002e0002
R10: ffff88104f603a80 R11: ffffea0021370400 R12: ffff88084dc16300
R13: 0000000000000001 R14: ffff881026935388 R15: ffff880ff56b3a18
FS:  00007f2eed940880(0000) GS:ffff88085fd00000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007f2eed0e2c20 CR3: 000000084d6c8000 CR4: 00000000000407e0
Stack:
 ffff88076248d0a8 ffff880729139a98 ffffffff813e57d7 ffff880729139ac0
 ffffffff8141bf3e 000000018141be66 ffff88076248d0a8 ffff88104def6840
 ffff880729139b20 ffffffffa00a46e0 ffff88104def6840 ffff88076248d0a8
Call Trace:
 [<ffffffff813e57d7>] put_device+0x17/0x20
 [<ffffffff8141bf3e>] scsi_prep_return+0x9e/0xc0
 [<ffffffffa00a46e0>] sd_prep_fn+0x70/0xcd0 [sd_mod]
 [<ffffffff812bb49f>] blk_peek_request+0x12f/0x250
 [<ffffffff8141cdf8>] scsi_request_fn+0x48/0x570
 [<ffffffff812b66f3>] __blk_run_queue+0x33/0x40
 [<ffffffff812b67aa>] queue_unplugged+0x2a/0xa0
 [<ffffffff812bb928>] blk_flush_plug_list+0x1d8/0x230
 [<ffffffff812bbd14>] blk_finish_plug+0x14/0x40
 [<ffffffff8116b239>] __do_page_cache_readahead+0x209/0x290
 [<ffffffff8116b52d>] force_page_cache_readahead+0x6d/0xa0
 [<ffffffff8116b843>] page_cache_sync_readahead+0x43/0x50
 [<ffffffff81161b35>] generic_file_aio_read+0x4f5/0x720
 [<ffffffff8120dc2b>] blkdev_aio_read+0x4b/0x70
 [<ffffffff811d27e7>] do_sync_read+0x67/0xa0
 [<ffffffff811d2efb>] vfs_read+0x9b/0x160
 [<ffffffff811d3a05>] SyS_read+0x55/0xd0
 [<ffffffff81637aa9>] system_call_fastpath+0x16/0x1b

Regards,

-- Joe
