Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EF79379993
	for <linux-scsi@vger.kernel.org>; Tue, 23 Jun 2026 01:54:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1782179643; cv=none; b=UVpUqhF/GPx4ZY6aqpbpjS7g4/oWBSNDiyBGfTAkTXGOzmclpV8RSKMCFXnxl6vl7+Kso9RI3cPUJbaBZ63dxmvkKbSUi7nPKfubNeG+hYSny+Z/ixysIymxan6VnCoSvzeCFndSEMYPVonxdByMkTbQXlxP0BcUe4bMqVe2Coo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1782179643; c=relaxed/simple;
	bh=Elf91vwvTieqqqfeZmAwwZwg3cDXo08WwGBdOerWa7c=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=uaZvWSiGayPrE+jH8Ug17zqRII96bugVtf0MX6vgRihhz1mf37ZUNagirgrcRlg8SObtic7SUfxReV4i8MUw0K31h70gB+xmCcggnCWlcGQvasinLEU472T9HgVEiR3CItwkbd5NRFH6fdn6OUsCKLeCvChW8pteR8SNO9hmY50=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=amrM416C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="amrM416C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D360A1F000E9;
	Tue, 23 Jun 2026 01:54:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1782179641;
	bh=F490ByG9qhMlcT0ygJ7tXsaFp9oAzyktdMte8+W6Rh0=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=amrM416Cf10/XZp/sqtjQk/xDOY80Zarhw+5+Wy87gog6aVLtCtM3dijUuTKjrSTY
	 r+qgLJ7UvgHv1PmFg++qaSQGyVhE3aiyic0rf5HB2XRnjS9IkgKcR0oLjeTM2RK4VM
	 wHzfwD4nh01BPEV3mWpbiPyHvd0jseBm19uUpfcw/m8lCY+y1vwNdDe5q3sF/sf2Lc
	 nbuAQ3qsEJrZk2aInA7wVj70FoCAAhq7yZVdNcyAxYyOS6IxxIILCZE8HvZfwGGa+R
	 2uR1H/3IKkIHkvnxoRftxJToHWcMGelo34EAtAaze4B51nnoUqzax6qbuspB9Gz3gh
	 ZkNQOgbyh6Tew==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH 02/29] ibmvfc: add NVMe/FC protocol interface
 definitions
Reply-To: sashiko-reviews@lists.linux.dev
To: "Tyrel Datwyler" <tyreld@linux.ibm.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260623013035.3436640-3-tyreld@linux.ibm.com>
References: <20260623013035.3436640-1-tyreld@linux.ibm.com>
 <20260623013035.3436640-3-tyreld@linux.ibm.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 23 Jun 2026 01:54:01 +0000
Message-Id: <20260623015401.D360A1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:
- [High] Unconditional size expansion of `struct ibmvfc_implicit_logout` br=
eaks backwards compatibility with older VIOS versions.
--

commit c4f31afebbe28cbb64ba03689b7e7ed327cb6d9e
Author: Tyrel Datwyler <tyreld@linux.ibm.com>

ibmvfc: add NVMe/FC protocol interface definitions

This commit adds the protocol definitions for client-VIOS interface updates
needed to support NVMe/FC over the ibmvfc NPIV transport. It extends the
ibmvfc interface with NVMe/FC-specific capabilities, queue definitions,
and command layout support.

> diff --git a/drivers/scsi/ibmvscsi/ibmvfc.h b/drivers/scsi/ibmvscsi/ibmvf=
c.h
> index 0e259e9d2e9bb..f8a2bf92da410 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc.h
> +++ b/drivers/scsi/ibmvscsi/ibmvfc.h

[ ... ]

> @@ -377,20 +419,27 @@ struct ibmvfc_query_tgt {
>  struct ibmvfc_implicit_logout {
>  	struct ibmvfc_mad_common common;
>  	__be64 old_scsi_id;
> -	__be64 reserved[2];
> +	__be64 reserved[8];
> +	__be64 target_wwpn;
>  } __packed __aligned(8);

[Severity: High]
Will this unconditional size expansion break backwards compatibility with o=
lder
Virtual I/O Server (VIOS) firmware?

Since the driver calculates the MAD length dynamically using sizeof():

drivers/scsi/ibmvscsi/ibmvfc.c:__ibmvfc_tgt_get_implicit_logout_evt() {
    ...
    mad->common.length =3D cpu_to_be16(sizeof(*mad));
    ...
}

This changes the length sent for version 1 IBMVFC_IMPLICIT_LOGOUT operations
from 40 bytes to 96 bytes. Could older VIOS versions that strictly validate
MAD lengths against the version 1 specification reject this payload, breaki=
ng
target teardown and error recovery?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260623013035.3436=
640-1-tyreld@linux.ibm.com?part=3D2
