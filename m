From: James Smart <james.smart@emulex.com>
Subject: Re: [PATCH] lpfc: lower stack use in lpfc_fc_frame_check
Date: Mon, 3 Jan 2011 08:53:21 -0500
Message-ID: <4D21D4D1.1010208@emulex.com>
References: <4D121EC8.3090205@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exht1.emulex.com ([138.239.113.183]:38094 "EHLO
	exht1.ad.emulex.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932129Ab1ACNxo (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 3 Jan 2011 08:53:44 -0500
In-Reply-To: <4D121EC8.3090205@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>
Cc: "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>

Tomas,

Thank you.

Acked-by: James Smart <james.smart@emulex.com>

-- james s


On 12/22/2010 10:52 AM, Tomas Henzl wrote:
> Hi,
> according to checkstack the lpfc_fc_frame_check occupies the first place in stack usage:
> make checkstack
> objdump -d vmlinux $(find . -name '*.ko') | \
> 	perl /root/rpmbuild/BUILD/kernel-2.6.32/linux-2.6.32.x86_64/scripts/checkstack.pl x86_64
> 0x000013f4 lpfc_fc_frame_check [lpfc]:			1936
> ...
> This change makes the rctl_names static, thus not on stack.
>
> Tomas
>
> Signed-off-by: Tomas Henzl<thenzl@redhat.com>
>
>
> diff --git a/drivers/scsi/lpfc/lpfc_sli.c b/drivers/scsi/lpfc/lpfc_sli.c
> index e98e792..634b2fe 100644
> --- a/drivers/scsi/lpfc/lpfc_sli.c
> +++ b/drivers/scsi/lpfc/lpfc_sli.c
> @@ -11578,7 +11578,8 @@ lpfc_sli4_post_scsi_sgl_block(struct lpfc_hba *phba, struct list_head *sblist,
>   static int
>   lpfc_fc_frame_check(struct lpfc_hba *phba, struct fc_frame_header *fc_hdr)
>   {
> -	char *rctl_names[] = FC_RCTL_NAMES_INIT;
> +	/*  make rctl_names static to save stack space */
> +	static char *rctl_names[] = FC_RCTL_NAMES_INIT;
>   	char *type_names[] = FC_TYPE_NAMES_INIT;
>   	struct fc_vft_header *fc_vft_hdr;
>
>
>
>
>
>
