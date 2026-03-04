Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60C38371CE8
	for <linux-scsi@vger.kernel.org>; Wed,  4 Mar 2026 20:31:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772656311; cv=none; b=Kw5o5wWJq1Nct/HAgufhNQRixfZV6zoYs09j+yu5iydSuryGYSb8IKUVOMAvjl8l6JcDPPYQymW8HZuedXjz19wT+PNXkCtFgE9WIJwk2vamlI9hc4X8dioJ78xKnsCSbvX/LC3kPP9P84MQweI0ipgAbEq8vF6fpJ4RPjSdITY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772656311; c=relaxed/simple;
	bh=xoP1qizoHJt18C53/z2ZZdbveYWJn5jL4aOhQ8SoOoA=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GCR+iISId2tt4JPPuApJaSePNt5oyaTWmUanJ7Fl4OBTgBifHStIEyRzrWf81eY3c/immNa8xXhAZ9+hz2qI2MsAuwx5CZHD4tHRS+PW5Q/LPA+fH0AEjP77xOijuBXDuZcu7UAorowx5Gz6HzeanjSITzU9mw/blogPJLPHXng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=pui0NfHT; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="pui0NfHT"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4fR48P6K64zlfl5P;
	Wed,  4 Mar 2026 20:31:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1772656306; x=1775248307; bh=xoP1qizoHJt18C53/z2ZZdbv
	eYWJn5jL4aOhQ8SoOoA=; b=pui0NfHTE84Yj4dEEP2DKM4C0bEznnCTBr8cVdpk
	louLQ6hWPvrUUxItQSr0Jrc/L5IkFthOzPUMnjG2Egifx8r5hDd/BGyUOCb05VR1
	nPQjFXlzgo0INx1lKjZiVpxXTbb6ly81nHDgbTrE24COIyksCAMG4GPVDezstS0t
	/8YYO7PfNXVLNuVWvnknepvm+vrM86AVQJjvP/n1ianbKv5kZmKiMg0+E4v9AHpE
	pLKOWPI1tlOXZRFETeYXzAVA3NO34fgPz2gM/xuuLOL6+m1mn0uTj59Ulk/498lg
	h2jtxfr05UQt4CHZNsR2jAe9YXv94KbVpqBXoW0q66PP3A==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id S9aUqhifXknN; Wed,  4 Mar 2026 20:31:46 +0000 (UTC)
Received: from [192.168.132.187] (unknown [12.150.89.26])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4fR48J6jBvzlfl5n;
	Wed,  4 Mar 2026 20:31:44 +0000 (UTC)
Message-ID: <adea7fef-e0a3-4573-bf27-3796b611c1f0@acm.org>
Date: Wed, 4 Mar 2026 14:31:42 -0600
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 7.0/scsi-fixes] scsi: core: fix error handling for
 scsi_alloc_sdev()
To: Junxiao Bi <junxiao.bi@oracle.com>, linux-scsi@vger.kernel.org
Cc: martin.petersen@oracle.com, James.Bottomley@HansenPartnership.com,
 michael.christie@oracle.com, john.g.garry@oracle.com
References: <20260304164603.51528-1-junxiao.bi@oracle.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20260304164603.51528-1-junxiao.bi@oracle.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/4/26 10:46 AM, Junxiao Bi wrote:
> After scsi_sysfs_device_initialize() was called, error paths
> must call __scsi_remove_device().

My suggestion was to include the above sentence in the patch description
instead of replacing the entire patch description with the above
sentence. Anyway:

Reviewed-by: Bart Van Assche <bvanassche@acm.org>
