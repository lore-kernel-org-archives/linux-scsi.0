Received: from mail-106117.protonmail.ch (mail-106117.protonmail.ch [79.135.106.117])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD22D3CAA3C;
	Tue, 15 Sep 2026 12:25:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=79.135.106.117
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789475112; cv=none; b=YuAy50BCPs+/E+XJS5R+lwoxhBBnl8lI6uom/ny2Kt/O3QfgDC2oGHJPbTcTJx8aU/tmATOzk4l4Qw1zESUq116WzOYqBb6dU1paTyVjaYqAXz8D9bfat9PXUgM3Bwq2wbauoF7h1q54aixyXkxlWj6dZnM17AwpaSdFDMm5NdU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789475112; c=relaxed/simple;
	bh=dQwY+fJdZSq7f2R1G4MVjrIF2+KddO9Z6wzUzNnLF84=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=u40iF9GLR6RUcDVjjeio1vmllT0krhq8tXpM0TMbFftIyg1xSKLVWnVyvYzUXGT5/62srQmbeVX2AB6uSatyzDDYOL0AJFNivQ8fBChBqijbRB1FQI+k5jyC+lYkISrGZhwwmh9fGFBxxkblSCz+A/3meSdmOVZWyxAyvFdU/ZU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=danielfernau.com; spf=pass smtp.mailfrom=danielfernau.com; dkim=pass (2048-bit key) header.d=danielfernau.com header.i=@danielfernau.com header.b=FG9g4kVf; arc=none smtp.client-ip=79.135.106.117
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=danielfernau.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=danielfernau.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=danielfernau.com header.i=@danielfernau.com header.b="FG9g4kVf"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=danielfernau.com;
	s=protonmail; t=1789475106; x=1789734306;
	bh=92rny1zNwUdZet6IQ9calXezSfCPdzK7V6o7gfAiUqM=;
	h=Date:To:From:Cc:Subject:Message-ID:In-Reply-To:References:
	 Feedback-ID:From:To:Cc:Date:Subject:Reply-To:Feedback-ID:
	 Message-ID:BIMI-Selector;
	b=FG9g4kVfcjG/b9RtK29o2Gfd/KqWicum2xw1xYQLhEt6Q6SP+AmcgJDXWI67nuHXw
	 MXN9CJ2gJ0IrBgLlBJE9r/eGgozkJwlRPoh72W/5e/JwwxMQk3A/Kr7/WzzBJx5P4Z
	 qSHzsBKg6kJD8+Ud4CnTYHrWsU+UxovMwQI7ecNC9DrXNZLaoiIHRCHRzsM/Xq0ELC
	 vTm4cwK1fzp/f1b0alqv+8XFq6gUkcwDc3MnufJDTgXZV4MKbSFHSpx11Q9MG0kyWG
	 gwy/7siRdIcSMsM6G8AhFM1287BF6DPH8ygbMbUBUziU0ljTxA33zf/ZFNoJ+zbL1A
	 pxrsegApParMQ==
Date: Tue, 15 Sep 2026 12:24:58 +0000
To: "Martin K. Petersen (Oracle)" <mkp@kernel.org>
From: Daniel Fernau <mail@danielfernau.com>
Cc: Kashyap Desai <kashyap.desai@broadcom.com>, Sumit Saxena <sumit.saxena@broadcom.com>, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, Chandrakanth patil <chandrakanth.patil@broadcom.com>, megaraidlinux.pdl@broadcom.com, Thomas Lamprecht <t.lamprecht@proxmox.com>, "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Damien Le Moal <dlemoal@kernel.org>, Jens Axboe <axboe@kernel.dk>, Keith Busch <kbusch@kernel.org>, Ranjan Kumar <ranjan.kumar@broadcom.com>, Thorsten Leemhuis <regressions@leemhuis.info>, regressions@lists.linux.dev, Lukasz Magiera <me@magik.net>, Mira Limbeck <m.limbeck@proxmox.com>, Mats Topstad <Mats.topstad@intility.no>, stable@vger.kernel.org
Subject: Re: [PATCH] scsi: megaraid_sas: Limit NVMe request size to the PRP chain frame
Message-ID: <k5_uJWSlVpSwhVugTUyBfaq9oFVqFfpeuk_765JDKLtq_vKNO8mXI6TznKe4bX9WisARpHFxQYZ6i7W8YBT02KYaHL5d3LKSfyfCkNAh1jc=@danielfernau.com>
In-Reply-To: <178840472610.670675.12272571379596581093.b4-ty@b4>
References: <20260827175743.734593-1-t.lamprecht@proxmox.com> <178840472610.670675.12272571379596581093.b4-ty@b4>
Feedback-ID: 131378921:user:proton
X-Pm-Message-ID: cedc9534f7bd132ab88023fdca5b51ac4853a55e
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable

Follow-up from our earlier note on pinning 6.8.12-4-pve.

We have now been running the HPE MR416i-o Gen11 cluster on Proxmox
kernel 7.0.14-15-pve without the previous megasas_make_prp_nvme
overflow.

Hardware / firmware
- HPE MR416i-o Gen11 (Broadcom PCI 0x1000:0x10e2)
- HPE FW package 52.32.3-6333 / controller FW 5.320.03-4207
- megaraid_sas 07.734.00.00-rc1
- KIOXIA NVMe behind the controller

7.0.14-15-pve includes
"scsi: megaraid_sas: Limit NVMe request size to the PRP chain frame"
(pve-kernel 46a6f4f). That is the driver-side max_hw_sectors cap
Martin suggested and the megaraid equivalent of Damien's
04631f55afc5 ("scsi: mpt3sas: Limit NVMe request size to 2 MiB"),
not Lukasz's original bounds check in megasas_make_prp_nvme().

On this hardware the cap is enough. We no longer need the
max_sectors_kb udev workaround, and we do not see the page-boundary
ptr_sgl fault (RAX=3D0x200 / 512th PRP slot) under production load.

Thanks,
Daniel
=20



On Thursday, September 3rd, 2026 at 5:10 AM, Martin K. Petersen (Oracle) <m=
kp@kernel.org> wrote:

> On Thu, 27 Aug 2026 19:24:24 +0200, Thomas Lamprecht wrote:
>=20
> > megasas_make_prp_nvme() builds a command's PRP list in cmd->sg_frame, a
> > DMA pool buffer of instance->max_chain_frame_sz bytes, spending one ent=
ry
> > per NVMe page of the transfer plus one per page of the buffer for the
> > chain pointer. The loop runs until the transfer is described and never
> > checks the buffer bound.
> >
> > max_hw_sectors comes straight from the MDTS the firmware reports for th=
e
> > drive. On drives with a large MDTS the only thing keeping the list insi=
de
> > the buffer was the block layer default of 1280 KiB, which needs 320
> > entries, which fit into a 4 KiB frame as that holds 512. But since comm=
it
> > 9b8b84879d4a ("block: Increase BLK_DEF_MAX_SECTORS_CAP") that default i=
s
> > 4 MiB, and such a transfer needs 1025 entries, so the list runs a full
> > page past the end of the frame:
> >
> > [...]
>=20
> Applied to 7.3/scsi-fixes, thanks!
>=20
> [1/1] scsi: megaraid_sas: Limit NVMe request size to the PRP chain frame
>       https://git.kernel.org/mkp/scsi/c/af8c27375733
>=20
> --
> Martin K. Petersen
> 
