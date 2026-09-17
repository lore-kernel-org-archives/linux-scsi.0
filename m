Received: from mta0.migadu.com (out-250.mta0.migadu.com [91.218.175.250])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 132EA4A5EB8
	for <linux-scsi@vger.kernel.org>; Thu, 17 Sep 2026 10:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=91.218.175.250
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789640814; cv=none; b=scPETXlgFo8yKtTQ1pORwkm+vsR9G16zHVdNKYFvB6bqJjda/hVZb7Mc82XeDyuMXWCA79b4EvGCY4Bp1kEOtWhEPdXmGk0v7dy+rfjGM6UJAihAKi2oSvRj11AQ6RbYtJVqd3k7fwHoCFfsjjTX+Iv9F3UPd6YyNPMtX7xIGHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789640814; c=relaxed/simple;
	bh=HxTI8x+udaq/A6fK3KTDzKYwWnZ3dpHQNxUEWV2rq6c=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=fZHCgDVtFJkR+pZqDT4yhb7yX81FT4elDbuQfO1Ui2UfVissOlos3Mt1JCMcb18dkcAZKz9uVstA4IxJHhsjxLZ3a2g2cEkq9Wpq83GTwzsTr/+oBI4VuadbbVXs3jr1jFocsR6PFK4pHEryYyJrCBr07EiV1fBF2dUkoWesfP4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev; spf=pass smtp.mailfrom=linux.dev; dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b=qC2wNu7q; arc=none smtp.client-ip=91.218.175.250
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linux.dev
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linux.dev
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linux.dev header.i=@linux.dev header.b="qC2wNu7q"
X-Envelope-To: linux-scsi@vger.kernel.org
DKIM-Signature: a=rsa-sha256; bh=HxTI8x+udaq/A6fK3KTDzKYwWnZ3dpHQNxUEWV2rq6c=;
 c=simple/simple; d=linux.dev;
 h=from:to:subject:date:message-id:mime-version:content-type; s=key1;
 t=1789640809; v=1; x=1790245609;
 b=qC2wNu7qi0BvElPEnzt9qaugiRdBJ9MpYetCv3H1/bCbaTnq7pYMtyZYwT3SJ4guZmaRSEa9
 Zq6JcNlikc9P7yMDuuc9PZHLKpXiF1xhmrCZmi2OFQDh/9NX3e+BpCT5C8yuE1tSo0WmBRP7Bsb
 nI/eJe5QA9uWN+n/zA8k71AQ=
X-Envelope-To: linux-scsi@vger.kernel.org
Received: by mta10.migadu.com with ESMTPS id 90f2fb25098390b4;
	Thu, 17 Sep 2026 10:26:49 +0000
X-Mizu-Trace-ID: 90f2fb25098390b4
X-Migadu-Flow: FLOW_OUT
Message-ID: <0acc0a4d-b532-4f69-8fcc-1d4eef7549c0@linux.dev>
Date: Thu, 17 Sep 2026 11:26:45 +0100
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH 2/2] scsi: scsi_debug: Validate zone access for WRITE
 ATOMIC (16)
To: Niklas Cassel <cassel@kernel.org>
Cc: "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>, linux-scsi@vger.kernel.org,
 Damien Le Moal <dlemoal@kernel.org>, Christoph Hellwig <hch@lst.de>
References: <20260917084553.559765-4-cassel@kernel.org>
 <20260917084553.559765-6-cassel@kernel.org>
 <f1c5db8b-2c99-4c5f-bb1a-3da8f2c5413b@linux.dev> <aqu5Q_6EvfY7iRmk@ryzen>
Content-Language: en-US
From: John Garry <john.garry@linux.dev>
In-Reply-To: <aqu5Q_6EvfY7iRmk@ryzen>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit

On 9/17/26 10:56, Niklas Cassel wrote:
> On Thu, Sep 17, 2026 at 10:38:30AM +0100, John Garry wrote:
>> On 9/17/26 09:45, Niklas Cassel wrote:
>>
>> So far we have not considered atomic writes for zoned devices
>> - do devices which support both technologies exist? Or is
>> this just hypothetical?
> If the specs allow it, someone might build it.

Sure, but do they (allow it)? atomic writes have specific alignment and 
granularity rules - how does that play with zoned devices?

I would need to check the specs more on this..

> 
> I don't see why someone would not want to build a device that supports both,
> as they are both really nice features 🙂

