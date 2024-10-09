Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B851B154C1D;
	Wed,  9 Oct 2024 17:32:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728495160; cv=none; b=dO0yA3gTonjjTfh/mB9OjhkuX3fQcIa5nUq5eq+tA2QVvbPVY5RKOnMfUQKz2VETswVVOHVU0Yyc7OKdt59QzqRXQgNgRPm6N3pWfHS/OIgyiyzcJa95+SiDLP4tmFmpEqeXlL0TKfvyHFJXL85LQSakDnUJq5NNggklCtjGmUA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728495160; c=relaxed/simple;
	bh=HLfQlQ2/O7dyfUzi8c1/yl1T4dTIlEu3tRNygTKHdCI=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=W69p1d/fJdGDFgQRh/ttsh3oEtKGzdJKa8lpUOzQRLX8mKQFdKTS2RhPKahl5OVi0evm4ogbZ4ageieaoJFE0JFT7qvTSIufSH5VcpqHVU69VsFSpCvUYXWR+OJdgaM0EfJOzlejtkewjHewepi1kvBCEh3gq8vG1twPzJEsYWU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=DiJJd2oZ; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=reject dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="DiJJd2oZ"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4XP0MT6kK6zlgTWK;
	Wed,  9 Oct 2024 17:32:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:content-language:references:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1728495152; x=1731087153; bh=3DVpDAPKhEQs5DGtkKhEpGFC
	tL0k+5cJbfMeqq+88o0=; b=DiJJd2oZrVYWhoVOPCyKUzLAXJ4n0ACW3pYzj/BB
	lmNj1+MFwNRj/G8yX7cf3ONGLe82tkGxBJWP7hKx3kKN/kAix29xQFdGxN0qVMZ2
	qw/Oe3N/SuMnxuWuGCSqR1535AvW/FKWoV4qpQUbkXXbvfGMCeuNEf0/OBQLyB0I
	d3RNz6kQbKdQQcqTd1i4gWGbNsHkBIuIw7ArGzDC9Cjsg4Ub52SHrWVic9fLHnYq
	0VI/yUVInYb5VcX4RI+qgbjRWOxs1lP0u1GyjyEiljmFM3ZdAtmiSAsUWHEoXRnP
	rs9LaUziK5iwAKsh8vA1gXGhJxDNuYUIQjupLrvsNB42yA==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id MYxXZzrosPRi; Wed,  9 Oct 2024 17:32:32 +0000 (UTC)
Received: from [100.66.154.22] (unknown [104.135.204.82])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4XP0MJ6TNJzlgTWG;
	Wed,  9 Oct 2024 17:32:28 +0000 (UTC)
Message-ID: <17abd508-3d83-4926-bb16-0176fd46f100@acm.org>
Date: Wed, 9 Oct 2024 10:32:27 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2] scsi: ufs: ufs-mediatek: configure individual LU queue
 flags
To: ed.tsai@mediatek.com, Alim Akhtar <alim.akhtar@samsung.com>,
 Avri Altman <avri.altman@wdc.com>,
 "James E.J. Bottomley" <James.Bottomley@HansenPartnership.com>,
 "Martin K. Petersen" <martin.petersen@oracle.com>,
 Peter Wang <peter.wang@mediatek.com>, Stanley Jhu <chu.stanley@gmail.com>,
 Matthias Brugger <matthias.bgg@gmail.com>,
 AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Cc: wsd_upstream@mediatek.com, chun-hung.wu@mediatek.com,
 linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
 linux-mediatek@lists.infradead.org, linux-arm-kernel@lists.infradead.org
References: <20241009053854.15353-1-ed.tsai@mediatek.com>
Content-Language: en-US
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20241009053854.15353-1-ed.tsai@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 10/8/24 10:38 PM, ed.tsai@mediatek.com wrote:
> In addition, because the SCSI probe_type = PROBE_PREFFER_ASYNCHRONOUS,
> sd_probe() is completed by another thread, causing the sd index to be
> obtained asynchronously. Directly setting the queue through sysfs is
> cumbersome. We do not need to change the queue settings at runtime, so
> a simpler and more intuitive approach is to set its flag once the SCSI
> device is confirmed to be ready.

Please set this flag from user space. The example below shows that it is
easy to set this flag from user space without knowing which sd* name
has been assigned to the block device:

$ adb root
$ adb shell 'cat 
/sys/class/scsi_device/0:0:0:2/device/block/*/queue/rq_affinity'
1
$ adb shell 'echo 2 > $(echo 
/sys/class/scsi_device/0:0:0:2/device/block/*/queue/rq_affinity)'
$ adb shell 'cat 
/sys/class/scsi_device/0:0:0:2/device/block/*/queue/rq_affinity'
2

Thanks,

Bart.
