Received: from desiato.infradead.org (desiato.infradead.org [90.155.92.199])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 539C3215F55
	for <linux-scsi@vger.kernel.org>; Tue,  8 Oct 2024 23:26:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=90.155.92.199
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728430007; cv=none; b=bFtP0D9POAnrIxQemu13q5t7FOr80+wXsodelMYPXwdwNJIi7qYLFC+Atea7HbNWKFsgEn9BzOCbWP/2NyxtzST2aZQKZC3mMf8UlVfzX/T7DyrnKoQkzp2uVX9GlVAQZKbzVGoFR/rrehqJkB6fX5xfPg65pEoODyLvuLj6tLY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728430007; c=relaxed/simple;
	bh=19wvEedYWFS/kFUF4FDkqx7Tryf685VxWrhsmGwIfL8=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fIDNEYFJIaaXt+XNpoFpwrkRBxfPSDqs4b92u+Z/HZChxWKKaDUVUTHe2BD9RvqibjXRxfCXxM6pznObGKgE8eFw3kRBboUBrbFdlzXZ6S8j+Mosgo8kWLKgZKKLuxGPC6DgfstWCd1K+YLrqDNK93de++AVA8kI/CHb+s2t+wA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org; spf=none smtp.mailfrom=infradead.org; dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b=Iwz/9ljd; arc=none smtp.client-ip=90.155.92.199
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=infradead.org
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=infradead.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="Iwz/9ljd"
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
	d=infradead.org; s=desiato.20200630; h=Content-Transfer-Encoding:Content-Type
	:In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:
	Sender:Reply-To:Content-ID:Content-Description;
	bh=ddhYRCjIndS5Cwyct3nxT6vUdpKyMWi7Nu3lDpbXsX8=; b=Iwz/9ljdJn7geBCbcGSnTT1lEE
	AqtOyd7UKIp7ZsS2NC3Vsmd3hGfQxrfBSUwN8QfRkzDQ+8VDpf+UUZEJuxD7F+MhWfj4MKzEU+o1f
	mh3YJ+M/vvdKU0DAg/cwDzCBmPumcGKFMda3Eknw74zTV7Iq1t4PkojIej8ON80juQdFgtdq/ZN/s
	gZhf9UZnF7SUtNe8t0j54WwtNSrY4nye8X4NwVTeeP++xEYuyr+7gAIJoay24oHoSXv5pdmCGgFY3
	Z9YR/nulVG3My5tNrS+scUOc1aPJ4HCiAkv7PsXqS6+9niXYrioG4exMi5AFmdPqoaYvGA0F5O7Ne
	fpSV5KHQ==;
Received: from [50.53.2.24] (helo=[192.168.254.17])
	by desiato.infradead.org with esmtpsa (Exim 4.98 #2 (Red Hat Linux))
	id 1syJbG-00000004ki8-23OT;
	Tue, 08 Oct 2024 23:26:42 +0000
Message-ID: <ac20fa78-4837-49ed-90c2-49bc3cde9b47@infradead.org>
Date: Tue, 8 Oct 2024 16:26:40 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 2/6] scsi: core: Rename .slave_alloc() and
 .slave_destroy() in the documentation
To: Bart Van Assche <bvanassche@acm.org>,
 "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, Damien Le Moal <dlemoal@kernel.org>,
 Jonathan Corbet <corbet@lwn.net>
References: <20241008205139.3743722-1-bvanassche@acm.org>
 <20241008205139.3743722-3-bvanassche@acm.org>
 <ba58a12b-9745-4fb0-8be0-199bd8827201@infradead.org>
 <a07e83ae-bec7-4738-8c79-328492dbce79@acm.org>
Content-Language: en-US
From: Randy Dunlap <rdunlap@infradead.org>
In-Reply-To: <a07e83ae-bec7-4738-8c79-328492dbce79@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit



On 10/8/24 4:05 PM, Bart Van Assche wrote:
> On 10/8/24 4:00 PM, Randy Dunlap wrote:
>> It sure would be nice to know what changed between v2 and v3 of your patches
>> (or vN .. vN+1 any time).
> 
> Hi Randy,
> 
> The changelog is available in the cover letter:
> https://lore.kernel.org/linux-scsi/20241008205139.3743722-1-bvanassche@acm.org/

Oh, I see. Thanks.
I didn't receive that email...

-- 
~Randy
