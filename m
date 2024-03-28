Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2AD74EB4E;
	Thu, 28 Mar 2024 06:51:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711608672; cv=none; b=QWV84BXUWvnxfWhtJIr1dkAFnytWOfIoo0yjBmCkorlDLnul4nAY1ZjOajvPJOe9LbbcvnrQWpstb1in4WP6p25qP1+/o7ZfuB6/lzYTIMPMhc5hlTpcZ8oBKdOKYdOY7AKDBSKvRDvgDlnmtS6mTn928EDe60GTjmZqPReFs9A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711608672; c=relaxed/simple;
	bh=aTzaANG9xoqixNTobM3JZiK2u04Y/OCEwuf/Z1KZ1w0=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=pa5Kd7hCD0s8dyM1ab6eipoXvCzAwK54BrERfZxK+zmh6OyKeqXCc2/ipYYb+JBCndDJnSCsEE2IPz+i0QNIfJcYWdZZTXvCkPrDl+wMmmrl7NSM8c7NITf93gz4SHDDgFftSRrxhmpghtwIE806+ttUljYOob3ENL4hYdQ+YYc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Pv4O/eRb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Pv4O/eRb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0ACA3C433C7;
	Thu, 28 Mar 2024 06:51:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1711608672;
	bh=aTzaANG9xoqixNTobM3JZiK2u04Y/OCEwuf/Z1KZ1w0=;
	h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
	b=Pv4O/eRb9QBl3AAjajxbG9oGIZoyqT5pWb+5oAjc6+Fg5gQDudUBO5e7G8OyQZaYA
	 CCYE8wkhyLalBuSmlxqMUF7NfEyQSoVoKX4Nfx24F1EUZDGpqK4FnjjsVs63RnbT4Z
	 lP8+zeL28RqpQqhXbZmCxXePPrZ+ZdbMYuTGbq3/lRiFGVpmAIaRni1Yn+5CPcmOPQ
	 3n8v9NS7DxtYhYd23twfxVX7s7mQEWRizdJ/Kg5B0LdrAjeEPA5Qi+9ADJCE8hjFDW
	 HVo02vh2Tb6eiQXHjAREuuNUy5s0WPdebMzVIac7oQyDGbI9fOcftJhrpt8BfjKYDb
	 Yd4GDLFPvuUrA==
Message-ID: <b144a7f1-af29-4c0d-96f7-c0f16b2299b8@kernel.org>
Date: Thu, 28 Mar 2024 15:51:09 +0900
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 09/30] block: Pre-allocate zone write plugs
To: Christoph Hellwig <hch@lst.de>
Cc: linux-block@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
 linux-scsi@vger.kernel.org, "Martin K . Petersen"
 <martin.petersen@oracle.com>, dm-devel@lists.linux.dev,
 Mike Snitzer <snitzer@redhat.com>, linux-nvme@lists.infradead.org,
 Keith Busch <kbusch@kernel.org>
References: <20240328004409.594888-1-dlemoal@kernel.org>
 <20240328004409.594888-10-dlemoal@kernel.org> <20240328043016.GA13701@lst.de>
 <714d0cbc-be4d-4aa9-b200-73c6caaa1d18@kernel.org>
 <20240328054652.GA16237@lst.de>
 <7d8f3ec4-c416-445f-92db-7d2b60726821@kernel.org>
 <20240328060357.GA16819@lst.de>
 <ca3fe7b0-7e27-4ac9-b669-5263c3cec550@kernel.org>
 <20240328062237.GA17225@lst.de>
 <0d54c569-f586-4b75-a8a3-509e3f3717e2@kernel.org>
 <20240328063816.GA17642@lst.de>
Content-Language: en-US
From: Damien Le Moal <dlemoal@kernel.org>
Organization: Western Digital Research
In-Reply-To: <20240328063816.GA17642@lst.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit

On 3/28/24 15:38, Christoph Hellwig wrote:
> On Thu, Mar 28, 2024 at 03:33:13PM +0900, Damien Le Moal wrote:
>> Ha. OK. I did not see that one. But that means that the plug kfree() can then
>> block the caller. Given that the last ref drop may happen from BIO completion
>> context (when the last write to a zone making the zone full complete), I do not
>> think we can use this function...
> 
> Ah, damn.  So yes, we probably still need the rcu head.  We can kill
> the gendisk pointer, though.  Or just stick with the existing version
> and don't bother with the micro-optimization, at which point the
> mempool might actually be the simpler implementation?

I am all for not micro-optimizing the free path right now.
I am not so sure about the mempool being simpler... And I do see some
improvements in perf for SMR HDDs with the free list. Could be noise though but
it feels a little more solid perf-wise. I have not seen any benefit for faster
devices with the free list though...

If you prefer the mempool, I can go back to using it though, not a big deal.

For other micro-optimizations worth looking at later would be to try out the new
low latency workqueues for the plug BIO work.

-- 
Damien Le Moal
Western Digital Research

