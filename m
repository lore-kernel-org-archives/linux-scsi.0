From: "Ewan D. Milne" <emilne@redhat.com>
Subject: Re: [PATCH] sd: get disk reference in sd_check_events()
Date: Tue, 17 May 2016 09:17:10 -0400
Message-ID: <1463491030.6171.81.camel@localhost.localdomain>
References: <1461650818-107190-1-git-send-email-hare@suse.de>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:42041 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754465AbcEQNRN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 May 2016 09:17:13 -0400
In-Reply-To: <1461650818-107190-1-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org

On Tue, 2016-04-26 at 08:06 +0200, Hannes Reinecke wrote:
> sd_check_events() is called asynchronously, and might race
> with device removal. So always take a disk reference when
> processing the event to avoid the device being removed while
> the event is processed.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/scsi/sd.c | 9 +++++++--
>  1 file changed, 7 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index f52b74c..91f609f 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -1398,11 +1398,15 @@ static int media_not_present(struct scsi_disk *sdkp,
>   **/
>  static unsigned int sd_check_events(struct gendisk *disk, unsigned int clearing)
>  {
> -	struct scsi_disk *sdkp = scsi_disk(disk);
> -	struct scsi_device *sdp = sdkp->device;
> +	struct scsi_disk *sdkp = scsi_disk_get(disk);
> +	struct scsi_device *sdp;
>  	struct scsi_sense_hdr *sshdr = NULL;
>  	int retval;
>  
> +	if (!sdkp)
> +		return 0;
> +
> +	sdp = sdkp->device;
>  	SCSI_LOG_HLQUEUE(3, sd_printk(KERN_INFO, sdkp, "sd_check_events\n"));
>  
>  	/*
> @@ -1459,6 +1463,7 @@ out:
>  	kfree(sshdr);
>  	retval = sdp->changed ? DISK_EVENT_MEDIA_CHANGE : 0;
>  	sdp->changed = 0;
> +	scsi_disk_put(sdkp);
>  	return retval;
>  }
>  

This has been verified to fix a reported crash:

[15111.105473] Workqueue: events_freezable disk_events_workfn
[15111.106229] task: ffff88082297ae00 ti: ffff8807b54e0000 task.ti: ffff8807b54e0000
[15111.107039] RIP: 0010:[<ffffffffa008e474>] [<ffffffffa008e474>] sd_check_events+0x24/0x1a0 [sd_mod]
[15111.107885] RSP: 0018:ffff8807b54e3d88 EFLAGS: 00010293
[15111.108739] RAX: 0000000000000000 RBX: 0000000000000000 RCX: dead000000200200
[15111.109587] RDX: 0000000000000001 RSI: 0000000000000001 RDI: ffff8807c040f400
[15111.110403] RBP: ffff8807b54e3da0 R08: ffff8807d233f568 R09: dfe03f37fcb3f560
[15111.111208] R10: dfe03f37fcb3f560 R11: 0000000000000001 R12: ffff8807c040f400
[15111.112018] R13: ffff88084fc33fc0 R14: 0000000000000001 R15: ffff8807d233f550
[15111.112830] FS: 0000000000000000(0000) GS:ffff88084fc20000(0000) knlGS:0000000000000000
[15111.113681] CS: 0010 DS: 0000 ES: 0000 CR0: 000000008005003b
[15111.114511] CR2: 0000000000000008 CR3: 0000000f9cbb8000 CR4: 00000000000007e0
[15111.115370] DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
[15111.116268] DR3: 0000000000000000 DR6: 00000000ffff0ff0 DR7: 0000000000000400
[15111.117131] Stack:
[15111.118010] ffff8807d233f500 ffff8807c040f400 ffff88084fc33fc0 ffff8807b54e3e08
[15111.118932] ffffffff812da84b 0000000000000000 0000000000000000 0000000000000000
[15111.119894] 0000000000000000 0000000000000000 0000000057fe1a80 ffff8807d233f560
[15111.120842] Call Trace:
[15111.121832] [<ffffffff812da84b>] disk_check_events+0x5b/0x1b0
[15111.122817] [<ffffffff812da9b6>] disk_events_workfn+0x16/0x20
[15111.123848] [<ffffffff8109d5fb>] process_one_work+0x17b/0x470
[15111.124872] [<ffffffff8109e3cb>] worker_thread+0x11b/0x400
[15111.125904] [<ffffffff8109e2b0>] ? rescuer_thread+0x400/0x400
[15111.126928] [<ffffffff810a5aef>] kthread+0xcf/0xe0
[15111.127967] [<ffffffff810a5a20>] ? kthread_create_on_node+0x140/0x140
[15111.129040] [<ffffffff81645858>] ret_from_fork+0x58/0x90
[15111.130118] [<ffffffff810a5a20>] ? kthread_create_on_node+0x140/0x140
[15111.131208] Code: 1f 84 00 00 00 00 00 66 66 66 66 90 55 8b 05 28 fb e8 e1 48 89 e5 41 55 c1 e8 15 41 54 83 e0 07 83 f8 03 53 48 8b 9f 68 03 00 00 <4c> 8b 63 08 0f 87 18 01 00 00 41 8b 84 24 d0 06 00 00 8d 50 fa
[15111.133564] RIP [<ffffffffa008e474>] sd_check_events+0x24/0x1a0 [sd_mod]
[15111.134721] RSP <ffff8807b54e3d88>
[15111.135878] CR2: 0000000000000008

Reviewed-by: Ewan D. Milne <emilne@redhat.com>


