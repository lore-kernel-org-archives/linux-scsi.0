Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE1EB13474C
	for <linux-scsi@vger.kernel.org>; Thu, 25 Jan 2024 19:16:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706210172; cv=none; b=JQic39fU9jSTGaQkpgVqaEKnjZvDl8/sKBKqN6QHdZnpdz6+Rf2M5oV+t0HGRovzVc2wNrjTVNC4tBtze43+iX2d3KNgeChWD2Lg4g4L6IvGaPSYyQR3ZpPzTkl/TxWgU+q13/R0lKhxgilJ+Fxasov5McZ+Ygc6u1XAf+VbUyk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706210172; c=relaxed/simple;
	bh=RV3gcOJ6O0wkpXXHtiU0FnVN0Jd8vUXDerVNURSn8A0=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=sgtCF+LfYxtBY7GT7KJ1joARmHLrxiqqhPshUyMNlPdlxRA8G/Gpks2aBX93+9M8s0I0LQRzvO96D3TxgfhGCRK2pI7wJSLVHZlrxp0thuJ1sY+tRZv6XTVouFOSDCCPgg6wuT3mgL2MleRUwL7XfS9wK5KjtMtwMfEl7zHRnzY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=RLpZ2TuR; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="RLpZ2TuR"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1706210169;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+UxhK58VNA+sRPPlMED86Th/E7m4Bo8QUDEQCWgzChg=;
	b=RLpZ2TuR7SCJSkFr/km1q8RkaITwIUk4e8z0NQ2dWWgu2kr/hcK4eqKo8GXSYu2iFj/cvI
	CF9ex1iuLv3KyRX+03rDrQ2/i/5Au8ibQI3mDY74oCv4RJbjvLOS7NUzMKrcEbQd9jKQUx
	DRH/nvnM5iZS2KVcX8yZmQh0RpHztgQ=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-694-Ppg5VnFoMS2bYMq2ZGq1lA-1; Thu, 25 Jan 2024 14:16:05 -0500
X-MC-Unique: Ppg5VnFoMS2bYMq2ZGq1lA-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.rdu2.redhat.com [10.11.54.5])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 9C342863062;
	Thu, 25 Jan 2024 19:16:04 +0000 (UTC)
Received: from rhel-developer-toolbox-latest (unknown [10.2.16.47])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id BA2C05012;
	Thu, 25 Jan 2024 19:16:03 +0000 (UTC)
Date: Thu, 25 Jan 2024 11:16:01 -0800
From: Chris Leech <cleech@redhat.com>
To: Nilesh Javali <njavali@marvell.com>
Cc: "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
	"lduncan@suse.com" <lduncan@suse.com>,
	"linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
	GR-QLogic-Storage-Upstream <GR-QLogic-Storage-Upstream@marvell.com>,
	"jmeneghi@redhat.com" <jmeneghi@redhat.com>,
	Kaushal Desai <kdesai@marvell.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: Re: [EXT] Re: [PATCH v3 1/3] uio: introduce UIO_MEM_DMA_COHERENT type
Message-ID: <ZbKzcbPK9YwYBWkv@rhel-developer-toolbox-latest>
References: <20240109121458.26475-1-njavali@marvell.com>
 <20240109121458.26475-2-njavali@marvell.com>
 <ZbGfB2tqASg5Jiaq@rhel-developer-toolbox-latest>
 <CO6PR18MB4500FF2280015A78C0669B7EAF7A2@CO6PR18MB4500.namprd18.prod.outlook.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CO6PR18MB4500FF2280015A78C0669B7EAF7A2@CO6PR18MB4500.namprd18.prod.outlook.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.5

On Thu, Jan 25, 2024 at 10:49:56AM +0000, Nilesh Javali wrote:
>
> We have extensively verified this patch set with IOMMU enabled and see
> no regression when VT and SRIOV are enabled. However issues are observed
> only when VT, VT-D and SRIOV are enabled in the HW BIOS.

I don't understand what having IOMMU enabled while VT-d is disabled in
the BIOS settings actually means. Isn't VT-d Intel's name for it's IOMMU
implemenation? Does disabling VT-d support but setting intel_iommu=on
actually do anything?

> In the failure case, with VT-D enabled, we observe the OS fails to boot with
> DMAR timeout error.
> 
> "  **] A start job is running for Network Manager (2min 6s / no limit)
> [ 147.069016] DMAR: VT-d detected Invalidation Time-out Error: SID 0
> [ 147.069016] DMAR: DRHD: handling fault status reg 40
> [ 147.080924] DMAR: QI HEAD: Device-TLB Invalidation qw0 = 0xaf0300100003, qw1 = 0x7ffffffffffff001
> [ 147.090207] DMAR: QI PRIOR: Invalidation Wait qw0 = 0x200000025, qw1 = 0x10005f634".
> 
> With your proposed changes, please confirm if you see no issues with
> VT-D enabled on Intel/AMD platform.

I've just gone back and tested on a R320 with a Xeon E5-2420, this
systems BIOS does not have seperate VT and VT-d setting, but VT-d does
appear to be on when the single virtualization features setting is
enabled.

- A kernel with my v1 patches logs into a target just fine.
- These v3 patches fail.  My configuration is probably different, I
  don't see a network manager online stall but I do see segfaults in
  iscsiuio.
- Adding back the dma_device lines to the v3 patches, keeping the union
  cleanups you did in place, and it goes back to working.

> Also based on our observation the issue with VT-D enabled is not
> related to the current patch set under test.

Yes, Jerry Snitsel noted that the IOMMU code had been clearing the
__GFP_COMP flag for longer than the DMA API has been rejecting it. 
So IOMMU support has had issues for longer, but I think we can fix both
by doing this correctly.

Thanks,
 Chris Leech

