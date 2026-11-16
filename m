Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=91.218.175.219
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794818691;
	b=Cys6bvUSIQtmIj4mmfgT1WYv+v7NlrUN1fH4YhQMWQvQrGxupWHj8J00y2clLxmV3Z47
	 U1C7f3cnmtwsuQ3dJ1qMS9WqSObU2gLUJqX6EkXS6wXll3OPnkOnq8X2daWtm5IoVLG1t
	 UjMTHe8lb2sxqG5QHcYGzE40WwWQ7qzaLcGxj2kHLgxjQAY6ttCI347z3jR+mPZltc8s9
	 m56Nq9CMqPoEVNOVv4do+JoH2tARfD8OdSLAClMo982FCqagvySAMkasWXU9vARnRGCqZ
	 JR2eyaCOWeEpz7WXwpzEdwjraFsRVCec2YMVsm5q2WIqLA1kEOT/w67G0qV+KdM6WjQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794818691;
	h=DMARC-Filter:X-Envelope-To:DKIM-Signature:X-Envelope-To:Received:
	 X-Mizu-Trace-ID:X-Migadu-Flow:Message-ID:Date:MIME-Version:User-Agent:
	 Subject:To:Cc:References:Content-Language:From:In-Reply-To:
	 Content-Type:Content-Transfer-Encoding;
	bh=App5MivrC29qJ5YU4+PdoN/90QWxn2hpy56HecE5sTc=;
	b=SOxiEthQlfgjnlRoKvrufTeDCkjCGeRK6bWTtMUyNMREEIq1ZZIeDogTjrKn6eBKpSbF
	 N77r+C+aAK8TmScqcTfC/ahTL7CsKEKUmp0ia2KdGmei53AUYjuS4gaOplHtEWCV1wewz
	 GmwRv0cznzIjpVCa4ObP91fFwo6RfdYgPLD/dzXnfbzkkpkbsI4i0QD7dhQNvN2nL8ggq
	 of5robvHfLlLg8q5gsDeFSr0/HQClGDjtt+p02aifCoVHj28/lIC1QRXfAXXxtkQy1c9u
	 /BZVRwLVT0VX5Lwki+AdswgNqjqOgc6JkT4ajb8hNduUUy12ruAdldzTHpzgEPuHlFQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dmarc=pass header.from=linux.dev;
	spf=pass smtp.mailfrom=linux.dev;
	dkim=pass header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b="rn/HLG3Y";
	arc=none smtp.remote-ip=91.218.175.219
Received: from mta0.migadu.com (out-219.mta0.migadu.com [91.218.175.219])
	(using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1) server-digest SHA256)
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E2E2606A323
	for <linux-scsi@vger.kernel.org>; Mon, 16 Nov 2026 08:44:50 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.2 smtp.subspace.kernel.org 2E2E2606A323
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linux.dev header.i=@linux.dev header.a=rsa-sha256 header.s=key1 header.b=rn/HLG3Y
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=/9gL/L4VRPsjzM4uXBvjKnOQSjh1vwhsojRka+2HEnc=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1794818689; v=1; x=1795423489;
 b=rn/HLG3YYMNYo8/Wmq3T0sKhDAVEDcszGPsHt4wuj9yh0W/PUJDzNhz5Xv2gfNiCIO7if3jz
 oZZV9Kd25GtTsmdCTcPgUY/jVrpknIIymsTdJ4IfBaCdQZGdTC8H9Z08IOp34MkgEgQ+rhjf96L
 FD2D9zSTjq4GnSAhmKvXBhEI=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by mta12.migadu.com with ESMTPS id 112a824f4d90f4bf;
	Mon, 16 Nov 2026 08:44:49 +0000
X-Mizu-Trace-ID: 112a824f4d90f4bf
X-Migadu-Flow: FLOW_OUT
Message-ID: <70e9dc89-595b-4cab-a338-f0a1b6b9b58a@linux.dev>
Date: Mon, 16 Nov 2026 08:44:48 +0000
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Post: <mailto:linux-scsi@vger.kernel.org>
List-Help: <mailto:linux-scsi+help@vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
List-Owner: <mailto:linux-scsi+owner@vger.kernel.org>
Precedence: list
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: scsi_dh_alua: set handler_data before
 alua_initialize()
To: Laurence Oberman <loberman@redhat.com>,
 "Martin K . Petersen" <mkp@kernel.org>, linux-scsi@vger.kernel.org
Cc: "James E . J . Bottomley" <James.Bottomley@HansenPartnership.com>,
 Bart Van Assche <bvanassche@acm.org>, Martin Wilck <mwilck@suse.com>,
 Hannes Reinecke <hare@kernel.org>, linux-kernel@vger.kernel.org,
 stable@vger.kernel.org
References: <20261109201120.1067815-1-loberman@redhat.com>
 <37cb0b01-0c6a-4b3d-b3d8-c4e5a45977a8@linux.dev>
 <57f9665fb8c3571cff55b2fafceec7437634fd5d.camel@redhat.com>
Content-Language: en-US
From: John Garry <john.garry@linux.dev>
In-Reply-To: <57f9665fb8c3571cff55b2fafceec7437634fd5d.camel@redhat.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 11/15/26 19:37, Laurence Oberman wrote:
> Agreed, group_id is never read or written. All other members are
> initialized before handler_data is set (h is kzalloc'd, and disabled
> is set under init_mutex in alua_initialize()).
> 
> I would prefer to keep this patch minimal since it is tagged for
> stable, and send a follow-up cleanup that drops the now-redundant
> h check in alua_rtpg_queue() and removes the unused group_id member.
> Does that work for you, or would you rather I fold both into a v2?

I think that you can keep it separate.

Thanks,
John
