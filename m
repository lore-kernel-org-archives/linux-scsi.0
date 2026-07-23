Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0E1F0439350
	for <linux-scsi@vger.kernel.org>; Thu, 23 Jul 2026 10:25:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784802316; cv=none; b=QBQ+2aSo4QlU67yttfIG7PPsA+9leyjfGyXviUDtjBgqWUfbWJQhFrd1J1UHKi5CyE/REHC2sCPXIPh6/dKEjvhAaAEL6l1r1C0u8rdG5BbO/dcblgGVike953gJcR+C/IMRm+aL2GcCeBPNy2SAzdBDkJsvVmqCj2L/2Q9VqaE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784802316; c=relaxed/simple;
	bh=Eyf1eRvlO+TDlGlUXbByAdPvYEE1M9OLAha/nWgnN74=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=HxOG65nxtlEiTzZrr/OKmJFYQ/J3LW9qxsj4cE7kldR8Lunjw4XRnHufK3j5V8MJ0Hkd5XZMrlK/YzvFwON62a+Iz9HLAV1OKlJ5De6jfr7dDakzop3qmh/N0wlToFnQHUQjEYlixXEaFOTNZXiEUJBH9w8ujiPlPIklypTB4+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=CuaStabT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="CuaStabT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 762411F000E9;
	Thu, 23 Jul 2026 10:25:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1784802314;
	bh=chV0L+N2zG2V/YAYZYLUpTLrQAEs8eyiK8Mm8ueUmwM=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=CuaStabTbq88SNDci8/TnbB0b44wCZdD3S7hcn3ydeeuUbbh0Qda0Oi/hXFjYRx2V
	 H5rPNK0ecpuBpXvdWHUp3ojXyyC5QBrP9XQAnLNhShi7dwPgpNDNIuflAG5kWxFH02
	 C1bgrLksc6ByYET/3DioknZ7cvs18CIGL8swpDq21U5DG505DV0l2r18apini0n16/
	 l9Rqf74pkMgrC7MLnmWd12Gp7ex115jLwBGvPzURVPVWJEfu7Xw/83nmk599sC4KP3
	 3xDJ4MfZZKYdDldwNJJRp34ZpONG1SXyfPhzY1f2NGbcJ7o4HcZtA0pBv1g2qw/xcy
	 fFcxahujmnFuA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v6 21/56] scsi: qla2xxx: Add support for QLA29XX in data
 rate functions
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260723050413.3897522-22-njavali@marvell.com>
References: <20260723050413.3897522-1-njavali@marvell.com>
 <20260723050413.3897522-22-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 23 Jul 2026 10:25:13 +0000
Message-Id: <20260723102514.762411F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] The check `mcp->mb[1] !=3D 0x7` prevents updating `ha->link_data_r=
ate` for 64GBps links.
--

--- Patch [21]: [PATCH v6 21/56] scsi: qla2xxx: Add support for QLA29XX in =
data rate functions ---
commit a940865e619482397b688263aefb07728776bca0
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Add support for QLA29XX in data rate functions

Enhance the qla2x00_set_data_rate and qla2x00_get_data_rate
functions to include checks for the QLA29XX series adapters.
This modification ensures that the mailbox commands are correctly
configured for the 29xx series, improving functionality and
compatibility.

> diff --git a/drivers/scsi/qla2xxx/qla_mbx.c b/drivers/scsi/qla2xxx/qla_mb=
x.c
> index a8dd01cb9a9ae..c073dc35ef8e5 100644
> --- a/drivers/scsi/qla2xxx/qla_mbx.c
> +++ b/drivers/scsi/qla2xxx/qla_mbx.c
[ ... ]
> @@ -5733,7 +5733,7 @@ qla2x00_get_data_rate(scsi_qla_host_t *vha)
>  		if (mcp->mb[1] !=3D 0x7)
>  			ha->link_data_rate =3D mcp->mb[1];

[Severity: High]
This is a pre-existing issue, but does this check prevent updating the link
speed for 64GBps links?

Since PORT_SPEED_64GB is defined as 0x07, querying a 64GBps link will return
0x07 in mcp->mb[1]. Filtering this out appears to leave ha->link_data_rate
stale (e.g., PORT_SPEED_UNKNOWN).

Could this break sysfs speed reporting and prevent proper hardware
configuration, such as setting the correct iIDMA speed in
qla2x00_iidma_fcport()?

There appears to be another instance of this check further down in
qla2x00_get_data_rate(), as well as a similar check in
qla2x00_set_data_rate() that prevents logging the successful configuration =
of
a 64GBps speed.

> -		if (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha)) {
> +		if (IS_QLA83XX(ha) || IS_QLA27XX(ha) || IS_QLA28XX(ha) || IS_QLA29XX(h=
a)) {
>  			if (mcp->mb[4] & BIT_0)
>  				ql_log(ql_log_info, vha, 0x11a2,
>  				    "FEC=3Denabled (data rate).\n");

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260723050413.3897=
522-1-njavali@marvell.com?part=3D21
