Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80C35524B0;
	Mon, 31 Mar 2025 08:41:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1743410464; cv=none; b=V5avP1UNMTvNuTfZ3QtUkKfUtoNMJPGEflupCIThzZFJVzFFrKuZ8zPEpRKfR6d+ZJxhY03EPYvNaN6bjUIlhgttAAdm7fGWMuaBaIz07sly+huNTdSD17xC4LPyQxL8Fcpg8eQvXkJErodvzg/CGnCetEcKsRTTIBYU+MrLkZk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1743410464; c=relaxed/simple;
	bh=WutQ487qOILgzK3veqk4z1NcBGz1aX7aTncezPw28NI=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=P09hpGnfAVyQVjLBwFM1yhZS+duFQ4csGf2foIHd+5Zx2bG2+MWvU+Tp9HDsHxLKPwGfwFAwFCEc3JTCe/L75jRiu1nIfJl/PVDBn/KcDbsKVQNCwEq9neUm8VuMcpUfIesC87qeoJ0VxsqVnVSq1IK9IraAmHJZowcaY3cxybA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Cxol9UGG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Cxol9UGG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9CF1BC4CEE3;
	Mon, 31 Mar 2025 08:41:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1743410464;
	bh=WutQ487qOILgzK3veqk4z1NcBGz1aX7aTncezPw28NI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
	b=Cxol9UGGXNNgTGlIMNsCqkZsiaMxouPCuINRVkhpFotLHkGNqSQoWeZO51rYIFPjg
	 MxMVNYlzECKiKwHpXD32PD9GdtdEldyHYCNBlteGrxsDjCfXJCcB07Xo5PYyNlfw2N
	 nHPGP3pzRca/ROGKZBdaIEDCARZ1URT4Msui5e9+0yI8LlI/aGkxWAnNMl6t3DGdKW
	 wHMoedWU4DuGp1U5vlPOtIIteNbdl/UCiz4ZgRcPmIEI8lYJLCPrx+A41A9qJ1Xyur
	 fEwsok7pwVmf2D5Jg/9fnxDTqB1Fqx38jg2r0shxRqEjXBw9DA+H5eiAJ7s0L+R/nc
	 6vAz+pHfGCXbw==
Date: Mon, 31 Mar 2025 10:40:59 +0200
From: Niklas Cassel <cassel@kernel.org>
To: yangxingui <yangxingui@huawei.com>
Cc: John Garry <john.g.garry@oracle.com>, Yihang Li <liyihang9@huawei.com>,
	martin.petersen@oracle.com, James.Bottomley@hansenpartnership.com,
	linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
	linuxarm@huawei.com, liuyonglong@huawei.com,
	prime.zeng@hisilicon.com, dlemoal@kernel.org
Subject: Re: [PATCH 1/5] scsi: hisi_sas: Add host_tagset_enable module param
 for v3 hw
Message-ID: <Z-pVGyZ1vMBhUfYH@ryzen>
References: <20250329073236.2300582-1-liyihang9@huawei.com>
 <20250329073236.2300582-2-liyihang9@huawei.com>
 <f53505e6-9bfa-4553-91cc-497512a6977f@oracle.com>
 <e5ab4e5a-33d0-6102-1c5c-f1f83a752346@huawei.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <e5ab4e5a-33d0-6102-1c5c-f1f83a752346@huawei.com>

Hello Xingui,

On Sat, Mar 29, 2025 at 05:49:47PM +0800, yangxingui wrote:
> Hi，John
> 
> On 2025/3/29 16:50, John Garry wrote:
> > On 29/03/2025 07:32, Yihang Li wrote:
> > 
> > +
> > 
> > > From: Xingui Yang<yangxingui@huawei.com>
> > > 
> > > After driver exposes all HW queues and application submits IO to multiple
> > > queues in parallel, if NCQ and non-NCQ commands are mixed to sata disk,
> > > ata_qc_defer() causes non-NCQ commands to be requeued and possibly
> > > repeated
> > > forever.
> > 
> > I don't think that it is a good idea to mask out bugs with module
> > parameters.
> > 
> > Was this the same libata/libsas issue reported some time ago?
> 
> Yeah，related to this issue: https://lore.kernel.org/linux-block/eef1e927-c9b2-c61d-7f48-92e65d8b0418@huawei.com/
> 
> And, Niklas tried to help fix this problem:
> https://lore.kernel.org/linux-scsi/ZynmfyDA9R-lrW71@ryzen/
> 
> Considering that there is no formal solution yet. And our users rarely use
> SATA disks and SAS disks together on a single machine. For this reason, they
> can flexibly turn off the exposure of multiple queues in the scenario of
> using only SATA disks. In addition, it is also convenient to conduct
> performance comparison tests to expose multiple hardware queues and single
> queues.

The solution I sent is not good since it relies on EH.

One would need to come up with a better solution to fix libsas drivers,
possibly a workqueue.

I think Damien is planning to add a workqueue submit path to libata,
if so, perhaps we could base a better solution on top of that.


Kind regards,
Niklas
