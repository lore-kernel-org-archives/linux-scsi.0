Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1792752203;
	b=ZoqVUemzlBrC8oYbjnTOWTi4xV6e3Yruqp/nttbKkT3dggorY6WIXBkpl6Nh6DKxdcuA
	 UaiL9rUXC557fkLrLfDQDftWkbhUQ24R1+x7Gis06ghXy66+LW52DJkz9JyxSo09oEyME
	 61KCyxbNvNfEAmspZ5sMx+ahoC6XOmbiXHcpTJDlMybJ5rzZf7H5z8nmYM64FizvLTFwU
	 Q3wmvWnupaBYgrQZdUshFovrbjWb9hKzvBqUW4Bq6jKAh/TxNhYAVY38N7K2hBMRBy9No
	 GOzNwKyg02VfhcKyE1LMRWj4nZWXvW/z9a9OWksTZ0ot3zV0R4x2rUF866KE2KzJvkw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1792752203;
	h=Received:DKIM-Signature:Message-ID:From:Subject:Reply-To:To:Cc:
	 In-Reply-To:References:Content-Type:Content-Transfer-Encoding:Date;
	bh=iB8I6uhBi3rMoDVaoDSLesJ5iU8XlCXXIuLi8ylk7mc=;
	b=utWH2FXXPon7Jd70/sN/CnASw7Um6cwefYIpYLolISaBpmVMLVHhkG7YyQOloZzk/qsT
	 Q7JJv2kryqiUXrI70skK3gd2XAMD6Wj5ovaZmdPNLCSOLcAfqdz6BNrIYI2HPG/cSppMD
	 LgAEv7vspyywkRO6UMsRLe5ojHhtOGGJQICFDT95/QKFExkq8aLZKqX7lzGDWLUtNGBbj
	 o7LcPL23DMSt2a2sPyk031n2C9m2jE0Pl+aTNAXaZtzyPdLhwG8bOgzecGINJ0xhwZ6ga
	 Ir7XEEAfmAvezi4FsNL5/RYWsJSNuXfgAjZYKQttDli4mO26W5vyrY1pZ2cMSeg08wg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kDZ2XUhi;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D57B606A31B
	for <linux-scsi@vger.kernel.org>; Fri, 23 Oct 2026 10:43:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key, unprotected) header.d=kernel.org header.i=@kernel.org header.a=rsa-sha256 header.s=k20260515 header.b=kDZ2XUhi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 026C81F01828;
	Fri, 23 Oct 2026 10:43:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1792752203;
	bh=iB8I6uhBi3rMoDVaoDSLesJ5iU8XlCXXIuLi8ylk7mc=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=kDZ2XUhihNpn+lBHiKejPDdVgU0fb9U32fvcKqiCf1QzQTVFebjYwjvbA3Rb6H8MC
	 WkPbP85kHq77KZqE+vxNSrKnXjbU6E0tS3czVdTQlP642PISD/mn1dSyWGDG4KsuDi
	 LnY6TUn0MfLejx+NVbEB6nqBQcvR7hrCYO7sfsrRN8Wo//PxnQ6QsPJ8w14DikpYxT
	 nuxiwCYqb+GA2z081r7eM4uyLnhpGnzkZVWefhFdBczW3GdxnZ7gVdR1eN91mypuu2
	 2zyk+WkG7VnO/pgm2sMkBjEFeb6OLN3ynx/84EhoZ1FIf2QUnXvJRH2H3SyP4YWfvZ
	 3br3m0d3GrSOA==
Message-ID: <sashiko-outbox-182702@kernel.org>
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v2 12/13] scsi: qla2xxx: Fix purex IOCB copy size on
 non-29xx adapters
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20261023101600.1431179-13-njavali@marvell.com>
References: <20261023101600.1431179-1-njavali@marvell.com>
 <20261023101600.1431179-13-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Fri, 23 Oct 2026 10:43:22 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [Medium] scsi: qla2xxx: false bug fix claim and bad Fixes tag in qla24xx_=
copy_std_pkt()
--

commit 80556b286ead6fe5fe43e6fbf646d23656fb7c8a
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Fix purex IOCB copy size on non-29xx adapters

This patch replaces QLA_DEFAULT_PAYLOAD_SIZE with
sizeof(struct purex_entry_24xx) in qla24xx_copy_std_pkt() for non-29xx
adapters and removes the QLA_DEFAULT_PAYLOAD_SIZE macro definition.

