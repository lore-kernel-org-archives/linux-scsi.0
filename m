From: Raghava Aditya Renukunta <RaghavaAditya.Renukunta@microsemi.com>
Subject: RE: [PATCH 04/47] aacraid: use aac_tmf_callback for reset fib
Date: Thu, 29 Jun 2017 20:06:53 +0000
Message-ID: <4D8E82A446BF54499747901DBDEB737A81C2CC8E@avsrvexchmbx2.microsemi.net>
References: <1498638793-44672-1-git-send-email-hare@suse.de>
 <1498638793-44672-5-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-by2nam03on0064.outbound.protection.outlook.com ([104.47.42.64]:36496
        "EHLO NAM03-BY2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1752193AbdF2UG7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 29 Jun 2017 16:06:59 -0400
In-Reply-To: <1498638793-44672-5-git-send-email-hare@suse.de>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, James Bottomley <james.bottomley@hansenpartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Hannes Reinecke <hare@suse.com>

[.....]
> @@ -879,8 +906,12 @@ static int aac_eh_dev_reset(struct scsi_cmnd *cmd)
[......]
>         bus =3D aac_logical_to_phys(scmd_channel(cmd));
>         cid =3D scmd_id(cmd);
> +       info =3D &aac->hba_map[bus][cid];
>         if (bus >=3D AAC_MAX_BUSES || cid >=3D AAC_MAX_TARGETS ||
> -           aac->hba_map[bus][cid].devtype !=3D AAC_DEVTYPE_NATIVE_RAW)
> +           info->devtype !=3D AAC_DEVTYPE_NATIVE_RAW)
> +               return FAILED;
> +
> +       if (info->reset_state > 0)
>                 return FAILED;
[......]
=20
> @@ -932,8 +962,9 @@ static int aac_eh_target_reset(struct scsi_cmnd
> *cmd)
>=20
>         bus =3D aac_logical_to_phys(scmd_channel(cmd));
>         cid =3D scmd_id(cmd);
> +       info =3D &aac->hba_map[bus][cid];
>         if (bus >=3D AAC_MAX_BUSES || cid >=3D AAC_MAX_TARGETS ||
> -           aac->hba_map[bus][cid].devtype !=3D AAC_DEVTYPE_NATIVE_RAW)
> +           info->devtype !=3D AAC_DEVTYPE_NATIVE_RAW)
>                 return FAILED;

Can we have a=20
	If (info->reset_state > 0
		Return FAILED;
here as well?

>         pr_err("%s: Host adapter reset request. SCSI hang ?\n",
> @@ -945,18 +976,18 @@ static int aac_eh_target_reset(struct scsi_cmnd
> *cmd)
>=20
[.....]
