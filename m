From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH RESEND] scsi: Set sg_tablesize to 1, for LLDDs that set
 SG_NONE
Date: Wed, 11 Nov 2015 08:28:58 +0100
Message-ID: <5642EE3A.50308@suse.de>
References: <1447195520-27307-1-git-send-email-manoj@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:56861 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750999AbbKKH3A (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Nov 2015 02:29:00 -0500
In-Reply-To: <1447195520-27307-1-git-send-email-manoj@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Manoj Kumar <manoj@linux.vnet.ibm.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org
Cc: "Matthew R. Ochs" <mrochs@linux.vnet.ibm.com>, Youngjae Lee <leeyo@linux.vnet.ibm.com>

On 11/10/2015 11:45 PM, Manoj Kumar wrote:
> Oops while testing blk_mq over the new cxlflash driver.
>=20
> [ 2960.817172] Oops: Kernel access of bad area, sig: 11 [#5]
> [ 2960.817309] NIP  __blk_mq_run_hw_queue+0x278/0x4c0
> [ 2960.817313] LR __blk_mq_run_hw_queue+0x2bc/0x4c0
> [ 2960.817314] Call Trace:
> [ 2960.817320] __blk_mq_run_hw_queue+0x2bc/0x4c0 (unreliable)
> [ 2960.817324] blk_mq_run_hw_queue+0xd8/0x100
> [ 2960.817329] blk_mq_insert_requests+0x14c/0x1f0
> [ 2960.817333] blk_mq_flush_plug_list+0x150/0x190
> [ 2960.817338] blk_flush_plug_list+0x11c/0x2b0
> [ 2960.817344] blk_finish_plug+0x58/0x80
> [ 2960.817348] __do_page_cache_readahead+0x1c0/0x2e0
> [ 2960.817352] force_page_cache_readahead+0x68/0xd0
> [ 2960.817356] generic_file_read_iter+0x43c/0x6a0
> [ 2960.817359] blkdev_read_iter+0x68/0xa0
> [ 2960.817361] __vfs_read+0x11c/0x180
> [ 2960.817364] vfs_read+0xa4/0x1c0
> [ 2960.817366] SyS_read+0x6c/0x110
> [ 2960.817369] system_call+0x38/0xb4
>=20
> The root cause of the problem was this low level device driver(LLDD),
> in this case cxlflash, does not support scatter-gather and hence had
> set it's sg_tablesize to SG_NONE (value of 0). In reality the tablesi=
ze
> is of length 1. This value of SG_NONE does not cause any problems wit=
h
> the standard block driver stack but causes issues for blk_mq, as show=
n
> above. Since quite a few of the legacy LLDDs are setting sg_tablesize
> to SG_NONE, it was preferable to override the LLDD provided value in
> scsi_host_alloc().
>=20
> Signed-off-by: Manoj N. Kumar <manoj@linux.vnet.ibm.com>
> Signed-off-by: Youngjae Lee <leeyo@linux.vnet.ibm.com>
> Reviewed-by: Matthew R. Ochs <mrochs@linux.vnet.ibm.com>
> ---
>  drivers/scsi/hosts.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>=20
> diff --git a/drivers/scsi/hosts.c b/drivers/scsi/hosts.c
> index 8bb173e..bd13c9d 100644
> --- a/drivers/scsi/hosts.c
> +++ b/drivers/scsi/hosts.c
> @@ -413,7 +413,7 @@ struct Scsi_Host *scsi_host_alloc(struct scsi_hos=
t_template *sht, int privsize)
>  	shost->hostt =3D sht;
>  	shost->this_id =3D sht->this_id;
>  	shost->can_queue =3D sht->can_queue;
> -	shost->sg_tablesize =3D sht->sg_tablesize;
> +	shost->sg_tablesize =3D (sht->sg_tablesize ? sht->sg_tablesize : 1)=
;
>  	shost->sg_prot_tablesize =3D sht->sg_prot_tablesize;
>  	shost->cmd_per_lun =3D sht->cmd_per_lun;
>  	shost->unchecked_isa_dma =3D sht->unchecked_isa_dma;
>=20
Shouldn't we rather fixup blk-mq to properly support SG_NONE?
Silently converting SG_NONE (=3D0) to 1 has a fair chance of breaking
non-mq enabled setups, which happily work with SG_NONE currently.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
