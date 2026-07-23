Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3BDBD3D7D6B
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 06:53:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784789640; cv=none; b=XGLwUSZRIhgx4VlLMyTIwRF2OiN0I9orDl/g6OMJ3Da9tvJraKj8ZfgAgctrdbY4w66TmiW3IPAe+LR8VJbAFSIURwLuHo1aErGX8rnUg6RXtrvJH8gKpKC6qF+zfXp3iZgXpkahjRhoNPz4kdc2oPFa3ppv3qIsZIdj4OyfRf4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784789640; c=relaxed/simple;
	bh=LL1H1pJkf5ry56jlTVuf+ciDOgx3vAZz9jM/WPHt7Tk=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=GaM7jngkIwb1+nPO94UdNvxJroSi83fG5fLVRejwPPYKxwqIi8IzijusZBz4z3rhkbcZunEvzN4lS/C/GpAWvX7oCKuc8Y7hXhxY7LhSbz7Ai1hV+qtJvsC7h08xX8yx/tomrByT1BbIfgMxKQxIAVXAb2pVkbOpesqrdhqIGGw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=GwwzwxdY; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="GwwzwxdY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB9C71F00A3A;
	Thu, 23 Jul 2026 06:53:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784789637;
	bh=N1IeinFU2+KHpK/r+AkEVp1qrpB3b+SV4I17TOgzmIs=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=GwwzwxdYduieta5sSNC4wvgbrtdye6HQLlKG2yfsKDkkOn6pvrTufuMbJIjB/J8K1
	 vgNGjRe/iVi6f897cs6JzzUV/x3YLPvGea+u1Gy9VP1OfXKFamcOiv/YCPDecwmeb9
	 ftwc2mhG4Uqf7GgJ3q8xqpBwpld7b6nXDW9HS5rdsHVvb40lc+DE+F0Oi5MwtsNs1V
	 euchQMpDaVVdnz4X9HQ5UlNBoLv2HWu1Lt+CHJqeyJLzM8AXwPgbj5X2V1LOFtt0ZM
	 ZCCbNFKlYKybV0lMb9ghJSL9MaeTftDNev4jnvf8WqlBf0bBT7E00AqgIxmyjQzmNW
	 aK6Z62d4cZkdA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 06/56] scsi: qla2xxx: Remove redundant VPD flash read
 in sysfs read path
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260723050413.3897522-7-njavali@marvell.com>
References: <20260723050413.3897522-1-njavali@marvell.com>
 <20260723050413.3897522-7-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 Jul 2026 06:53:56 +0000
Message-Id: <20260723065356.DB9C71F00A3A@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Unprotected flash hardware register access in qla2x00_sysfs_read_v=
pd().
--

--- Patch [6]: [PATCH v6 06/56] scsi: qla2xxx: Remove redundant VPD flash r=
ead in sysfs read path ---
commit e9338dabc7b53d75f2d4ddaf069664fa8b72258d
Author: Manish Rangankar <mrangankar@marvell.com>
Subject: scsi: qla2xxx: Remove redundant VPD flash read in sysfs read path

This patch removes a redundant and unprotected call to read_optrom() in=20
qla2x00_sysfs_read_vpd(). By dropping the second call, it prevents exposing=
=20
flash accesses to concurrent optrom operations while optrom_mutex is not he=
ld.

> diff --git a/drivers/scsi/qla2xxx/qla_attr.c b/drivers/scsi/qla2xxx/qla_a=
ttr.c
> index 6a05ce195aa05..800751ab562a1 100644
> --- a/drivers/scsi/qla2xxx/qla_attr.c
> +++ b/drivers/scsi/qla2xxx/qla_attr.c
> @@ -580,7 +580,6 @@ qla2x00_sysfs_read_vpd(struct file *filp, struct kobj=
ect *kobj,

[Severity: High]
This is a pre-existing issue, but does calling qla28xx_get_aux_images() ear=
lier
in qla2x00_sysfs_read_vpd() without holding optrom_mutex risk corrupting the
flash hardware state?

While this patch successfully addresses the unprotected read_optrom() call =
below,
qla28xx_get_aux_images() is still called before the lock is acquired:

qla2x00_sysfs_read_vpd() {
    ...
    if (IS_QLA28XX(ha)) {
        qla28xx_get_aux_images(vha, &active_regions);
        ...
    }

    mutex_lock(&ha->optrom_mutex);
    ...
}

Because qla28xx_get_aux_images() eventually performs raw MMIO accesses to t=
he
flash hardware registers, could concurrent sysfs reads to the vpd attribute
interleave these writes and reads (e.g., to reg->flash_addr and reg->flash_=
data)
and corrupt the ISP flash hardware state machine?

>  	ha->isp_ops->read_optrom(vha, ha->vpd, faddr, ha->vpd_size);
>  	mutex_unlock(&ha->optrom_mutex);
> =20
> -	ha->isp_ops->read_optrom(vha, ha->vpd, faddr, ha->vpd_size);
>  skip:
>  	return memory_read_from_buffer(buf, count, &off, ha->vpd, ha->vpd_size);
>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723050413.3897=
522-1-njavali@marvell.com?part=3D6
