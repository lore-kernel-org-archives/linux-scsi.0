Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF7C21E261D
	for <linux-scsi@vger.kernel.org>; Fri, 15 Nov 2024 20:25:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=170.10.133.124
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731702305; cv=none; b=g4/LfrIXpDoXXtZhtbhbvErn6QE6Ecn4UvfGv6ePQ4w8UzRGdP5avXPhNCcDt69F/gZT8bTzcgKMozI5GyuuEBA5CmidOaJuZ4BVwRRBl1QLHk+PklX1i2rphwr8d+kzIFggaK0umDuR8pD2iudA19bMdq/bKYEh1B/G0lwRFb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731702305; c=relaxed/simple;
	bh=hvF03FhAh8ktG5z2TiMAbW6Ya7E4zrNk6yvwFV+EazI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=U6QFzanAp73FeaxWBgO4eeAFVsr8PtWwpN/kjm/7YKAcztGzFuoHDRzOKv1a8ruGULTPQJNTrKgzqgqOVS6/zjI/+rg+Nj40Ffpoa3uIQ+0saC9SAX+nQfgcPdDLd395e8k/v23H8dTUlkkgcVij3N3PuwVLeSJazCIdfdZAAzg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com; spf=pass smtp.mailfrom=redhat.com; dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b=CD2liQ+H; arc=none smtp.client-ip=170.10.133.124
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=redhat.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=redhat.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="CD2liQ+H"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
	s=mimecast20190719; t=1731702302;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:content-type:content-type:
	 content-transfer-encoding:content-transfer-encoding:
	 in-reply-to:in-reply-to:references:references;
	bh=0KsHqtevqi94k/wuH1AavMKuBodzdw49pCdawJi5eRo=;
	b=CD2liQ+Hz+ObqVg2JQxmUPdrzlvXoTfmgzLL0qu1spYznfQORT1B/FslMLp8Nsj6ltDpQ+
	56aGhBUr4N9yT8QQWjv9AulhgRheiiY7LFhei1IISF4tcuYam0v0u8OS+UOX05IIvEyuht
	iUscVfDuGqlkDIplc5jvqd76ThYLLxI=
Received: from mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com
 (ec2-54-186-198-63.us-west-2.compute.amazonaws.com [54.186.198.63]) by
 relay.mimecast.com with ESMTP with STARTTLS (version=TLSv1.3,
 cipher=TLS_AES_256_GCM_SHA384) id us-mta-278-aEFVChi2OyCcVrsWQ4YEyg-1; Fri,
 15 Nov 2024 15:24:59 -0500
X-MC-Unique: aEFVChi2OyCcVrsWQ4YEyg-1
X-Mimecast-MFC-AGG-ID: aEFVChi2OyCcVrsWQ4YEyg
Received: from mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com [10.30.177.40])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	by mx-prod-mc-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTPS id 251F019560BE;
	Fri, 15 Nov 2024 20:24:58 +0000 (UTC)
Received: from [10.22.81.39] (unknown [10.22.81.39])
	by mx-prod-int-04.mail-002.prod.us-west-2.aws.redhat.com (Postfix) with ESMTP id 18BE71956054;
	Fri, 15 Nov 2024 20:24:54 +0000 (UTC)
Message-ID: <5cc6e84b-9811-4a86-acc4-1cfec169c6b1@redhat.com>
Date: Fri, 15 Nov 2024 15:24:54 -0500
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: DMMP request-queue vs. BiO
To: Mikulas Patocka <mpatocka@redhat.com>
Cc: linux-block@vger.kernel.org, dm-devel@lists.linux.dev,
 linux-scsi@vger.kernel.org, Chris Leech <cleech@redhat.com>,
 Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@lst.de>,
 snitzer@kernel.org, Ming Lei <minlei@redhat.com>,
 Benjamin Marzinski <bmarzins@redhat.com>,
 Jonathan Brassow <jbrassow@redhat.com>, Ewan Milne <emilne@redhat.com>,
 bmarson@redhat.com, Jeff Moyer <jmoyer@redhat.com>,
 "spetrovi@redhat.com" <spetrovi@redhat.com>, Rob Evers <revers@redhat.com>
References: <2d5fe016-2941-43a4-8b7c-850b8ee1d6ce@redhat.com>
 <20241104073547.GA20614@lst.de>
 <d9733713-eb7b-4efa-ad6b-e6b41d1df93b@suse.de> <20241105103307.GA1385@lst.de>
 <643e61a8-b0cb-4c9d-831a-879aa86d888e@redhat.com>
 <41cf98c3-a1de-a740-01ad-53c86f3bc8a5@redhat.com>
Content-Language: en-US
From: John Meneghini <jmeneghi@redhat.com>
Organization: RHEL Core Storge Team
In-Reply-To: <41cf98c3-a1de-a740-01ad-53c86f3bc8a5@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.0 on 10.30.177.40

On 11/15/24 09:05, Mikulas Patocka wrote:
> I suggest to use some real-world workload - you can use something that you
> already use to verify the performance of RHEL.
> 
> The problem with fio is that it generates I/O at random locations, so
> there is no bio merging possible, so it will show just the IOPS value of
> the underlying storage device.

OK. That's the information was as looking for. So we'll be sure to run some real world workloads that hit the bio merging code 
path.

Thanks,

/John

