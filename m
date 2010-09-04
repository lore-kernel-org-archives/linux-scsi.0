From: Konstantinos Skarlatos <k.skarlatos@gmail.com>
Subject: Re: [PATCH] mvsas: mvs_lu_reset iterates phy num times when releasing
 task
Date: Sat, 04 Sep 2010 22:04:08 +0300
Message-ID: <4C829828.605@gmail.com>
References: <20100806161622.GA8696@localhost.localdomain> <4C5C448C.2040509@gmail.com> <20100903221303.GA9527@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:53212 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752749Ab0IDTEP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 4 Sep 2010 15:04:15 -0400
Received: by wyf22 with SMTP id 22so1345082wyf.19
        for <linux-scsi@vger.kernel.org>; Sat, 04 Sep 2010 12:04:14 -0700 (PDT)
In-Reply-To: <20100903221303.GA9527@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Milburn <dmilburn@redhat.com>
Cc: linux-scsi@vger.kernel.org, wouter_naaktgeboren@xs4all.nl

  Thanks for the patch, i will test it today if i manage to find some t=
ime.

I should mention that 2.6.35 has solved most of the problems i had with=
=20
mvsas, but i will still try my best to test it as much as i can.

Wooter if you can please test this patch, because it seems that your=20
configuration still has problems with 2.6.36

Kind regards


On 4/9/2010 1:13 =CF=80=CE=BC, David Milburn wrote:
> On Fri, Aug 06, 2010 at 08:21:16PM +0300, Konstantinos Skarlatos wrot=
e:
>>   Hello,
>>
>> Does this patch fix any of the mvs_abort_task:rc=3D 5 and the other
>> problems that are being reported for this driver? for more info plea=
se
>> see http://marc.info/?l=3Dlinux-scsi&m=3D127583131805429&w=3D2
>>
> Hello,
>
> Can you see if this patch prevents the ata_qc_issue warning?
>
> Thanks,
> David
>
>   drivers/scsi/libsas/sas_ata.c |    1 +
>   1 files changed, 1 insertions(+), 0 deletions(-)
>
> diff --git a/drivers/scsi/libsas/sas_ata.c b/drivers/scsi/libsas/sas_=
ata.c
> index 042153c..ddbade7 100644
> --- a/drivers/scsi/libsas/sas_ata.c
> +++ b/drivers/scsi/libsas/sas_ata.c
> @@ -347,6 +347,7 @@ static int sas_ata_scr_read(struct ata_link *link=
, unsigned int sc_reg_in,
>   static struct ata_port_operations sas_sata_ops =3D {
>   	.phy_reset		=3D sas_ata_phy_reset,
>   	.post_internal_cmd	=3D sas_ata_post_internal,
> +	.qc_defer               =3D ata_std_qc_defer,
>   	.qc_prep		=3D ata_noop_qc_prep,
>   	.qc_issue		=3D sas_ata_qc_issue,
>   	.qc_fill_rtf		=3D sas_ata_qc_fill_rtf,

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
