Received: from canpmsgout05.his.huawei.com (canpmsgout05.his.huawei.com [113.46.200.220])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CAE263559F5;
	Tue, 17 Mar 2026 06:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.220
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773728679; cv=none; b=FPJ67UFOx6Ao+sDGHmHoEnquhkOyF+gkdsLO93usw8Y/mQekcjN6n1V8RCJRFtxMbJZWhr11vssioPoe/cvRGIyTVzfPbOAkZzvji2XO346M159FCVW1uWgJ/mHeAv5OGkwNvgGWShzHVEFP+RMOU1E770q3gZ+5F+qON0ns38Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773728679; c=relaxed/simple;
	bh=GjedUynhRQ0OoszqlHV63oJsqymHHHB/b4DaWxO4kZg=;
	h=Subject:To:References:CC:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=YdE24bjH5bdUY5AM1Eow9+IbtG+MVcRL/De5XWYqUL+9PumC1++tBLy4270zr9FGip3TZv0M5kH3APF2RB+X6Tqq1BA0kGAnnoHUS+Om6Uy19m+6AEWkzFKWZim0hwVBpork2fM6ZzUnazV7mQKcQxS8QoahEaPRoXD9JY3bKyU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=h-partners.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=Yfv8PkSk; arc=none smtp.client-ip=113.46.200.220
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=h-partners.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="Yfv8PkSk"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=IceBJOdOJ0Wo5kaiil1rI3bIeydEAyJ779iXcpPW8ZU=;
	b=Yfv8PkSkgihcqgAbfVpdFYS2i9Ra2yMWm2yRSanCj8/AYBs5TZWUwMwOSuev/CKWEoH8k0t+m
	GAP+Vwb7CUePAW1hW4DrvivVqB5JCp6zU53nAfWDnP0v/JPxrPhPL/FDLpOCtc4jQxvJ8JhxJZT
	AmsyssgQUKYCj1IbkqD+2AY=
Received: from mail.maildlp.com (unknown [172.19.163.104])
	by canpmsgout05.his.huawei.com (SkyGuard) with ESMTPS id 4fZhcP5mpDz12LdJ;
	Tue, 17 Mar 2026 14:19:01 +0800 (CST)
Received: from kwepemh200005.china.huawei.com (unknown [7.202.181.112])
	by mail.maildlp.com (Postfix) with ESMTPS id D2499404AD;
	Tue, 17 Mar 2026 14:24:33 +0800 (CST)
Received: from [10.67.120.126] (10.67.120.126) by
 kwepemh200005.china.huawei.com (7.202.181.112) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 17 Mar 2026 14:24:33 +0800
Subject: Re: [PATCH] scsi: Fix the maximum channel scanning issue
To: Bart Van Assche <bvanassche@acm.org>, Yihang Li <liyihang9@huawei.com>,
	<martin.petersen@oracle.com>, <James.Bottomley@HansenPartnership.com>,
	<ranjan.kumar@broadcom.com>
References: <20260313023057.4151105-1-liyihang9@huawei.com>
 <6103e5cd-12e2-4527-8aee-985c2a75f255@acm.org>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<liuyonglong@huawei.com>, <linuxarm@huawei.com>, <liyihang9@huawei.com>
From: Yihang Li <liyihang9@h-partners.com>
Message-ID: <bea1f556-75bb-aedb-61fd-553841c9aadd@h-partners.com>
Date: Tue, 17 Mar 2026 14:24:32 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <6103e5cd-12e2-4527-8aee-985c2a75f255@acm.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepems200002.china.huawei.com (7.221.188.68) To
 kwepemh200005.china.huawei.com (7.202.181.112)

Hi, Bart

On 2026/3/17 1:22, Bart Van Assche wrote:
> On 3/12/26 7:30 PM, Yihang Li wrote:
>> Fix and support specifying the scan shost->max_channel for scanning.
> 
> A more specific prefix than "scsi:" should be used for SAS patches. In
> the kernel log I found the following examples:
> * scsi: transport: sas:
> * scsi: scsi_transport_sas:
> 
> I'm not sure what prefix is preferred.

Thank you for your reply. I will carefully consider this suggestion.

Thanks,
Yihang
