Received: from 011.lax.mailroute.net (011.lax.mailroute.net [199.89.1.14])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7AED94F93C9
	for <linux-scsi@vger.kernel.org>; Mon, 28 Sep 2026 17:42:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.14
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790617373; cv=none; b=Y1J63wBkS+gioVVYIy9rGdlKKmK9T7261uJ8Xuc6Q3xSM8DPsQ/RneiyVnNRPAqaMnhmEQdfv/eoFpl+pWMzcYgB3L7PmTXf09I6tz9XJRGIEuRyCk26b8WszO2OtdBmmHAk5AT7xvE5NEmjT/oDELg5rAY2Odw7aQtIyY0xDO8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790617373; c=relaxed/simple;
	bh=1rOpq6LeVE8qXkxsIEve4N4OOaPYUZPcyM2A4Y0VmZU=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=kyTn6KMB/QX0hJm4jQ/3rkquE02hJE+76kiEGRI8REPKddsNa9mktZxDcq4S9fBcXkgvzLdWg2yZo2zChOqFOes0UG+4DoXrD+odbyc2wBB5HR4gI3RdJbkEP7OZeQWkU3r9I6+DHd8Ba0eDtuFwXXvSIFQHAYNaBSO0A9BBYq8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=UY62IRH0; arc=none smtp.client-ip=199.89.1.14
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="UY62IRH0"
Received: from localhost (localhost [127.0.0.1])
	by 011.lax.mailroute.net (Postfix) with ESMTP id 4htpYR71Spz1XM4TB;
	Mon, 28 Sep 2026 17:42:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1790617368; x=1793209369; bh=TgC/UZ4H1fwXMswgbvHYjiJD
	uCBkRhlteJ1a8it6dGA=; b=UY62IRH03STIxyteE8sAYBc3ckrIquAXK0qVM1YW
	IkunbjsdCV1o8mKFHv0g+W7HjUdlG41VO+BLpFjyx+I6P6iRlNIw4ikvf3BnHS/s
	LsmeMtjNUYGGXDDP0xFbFqPJ1i/RUVOj0R8id5d5xTAVPRej7xY8j+hLJWMFfb0H
	UG6ULxfmuonsxjV/FFLHdvOD7vf3xhjRmigbW8lubl3TPbo8KySzHKyji2Vf1bTh
	LOfGrnBf60AiBvwyQhXTJ4DwURiEuxQk9z+DkVc+jN1ma0+nR3aKl181zh0W5Ufn
	qbdx+WlBOpnrwmlbimYSp2rEwRPKla1lY+A7Kk0JYEw0pA==
X-Virus-Scanned: by MailRoute
Received: from 011.lax.mailroute.net ([127.0.0.1])
 by localhost (011.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id mC29B0vhXiAo; Mon, 28 Sep 2026 17:42:48 +0000 (UTC)
Received: from [IPV6:2a00:79e0:2ed2:d:334e:163d:7b65:8f42] (unknown [104.135.182.42])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 011.lax.mailroute.net (Postfix) with ESMTPSA id 4htpYM0FCKz1XM4Sx;
	Mon, 28 Sep 2026 17:42:46 +0000 (UTC)
Message-ID: <3e9a812b-68b7-4afc-82f0-afec8fa3c53b@acm.org>
Date: Mon, 28 Sep 2026 10:42:46 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v4 06/54] scsi: NCR5380: Prepare for enabling lock context
 analysis
To: Finn Thain <fthain@linux-m68k.org>
Cc: "Martin K . Petersen" <martin.petersen@oracle.com>,
 linux-scsi@vger.kernel.org, Michael Schmitz <schmitzmic@gmail.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <mkp@kernel.org>
References: <cover.1790360262.git.bvanassche@acm.org>
 <a9d1b960868ac4dae9c5a9b98aea5dcf6713fb97.1790360262.git.bvanassche@acm.org>
 <f2c1a279-088a-9e78-8b87-e5296950ff1d@linux-m68k.org>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <f2c1a279-088a-9e78-8b87-e5296950ff1d@linux-m68k.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 9/25/26 5:42 PM, Finn Thain wrote:
> On Fri, 25 Sep 2026, Bart Van Assche wrote:
>>   /*
>> - * Function : NCR5380_information_transfer (struct Scsi_Host *instance)
>> + * Function : NCR5380_information_transfer(struct NCR5380_hostdata *hostdata)
>>    *
>>    * Purpose : run through the various SCSI phases and do as the target
>>    * directs us to.  Operates on the currently connected command,
>>    * instance->connected.
>>    *
>> - * Inputs : instance, instance for which we are doing commands
>> + * Inputs : hostdata, the private host data
>>    *
>>    * Side effects : SCSI things happen, the disconnected queue will be
>>    * modified if a command disconnects, *instance->connected will
>>    * change.
>>    */
>>   
> 
> Acked-by: Finn Thain <fthain@linux-m68k.org>

Thanks!

> Would you please update that to kerneldoc format? Something like this:
> 
> /**
>   * NCR5380_information_transfer - respond to information transfer phases
>   * @hostdata: private host data
>   *
>   * Run through various bus phases as directed by the target.
>   * Operates on the currently connected command until it's either completed
>   * or moved to the disconnected queue.
>   */

Sure, if I have to repost this patch series I will include the above
change.

Bart.
