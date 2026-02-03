Received: from dggsgout12.his.huawei.com (dggsgout12.his.huawei.com [45.249.212.56])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 820DA56B81
	for <linux-scsi@vger.kernel.org>; Tue,  3 Feb 2026 02:02:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.56
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770084173; cv=none; b=mazcEdzcpaZSLlzdXZb6sFWbRTea11GH2H3F/aWjw20Vh7GkLwa2iULUKnWvf1xkQlKenifvt5RSWXi8W/n5RoE2YEQ89IsjOL0PtxvYmy5i2sU46r0O8TxXT1CkWSlZYijGKLebsW4Hz2gChvS0gWlu5Uqd1M1TmkQcJQkV+Ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770084173; c=relaxed/simple;
	bh=UpIFa5PxbljbZRfdUOSjmLaKVZopagdSGq/tjoA2u48=;
	h=Message-ID:Date:MIME-Version:Subject:To:References:From:
	 In-Reply-To:Content-Type; b=JRl/RByklE5tvU/jm1zfaq5p1avxV8k6QVB49LiafKMhuPOZkOE+j8oZB1ZJ3XSMZ589TXXjdTFGqnNu+9oSkCanGgJbrWjocbAlMa6DrJCclyZ+Bc6TmgzJl9LEFjMC2tO96Ja6Hyc1Aj3gQ1OgHLmhG55im3mFmwKsb+BH2GI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com; spf=none smtp.mailfrom=huaweicloud.com; arc=none smtp.client-ip=45.249.212.56
Authentication-Results: smtp.subspace.kernel.org; dmarc=none (p=none dis=none) header.from=huaweicloud.com
Authentication-Results: smtp.subspace.kernel.org; spf=none smtp.mailfrom=huaweicloud.com
Received: from mail.maildlp.com (unknown [172.19.163.198])
	by dggsgout12.his.huawei.com (SkyGuard) with ESMTPS id 4f4mvd6sq1zKHMRK
	for <linux-scsi@vger.kernel.org>; Tue,  3 Feb 2026 10:02:21 +0800 (CST)
Received: from mail02.huawei.com (unknown [10.116.40.128])
	by mail.maildlp.com (Postfix) with ESMTP id 0280240574
	for <linux-scsi@vger.kernel.org>; Tue,  3 Feb 2026 10:02:43 +0800 (CST)
Received: from [10.174.179.194] (unknown [10.174.179.194])
	by APP4 (Coremail) with SMTP id gCh0CgBHqPhBV4FpmqdFGA--.21999S3;
	Tue, 03 Feb 2026 10:02:42 +0800 (CST)
Message-ID: <255c35f0-6eae-a7cc-426e-009ba1266a4e@huaweicloud.com>
Date: Tue, 3 Feb 2026 10:02:41 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v2 0/3] scsi: sg: minor bugfix and cleanup
To: Yang Erkun <yangerkun@huawei.com>, bvanassche@acm.org,
 dgilbert@interlog.com, James.Bottomley@HansenPartnership.com,
 martin.petersen@oracle.com, linux-scsi@vger.kernel.org
References: <20260127062044.3034148-1-yangerkun@huawei.com>
From: yangerkun <yangerkun@huaweicloud.com>
In-Reply-To: <20260127062044.3034148-1-yangerkun@huawei.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-CM-TRANSID:gCh0CgBHqPhBV4FpmqdFGA--.21999S3
X-Coremail-Antispam: 1UD129KBjDUn29KB7ZKAUJUUUUU529EdanIXcx71UUUUU7v73
	VFW2AGmfu7bjvjm3AaLaJ3UjIYCTnIWjp_UUUYI7kC6x804xWl14x267AKxVW8JVW5JwAF
	c2x0x2IEx4CE42xK8VAvwI8IcIk0rVWrJVCq3wAFIxvE14AKwVWUJVWUGwA2ocxC64kIII
	0Yj41l84x0c7CEw4AK67xGY2AK021l84ACjcxK6xIIjxv20xvE14v26w1j6s0DM28EF7xv
	wVC0I7IYx2IY6xkF7I0E14v26r4UJVWxJr1l84ACjcxK6I8E87Iv67AKxVW0oVCq3wA2z4
	x0Y4vEx4A2jsIEc7CjxVAFwI0_GcCE3s1le2I262IYc4CY6c8Ij28IcVAaY2xG8wAqx4xG
	64xvF2IEw4CE5I8CrVC2j2WlYx0E2Ix0cI8IcVAFwI0_Jr0_Jr4lYx0Ex4A2jsIE14v26r
	1j6r4UMcvjeVCFs4IE7xkEbVWUJVW8JwACjcxG0xvEwIxGrwCYjI0SjxkI62AI1cAE67vI
	Y487MxAIw28IcxkI7VAKI48JMxAqzxv26xkF7I0En4kS14v26r126r1DMxC20s026xCaFV
	Cjc4AY6r1j6r4UMI8I3I0E5I8CrVAFwI0_Jr0_Jr4lx2IqxVCjr7xvwVAFwI0_JrI_JrWl
	x4CE17CEb7AF67AKxVWUAVWUtwCIc40Y0x0EwIxGrwCI42IY6xIIjxv20xvE14v26r1j6r
	1xMIIF0xvE2Ix0cI8IcVCY1x0267AKxVWUJVW8JwCI42IY6xAIw20EY4v20xvaj40_Jr0_
	JF4lIxAIcVC2z280aVAFwI0_Jr0_Gr1lIxAIcVC2z280aVCY1x0267AKxVWUJVW8JbIYCT
	nIWIevJa73UjIFyTuYvjxUrR6zUUUUU
X-CM-SenderInfo: 51dqwvhunx0q5kxd4v5lfo033gof0z/

Gently ping...

在 2026/1/27 14:20, Yang Erkun 写道:
> v1->v2:
> update commit message as suggested by Bart
> 
> Yang Erkun (3):
>    scsi: sg: Fix sysctl sg-big-buff register during sg_init
>    scsi: sg: Resolve soft lockup issue when opening /dev/sgX
>    scsi: sg: Remove deprecated sg-big-buff
> 
>   drivers/scsi/sg.c | 88 ++++++++++++++++++++---------------------------
>   1 file changed, 38 insertions(+), 50 deletions(-)
> 

