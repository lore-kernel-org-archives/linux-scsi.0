Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE20815D5C8;
	Tue, 18 Jun 2024 11:46:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718711165; cv=none; b=Io409czbgaMyOFojKOh3L5jDCHWRVqSGsjq1RfPuIpFKtInAVKnOw0BKt3oljXUZhjiCmazyMamnR0Jajr1u6cfTGqhyTdZvf1dbOXpAt/JmS7VSPMHKlOto4zydmL9PpgV8XrQkc/lK0vUHWm/gS1fY5Ioo7K0tG38xsZQfs/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718711165; c=relaxed/simple;
	bh=1QIcrNptfaU/0/hqEe+Sb9+thzwL6QqBhrUZ3lP5deU=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=E8f28h2KWWbrZwT6KBKyA+veCTDYO58V9VAenoBNzu9bM5sum52+5a+5bZYAvIw/UNqyhWVTGHxH/KtEbA1e5kHLs30uLqF/UlH/W+Sb0nmz5+PEs74X54Mxoj/UlL07xALEnHIMB7hfUBaQYrqCRjgtuInv4q8lr6hlZtREIXc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.105])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4W3Pzx5LGBzdc8F;
	Tue, 18 Jun 2024 19:44:29 +0800 (CST)
Received: from dggpemd100001.china.huawei.com (unknown [7.185.36.94])
	by mail.maildlp.com (Postfix) with ESMTPS id EAC25140361;
	Tue, 18 Jun 2024 19:45:59 +0800 (CST)
Received: from [10.67.120.108] (10.67.120.108) by
 dggpemd100001.china.huawei.com (7.185.36.94) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1258.34; Tue, 18 Jun 2024 19:45:59 +0800
Message-ID: <815fcddf-85cc-126e-4be1-618b5ba8f823@huawei.com>
Date: Tue, 18 Jun 2024 19:45:59 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH v3] scsi: libsas: Fix exp-attached end device cannot be
 scanned in again after probe failed
Content-Language: en-CA
To: John Garry <john.g.garry@oracle.com>, <yanaijie@huawei.com>,
	<jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
	<damien.lemoal@opensource.wdc.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <prime.zeng@hisilicon.com>,
	<chenxiang66@hisilicon.com>, <kangfenglong@huawei.com>
References: <20240613122355.7797-1-yangxingui@huawei.com>
 <437c99f4-a67d-48d9-98ee-58cbbc3d19f4@oracle.com>
From: yangxingui <yangxingui@huawei.com>
In-Reply-To: <437c99f4-a67d-48d9-98ee-58cbbc3d19f4@oracle.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: dggpemm500002.china.huawei.com (7.185.36.229) To
 dggpemd100001.china.huawei.com (7.185.36.94)

Hi, John,

Thanks for your reply.

On 2024/6/18 16:55, John Garry wrote:
> On 13/06/2024 13:23, Xingui Yang wrote:
> 
> Sorry for delay in responding and asking further questions.
It doesn't matter.
> 
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
> 
> Can you just manually clear the ex_phy's attached_sas_addr at the 
> appropiate point (along with calling sas_unregister_dev())? It seems 
> that we are using heavy-handed approach in calling 
> sas_unregister_devs_sas_addr(), which does the clearing and much more.

I just tried it and it worked. If we only clear ex_phy's 
attached_sas_addr, there is no need to call sas_destruct_ports(). We are 
currently using sas_unregister_devs_sas_addr() which will add the port 
to sas_port_del_list, so we need to call sas_destruct_ports() separately 
to delete the port.

Should we also delete the port after the devices probe failed?

Maybe I can update another version and only clear ex_phy's 
attached_sas_addr based on your suggestions.
> 
>>
>> As devices may probe failed after done REVALIDATING DOMAIN when call
>> sas_probe_devices(). Then after its port is added to the 
>> sas_port_del_list,
>> the port will not be deleted until the end of the next REVALIDATING 
>> DOMAIN
>> and sas_destruct_ports() is called. A warning about creating a duplicate
>> port will occur in the new REVALIDATING DOMAIN when the end device
>> reconnects. Therefore, the previous destroy_list and sas_port_del_list
>> should be handled after devices probe failed.
>>
>> Signed-off-by: Xingui Yang <yangxingui@huawei.com>
>> ---
>> Changes since v2:
>> - Add a helper for calling sas_destruct_devices() and 
>> sas_destruct_ports(),
>>    and put the new call at the end of sas_probe_devices() based on John's
>>    suggestion.
>>
>> Changes since v1:
>> - Simplify the process of getting ex_phy id based on Jason's suggestion.
>> - Update commit information.
>> ---
>>   drivers/scsi/libsas/sas_discover.c | 32 +++++++++++++++++++-----------
>>   drivers/scsi/libsas/sas_expander.c |  8 ++++++++
>>   drivers/scsi/libsas/sas_internal.h |  6 +++++-
>>   3 files changed, 33 insertions(+), 13 deletions(-)
>>
>> diff --git a/drivers/scsi/libsas/sas_discover.c 
>> b/drivers/scsi/libsas/sas_discover.c
>> index 8fb7c41c0962..8c517e47d2b9 100644
>> --- a/drivers/scsi/libsas/sas_discover.c
>> +++ b/drivers/scsi/libsas/sas_discover.c
>> @@ -17,6 +17,22 @@
>>   #include <scsi/sas_ata.h>
>>   #include "scsi_sas_internal.h"
>> +static void sas_destruct_ports(struct asd_sas_port *port)
>> +{
>> +    struct sas_port *sas_port, *p;
>> +
>> +    list_for_each_entry_safe(sas_port, p, &port->sas_port_del_list, 
>> del_list) {
>> +        list_del_init(&sas_port->del_list);
>> +        sas_port_delete(sas_port);
>> +    }
>> +}
>> +
>> +static void sas_destruct_devices_and_ports(struct asd_sas_port *port)
> 
> "and" in a function name never sounds right.
> 
> Can you just call sas_destruct_port(), as it takes a port arg? Maybe 
> rename sas_destruct_ports() to sas_delete_ports(), as it does "delete" - 
> this may avoid some confusion in names.
As described above, if we only clear ex_phy's attached_sas_addr, we do 
not need to call sas_destruct_ports().
Thanks,
Xingui
