From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH V3] scsi_debugfs: fix crash in scsi_show_rq()
Date: Wed, 08 Nov 2017 08:01:08 -0800
Message-ID: <1510156868.3121.7.camel@HansenPartnership.com>
References: <20171108132149.3769-1-ming.lei@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-block-owner@vger.kernel.org>
In-Reply-To: <20171108132149.3769-1-ming.lei@redhat.com>
Sender: linux-block-owner@vger.kernel.org
To: Ming Lei <ming.lei@redhat.com>, Jens Axboe <axboe@fb.com>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Christoph Hellwig <hch@lst.de>, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, John Garry <john.garry@huawei.com>, Bart Van Assche <bart.vanassche@sandisk.com>, Omar Sandoval <osandov@fb.com>, Hannes Reinecke <hare@suse.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2017-11-08 at 21:21 +0800, Ming Lei wrote:
> cmd->cmnd can be allocated/freed dynamically in case of
> T10_PI_TYPE2_PROTECTION,
> so we should check it in scsi_show_rq() because this request may have
> been freed in scsi_show_rq().
> 
> This patch fixs the following kernel crash when dumping request via
> block's
> debugfs interface:
> 
> [  252.962045] BUG: unable to handle kernel NULL pointer dereference
> at           (null)
> [  252.963007] IP: scsi_format_opcode_name+0x1a/0x1c0
> [  252.963007] PGD 25e75a067 P4D 25e75a067 PUD 25e75b067 PMD 0
> [  252.963007] Oops: 0000 [#1] PREEMPT SMP
> [  252.963007] Dumping ftrace buffer:
> [  252.963007]    (ftrace buffer empty)
> [  252.963007] Modules linked in: scsi_debug ebtable_filter ebtables
> ip6table_filter ip6_tables xt_CHECKSUM iptable_mangle ipt_MASQUERADE
> nf_nat_masquerade_ipv4 iptable_nat nf_conntrack_ipv4 nf_defrag_ipv4
> nf_nat_ipv4 nf_nat nf_conntrack libcrc32c bridge stp llc
> iptable_filter fuse ip_tables sd_mod sg mptsas mptscsih mptbase
> crc32c_intel ahci libahci nvme serio_raw scsi_transport_sas libata
> lpc_ich nvme_core virtio_scsi binfmt_misc dm_mod iscsi_tcp
> libiscsi_tcp libiscsi scsi_transport_iscsi null_blk configs
> [  252.963007] CPU: 1 PID: 1881 Comm: cat Not tainted 4.14.0-
> rc2.blk_mq_io_hang+ #516
> [  252.963007] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009),
> BIOS 1.9.3-1.fc25 04/01/2014
> [  252.963007] task: ffff88025e6f6000 task.stack: ffffc90001bd0000
> [  252.963007] RIP: 0010:scsi_format_opcode_name+0x1a/0x1c0
> [  252.963007] RSP: 0018:ffffc90001bd3c50 EFLAGS: 00010286
> [  252.963007] RAX: 00000000ffff4843 RBX: 0000000000000050 RCX:
> 0000000000000000
> [  252.963007] RDX: 0000000000000000 RSI: 0000000000000050 RDI:
> ffffc90001bd3cd8
> [  252.963007] RBP: ffffc90001bd3c88 R08: 0000000000001000 R09:
> 0000000000000000
> [  252.963007] R10: ffff880275134000 R11: ffff88027513406c R12:
> 0000000000000050
> [  252.963007] R13: ffffc90001bd3cd8 R14: 0000000000000000 R15:
> 0000000000000000
> [  252.963007] FS:  00007f4d11762700(0000) GS:ffff88027fc40000(0000)
> knlGS:0000000000000000
> [  252.963007] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
> [  252.963007] CR2: 0000000000000000 CR3: 000000025e789003 CR4:
> 00000000003606e0
> [  252.963007] DR0: 0000000000000000 DR1: 0000000000000000 DR2:
> 0000000000000000
> [  252.963007] DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7:
> 0000000000000400
> [  252.963007] Call Trace:
> [  252.963007]  __scsi_format_command+0x27/0xc0
> [  252.963007]  scsi_show_rq+0x5c/0xc0
> [  252.963007]  ? seq_printf+0x4e/0x70
> [  252.963007]  ? blk_flags_show+0x5b/0xf0
> [  252.963007]  __blk_mq_debugfs_rq_show+0x116/0x130
> [  252.963007]  blk_mq_debugfs_rq_show+0xe/0x10
> [  252.963007]  seq_read+0xfe/0x3b0
> [  252.963007]  ? __handle_mm_fault+0x631/0x1150
> [  252.963007]  full_proxy_read+0x54/0x90
> [  252.963007]  __vfs_read+0x37/0x160
> [  252.963007]  ? security_file_permission+0x9b/0xc0
> [  252.963007]  vfs_read+0x96/0x130
> [  252.963007]  SyS_read+0x55/0xc0
> [  252.963007]  entry_SYSCALL_64_fastpath+0x1a/0xa5
> [  252.963007] RIP: 0033:0x7f4d1127e9b0
> [  252.963007] RSP: 002b:00007ffd27082568 EFLAGS: 00000246 ORIG_RAX:
> 0000000000000000
> [  252.963007] RAX: ffffffffffffffda RBX: 00007f4d1154bb20 RCX:
> 00007f4d1127e9b0
> [  252.963007] RDX: 0000000000020000 RSI: 00007f4d115a7000 RDI:
> 0000000000000003
> [  252.963007] RBP: 0000000000021010 R08: ffffffffffffffff R09:
> 0000000000000000
> [  252.963007] R10: 000000000000037b R11: 0000000000000246 R12:
> 0000000000022000
> [  252.963007] R13: 00007f4d1154bb78 R14: 0000000000001000 R15:
> 0000000000020000
> [  252.963007] Code: c6 e8 1b ca 24 00 eb 8c e8 74 2c ae ff 0f 1f 40
> 00 0f 1f 44 00 00 55 48 89 e5 41 56 41 55 41 54 53 49 89 fd 49 89 f4
> 48 83 ec 18 <44> 0f b6 32 48 c7 45 c8 00 00 00 00 65 48 8b 04 25 28
> 00 00 00
> [  252.963007] RIP: scsi_format_opcode_name+0x1a/0x1c0 RSP:
> ffffc90001bd3c50
> [  252.963007] CR2: 0000000000000000
> [  252.963007] ---[ end trace 83c5bddfbaa6573c ]---
> [  252.963007] Kernel panic - not syncing: Fatal exception
> [  252.963007] Dumping ftrace buffer:
> [  252.963007]    (ftrace buffer empty)
> [  252.963007] Kernel Offset: disabled
> [  252.963007] ---[ end Kernel panic - not syncing: Fatal exception
> 
> Fixes: 0eebd005dd07(scsi: Implement blk_mq_ops.show_rq())
> Cc: Bart Van Assche <bart.vanassche@sandisk.com>
> Cc: Omar Sandoval <osandov@fb.com>
> Cc: Martin K. Petersen <martin.petersen@oracle.com>
> Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
> Cc: Hannes Reinecke <hare@suse.com>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
> V2:
> 	- fix typo
> V3:
> 	- prefer to dump data and accept read-after-free
> 	- add some comment
> 
> James, since read-after-free is inevitable and we prefer to dump
> data,
> we needn't to move clearing the buffer pointer before freeing the
> buffer
> in sd_uninit_command(), otherwise we may miss the dump a bit
> 
>  drivers/scsi/scsi_debugfs.c | 12 +++++++++++-
>  1 file changed, 11 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_debugfs.c
> b/drivers/scsi/scsi_debugfs.c
> index 5e9755008aed..2320d8f569b8 100644
> --- a/drivers/scsi/scsi_debugfs.c
> +++ b/drivers/scsi/scsi_debugfs.c
> @@ -9,7 +9,17 @@ void scsi_show_rq(struct seq_file *m, struct request
> *rq)
>  	int msecs = jiffies_to_msecs(jiffies - cmd-
> >jiffies_at_alloc);
>  	char buf[80];
>  
> -	__scsi_format_command(buf, sizeof(buf), cmd->cmnd, cmd-
> >cmd_len);
> +	/*
> +	 * This rq may have been freed, so don't be surprised if
> +	 * read-after-free is reported.

This can be fixed, see below.

> +	 *
> +	 * __scsi_format_command() should be written as not being
> broken
> +	 * with gargabe 'cdb' input.
> +	 */
> +	if (cmd->cmnd && cmd->cmd_len)

Why is it necessary to check cmd_len as well?  It's not wrong, it just
doesn't seem to be useful

> +		__scsi_format_command(buf, sizeof(buf), cmd->cmnd,
> cmd->cmd_len);
> +	else
> +		strcpy(buf, "");
>  	seq_printf(m, ", .cmd=%s, .retries=%d, allocated %d.%03d s
> ago", buf,
>  		   cmd->retries, msecs / 1000, msecs % 1000);
>  }


