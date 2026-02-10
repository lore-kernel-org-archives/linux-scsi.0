Received: from canpmsgout01.his.huawei.com (canpmsgout01.his.huawei.com [113.46.200.216])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBB262DC339
	for <linux-scsi@vger.kernel.org>; Tue, 10 Feb 2026 02:44:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.216
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770691468; cv=none; b=MxosyAHJyptGNCK7udjg1atGNxjxzW1GL0PYi/OvvvOjqS+9FsFclGOWpxzUuB0CFGU5H0tzgCoyjuVqF3fsJYIEVkGc6+gOb26zFCUjblCQ3D0oWsjFrEjTb5aUE3rZ+END3pMjvJjQjHBGsX9aUXXLiV0kggiBxLQcV2nvvb4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770691468; c=relaxed/simple;
	bh=qLzBRIPmbJArHFpzya+ZbyzLUKo7DlwbYNKJKKJK19g=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=RjwiD2YEyGiCJmSH8HmKEbz3aNsw0iKmuIpCdWr2njUyQZJsWNc7zhnh9rV6puWgtBDxD92HcH9hlZ1ceUy74r/FPT1LSqkjRNMuEjRCgujnpidiHKhA67LobSvurcEjZj/YSYeEPtcY8GL0zmHEBQsb4O2Xu6/3SOj/nhG4aNI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b=01RtO4xW; arc=none smtp.client-ip=113.46.200.216
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=huawei.com header.i=@huawei.com header.b="01RtO4xW"
dkim-signature: v=1; a=rsa-sha256; d=huawei.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=0ghBlJQT9LelAoC+5uHiCKkbNnnfh3yeC+85WvMzyvg=;
	b=01RtO4xWm8GGl9f+y919K/84Q9HSZXlT0Ogu0gDD94Tz/s2hHbnANNvi4MBE6Fx+y12Eq4yFd
	fvb1jpRd68YyqCtD6bWEeqFRoWP63zIvSyNAAf28A7wxrAvm/2nNOhIqCMiFpc1L0ZRsZUsLDRL
	1WTP7Ig+63xggTJStHhCXho=
Received: from mail.maildlp.com (unknown [172.19.163.0])
	by canpmsgout01.his.huawei.com (SkyGuard) with ESMTPS id 4f95Ph2gF8z1T4JV;
	Tue, 10 Feb 2026 10:39:52 +0800 (CST)
Received: from kwepemf100006.china.huawei.com (unknown [7.202.181.220])
	by mail.maildlp.com (Postfix) with ESMTPS id B769B4036C;
	Tue, 10 Feb 2026 10:44:22 +0800 (CST)
Received: from [10.174.176.137] (10.174.176.137) by
 kwepemf100006.china.huawei.com (7.202.181.220) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Tue, 10 Feb 2026 10:44:22 +0800
Message-ID: <e959f667-1703-45a4-98fb-4b42b7b27a4a@huawei.com>
Date: Tue, 10 Feb 2026 10:44:21 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH v2 0/3] scsi: sg: minor bugfix and cleanup
To: Bart Van Assche <bvanassche@acm.org>, <dgilbert@interlog.com>,
	<James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>,
	<linux-scsi@vger.kernel.org>
CC: <yangerkun@huaweicloud.com>
References: <20260127062044.3034148-1-yangerkun@huawei.com>
 <b40028c0-910b-4228-8ed9-9843e3db394e@acm.org>
From: yangerkun <yangerkun@huawei.com>
In-Reply-To: <b40028c0-910b-4228-8ed9-9843e3db394e@acm.org>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepems500001.china.huawei.com (7.221.188.70) To
 kwepemf100006.china.huawei.com (7.202.181.220)

Thanks a lot for your review!

在 2026/2/10 1:47, Bart Van Assche 写道:
> On 1/26/26 10:20 PM, Yang Erkun wrote:
>> [ ... ]
> 
> For the entire series:
> 
> Reviewed-by: Bart Van Assche <bvanassche@acm.org>

