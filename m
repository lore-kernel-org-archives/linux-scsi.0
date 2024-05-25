Received: from szxga06-in.huawei.com (szxga06-in.huawei.com [45.249.212.32])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AA5B10F1;
	Sat, 25 May 2024 03:08:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.32
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1716606515; cv=none; b=YJ2c6ADo6nf/CBEI+WRiTxmiSe4Yo1LnNc2YEp5RooI1wlEqLnrKr1DrNzhq0XgHiHyovWTmG4WvoBG6alI0/i2CfyOiq0n09qpVeKXs9eT+BZbg1JNK/AqH26o/p/yxAdk6TbvgL0YGZSnxLu24Nr7RguNwKofQG4999mP2+cw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1716606515; c=relaxed/simple;
	bh=xJsj13ODp3PFGuvTZwtq0KTiYS6c5OhYbGxjEeI8Imc=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=aiM4ItavZtE48zf+vl0/A3ddahYta4oMksKiH9tPuiU+1bHhB5NNuK5TpIOPYWwop970R68ogdSyDH/42wSln2jkwgDaD5uFdd7SkL66CimPbLReOnv5te+TeTlhWvBOkHYWsZFDW4OI+ilCziaPyyNsbP4wv6RPoCPVgN+MRBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.32
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.163.17])
	by szxga06-in.huawei.com (SkyGuard) with ESMTP id 4VmRfB0gBxz1wwKy;
	Sat, 25 May 2024 11:07:14 +0800 (CST)
Received: from dggpemd100001.china.huawei.com (unknown [7.185.36.94])
	by mail.maildlp.com (Postfix) with ESMTPS id 46D3E1A0188;
	Sat, 25 May 2024 11:08:29 +0800 (CST)
Received: from [10.67.120.108] (10.67.120.108) by
 dggpemd100001.china.huawei.com (7.185.36.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Sat, 25 May 2024 11:08:28 +0800
Message-ID: <12ea14e9-5821-b2b5-16c1-ac48985927d7@huawei.com>
Date: Sat, 25 May 2024 11:08:28 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH v2] scsi: libsas: Fix exp-attached end device cannot be
 scanned in again after probe failed
Content-Language: en-CA
To: John Garry <john.g.garry@oracle.com>, <yanaijie@huawei.com>,
	<jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
	<damien.lemoal@opensource.wdc.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <prime.zeng@hisilicon.com>,
	<chenxiang66@hisilicon.com>, <kangfenglong@huawei.com>
References: <20240424080807.8469-1-yangxingui@huawei.com>
 <824c34aa-7c4c-4edd-b41c-f9b5ff5aff03@oracle.com>
From: yangxingui <yangxingui@huawei.com>
In-Reply-To: <824c34aa-7c4c-4edd-b41c-f9b5ff5aff03@oracle.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggpemm100018.china.huawei.com (7.185.36.206) To
 dggpemd100001.china.huawei.com (7.185.36.94)

Hi John,

Thank you for your reply

On 2024/5/24 16:36, John Garry wrote:
> On 24/04/2024 09:08, Xingui Yang wrote:
>> We found that it is judged as broadcast flutter when the exp-attached end
>> device reconnects after probe failed, as follows:
>>
>> [78779.654026] sas: broadcast received: 0
>> [78779.654037] sas: REVALIDATING DOMAIN on port 0, pid:10
>> [78779.654680] sas: ex 500e004aaaaaaa1f phy05 change count has changed
>> [78779.662977] sas: ex 500e004aaaaaaa1f phy05 originated 
>> BROADCAST(CHANGE)
>> [78779.662986] sas: ex 500e004aaaaaaa1f phy05 new device attached
>> [78779.663079] sas: ex 500e004aaaaaaa1f phy05:U:8 attached: 
>> 500e004aaaaaaa05 (stp)
>> [78779.693542] hisi_sas_v3_hw 0000:b4:02.0: dev[16:5] found
>> [78779.701155] sas: done REVALIDATING DOMAIN on port 0, pid:10, res 0x0
>> [78779.707864] sas: Enter sas_scsi_recover_host busy: 0 failed: 0
>> ...
>> [78835.161307] sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 0 
>> tries: 1
>> [78835.171344] sas: sas_probe_sata: for exp-attached device 
>> 500e004aaaaaaa05 returned -19
>> [78835.180879] hisi_sas_v3_hw 0000:b4:02.0: dev[16:5] is gone
>> [78835.187487] sas: broadcast received: 0
>> [78835.187504] sas: REVALIDATING DOMAIN on port 0, pid:10
>> [78835.188263] sas: ex 500e004aaaaaaa1f phy05 change count has changed
>> [78835.195870] sas: ex 500e004aaaaaaa1f phy05 originated 
>> BROADCAST(CHANGE)
>> [78835.195875] sas: ex 500e004aaaaaaa1f rediscovering phy05
>> [78835.196022] sas: ex 500e004aaaaaaa1f phy05:U:A attached: 
>> 500e004aaaaaaa05 (stp)
>> [78835.196026] sas: ex 500e004aaaaaaa1f phy05 broadcast flutter
>> [78835.197615] sas: done REVALIDATING DOMAIN on port 0, pid:10, res 0x0
>>
>> The cause of the problem is that the related ex_phy's 
>> attached_sas_addr was
>> not cleared after the end device probe failed. In order to solve the 
>> above
>> problem, a function sas_ex_unregister_end_dev() is defined to clear the
>> ex_phy information and unregister the end device after the 
>> exp-attached end
>> device probe failed.
>>
>> As the sata device is an asynchronous probe, the sata device may probe
>> failed after done REVALIDATING DOMAIN. Then after its port is added to 
>> the
>> sas_port_del_list, the port will not be deleted until the end of the next
>> REVALIDATING DOMAIN and sas_destruct_ports() is called. A warning about
>> creating a duplicate port will occur in the new REVALIDATING DOMAIN when
>> the end device reconnects. Therefore, the previous destroy_list and
>> sas_port_del_list should be handled before REVALIDATING DOMAIN.
>>
>> Signed-off-by: Xingui Yang <yangxingui@huawei.com>
>> ---
>> Changes since v1:
>> - Simplify the process of getting ex_phy id based on Jason's suggestion.
>> - Update commit information.
>> ---
>>   drivers/scsi/libsas/sas_discover.c | 2 ++
>>   drivers/scsi/libsas/sas_expander.c | 8 ++++++++
>>   drivers/scsi/libsas/sas_internal.h | 6 +++++-
>>   3 files changed, 15 insertions(+), 1 deletion(-)
>>
>> diff --git a/drivers/scsi/libsas/sas_discover.c 
>> b/drivers/scsi/libsas/sas_discover.c
>> index 8fb7c41c0962..aae90153f4c6 100644
>> --- a/drivers/scsi/libsas/sas_discover.c
>> +++ b/drivers/scsi/libsas/sas_discover.c
>> @@ -517,6 +517,8 @@ static void sas_revalidate_domain(struct 
>> work_struct *work)
>>       struct sas_ha_struct *ha = port->ha;
>>       struct domain_device *ddev = port->port_dev;
>> +    sas_destruct_devices(port);
>> +    sas_destruct_ports(port);
> 
> We still have both these same calls at the @out label - is that as desired?
Yes, I think so
> 
> Why do these new additions not cover the same job which those calls to 
> the same functions @out covers?
For asynchronous probes like sata, the failure occurs after @out. After 
adding the device to port_delete_list, the port is not deleted 
immediately. This may cause the device to fail to create a new port 
because the previous port has not been deleted when the device attached 
again. as follow:

