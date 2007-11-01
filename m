From: Andreas Schwab <schwab@suse.de>
Subject: Re: [PATCHv2] aacraid: don't assign cpu_to_le32(constant) to u8
Date: Thu, 01 Nov 2007 14:31:29 +0100
Message-ID: <jefxzqqeha.fsf@sykes.suse.de>
References: <20071031150216.88cecc21.sfr@canb.auug.org.au>
	<20071101173221.2e1fea42.sfr@canb.auug.org.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.suse.de ([195.135.220.2]:54964 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751795AbXKANbc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Nov 2007 09:31:32 -0400
In-Reply-To: <20071101173221.2e1fea42.sfr@canb.auug.org.au> (Stephen
	Rothwell's message of "Thu\, 1 Nov 2007 17\:32\:21 +1100")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: aacraid@adaptec.com, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>

Stephen Rothwell <sfr@canb.auug.org.au> writes:

> diff --git a/drivers/scsi/aacraid/commsup.c b/drivers/scsi/aacraid/co=
mmsup.c
> index 240a0bb..3c2dbc0 100644
> --- a/drivers/scsi/aacraid/commsup.c
> +++ b/drivers/scsi/aacraid/commsup.c
> @@ -1339,9 +1339,9 @@ int aac_check_health(struct aac_dev * aac)
>  			aif =3D (struct aac_aifcmd *)hw_fib->data;
>  			aif->command =3D cpu_to_le32(AifCmdEventNotify);
>  		 	aif->seqnum =3D cpu_to_le32(0xFFFFFFFF);
> -		 	aif->data[0] =3D cpu_to_le32(AifEnExpEvent);
> -			aif->data[1] =3D cpu_to_le32(AifExeFirmwarePanic);
> -		 	aif->data[2] =3D cpu_to_le32(AifHighPriority);
> +			aif->data[0] =3D AifEnExpEvent;
> +			aif->data[1] =3D AifExeFirmwarePanic;
> +			aif->data[2] =3D AifHighPriority;
>  			aif->data[3] =3D cpu_to_le32(BlinkLED);

What about the last line?

Andreas.

--=20
Andreas Schwab, SuSE Labs, schwab@suse.de
SuSE Linux Products GmbH, Maxfeldstra=DFe 5, 90409 N=FCrnberg, Germany
PGP key fingerprint =3D 58CA 54C7 6D53 942B 1756  01D3 44D5 214B 8276 4=
ED5
"And now for something completely different."
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
