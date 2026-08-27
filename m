Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0B0925A2DD
	for <linux-scsi@vger.kernel.org>; Thu, 27 Aug 2026 01:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1787795088; cv=none; b=adDJ8xR34MajdqzcuoHQlsBjqf6TvXUCnyQSpdjpyT4KUtoYuNoSZvIZf5d8HYhnWUp/pxEQc/+IqoMOSgOW/DjxFtmQhYwx2WdQ4P3DfZSAt+RxVPJu4sCdhNTDz7OM0TOJvBLYx5sBhaXGZP0IJJtkFaxztDpy8xw96GOu6lk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1787795088; c=relaxed/simple;
	bh=LSVKhz0Zt2rwg2SFSGYlbY3nSXFXwSgJhqU0CtUI4yI=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=jcal7I1J5Jsv5Bv5ekdRzPymBHDAh132OdS43BZVHd4BoLJe9q/BYFDvCMtuSBij4FdnLRKGscB6KWOE1xD9MVbhxwiJlFiTHB5GpSqD2T0AW25cl4ukSUu5POao+vx3X0MLpAymV2KnwOOOAb84yHsqp0xCXo+eC4kUK7NTs4A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=XZlG5HEg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="XZlG5HEg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 664561F000E9;
	Thu, 27 Aug 2026 01:44:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1787795086;
	bh=l/QRXlD7uwr9ljVtYe0VVu1gvgNtUOfySjlInsA/LyU=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=XZlG5HEg0vabt/YVyyvVES6yrZjAUl8J6uZD4b6kis1kjhoN40L4x8DP+Jy7/0ilX
	 QvV9cY41aUtqn41U/expGS+0r1cgv4DHlXxK8KyXtK8kch2awx64/ktdvBd5BR1+th
	 1cz5pTQ7fsJmY1VhuSRmVIiIDlj5kZI9e1O+1OmgSM25fHHmhPuMAe4SDPucWc8fbl
	 amIKVZilkDrtBnmD1H4cw68yfdPoAPHshtqYq03IsgELVq+lrpgJ1l8/4lrlT5egqN
	 aNvIt2Elj+x5K30YCupXTmd008g5s3Zt22avPfV4t0G0Rla54nW11nNA9jOMFmC+7U
	 XhSuStv/iEmBA==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3] scsi: target: iscsi: Reject CDB size exceeding
 available buffer
Reply-To: sashiko-reviews@lists.linux.dev
To: ghuicao@163.com
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260827013245.21289-1-ghuicao@163.com>
References: <20260826100526.106011-1-ghuicao@163.com>
 <20260827013245.21289-1-ghuicao@163.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Thu, 27 Aug 2026 01:44:45 +0000
Message-Id: <20260827014446.664561F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] The iSCSI target RX path fails to include Additional Header Segmen=
ts (AHS) when computing the received HeaderDigest, breaking CRC verificatio=
n for valid PDUs with AHS.
--

commit 6cf5aacf20580909d513380590652bf27da173c3
Author: Cao Guanghui <caoguanghui@kylinos.cn>

scsi: target: iscsi: Reject CDB size exceeding available buffer

This commit adds validation to ensure the CDB size requested by
scsi_command_size() and the Extended CDB length do not exceed available
buffers. It prevents out-of-bounds reads during memcpy in
target_cmd_init_cdb() and fortify_source panics when an Extended CDB AHS
is present.

> diff --git a/drivers/target/iscsi/iscsi_target.c b/drivers/target/iscsi/i=
scsi_target.c
> index 62ada3a52210e..f19f1c31a39b2 100644
> --- a/drivers/target/iscsi/iscsi_target.c
> +++ b/drivers/target/iscsi/iscsi_target.c

[ ... ]

[Severity: High]
This isn't a bug introduced by this patch, but since this code correctly
handles AHS structures, I noticed a pre-existing issue in the iSCSI target
RX path that might also need addressing.

In iscsit_get_rx_pdu(), does the header digest calculation need to be updat=
ed
to include the AHS length?

drivers/target/iscsi/iscsi_target.c:iscsit_get_rx_pdu() {
    ...
			checksum =3D iscsit_crc_buf(buffer, ISCSI_HDR_LEN, 0,
						  NULL);
    ...
}

Doesn't this calculate the CRC exclusively over the 48-byte basic header
(ISCSI_HDR_LEN)?

If the initiator negotiates HeaderDigest and sends an iSCSI PDU with an
Additional Header Segment (hdr->hlength > 0), wouldn't this break CRC
verification for valid PDUs with AHS since they will be falsely rejected
with a CRC error?

According to RFC 3720 Section 10.2.1.2, shouldn't the Header Digest be
calculated over the basic header AND any AHS, using
ISCSI_HDR_LEN + (hdr->hlength * 4) instead of just ISCSI_HDR_LEN?

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260827013245.2128=
9-1-ghuicao@163.com?part=3D1
