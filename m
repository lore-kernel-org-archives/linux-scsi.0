Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 744643D69
	for <linux-scsi@vger.kernel.org>; Wed, 30 Jul 2025 00:05:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.129.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753833913; cv=none; b=NC90dA/AacBnQOPO3DnVmclKKhmMl4yGCSr6PbU929ZdhtMaxo19L24CoZh03GXFuqGrctFTMjjPZImckGgf8oJMh5r0d5agSF67V9jGqK52fgWHi+gAfyUBCtstz6wQxFsDb/N8F3hHG8sQPsYRDb0wMv9IOP/K7ipY5UYlFf8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753833913; c=relaxed/simple;
	bh=DaGkeKEYfGPxiOX5XZ521SqomIWxHWix3NiJ8VBxUwA=;
	h=Date:From:To:Cc:Subject:Message-ID:References:MIME-Version:
	 Content-Type:Content-Disposition:In-Reply-To; b=rzeRQFOD/tYw+7eCVwi63moBG4D+u/Z45dP9h7c/MqjQKcRsKiLAdQWRouAnk+akx+tKKi36BpknH8mELEaBJvdfcGCoBwfX0bBAqRGtKu92K3rxQ7WADqFpS6ElPEQzd9u9/NrlbCKc/ZODKCD8dtcQ1st/AMIXT0p3V3zlfRM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=XcCmnCT4; arc=none smtp.client-ip=170.10.129.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XcCmnCT4"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1753833909;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 in-reply-to:in-reply-to:references:references;
	bh=T5CG1mCyiMgOuAFC8VT29nFYfEFTff+omQN6RM6ipy0=;
	b=XcCmnCT4FL0fV8rl2F6QAJKsN1Ukadz02JlYQGNmFu4+5IykXcIebaJJBJ4K5MAcFqF2sb
	QPTV3sYmfJ3TTdS/tKWjVy+01vDnJydj7DiBfgtAemTbG3brsgll5fK4BqhLRlErqLR2q2
	aKPOqE0YHOToiMHhUOFFaknyPKVvx3A=
Received: from mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-35-165-154-97.us-west-2.compute.amazonaws.com [35.165.154.97]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-475-6B5kBh7mPI626SEbmXaVmg-1; Tue,
 29 Jul 2025 20:05:05 -0400
X-MC-Unique: 6B5kBh7mPI626SEbmXaVmg-1
X-Mimecast-MFC-AGG-ID: 6B5kBh7mPI626SEbmXaVmg_1753833904
Received: from mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.111])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-06.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id E0993180045B;
	Wed, 30 Jul 2025 00:05:03 +0000 (UTC)
Received: from my-developer-toolbox-latest (unknown [10.2.16.27])
	by mx-prod-int-08.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id AE00C1800242;
	Wed, 30 Jul 2025 00:05:01 +0000 (UTC)
Date: Tue, 29 Jul 2025 17:04:58 -0700
From: Chris Leech <cleech@redhat.com>
To: "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Cc: linux-scsi@vger.kernel.org, Nilesh Javali <njavali@marvell.com>,
	Kees Cook <kees@kernel.org>, Bryan Gurney <bgurney@redhat.com>,
	"Gustavo A . R . Silva" <gustavoars@kernel.org>,
	John Meneghini <jmeneghi@redhat.com>
Subject: Re: [PATCH v2 1/1] scsi: qla2xxx: replace non-standard flexible
 array purex_item.iocb
Message-ID: <aIlhqnjTI_7K-Iws@my-developer-toolbox-latest>
References: <20250725212732.2038027-2-cleech@redhat.com>
 <20250728185725.2501761-1-cleech@redhat.com>
 <a1c61211-816e-4479-81ce-e71a0d2b8ec2@embeddedor.com>
 <aIfoWk_I1V0KUx4T@my-developer-toolbox-latest>
 <98ef5001-2ad4-4f2c-946e-57251cd264c4@embeddedor.com>
 <aIgNUw8IfNGOz3tl@my-developer-toolbox-latest>
 <f9525216-5721-4f9e-99ab-d697506e0e8f@embeddedor.com>
 <6d8f13c8-405f-4fa0-ad23-09c9e4c5cd54@embeddedor.com>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6d8f13c8-405f-4fa0-ad23-09c9e4c5cd54@embeddedor.com>
X-Scanned-By: MIMEDefang 3.4.1 on 10.30.177.111

On Mon, Jul 28, 2025 at 08:20:12PM -0600, Gustavo A. R. Silva wrote:
> 
> I just noticed that the new TRAILING_OVERLAP() helper just landed in
> Linus' tree, and this issue seems to be a perfect candidate for it.
> 
> The (untested) patch below avoids the use of `struct_group_tagged()`
> and the casts to `struct purex_item *`:

(I was largely basing my use of struct_group on your blog post from a
few month back, but now there's another new macro!)

Yes, that looks like it would work as long as the driver maintainer
doesn't object to moving that field around in scsi_qla_host.

I'm getting ready to be away from the computer for a week, so I have to
leave this for now. Maybe Nilesh has an opinion?

- Chris

