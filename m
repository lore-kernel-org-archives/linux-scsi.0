Received: from 009.lax.mailroute.net (009.lax.mailroute.net [199.89.1.12])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3ABFF6ABF
	for <linux-scsi@vger.kernel.org>; Fri, 15 Mar 2024 02:41:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=199.89.1.12
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1710470465; cv=none; b=AhHIWXaz8vRRXDGS83+UWPdEGsiLUZO2w/vMRlKSmttTau7QazEfpcdfo3mtNQGT+LRisJ5sfbRy4ZYsFmPjpAug3qDFwexkk91U/M0dmnc/j5h8+CuIBOTbt5b7XDg8zv94ALSSFb+fkckzM9pnDmebuB9NGKLmHG2fOHwsc5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1710470465; c=relaxed/simple;
	bh=AV/KB8asYXTQ5aL5cGfwpczprSp3C033KzHYtpnu3xQ=;
	h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:
	 In-Reply-To:Content-Type; b=GmsG5X5eIHX+QH7XbP5umxPNrBn8KnJpVhlesJKwL7T9yxFckLTi781vZTZoHTStMGXyujkgLo3N99/P+Lumnz54cDd7cYBElFyBcdDo3mvNhuNpZMpyuSF8mHdLbI8qXuTic0EqzsKSWGcO/SrCqmeGzd2o1zzOIpJE+J0AhRc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org; spf=pass smtp.mailfrom=acm.org; dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b=Sg83dDfm; arc=none smtp.client-ip=199.89.1.12
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=acm.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=acm.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=acm.org header.i=@acm.org header.b="Sg83dDfm"
Received: from localhost (localhost [127.0.0.1])
	by 009.lax.mailroute.net (Postfix) with ESMTP id 4TwpQl49NJzlgVnf;
	Fri, 15 Mar 2024 02:41:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=acm.org; h=
	content-transfer-encoding:content-type:content-type:in-reply-to
	:from:from:references:content-language:subject:subject
	:user-agent:mime-version:date:date:message-id:received:received;
	 s=mr01; t=1710470459; x=1713062460; bh=AV/KB8asYXTQ5aL5cGfwpczp
	rSp3C033KzHYtpnu3xQ=; b=Sg83dDfmlxGtZWx1rN7jjUUDSzTKOpp73MZG8bG7
	jWNqWlDC3HDy4+ElMZHSSt5qPfqsakmydsr6JLQ2TJjIedwswnUCKBQh25UHf1S+
	Iww+s4/nEIYG0aeX2fbmjWCW1PSUPSyt8Exdwg51DowEQYwpxO00jb4KdaVmaYfx
	x4tALt4Kidvg7Ha/sLv+1qh5DHSCVRUsLjSrgNbvBBn4/DF5N8Dbp/Yp4/aYgawJ
	5rYGrtEIcrC3vJ35OY/EEQztHu9hm2BpJ4cupB4VVwscqhBJMRpcLlx/0ixmPU16
	5Gj9cKg6KZ0Fz2VpIJOVDUnYCA3uIkBO283jF4bioiBLTQ==
X-Virus-Scanned: by MailRoute
Received: from 009.lax.mailroute.net ([127.0.0.1])
 by localhost (009.lax [127.0.0.1]) (mroute_mailscanner, port 10029) with LMTP
 id jPI_V_cXvcRZ; Fri, 15 Mar 2024 02:40:59 +0000 (UTC)
Received: from [192.168.51.14] (c-73-231-117-72.hsd1.ca.comcast.net [73.231.117.72])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature RSA-PSS (2048 bits) server-digest SHA256)
	(No client certificate requested)
	(Authenticated sender: bvanassche@acm.org)
	by 009.lax.mailroute.net (Postfix) with ESMTPSA id 4TwpQY47fbzlgVnW;
	Fri, 15 Mar 2024 02:40:53 +0000 (UTC)
Message-ID: <8b63a194-e4c8-41df-90f4-869c39636467@acm.org>
Date: Thu, 14 Mar 2024 19:40:51 -0700
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v1 5/7] ufs: host: mediatek: rename host power control API
Content-Language: en-US
To: peter.wang@mediatek.com, linux-scsi@vger.kernel.org,
 martin.petersen@oracle.com, avri.altman@wdc.com, alim.akhtar@samsung.com,
 jejb@linux.ibm.com
Cc: wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
 chun-hung.wu@mediatek.com, alice.chao@mediatek.com, cc.chou@mediatek.com,
 chaotian.jing@mediatek.com, jiajie.hao@mediatek.com, powen.kao@mediatek.com,
 qilin.tan@mediatek.com, lin.gui@mediatek.com, tun-yu.yu@mediatek.com,
 eddie.huang@mediatek.com, naomi.chu@mediatek.com, chu.stanley@gmail.com
References: <20240308070241.9163-1-peter.wang@mediatek.com>
 <20240308070241.9163-6-peter.wang@mediatek.com>
From: Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <20240308070241.9163-6-peter.wang@mediatek.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

On 3/7/24 23:02, peter.wang@mediatek.com wrote:
> Host power control is control crypto sram power.

The above sentence is incomprehensible to me.

Thanks,

Bart.
