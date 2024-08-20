Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6BE917C67;
	Tue, 20 Aug 2024 01:24:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1724117067; cv=none; b=nvyNKT4e8T60Ik2AjYZEb68ySjDfO5xHofYv80die9RUM1+Ju2SViK20Hp3UuiznPtPzEiBBcT6B7NeV5vj7z2f/RbJuc8xu5pMXDNnIqDte/QgRdsm71juARQXitb8fXDQ51eAU+wt8mDnvRWojmDChcMwotC6p9TzoZhPDk2E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1724117067; c=relaxed/simple;
	bh=PFhpBbGcqoFv9Ee+zZUeXGlY7AZl2F9JOryxrAQ354Q=;
	h=Subject:To:References:CC:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=s97bg0apVqDRcxYwGh9Yj2QY20/Y+TFHXl08i6vYULwAZY8cUssVtI+XtcWZg0r5kf7gBbegcAe0bMjfEi8NC8/eVQmiay7l5AmJQ1LruAwtVCFvVaNAw1tbtDBTYKX0hBystqP4zp7u+zK5xfnOT0jjt8ZM8eIpT0RlAo7hEJo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.174])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4WnsC22hyvzfbd9;
	Tue, 20 Aug 2024 09:22:22 +0800 (CST)
Received: from dggpemf100013.china.huawei.com (unknown [7.185.36.179])
	by mail.maildlp.com (Postfix) with ESMTPS id 48822140135;
	Tue, 20 Aug 2024 09:24:22 +0800 (CST)
Received: from [10.67.120.126] (10.67.120.126) by
 dggpemf100013.china.huawei.com (7.185.36.179) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Tue, 20 Aug 2024 09:24:21 +0800
Subject: Re: [PATCH v5] scsi: sd: Ignore command SYNC CACHE error if format in
 progress
To: Bart Van Assche <bvanassche@acm.org>,
	<James.Bottomley@HansenPartnership.com>, <martin.petersen@oracle.com>
References: <20240819090934.2130592-1-liyihang9@huawei.com>
 <bfce098e-a070-40b1-95fc-951e2b3c1c22@acm.org>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<dlemoal@kernel.org>, <linuxarm@huawei.com>, <prime.zeng@huawei.com>,
	<stable@vger.kernel.org>, <liyihang9@huawei.com>
From: Yihang Li <liyihang9@huawei.com>
Message-ID: <fd8c091f-a777-6641-835e-397fa8b5de94@huawei.com>
Date: Tue, 20 Aug 2024 09:24:21 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <bfce098e-a070-40b1-95fc-951e2b3c1c22@acm.org>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems705-chm.china.huawei.com (10.3.19.182) To
 dggpemf100013.china.huawei.com (7.185.36.179)



On 2024/8/20 0:59, Bart Van Assche wrote:
> On 8/19/24 2:09 AM, Yihang Li wrote:
>> +            if ((sshdr.asc == 0x04 && sshdr.ascq == 0x04) ||
> 
> Shouldn't symbolic names be introduced for these numeric constants?
> Although there is more code in the SCSI core that compares ASC / ASCQ
> values with numeric constants, I think we need symbolic names for these
> constants to make code like the above easier to read. There is already
> a header file for definitions that come directly from the SCSI standard
> and that is used by both SCSI initiator and SCSI target code:
> <scsi/scsi_proto.h>.
> 

My idea is to be consistent with the style of the code context.
That's why I use numerical values.

If we want to use symbolic names to replace all numeric constants,
I think that would be another series of patches, and the changes would be more.

Thanks,

Yihang.
