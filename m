Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 74EC13A8724
	for <linux-scsi@vger.kernel.org>; Tue,  7 Jul 2026 06:40:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783406422; cv=none; b=io5zd0Z0WYQDVNqG7T+Wd7Ubn+L1ndGqyPWmbKsoY3yTr8pqz3dv/EtArYf3zw3YbliDts0IpDm5R/TDCwxYjPnwbXZW21oR0bjFflLRBVnF7yV/ac3VU2oTlsSKJ4XWur8hPgpFhYnqXB5OL723RrSB1BYfxib0olU5qBAEvyA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783406422; c=relaxed/simple;
	bh=VHfC5r8vv8iSsi/VJG41Bh60nAE7CwWKOetmtt2eu10=;
	h=From:Subject:To:Cc:In-Reply-To:References:Content-Type:Date:
	 Message-Id; b=SOjKR3DQUMpAGsAL5iRKe2kOUgG/cejY9zLzAK/N1rAgB/EhlemS9l9L36c+/R7UuGPmtcc9x7DxBptrnKnwuUY+CWmPFlW9iUd8PAMO7bmvrwfkWHaYU+crSlEZhkQn0/8G4ELFEJhn8XmuhGD2NE2QPv4A/sG32mWDxIkfAt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=B8JL8Qea; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="B8JL8Qea"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2FBDF1F000E9;
	Tue,  7 Jul 2026 06:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kernel.org;
	s=k20260515; t=1783406421;
	bh=52m7edzERCBjt9oC4f1drQMYJdJKdiRgvwEDI3afjao=;
	h=From:Subject:Reply-To:To:Cc:In-Reply-To:References:Date;
	b=B8JL8Qeawg7z34J3ZK8TxCzZebIUutP1ZgLrhX/kBmB3iEwfA/IGRE0QCeFJ1iKM+
	 6dEXJ7yWkn0zM3FcxSPEgkALDkZIOEZu5zQ9xNMLQ38kIGVK9ROxAq6Ft7lyj7z5eb
	 PStGulpMfEQGtjPAaoKDFhbP1vv0DkjX5Edw3YRzIwG5/6lfloJSdTBDJvbs94pyu5
	 nbNbVNQGR91bLWndSlhk0qv4uNWoHcYCFBP1YkU18j8tQPw/0iSMs6Sf29MCYaWZKx
	 B31I2B7OVYL1GuJ2/5gxgq4x9xbt1idfMRtb2woYDJh1XxNi0oS7+M69cMsCRoGdOY
	 V9yFKnMJ0fPqg==
From: sashiko-bot@kernel.org
Subject: Re: [PATCH v3 27/88] scsi: qla2xxx: Enhance ct_entry_24xx_ext iocb
 handling for 29xx series
Reply-To: sashiko-reviews@lists.linux.dev
To: "Nilesh Javali" <njavali@marvell.com>
Cc: linux-scsi@vger.kernel.org
In-Reply-To: <20260707055435.2680300-28-njavali@marvell.com>
References: <20260707055435.2680300-1-njavali@marvell.com>
 <20260707055435.2680300-28-njavali@marvell.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Date: Tue, 07 Jul 2026 06:40:20 +0000
Message-Id: <20260707064021.2FBDF1F000E9@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>

Thank you for your contribution! Sashiko AI review found 1 potential issue(=
s) to consider:

Pre-existing issues:
- [High] Integer truncation of `entry_count` leads to a ring buffer desynch=
ronization vulnerability with large BSG scatterlists.
--

--- Patch [27]: [PATCH v3 27/88] scsi: qla2xxx: Enhance ct_entry_24xx_ext i=
ocb handling for 29xx series ---
commit 189e3a470ed46e95c6229a85f830b4242d2ff725
Author: Nilesh Javali <njavali@marvell.com>

scsi: qla2xxx: Enhance ct_entry_24xx_ext iocb handling for 29xx series

Refine the handling of I/O control blocks (IOCBs) for the 29xx series
by introducing support for the extended structure ct_entry_24xx_ext.

> diff --git a/drivers/scsi/qla2xxx/qla_iocb.c b/drivers/scsi/qla2xxx/qla_i=
ocb.c
> --- a/drivers/scsi/qla2xxx/qla_iocb.c
> +++ b/drivers/scsi/qla2xxx/qla_iocb.c

[ ... ]

> @@ -3484,7 +3498,11 @@ qla24xx_ct_iocb(srb_t *sp, struct ct_entry_24xx *c=
t_iocb)
>  		append_dsd64(&cur_dsd, sg);
>  		avail_dsds--;
>  	}
> -        ct_iocb->entry_count =3D entry_count;
> +
> +	if (IS_QLA29XX(ha))
> +		((struct ct_entry_24xx_ext *)pkt)->entry_count =3D entry_count;
> +	else
> +		((struct ct_entry_24xx *)pkt)->entry_count =3D entry_count;

[Severity: High]
This is a pre-existing issue, but does assigning the accumulated entry_count
to this 8-bit entry_count field risk integer truncation with large BSG
scatterlists?

If a local user submits a BSG job (like an FC_BSG_HST_CT request) with a
large number of scatterlist entries (for example, 1024 for request and
1024 for reply), qla24xx_calc_ct_iocbs could calculate a required number
of IOCBs greater than 255 (such as 411).

Because the hardware packet header's entry_count is an 8-bit field, a
value like 411 would be truncated to 155.

Would the firmware then only consume 155 packets, leaving the remaining
continuation packets on the ring buffer to be interpreted as new, arbitrary
command headers? This ring buffer desynchronization could cause the firmware
to generate completion interrupts with random handle values. Since the
driver uses this handle to index into req->outstanding_cmds, could this lead
to out-of-bounds accesses, NULL pointer dereferences, or use-after-free
crashes in the completion interrupt handler?

>  }

--=20
Sashiko AI review =C2=B7 https://sashiko.dev/#/patchset/20260707055435.2680=
300-1-njavali@marvell.com?part=3D27
