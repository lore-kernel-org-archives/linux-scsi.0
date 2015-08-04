From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH] megaraid_sas: fix missing { } braces
Date: Tue, 04 Aug 2015 08:47:12 +0200
Message-ID: <mqdio8vv9cf.fsf@c203.arch.suse.de>
References: <1438614029-4257-1-git-send-email-colin.king@canonical.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:42466 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752517AbbHDGrP convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Aug 2015 02:47:15 -0400
In-Reply-To: <1438614029-4257-1-git-send-email-colin.king@canonical.com>
	(Colin King's message of "Mon, 3 Aug 2015 16:00:29 +0100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Colin King <colin.king@canonical.com>
Cc: Kashyap Desai <kashyap.desai@avagotech.com>, Sumit Saxena <sumit.saxena@avagotech.com>, Uday Lingala <uday.lingala@avagotech.com>, "James E.J. Bottomley" <JBottomley@odin.com>, megaraidlinux.pdl@avagotech.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org


Hi Colin,

Colin King <colin.king@canonical.com> writes:

> From: Colin Ian King <colin.king@canonical.com>
>
> Static analysis by smatch indicated that there was a curly
> braces issue:
>
> drivers/scsi/megaraid/megaraid_sas_base.c:6139
>   megasas_mgmt_fw_ioctl() warn: curly braces intended?
>
> Add braces in the appropriate place so that kbuf_arr[i] gets
> set to NULL only when we need to.  Also, remove whitespace
> between kbuff_arr and [].

I don't quite get where you removed that whitespace. Might it be a left
over from another version of the patch?

>
> Signed-off-by: Colin Ian King <colin.king@canonical.com>
> ---
>  drivers/scsi/megaraid/megaraid_sas_base.c | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)
>
> diff --git a/drivers/scsi/megaraid/megaraid_sas_base.c b/drivers/scsi=
/megaraid/megaraid_sas_base.c
> index 71b884d..8face78 100644
> --- a/drivers/scsi/megaraid/megaraid_sas_base.c
> +++ b/drivers/scsi/megaraid/megaraid_sas_base.c
> @@ -6131,12 +6131,13 @@ megasas_mgmt_fw_ioctl(struct megasas_instance=
 *instance,
>  	}
> =20
>  	for (i =3D 0; i < ioc->sge_count; i++) {
> -		if (kbuff_arr[i])
> +		if (kbuff_arr[i]) {
>  			dma_free_coherent(&instance->pdev->dev,
>  					  le32_to_cpu(kern_sge32[i].length),
>  					  kbuff_arr[i],
>  					  le32_to_cpu(kern_sge32[i].phys_addr));
>  			kbuff_arr[i] =3D NULL;
> +		}
>  	}
> =20
>  	megasas_return_cmd(instance, cmd);

=46or the curly braces part:
Reviewed-by: Johannes Thumshirn <jthumshirn@suse.de>

While you're up to it, care to check drivers/scsi/bfa as well? There wa=
s
a patch somewhen in the past but it seems it wasn't applied. But if
found this bugzilla entry
https://bugzilla.kernel.org/show_bug.cgi?id=3D98261
for it.

Thanks,
Johannes

--=20
Johannes Thumshirn                                           Storage
jthumshirn@suse.de                                 +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=C3=BCrnberg)
Key fingerprint =3D EC38 9CAB C2C4 F25D 8600  D0D0 0393 969D 2D76 0850
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
