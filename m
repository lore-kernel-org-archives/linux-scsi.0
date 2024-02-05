Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C508E82D87
	for <linux-scsi@vger.kernel.org>; Mon,  5 Feb 2024 19:51:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707162671; cv=none; b=iRxommOHfeVyzIc3Bkr6LqJqdnKIBmMA5CCfjpVC1/0Psaza2p96vhs4ehlXzBNYyLWGDwvDS6q6C92ssrIN2d6Al1aaXDbuVjkdE8cKmlm/yc5Lb86SWZyXNVOULbv66RDPVKNSasCPn7CV0g33c7zd/FQ2mfEGxZ5NIdhb4dM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707162671; c=relaxed/simple;
	bh=32IgZ6ko36r/TNs5ZFOUk3nuGoF25Qi3GhszNhaTrPw=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=ZPoci2MFHA03Am1bTe1AyBcZC6KVlimpfKaJ7kIwGBzzwD2lF2qHK9cxVgUw8/RNTO8eGUBM9jc3Y6cq1GB12/DXjgcCX/Iz6z8RxXS21FVttiOJ7t8ixpedUulypq9MtyzVRIOZxeadwkBef9nCatq7iPKfB6nFR5eecAw8PhU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=GqSpPm0i; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="GqSpPm0i"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1707162668;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=+tpfnxQlLNRm4M5QzduLIpK2iI7KFV9K8AqzkgCNCjM=;
	b=GqSpPm0iBWbUQkEcPodaPZcsb8B9T+wR4CHwNzLslCEDOmkrjxkOVPy6l+j1Q4BOsSvyB/
	YB89yhNs+Hd92IAl3YXzg1gf3M9qR6BJqWlnd/PMtrSXxysIK5AOKX+sMpKLWW8C0e3iLv
	SZtgDR2OqJgz1DqhJ5tIpHvWjwJXTc4=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-125-kdFpPILVOoydeVUitL3Emw-1; Mon, 05 Feb 2024 14:51:04 -0500
X-MC-Unique: kdFpPILVOoydeVUitL3Emw-1
Received: from smtp.corp.redhat.com (int-mx10.intmail.prod.int.rdu2.redhat.com [10.11.54.10])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 0863F868A00;
	Mon,  5 Feb 2024 19:51:04 +0000 (UTC)
Received: from rhel-developer-toolbox-latest (unknown [10.2.16.180])
	by smtp.corp.redhat.com (Postfix) with ESMTPS id C30A1492BF0;
	Mon,  5 Feb 2024 19:51:02 +0000 (UTC)
Date: Mon, 5 Feb 2024 11:51:00 -0800
From: Chris Leech <cleech@redhat.com>
To: Alexander Lobakin <aleksander.lobakin@intel.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	Nilesh Javali <njavali@marvell.com>, Christoph Hellwig <hch@lst.de>,
	John Meneghini <jmeneghi@redhat.com>, Lee Duncan <lduncan@suse.com>,
	Mike Christie <michael.christie@oracle.com>,
	Hannes Reinecke <hare@kernel.org>, netdev@vger.kernel.org,
	linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
	GR-QLogic-Storage-Upstream@marvell.com
Subject: Re: [PATCH v5 0/4] UIO_MEM_DMA_COHERENT for cnic/bnx2/bnx2x
Message-ID: <ZcE8JC0o9swkNzmr@rhel-developer-toolbox-latest>
References: <20240201233400.3394996-1-cleech@redhat.com>
 <5228a235-69f4-4a9b-8142-96d9b4a5a1c8@intel.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5228a235-69f4-4a9b-8142-96d9b4a5a1c8@intel.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.11.54.10

On Mon, Feb 05, 2024 at 05:57:58PM +0100, Alexander Lobakin wrote:
> From: Chris Leech <cleech@redhat.com>
> Date: Thu,  1 Feb 2024 15:33:56 -0800
> 
> > During bnx2i iSCSI testing we ran into page refcounting issues in the
> > uio mmaps exported from cnic to the iscsiuio process, and bisected back
> > to the removal of the __GFP_COMP flag from dma_alloc_coherent calls.
> 
> IIRC Jakub mentioned some time ago that he doesn't want to see
> third-party userspace <-> kernel space communication in the networking
> drivers, to me this looks exactly like that :z

This isn't something anyone likes, but it's an interface that's been in
the kernel and in use since 2009.  I'm trying to see if it can be fixed
"enough" to keep existing users functioning.  If not, maybe the cnic
interface and the stacking protocol drivers (bnx2i/bnx2fc) should be
marked as broken.

- Chris