>     scsi: qla2xxx: Fix purex IOCB copy size on non-29xx adapters
>    =20
>     qla24xx_copy_std_pkt() copies a single purex IOCB from the request/
>     response ring into a purex_item. The source entry size depends on the
>     adapter: 64 bytes (struct purex_entry_24xx) on 27xx/28xx and 128 bytes
>     (struct purex_entry_24xx_ext) on 29xx.
>    =20
>     For non-29xx adapters the copy size was set to QLA_DEFAULT_PAYLOAD_SI=
ZE
>     (128), causing memcpy() to read 64 bytes past the end of the 64-byte
>     source IOCB in the ring. Copy sizeof(struct purex_entry_24xx) instead=
 so
>     exactly one IOCB is copied on these adapters.
>    =20
>     Cc: stable@vger.kernel.org
>     Fixes: 150a29ebda52 ("scsi: qla2xxx: Enhance purex_entry handling for=
 29xx series")
>     Signed-off-by: Nilesh Javali <njavali@marvell.com>
>=20
> diff --git a/drivers/scsi/qla2xxx/qla_def.h b/drivers/scsi/qla2xxx/qla_de=
f.h
> index 97e2a1a9ce3f3..da5ca604d99eb 100644
> --- a/drivers/scsi/qla2xxx/qla_def.h
> +++ b/drivers/scsi/qla2xxx/qla_def.h
> @@ -5005,7 +5005,6 @@ struct active_regions {
>  #define QLA_SET_DATA_RATE_NOLR	1
>  #define QLA_SET_DATA_RATE_LR	2 /* Set speed and initiate LR */
> =20
> -#define QLA_DEFAULT_PAYLOAD_SIZE	64
>  #define QLA_MAX_IOCB_SIZE		128
>  /*
>   * This item might be allocated with a size > sizeof(struct purex_item).
> diff --git a/drivers/scsi/qla2xxx/qla_isr.c b/drivers/scsi/qla2xxx/qla_is=
r.c
> index 7bae26d4404c2..2a4eaefdcefc2 100644
> --- a/drivers/scsi/qla2xxx/qla_isr.c
> +++ b/drivers/scsi/qla2xxx/qla_isr.c
> @@ -1220,7 +1220,7 @@ static struct purex_item
>  	if (IS_QLA29XX(ha))
>  		copy_sz =3D sizeof(struct purex_entry_24xx_ext);
>  	else
> -		copy_sz =3D QLA_DEFAULT_PAYLOAD_SIZE;
> +		copy_sz =3D sizeof(struct purex_entry_24xx);

[Severity: Medium]
Is the commit description accurate about QLA_DEFAULT_PAYLOAD_SIZE being 128
and causing an out-of-bounds read in qla24xx_copy_std_pkt()?

As shown in the diff for drivers/scsi/qla2xxx/qla_def.h above,
QLA_DEFAULT_PAYLOAD_SIZE is defined as 64 (whereas QLA_MAX_IOCB_SIZE is 128=
),
and struct purex_entry_24xx in drivers/scsi/qla2xxx/qla_fw.h is also 64 byt=
es
(enforced by BUILD_BUG_ON(sizeof(struct purex_entry_24xx) !=3D 64) in
drivers/scsi/qla2xxx/qla_os.c).

Commit 7db93e3c580d ("scsi: qla2xxx: Enhance purex_entry handling for 29xx
series") already updated qla24xx_copy_std_pkt() in
drivers/scsi/qla2xxx/qla_isr.c from copying sizeof(item->iocb) to copying
copy_sz (64 bytes via QLA_DEFAULT_PAYLOAD_SIZE on non-29xx adapters).
Replacing QLA_DEFAULT_PAYLOAD_SIZE with sizeof(struct purex_entry_24xx)
therefore does not change the copy size or runtime behavior.

Additionally, the commit hash 150a29ebda52 in the Fixes tag does not exist =
in
the upstream tree (the upstream commit with that subject is 7db93e3c580d).
Since this change is a cleanup with no functional impact, should the Fixes
and Cc: stable@vger.kernel.org tags be dropped and the commit message updat=
ed
to reflect that this is a cleanup?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20261023101600.1431=
179-1-njavali@marvell.com?part=3D12
