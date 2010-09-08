From: Konstantinos Skarlatos <k.skarlatos@gmail.com>
Subject: Re: [PATCH] mvsas: mvs_lu_reset iterates phy num times when releasing
 task
Date: Wed, 08 Sep 2010 13:53:59 +0300
Message-ID: <4C876B47.50805@gmail.com>
References: <20100806161622.GA8696@localhost.localdomain> <4C5C448C.2040509@gmail.com> <20100903221303.GA9527@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ey0-f174.google.com ([209.85.215.174]:35916 "EHLO
	mail-ey0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757090Ab0IHKyW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Sep 2010 06:54:22 -0400
Received: by eyb6 with SMTP id 6so2886472eyb.19
        for <linux-scsi@vger.kernel.org>; Wed, 08 Sep 2010 03:54:21 -0700 (PDT)
In-Reply-To: <20100903221303.GA9527@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Milburn <dmilburn@redhat.com>
Cc: linux-scsi@vger.kernel.org, Wouter Naaktgeboren <wouter_naaktgeboren@xs4all.nl>

  On 4/9/2010 1:13 =CF=80=CE=BC, David Milburn wrote:
> On Fri, Aug 06, 2010 at 08:21:16PM +0300, Konstantinos Skarlatos wrot=
e:
>> >    Hello,
>> > =20
>> >  Does this patch fix any of the mvs_abort_task:rc=3D 5 and the oth=
er
>> >  problems that are being reported for this driver? for more info p=
lease
>> >  seehttp://marc.info/?l=3Dlinux-scsi&m=3D127583131805429&w=3D2
>> > =20
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

Hello,

I have been unable to patch my kernel, I am a noob at this and the=20
method i used a few months ago to apply Srinivas patches for mvsas does=
=20
not work now. I have asked for help from my distro (arch linux), but if=
=20
you have a quick and easy way for me to patch sas_ata.c and reload the=20
module without reboots or complete kernel recompilations I would be=20
grateful to hear it.

Kind regards
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
