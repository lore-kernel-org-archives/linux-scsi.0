From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
Subject: Re: [PATCH -next] [SCSI] mpt3sas: remove unused variables
Date: Mon, 17 Dec 2012 14:25:26 +0100
Message-ID: <87k3sgn73t.fsf@nemi.mork.no>
References: <20121211205651.GA5312@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from canardo.mork.no ([148.122.252.1]:43274 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752714Ab2LQNZs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 17 Dec 2012 08:25:48 -0500
In-Reply-To: <20121211205651.GA5312@localhost.localdomain> (sreekanth reddy's
	message of "Wed, 12 Dec 2012 02:26:51 +0530")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: sreekanth.reddy@lsi.com
Cc: linux-scsi@vger.kernel.org, jejb@kernel.org, yongjun_wei@trendmicro.com.cn, weiyj.lk@gmail.com, Nagalakshmi.Nandigama@lsi.com

<sreekanth.reddy@lsi.com> writes:

> diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3=
sas/mpt3sas_scsih.c
> index ac9dbc2..61a1a45 100644
> --- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> +++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> @@ -2754,13 +2754,11 @@ _scsih_block_io_to_children_attached_directly=
(struct MPT3SAS_ADAPTER *ioc,
>  	int i;
>  	u16 handle;
>  	u16 reason_code;
> -	u8 phy_number;
> =20
>  	for (i =3D 0; i < event_data->NumEntries; i++) {
>  		handle =3D le16_to_cpu(event_data->PHY[i].AttachedDevHandle);
>  		if (!handle)
>  			continue;
> -		phy_number =3D event_data->StartPhyNum + i;
>  		reason_code =3D event_data->PHY[i].PhyStatus &
>  		    MPI2_EVENT_SAS_TOPO_RC_MASK;
>  		if (reason_code =3D=3D MPI2_EVENT_SAS_TOPO_RC_DELAY_NOT_RESPONDING=
)

There is an identical copy of this code, including that bug, in
drivers/scsi/mpt2sas/mpt2sas_scsih.c.

If you insist on the stupid code duplication, then please try to keep
your bugs syncronized!  If you are going to fix this bug for the mpt3sa=
s
driver, then you *have* to fix it for mpt2sas as well.

Yes, I believe this is a mess and you have already demonstrated that yo=
u
are incapable of managing it.


Bj=C3=B8rn
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
