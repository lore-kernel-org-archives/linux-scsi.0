Received: from 008.lax.mailroute.net (008.lax.mailroute.net [199.89.1.11])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF554195FEF;
	Thu, 27 Jun 2024 14:40:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.11
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719499248; cv=none; b=gwIQmji75GANb+QWl+rqQ51960JPLAvjKYwzfFQSd6EmJifv27WyEMbGqIHNxcfOEzZZ5yauhJeOAfadjJi7JK1fHqtkyYpHN7oWnJ+bK9r8VOSiVsB/bfCor0hHBaXnyKs0IOb6NBXzdDLjxLa3LwFkoczXHguhgJVYu24htUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719499248; c=relaxed/simple;
	bh=NINHKb8FIlfx0+6iUSTr7gqb1HKbB0I//0MT6wTMqC4=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=aSLQsfpE6IC7wMT6FEQ7egQmOYdYQhqNfhrqQHCm+Ea6amZOPeFxHg5CnAMzY/y1mEuHtMDv/XN67aymiMHzBLdvM15kJIZllrVdTH22OZCaMSsCXTUnTSM7OUYBWC/aHb5uzrieiqF6RHU74ctmElWAnrN/2K8OqoGd6CF7LsQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=RaqP7sub; arc=none smtp.client-ip=199.89.1.11
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="RaqP7sub"
Received: from localhost (localhost [127.0.0.1])
	by 008.lax.mailroute.net (Postfix) with ESMTP id 4W91T96QtBz6Cnv3g;
	Thu, 27 Jun 2024 14:40:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1719499241; x=1722091242; bh=EtC9symTgPYYUVBekMSlXR6p
	wPouqgrhp8HSMzezDo0=; b=RaqP7subSlMFc+IkU0X1XvD9cfLdfswMVeAPEjzC
	YkjNyS2P1/JvQrhpaGuTFaMato2kPl7g+t/EE/2EX2Ece8rp/VWQ9+1qWbYkqUpH
	8n/Mfw0+YZOtJYD2lqoaAKMu7Q7+1WIKwCycNujOLspp2tpztoHoBfvHgWSYhZtM
	sfd8IMwxoQTOclUfLex6vJwugFOsO2aZXttghjgoa3jw9senLZmn0S0rS81WQ6hZ
	K/XGF5StqK1BwaNPYch3waSlw1VNPrhTgHeeX7FzuZDwOePzlbKMBBQCjmzJjWGS
	7WBh8JuSZTr+zFzgXBFxitbSsLSkgy/yckTRRd5NW9iFJQ==
X-Virus-Scanned: by MailRoute
Received: from 008.lax.mailroute.net ([127.0.0.1])
 by localhost (008.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id 5oERRB6kd5Jj; Thu, 27 Jun 2024 14:40:41 +0000 (UTC)
Received: from [192.168.50.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 008.lax.mailroute.net (Postfix) with ESMTPSA id 4W91T23Ww1z6Cnv3Q;
	Thu, 27 Jun 2024 14:40:38 +0000 (UTC)
Message-ID: <fcec8bfa-8e9b-41e8-a3df-99b3bf72a060@acm.org>
Date: Thu, 27 Jun 2024 07:40:35 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: get drivers out of setting queue flags
To: Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc: Ming Lei <ming.lei@redhat.com>, "Md. Haris Iqbal"
 <haris.iqbal@ionos.com>, Jack Wang <jinpu.wang@ionos.com>,
 Kashyap Desai <kashyap.desai@broadcom.com>,
 Sumit Saxena <sumit.saxena@broadcom.com>,
 Shivasharan S <shivasharan.srikanteshwara@broadcom.com>,
 Chandrakanth patil <chandrakanth.patil@broadcom.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Sathya Prakash <sathya.prakash@broadcom.com>,
 Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
 Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>,
 linux-block@vger.kernel.org, megaraidlinux.pdl@broadcom.com,
 linux-scsi@vger.kernel.org, MPT-FusionLinux.pdl@broadcom.com
References: <20240627124926.512662-1-hch@lst.de>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240627124926.512662-1-hch@lst.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 6/27/24 5:49 AM, Christoph Hellwig wrote:
> now that driver features have been moved out of the queue flags,
> the abuses where drivers set random internal queue flags stand out
> even more.  This series fixes them up.

For the entire series:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>

Thanks!

Bart.
