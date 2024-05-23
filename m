Received: from szxga01-in.huawei.com (szxga01-in.huawei.com [45.249.212.187])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 212B346AF;
	Thu, 23 May 2024 11:01:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.187
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716462110; cv=none; b=lIEn/WKcAZS3Trx7pFpL2tGuB+5JycrxiErq1alVM7BAdlgPzNRP/eFPe5BXbSqvmAmvKLrRxrN54ephjtuEsg+vuj5WbTfjkrpFCPBZ7mBZEqF7VLE4tk94wRw2acmGHOf1wcwJiKo14voBYoFia+9F2pzc4O+qHBEem84BKF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716462110; c=relaxed/simple;
	bh=4u59vjcCwefd5WAf6c0pCJI3+Xi+nJGFKnocFAIqYX8=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=NGqmOLdORbD9LwqhMb138lk2hZGHQUQXkaLl4oJv5xRokeUjt/PckC30YJdUeRSneHcBGunNIBh1kcuVqghC2CL8+FMioDqnBtZzLSoB79VKnnV60gKMneecev8gX3A8z3f43Es+VrWftndNnDAS1P7jowDB5g0/teROFzU8WLs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.187
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.48])
	by szxga01-in.huawei.com (SkyGuard) with ESMTP id 4VlQBG0pl8zxQKf;
	Thu, 23 May 2024 18:57:58 +0800 (CST)
Received: from dggpemd100001.china.huawei.com (unknown [7.185.36.94])
	by mail.maildlp.com (Postfix) with ESMTPS id A51FB180060;
	Thu, 23 May 2024 19:01:40 +0800 (CST)
Received: from [10.67.120.108] (10.67.120.108) by
 dggpemd100001.china.huawei.com (7.185.36.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Thu, 23 May 2024 19:01:40 +0800
Message-ID: <8e959699-0f74-2fc2-4e24-467b485838a1@huawei.com>
Date: Thu, 23 May 2024 19:01:40 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH] driver core: Add log when devtmpfs create node failed
Content-Language: en-CA
To: Greg KH <gregkh@linuxfoundation.org>
CC: <rafael@kernel.org>, <linux-scsi@vger.kernel.org>,
	<linux-kernel@vger.kernel.org>, <linuxarm@huawei.com>,
	<prime.zeng@hisilicon.com>, <liyihang9@huawei.com>, <kangfenglong@huawei.com>
References: <20240522114346.42951-1-yangxingui@huawei.com>
 <2024052221-pulverize-worrisome-37fb@gregkh>
 <794b5fa3-0135-80cc-4b55-f48a430a58ca@huawei.com>
 <2024052316-confused-payback-5658@gregkh>
 <68b110da-ea20-fa03-be26-49dd3a04f835@huawei.com>
 <2024052354-legibly-willow-7134@gregkh>
From: yangxingui <yangxingui@huawei.com>
In-Reply-To: <2024052354-legibly-willow-7134@gregkh>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggpemm100018.china.huawei.com (7.185.36.206) To
 dggpemd100001.china.huawei.com (7.185.36.94)



