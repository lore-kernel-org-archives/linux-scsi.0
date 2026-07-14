Received: from verein.lst.de (verein.lst.de [213.95.11.211])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2554477E28;
	Tue, 14 Jul 2026 13:46:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=213.95.11.211
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784036767; cv=none; b=PwTmMj2HtGNMPwBL6LkpZC4cSic6LjC7wRooe58XQbj/BI0dV5Xv0NvxMBnc8vbNL31lwp3FhHpnMwFPDfFhVYzzctFRcM+iWMfq1MXsg57LsnYvRCjhpXt2uYHww8HFc/1tRAT+9GiOR6sxVO+gAnRxt0jJ2j6lcVJe5RNYFeM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784036767; c=relaxed/simple;
	bh=iQ66h0CSnaeDJY+5S4c4RU6btkxvwUiep2IzGUB8V3o=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=c0Hsd/EfKWIrIQP1j6nU3N9XPFBW5aYB1yXUf/4sKKGYJHJ6WfaqAEl53XWvAY9ThgHlGacR7gb3co89eKbZv7LuTLqIhFqHmBbrUPU6Lixkd/vGc0rqN5rdYRqGZhLVf2rqOsGz6Pt/Jiucj7F7WqCu+XL5sgotde+tjfSiYIg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de; spf=pass smtp.mailfrom=lst.de; arc=none smtp.client-ip=213.95.11.211
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=lst.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=lst.de
Received: by verein.lst.de (Postfix, from userid 2407)
	id 3D70168B05; Tue, 14 Jul 2026 15:45:59 +0200 (CEST)
Date: Tue, 14 Jul 2026 15:45:58 +0200
From: Christoph Hellwig <hch@lst.de>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Caleb Sander Mateos <csander@purestorage.com>,
	Jens Axboe <axboe@kernel.dk>, Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Anuj Gupta <anuj20.g@samsung.com>, linux-block@vger.kernel.org,
	linux-nvme@lists.infradead.org, linux-scsi@vger.kernel.org,
	target-devel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 0/5] block: use integrity interval instead of sector
 as seed
Message-ID: <20260714134558.GA714@lst.de>
References: <20260627054220.2174166-1-csander@purestorage.com> <yq1cxwrdgmx.fsf@ca-mkp.ca.oracle.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq1cxwrdgmx.fsf@ca-mkp.ca.oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)

On Sun, Jul 12, 2026 at 07:09:01PM -0400, Martin K. Petersen wrote:
> 
> Caleb,
> 
> > The block integrity layer currently sets the integrity seed (initial
> > reference tag) in units of 512-byte sectors.
> 
> ... because that is the fundamental addressing unit in the block layer.
> 
> > However, Type 1 and Type 2 ref tags are actually in units of integrity
> > intervals.
> 
> They are not in units of anything until they reach their final
> protection envelope.

If that is the assumption we need to clearly specify that somewhere,
and also explain why that is a good idea.

Most users of bip_set_seed seem to assume it is in integrity interval
units, see commits:

e4dc9a4c31fe10d1751c542702afc85be8a5c56a
c6e3f13398123a008cd2ee28f93510b113a32791
3d8b5a22d40435b4a7e58f06ae2cd3506b222898

so we'll need to find out a way to come up with interfaces that
just do the right thing.

> 
> > On devices with integrity interval size > 512 bytes, ref tags are
> > seeded incorrectly.
> 
> The bip seed is whatever the caller decides it should be. The integrity
> interval size is irrelevant. As is the destination LBA.
> 
> > But REQ_OP_ZONE_APPEND operations don't have their ref tags remapped,
> > so the ref tags using units of sectors will be stored to the device.
> 
> Then there's a problem with how we handle REQ_OP_ZONE_APPEND. For NVMe,
> the PIREMAP flag should address this issue by remapping the written ref
> tags based on their ultimate destination LBA.

PIREMAP expects the ref tag to be in logical block sized units.

> Fundamentally, you should be able to set the bip seed for any READ or
> WRITE bio to 42, regardless of logical block size, and have it work. If
> it doesn't, then that's a bug.
> 
> The fact that the block layer happens to know the start LBA or ZSLBA
> does not mean that callers above the block layer have access to the same
> information. Changing the block layer's integrity handling semantics is
> not the correct approach. Everything above the block layer depends on
> the existing, format-agnostic, semantics.

We have 4 callers above the block layer, and all of them know that the
see is the LBA.  For type 1 that is enforced by hardware, and all the
Linux code is basically based around a type 1 model, which is emulate
don type 2 PI and type 3 PI using the available means.

