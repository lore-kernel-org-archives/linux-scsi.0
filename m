Received: from 013.lax.mailroute.net (013.lax.mailroute.net [199.89.1.16])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 79C7135A95A;
	Fri, 30 Jan 2026 22:59:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.16
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769813951; cv=none; b=nTNj6OMllJZ6bE/hD8Oc2Df3UFd1ylH1u4jcVctTkg6HWwxQtuPfHYPQUSiEJHGqsZcoG5/oH4rDK1oc0IhKQS3ohUWUzUqjaYT1Y/FXZd7QIfvQHZPzLEik32xNPzX9cOhtSZ04Vrc1RF9Bgkq8RYQJ5zxHNfLiz/REdg1Kn/4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769813951; c=relaxed/simple;
	bh=pGZCdfTqJZsczKLbgP8aETuCtwVHrNt9P39BRiViQ1g=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=qjQqLoRr6g4fvpxcq0r0MheajFzPM2dsaDwuhZYKoizfzs9lWi3NDGDWkjEoVgQmQtLfi38s7ZoEXDKvAiVxUaXeJGAfb/E0E+mQit4iH5DGSBuxXfO09Zt8YqDi3Di4vM4nJzwv+5MeT77GfcK19EzQgmmMHPZ4dy8GY5mvIzk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=QTk5ow9G; arc=none smtp.client-ip=199.89.1.16
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="QTk5ow9G"
Received: from localhost (localhost [127.0.0.1])
	by 013.lax.mailroute.net (Postfix) with ESMTP id 4f2rzX4wHrzm4ql0;
	Fri, 30 Jan 2026 22:59:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1769813942; x=1772405943; bh=pGZCdfTqJZsczKLbgP8aETuC
	twVHrNt9P39BRiViQ1g=; b=QTk5ow9G2TWbxVMxrX4lXhMSMGVYdJCx5sgAI6g+
	DvXEr0Dfl4mFpCNDj+rePLRl1xHfv3kOiZC78rLfcWYDE7t36Mu8sm5BNallsfrD
	q8dJMWUicsgcJ15Xpi1aW11ZTMcCLVTQH5I1eKTsjyroBiJZNyKFzQ4g2o7fprqA
	hBlgr/38v4a9BKiDtHo3KmvUZda3Icp2uFiuJtEJPPPTpK6puBucqhTZF4kcSPfu
	LAUYiqX3HT+b9+x1FoQvkzQgi1DGfFk7Y+UynoRvp0fWAd2Wjcz5gLHUrJqm9k2I
	6pI4tdBb+dNAd5qdVg7C2tgNuapW7ok6gVjRa9YQMxjYSw==
X-Virus-Scanned: by MailRoute
Received: from 013.lax.mailroute.net ([127.0.0.1])
 by localhost (013.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id YmmZJXQ3CZ6w; Fri, 30 Jan 2026 22:59:02 +0000 (UTC)
Received: from [100.119.48.131] (unknown [104.135.180.219])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 013.lax.mailroute.net (Postfix) with ESMTPSA id 4f2rzR6Blvzm4qkw;
	Fri, 30 Jan 2026 22:58:59 +0000 (UTC)
Message-ID: <c050a431-9425-467e-a6bd-1cfecc595416@acm.org>
Date: Fri, 30 Jan 2026 14:58:59 -0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v3 1/1] scsi: ufs: core: Flush exception handling work
 when RPM level is zero
To: Thomas Yen <thomasyen@google.com>
Cc: Stable Tree <stable@vger.kernel.org>,
 Alim Akhtar <alim.akhtar@samsung.com>, Avri Altman <avri.altman@wdc.com>,
 "James E.J. Bottomley" <James.Bottomley@hansenpartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Peter Wang <peter.wang@mediatek.com>, Bean Huo <beanhuo@micron.com>,
 Adrian Hunter <adrian.hunter@intel.com>,
 "Bao D. Nguyen" <quic_nguyenb@quicinc.com>,
 "open list:UNIVERSAL FLASH STORAGE HOST CONTROLLER DRIVER"
 <linux-scsi@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
References: <20260129070657.678532-1-thomasyen@google.com>
 <491d53b9-a110-431b-9a5e-3b46d833fdbb@acm.org>
 <CALw5pqG735L-6-umZspQOKB9DfRHf7D0AfpkRD_=xwX0LtZ2Vg@mail.gmail.com>
 <076fe171-6fd3-4dbc-9876-242905379594@acm.org>
 <CALw5pqH8LDxxHcpS=KGnLtdA0GG7sdd1y3Zz9hQLfcChgyH+GQ@mail.gmail.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <CALw5pqH8LDxxHcpS=KGnLtdA0GG7sdd1y3Zz9hQLfcChgyH+GQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 1/29/26 9:39 AM, Thomas Yen wrote:
> My apologies. I missed that Peter had already replied with his
> Reviewed-by tag on this v3 thread before I sent v4.

In the future, please leave more time between posting different versions
of a patch. Posting four versions of the same patch in five days is too
frequent because it doesn't give reviewers enough time to react.

Thanks,

Bart.