1. REVALIDATING DOMAIN
2. new device attached
3. ata_sas_async_probe
4. done REVALIDATING DOMAIN
5. @out, handle parent->port->sas_port_del_list
6. sata probe failed
7. add phy->port->list to parent->port->sas_port_del_list // port won't 
delete now

8、REVALIDATING DOMAIN
9、new device attached
10、new port create failed, as port already exits.

> 
>>       /* prevent revalidation from finding sata links in recovery */
>>       mutex_lock(&ha->disco_mutex);
>>       if (test_bit(SAS_HA_ATA_EH_ACTIVE, &ha->state)) {
>> diff --git a/drivers/scsi/libsas/sas_expander.c 
>> b/drivers/scsi/libsas/sas_expander.c
>> index f6e6db8b8aba..45793c10009b 100644
>> --- a/drivers/scsi/libsas/sas_expander.c
>> +++ b/drivers/scsi/libsas/sas_expander.c
>> @@ -1856,6 +1856,14 @@ static void sas_unregister_devs_sas_addr(struct 
>> domain_device *parent,
>>       }
>>   }
>> +void sas_ex_unregister_end_dev(struct domain_device *dev)
>> +{
>> +    struct domain_device *parent = dev->parent;
>> +    struct sas_phy *phy = dev->phy;
>> +
>> +    sas_unregister_devs_sas_addr(parent, phy->number, true);
>> +}
>> +
>>   static int sas_discover_bfs_by_root_level(struct domain_device *root,
>>                         const int level)
>>   {
>> diff --git a/drivers/scsi/libsas/sas_internal.h 
>> b/drivers/scsi/libsas/sas_internal.h
>> index 3804aef165ad..434f928c2ed8 100644
>> --- a/drivers/scsi/libsas/sas_internal.h
>> +++ b/drivers/scsi/libsas/sas_internal.h
>> @@ -50,6 +50,7 @@ void sas_discover_event(struct asd_sas_port *port, 
>> enum discover_event ev);
>>   void sas_init_dev(struct domain_device *dev);
>>   void sas_unregister_dev(struct asd_sas_port *port, struct 
>> domain_device *dev);
>> +void sas_ex_unregister_end_dev(struct domain_device *dev);
>>   void sas_scsi_recover_host(struct Scsi_Host *shost);
>> @@ -145,7 +146,10 @@ static inline void sas_fail_probe(struct 
>> domain_device *dev, const char *func, i
>>           func, dev->parent ? "exp-attached" :
>>           "direct-attached",
>>           SAS_ADDR(dev->sas_addr), err);
>> -    sas_unregister_dev(dev->port, dev);
>> +    if (dev->parent && !dev_is_expander(dev->dev_type))
> 
> This check looks odd.
> 
> So we're checking if we have a parent device and we are not an expander, 
> right?
Yes.
> 
>> +        sas_ex_unregister_end_dev(dev);
>> +    else
>> +        sas_unregister_dev(dev->port, dev);
>>   }
>>   static inline void sas_fill_in_rphy(struct domain_device *dev,
> 
> .

Thanks,
Xingui
