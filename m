Received: from szxga04-in.huawei.com (szxga04-in.huawei.com [45.249.212.190])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3CEDB33FD;
	Mon, 14 Apr 2025 01:10:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.190
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744593063; cv=none; b=a7bpyynEHJ3KLj63Pkg+OFmxyif5yVAGTWrPUcxNtsl1BqDWVSj2nNAVewaUTl3KETurnmaCxi0DmSihFKN0PhGSiwjn+BdQgA//tnMYqBxQ0M4m9z8iVl2a/ojWMnMKMpWe0EZ5DJBjt9FYk7ProNuYXvvNx1k/D5/MvvPTHZg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744593063; c=relaxed/simple;
	bh=LLOPkKaUy010hhQ5OjuyZsdP/LSm65ij9oOIUl6ATjQ=;
	h=Subject:To:References:CC:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=AkJiZz8vR0JTbqxY6jBEpNt5WwqG0nT5WI4wAAd0Fx6b9/QqeBw2/By9YtCQOYFmDXEeqkTDjNwv1AsiNoh13R1pN3BK2b0okpIXPzP1ng8DemaR4KFbZtJMgRfiZKBJGH490L5JDc1ZEsWNcu7Ylx80sf//eSqbdTrylrxcFfc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.190
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.234])
	by szxga04-in.huawei.com (SkyGuard) with ESMTP id 4ZbTfQ1nlgz2CdJZ;
	Mon, 14 Apr 2025 09:07:26 +0800 (CST)
Received: from dggpemf100013.china.huawei.com (unknown [7.185.36.179])
	by mail.maildlp.com (Postfix) with ESMTPS id 7A7991400CB;
	Mon, 14 Apr 2025 09:10:51 +0800 (CST)
Received: from [10.67.120.126] (10.67.120.126) by
 dggpemf100013.china.huawei.com (7.185.36.179) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Mon, 14 Apr 2025 09:10:51 +0800
Subject: Re: [PATCH v2 0/4] hisi_sas: Misc patches and cleanups
To: "Martin K. Petersen" <martin.petersen@oracle.com>
References: <20250331123349.99591-1-liyihang9@huawei.com>
 <yq1jz7qjjtw.fsf@ca-mkp.ca.oracle.com>
CC: <James.Bottomley@HansenPartnership.com>, <linux-scsi@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linuxarm@huawei.com>,
	<liuyonglong@huawei.com>, <prime.zeng@hisilicon.com>
From: Yihang Li <liyihang9@huawei.com>
Message-ID: <9171e7d0-46d9-f9aa-aa30-e95424a1456e@huawei.com>
Date: Mon, 14 Apr 2025 09:10:50 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:45.0) Gecko/20100101
 Thunderbird/45.7.1
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <yq1jz7qjjtw.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggems702-chm.china.huawei.com (10.3.19.179) To
 dggpemf100013.china.huawei.com (7.185.36.179)

I will check and fix, thanks for reminder.

Thanks,
Yihang