This is what you need as well:

diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
index d175c5c5ccf8..2d5e918c3e75 100644
--- a/drivers/scsi/sd.c
+++ b/drivers/scsi/sd.c
@@ -1284,6 +1284,7 @@ static int sd_init_command(struct scsi_cmnd *cmd)
 static void sd_uninit_command(struct scsi_cmnd *SCpnt)
 {
 	struct request *rq = SCpnt->request;
+	unsigned char *cmnd = SCpnt->cmnd;
 
 	if (SCpnt->flags & SCMD_ZONE_WRITE_LOCK)
 		sd_zbc_write_unlock_zone(SCpnt);
@@ -1292,9 +1293,9 @@ static void sd_uninit_command(struct scsi_cmnd *SCpnt)
 		__free_page(rq->special_vec.bv_page);
 
 	if (SCpnt->cmnd != scsi_req(rq)->cmd) {
-		mempool_free(SCpnt->cmnd, sd_cdb_pool);
 		SCpnt->cmnd = NULL;
 		SCpnt->cmd_len = 0;
+		mempool_free(cmnd, sd_cdb_pool);
 	}
 }


The reason it works is that function calls are an absolute barrier, so
setting the cmnd to NULL is seen everywhere before the mempool_free()
starts and the execution path of mempool_free() is much longer
than _scsi_format_command() so you can never get a use after free in
practice.  To make this completely bullet proof, scsi_show_rq() should
take a copy of the cmnd pointer before testing and using it, otherwise
there's a minute window where it could go to NULL between the check and
__scsi_format_command().  I've forgotten if we can rely on no-
preemption for RT or we need to add it explicitly, but I'm sure you can
figure it out.

James