On 2024/5/23 17:35, Greg KH wrote:
> On Thu, May 23, 2024 at 05:23:07PM +0800, yangxingui wrote:
>> Hi Greg,
>>
>> On 2024/5/23 15:25, Greg KH wrote:
>>> On Thu, May 23, 2024 at 09:50:09AM +0800, yangxingui wrote:
>>>> Hi, Greg
>>>>
>>>> On 2024/5/22 20:23, Greg KH wrote:
>>>>> On Wed, May 22, 2024 at 11:43:46AM +0000, Xingui Yang wrote:
>>>>>> Currently, no exception information is output when devtmpfs create node
>>>>>> failed, so add log info for it.
>>>>>
>>>>> Why?  Who is going to do something with this?
>>>> We execute the lsscsi command after the disk is connected, we occasionally
>>>> find that some disks do not have dev nodes and these disks cannot be used.
>>>
>>> Ok, but why do you think that devtmpfs create failed?
>> I found that lsscsi will traverse the dev node and obtain device major and
>> min. If no matching dev node is found, it will display "-       ".
>>>
>>>> However, there is no abnormal log output during disk scanning. We analyze
>>>> that it may be caused by the failure of devtmpfs create dev node, so the log
>>>> is added here.
>>>
>>> But is that the case?  Why is devtmpfs failing?  Shouldn't we fix that
>>> instead?
>> My subsequent reply touches on these points.
>>>
>>>> The lscsi command query results and kernel logs as follows:
>>>>
>>>> [root@localhost]# lsscsi
>>>> [9:0:4:0]	disk	ATA	ST10000NM0086-2A SN05	-
>>>>
>>>> kernel: [586669.541218] hisi_sas_v3_hw 0000:b4:04.0: phyup: phy0
>>>> link_rate=10(sata)
>>>> kernel: [586669.541341] sas: phy-9:0 added to port-9:0, phy_mask:0x1
>>>> (5000000000000900)
>>>> kernel: [586669.541511] sas: DOING DISCOVERY on port 0, pid:2330731
>>>> kernel: [586669.541518] hisi_sas_v3_hw 0000:b4:04.0: dev[4:5] found
>>>> kernel: [586669.630816] sas: Enter sas_scsi_recover_host busy: 0 failed: 0
>>>> kernel: [586669.665960] hisi_sas_v3_hw 0000:b4:04.0: phydown: phy0
>>>> phy_state=0xe
>>>> kernel: [586669.665964] hisi_sas_v3_hw 0000:b4:04.0: ignore flutter phy0
>>>> down
>>>> kernel: [586669.863360] hisi_sas_v3_hw 0000:b4:04.0: phyup: phy0
>>>> link_rate=10(sata)
>>>> kernel: [586670.024482] ata19.00: ATA-10: ST10000NM0086-2AA101, SN05, max
>>>> UDMA/133
>>>> kernel: [586670.024487] ata19.00: 19532873728 sectors, multi 16: LBA48 NCQ
>>>> (depth 32), AA
>>>> kernel: [586670.027471] ata19.00: configured for UDMA/133
>>>> kernel: [586670.027490] sas: --- Exit sas_scsi_recover_host: busy: 0 failed:
>>>> 0 tries: 1
>>>> kernel: [586670.037541] sas: ata19: end_device-9:0:
>>>> model:ST10000NM0086-2AA101 serial:            ZA2B3PR2
>>>> kernel: [586670.100856] scsi 9:0:4:0: Direct-Access     ATA ST10000NM0086-2A
>>>> SN05 PQ: 0 ANSI: 5
>>>> kernel: [586670.101114] sd 9:0:4:0: [sdk] 19532873728 512-byte logical
>>>> blocks: (10.0 TB/9.10 TiB)
>>>> kernel: [586670.101116] sd 9:0:4:0: [sdk] 4096-byte physical blocks
>>>> kernel: [586670.101125] sd 9:0:4:0: [sdk] Write Protect is off
>>>> kernel: [586670.101137] sd 9:0:4:0: [sdk] Write cache: enabled, read cache:
>>>> enabled, doesn't support DPO or FUA
>>>> kernel: [586670.101620] sd 9:0:4:0: Attached scsi generic sg10 type 0
>>>> kernel: [586670.101714] sas: DONE DISCOVERY on port 0, pid:2330731, result:0
>>>> kernel: [586670.101731] sas: sas_form_port: phy0 belongs to port0
>>>> already(1)!
>>>> kernel: [586670.152512] sd 9:0:4:0: [sdk] Attached SCSI disk
>>>
>>> Looks like sdk was found properly, what's the problem?
>>
>> Yes, this problem occurs occasionally. There is no exception log when
>> scanning the disk, but the disk cannot be used. It has been confirmed that
>> it is related to fio testing. When the dev node does not exist, fio may
>> actively create this file.
> 
> So that's a userspace issue.  If a device node is to be created, and the
> file is already present with that name, yes, we will fail to create it
> as obviously userspace did not want us to do so.
> 
> It's not the kernel's job to protect userspace from doing foolish things
> itself, right?  :)
Yes.
> 
>> If we want to solve this problem, should we delete the existing files first
>> when creating a dev node?
> 
> No.
Ok.
> 
>> Or just print a prompt indicating that the dev node creation failed.
> 
> We can do that, but will that cause error messages to be printed out for
> normal situations today where userspace does this on purpose?
> 
> Again, this isn't fixing the root problem here (which is userspace doing
> something it shouldn't be doing), adding kernel log messages might be
> just noise at this point in time given that it has been operating this
> way for many years, if not decades.
Yes, there is currently no fix for the problem, and it doesn't usually 
happen. Once it occurs, the device will be unavailable and difficult to 
locate. In addition, there are many possibilities for the failure of 
devtmpfs to create a dev node, including currently recognized scenarios 
and memory allocation failures, etc.

Thanks,
Xingui
.
