Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 586E5132805;
	Thu, 28 Mar 2024 22:25:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711664725; cv=none; b=OrlB6ew4z3Vvam6GG18M5Zdt07ka748p7sHi/5dDHO8NL/UYxmJUdN7MQi525qaMKBTt8SMaOFCr+olgieF1/CcvLrU8adaFHbnuxs6XgVHjsMNOHOqjMoCnnSyNGEZD/S7bZMEvL3/cK1RGVkPraD2lD5DxcWFhuKuBgKZlFqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711664725; c=relaxed/simple;
	bh=uDiRKu73/hN347FaSIguDcdRDat2bRMHejo+NSrNvNM=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=DqpKddu93hlNYO67OjKc9/Dxj+RSXUCtPN3PqXIC4mFFmgj63hS8+cF87CpN1AjRoujPoCaHgTEBTPelt4lkfV86tRed11vhOg7g431cF+4HwDTH3nZR+YTe2zbeGMMSfzLz7Xr8aspldxHpr+jMXyItc9s50YbGeIiC+ELzO70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=s0vj/K9X; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="s0vj/K9X"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4V5J5H5NWpzlgTGW;
	Thu, 28 Mar 2024 22:25:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1711664720; x=1714256721; bh=J5EShaWpE9jHmQcfxOwHNuuU
	+aQl/RglSXF/ix8VP1E=; b=s0vj/K9X9KhI6py6zwGuDXPLxewcaYA9G0fZ2t1E
	ByemSM4p5Vv0pmDOoOsShrkQ2rGaPPx22strVEnSL1X60/fwJIPZRbBrnQyxygol
	leU2is+RlifeFHMb6MuApx7yXo6Vu7zWPt+nj27ESc1c4t3JiBhVAdRihooKfRsu
	cRaOnu4k14iBW280127Cwe0mhu8pdY/5f5uW1dveRr39HLyOJRDLt4uAbJEf2TYo
	jl6DWejvHCBA1uRbVTwK74spYWXaJkjC/bM2gPsEtp4Yg12y8UqRM/F6eoJqhhg9
	CeJGS1mdaeJrlVYPxvb5rj45cB/4MV39m9RschazfPjn/g==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 2COEEicsZIZx; Thu, 28 Mar 2024 22:25:20 +0000 (UTC)
Received: from [192.168.3.219] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4V5J5C3msbzlgTHp;
	Thu, 28 Mar 2024 22:25:19 +0000 (UTC)
Message-ID: <711ee94e-7cf6-4a5d-8979-f20e48b5348a@acm.org>
Date: Thu, 28 Mar 2024 15:25:18 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 09/30] block: Pre-allocate zone write plugs
To: Christoph Hellwig <hch@lst.de>, Damien Le Moal <dlemoal@kernel.org>
Cc: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
 linux-scsi@vger.kernel.org, "Martin K . Petersen"
 <martin.petersen@oracle.com>, dm-devel@lists.linux.dev,
 Mike Snitzer <snitzer@redhat.com>, linux-nvme@lists.infradead.org,
 Keith Busch <kbusch@kernel.org>
References: <20240328004409.594888-1-dlemoal@kernel.org>
 <20240328004409.594888-10-dlemoal@kernel.org> <20240328043016.GA13701@lst.de>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240328043016.GA13701@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/27/24 9:30 PM, Christoph Hellwig wrote:
> Please verify my idea carefully, but I think we can do without the
> RCU grace period and thus the rcu_head in struct blk_zone_wplug:
> 
> When the zwplug is removed from the hash, we set the
> BLK_ZONE_WPLUG_UNHASHED flag under disk->zone_wplugs_lock.  Once
> caller see that flag any lookup that modifies the structure
> will fail/wait.  If we then just clear BLK_ZONE_WPLUG_UNHASHED after
> the final put in disk_put_zone_wplug when we know the bio list is
> empty and no other state is kept (if there might be flags left
> we should clear them before), it is perfectly fine for the
> zwplug to get reused for another zone at this point.

Hi Christoph,

I don't think this is allowed without grace period between kfree()
and reusing a zwplug because another thread might be iterating over
the hlist while only holding an RCU reader lock.

Thanks,

Bart.