On 2025/4/12 8:45, Martin K. Petersen wrote:
> 
> Hi Yihang!
> 
>> This series contains some minor bugfix and general tidying:
>> - Ignore the soft reset result by calling I_T_nexus after the SATA disk
>>   is soft reset
>> - General minor tidying
> 
> v3_hw won't compile after applying this series:
> 
> drivers/scsi/hisi_sas/hisi_sas_v3_hw.c: In function ‘debugfs_show_row_64_v3_hw’:
> drivers/scsi/hisi_sas/hisi_sas_v3_hw.c:3718:27: error: ‘TWO_PARA_PER_LINE’ undeclared (first use in this function)
>  3718 |                 if (!(i % TWO_PARA_PER_LINE))
>       |                           ^~~~~~~~~~~~~~~~~
> drivers/scsi/hisi_sas/hisi_sas_v3_hw.c:3718:27: note: each undeclared identifier is reported only once for each function it appears in
> drivers/scsi/hisi_sas/hisi_sas_v3_hw.c: In function ‘debugfs_show_row_32_v3_hw’:
> drivers/scsi/hisi_sas/hisi_sas_v3_hw.c:3734:27: error: ‘FOUR_PARA_PER_LINE’ undeclared (first use in this function)
>  3734 |                 if (!(i % FOUR_PARA_PER_LINE))
>       |                           ^~~~~~~~~~~~~~~~~~
> drivers/scsi/hisi_sas/hisi_sas_v3_hw.c: In function ‘debugfs_create_files_v3_hw’:
> drivers/scsi/hisi_sas/hisi_sas_v3_hw.c:3896:19: error: ‘NAME_BUF_SIZE’ undeclared (first use in this function); did you mean ‘PROT_BUF_SIZE’?
>  3896 |         char name[NAME_BUF_SIZE];
>       |                   ^~~~~~~~~~~~~
>       |                   PROT_BUF_SIZE
> drivers/scsi/hisi_sas/hisi_sas_v3_hw.c:3896:14: error: unused variable ‘name’ [-Werror=unused-variable]
>  3896 |         char name[NAME_BUF_SIZE];
>       |              ^~~~
> drivers/scsi/hisi_sas/hisi_sas_v3_hw.c: In function ‘debugfs_trigger_dump_v3_hw_write’:
> drivers/scsi/hisi_sas/hisi_sas_v3_hw.c:3974:18: error: ‘DUMP_BUF_SIZE’ undeclared (first use in this function); did you mean ‘DUMMY_BUF_SIZE’?
>  3974 |         char buf[DUMP_BUF_SIZE];
>       |                  ^~~~~~~~~~~~~
>       |                  DUMMY_BUF_SIZE
> drivers/scsi/hisi_sas/hisi_sas_v3_hw.c:3974:14: error: unused variable ‘buf’ [-Werror=unused-variable]
>  3974 |         char buf[DUMP_BUF_SIZE];
>       |              ^~~
> drivers/scsi/hisi_sas/hisi_sas_v3_hw.c: In function ‘debugfs_bist_linkrate_v3_hw_write’:
> drivers/scsi/hisi_sas/hisi_sas_v3_hw.c:4040:19: error: ‘BIST_BUF_SIZE’ undeclared (first use in this function); did you mean ‘PROT_BUF_SIZE’?
>  4040 |         char kbuf[BIST_BUF_SIZE] = {}, *pkbuf;
>       |                   ^~~~~~~~~~~~~
>       |                   PROT_BUF_SIZE
> drivers/scsi/hisi_sas/hisi_sas_v3_hw.c:4040:14: error: unused variable ‘kbuf’ [-Werror=unused-variable]
>  4040 |         char kbuf[BIST_BUF_SIZE] = {}, *pkbuf;
>       |              ^~~~
> drivers/scsi/hisi_sas/hisi_sas_v3_hw.c: In function ‘debugfs_bist_code_mode_v3_hw_write’:
> drivers/scsi/hisi_sas/hisi_sas_v3_hw.c:4115:19: error: ‘BIST_BUF_SIZE’ undeclared (first use in this function); did you mean ‘PROT_BUF_SIZE’?
>  4115 |         char kbuf[BIST_BUF_SIZE] = {}, *pkbuf;
>       |                   ^~~~~~~~~~~~~
>       |                   PROT_BUF_SIZE
> drivers/scsi/hisi_sas/hisi_sas_v3_hw.c:4115:14: error: unused variable ‘kbuf’ [-Werror=unused-variable]
>  4115 |         char kbuf[BIST_BUF_SIZE] = {}, *pkbuf;
>       |              ^~~~
> drivers/scsi/hisi_sas/hisi_sas_v3_hw.c: In function ‘debugfs_bist_mode_v3_hw_write’:
> drivers/scsi/hisi_sas/hisi_sas_v3_hw.c:4247:19: error: ‘BIST_BUF_SIZE’ undeclared (first use in this function); did you mean ‘PROT_BUF_SIZE’?
>  4247 |         char kbuf[BIST_BUF_SIZE] = {}, *pkbuf;
>       |                   ^~~~~~~~~~~~~
>       |                   PROT_BUF_SIZE
> drivers/scsi/hisi_sas/hisi_sas_v3_hw.c:4247:14: error: unused variable ‘kbuf’ [-Werror=unused-variable]
>  4247 |         char kbuf[BIST_BUF_SIZE] = {}, *pkbuf;
>       |              ^~~~
> drivers/scsi/hisi_sas/hisi_sas_v3_hw.c: In function ‘debugfs_phy_down_cnt_init_v3_hw’:
> drivers/scsi/hisi_sas/hisi_sas_v3_hw.c:4794:19: error: ‘NAME_BUF_SIZE’ undeclared (first use in this function); did you mean ‘PROT_BUF_SIZE’?
>  4794 |         char name[NAME_BUF_SIZE];
>       |                   ^~~~~~~~~~~~~
>       |                   PROT_BUF_SIZE
> drivers/scsi/hisi_sas/hisi_sas_v3_hw.c:4794:14: error: unused variable ‘name’ [-Werror=unused-variable]
>  4794 |         char name[NAME_BUF_SIZE];
>       |              ^~~~
> cc1: all warnings being treated as errors
> 
> Please fix, thanks!
> 
