Received: from canpmsgout02.his.huawei.com (canpmsgout02.his.huawei.com [113.46.200.217])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C84D253B73;
	Thu, 28 May 2026 02:40:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=113.46.200.217
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779936046; cv=none; b=f8uEJEGggHXNe/TPZIVcQxEPJ+IAWwN+78Gcrx3fK6eqnxB8cLn+2FeiK0hg2VZgGylUFVeQCUXsXUirOb5npP4SoBOrgETYdDY2AVXr8K2h06WOvwPS8RPqyC+LFAVTHZkb//yhxh5l0RIANsOq5rc9C8lBmgyv+y06sjsHoW8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779936046; c=relaxed/simple;
	bh=4ne/F3GhJd4ug+cucRL+Ux9T+hXykDXFIyYfjRJfAIc=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=RN3cKQoHIFMcZn9Z96//xN6gtR7q4g1Du6Fj5Y7ulxXnUE/NxrQFcdeTO+Rbop30ANCYtgi8T4J28fGCYnij2ca9pplYl2kedXlISno3zKF5bz/VdqU/ViwGdXFUlyGfT6kUx09dextBG5rGmox/w4l9rHXOtGZmcrTQ1/Kt4po=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=h-partners.com; dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b=djrm+F5D; arc=none smtp.client-ip=113.46.200.217
Authentication-Results: smtp.subspace.kernel.org; dmarc=fail (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=h-partners.com
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=h-partners.com header.i=@h-partners.com header.b="djrm+F5D"
dkim-signature: v=1; a=rsa-sha256; d=h-partners.com; s=dkim;
	c=relaxed/relaxed; q=dns/txt;
	h=From;
	bh=Jq/ZSA0n/bM3e0hfO/ARy0dkxHT14vAwyRwagdoexeA=;
	b=djrm+F5DQGCkVTqx31dpvD0YALMrrCaudrkHDbapQLfN+vU471sEjQoH9EqJVyGCVUr5aaZBy
	e3a99/fq1R38a6F1UYpydL7QKi7XOB0y8TfRsKDT/HssbY+ZGYZLNBv6rDAYVrRlZME1xMwXzpc
	zJN8+Tbpkrnv0/r4TMwK21o=
Received: from mail.maildlp.com (unknown [172.19.162.197])
	by canpmsgout02.his.huawei.com (SkyGuard) with ESMTPS id 4gQrB66z8Dzcb19;
	Thu, 28 May 2026 10:32:46 +0800 (CST)
Received: from kwepemj100018.china.huawei.com (unknown [7.202.194.12])
	by mail.maildlp.com (Postfix) with ESMTPS id E7A3140569;
	Thu, 28 May 2026 10:40:34 +0800 (CST)
Received: from [10.67.120.108] (10.67.120.108) by
 kwepemj100018.china.huawei.com (7.202.194.12) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.36; Thu, 28 May 2026 10:40:34 +0800
Message-ID: <a96f591e-5742-4e58-149b-294563d456d4@huawei.com>
Date: Thu, 28 May 2026 10:40:33 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH v3 2/2] scsi: libsas: Add linkrate and sas_addr change
 detection in rediscover
Content-Language: en-CA
To: John Garry <john.g.garry@oracle.com>, <yanaijie@huawei.com>,
	<jejb@linux.ibm.com>, <martin.petersen@oracle.com>
CC: <linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <liyihang9@h-partners.com>, <liuyonglong@huawei.com>,
	<kangfenglong@huawei.com>
References: <20260515084531.866259-1-yangxingui@huawei.com>
 <20260515084531.866259-3-yangxingui@huawei.com>
 <b18e1085-1d77-4b54-ae4d-8ae5a50a79b9@oracle.com>
 <5600f8fa-489a-9b81-9966-dc5d436c462e@huawei.com>
 <b99cd59f-b986-432e-aaf1-3b757e1c4c34@oracle.com>
 <be627116-acd2-c9c5-a665-b86e4f6392c5@huawei.com>
 <0a0f7284-8c11-4976-9377-d2fe9e0cf147@oracle.com>
From: yangxingui <yangxingui@huawei.com>
In-Reply-To: <0a0f7284-8c11-4976-9377-d2fe9e0cf147@oracle.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 8bit
X-ClientProxiedBy: kwepemh500008.china.huawei.com (7.202.181.139) To
 kwepemj100018.china.huawei.com (7.202.194.12)



On 2026/5/27 17:42, John Garry wrote:
> On 25/05/2026 03:25, yangxingui wrote:
>>>>
>>>> Hi, John
>>>> As the commit log. The existing pattern (unregister + 
>>>> sas_discover_new) handles the "replace" case where the SAS address 
>>>> changes completely, implying a different device.
>>>> For the flutter case where we detect linkrate/sas_addr changes,
>>>
>>> Can you please clarify this: you say that the existing pattern 
>>> handles "replace" case where the SAS address changes completely, and 
>>> then flutter case covers sas_addr changes.
>>>
>>> What is the difference in the SAS address changes between the two cases?
>>>
>> Hi, John
>>
>> The difference is in when the SAS address change is detected:
>> Replace case:
>> - Detected immediately by the initial SMP DISCOVER response
>> - New SAS address differs from stored phy->attached_sas_addr
>>
>> Flutter case:
>> - Initial SMP DISCOVER shows SAS address matching stored phy- 
>>  >attached_sas_addr
>> - Linkrate may change
>> - After sas_ex_phy_discover() refreshes phy info, child device address 
>> and linkrate may mismatched with refreshed phy info
>>
>> Additional issue with Replace flow:
>> The existing replace code path also suffers from the same 
>> sysfs_warn_dup issue I mentioned earlier. 
>> sas_unregister_devs_sas_addr() only marks the device as gone and adds 
>> it to destroy_list. The actual sysfs cleanup happens later in 
>> sas_destruct_devices(). Calling sas_discover_new() immediately after 
>> unregister causes sysfs duplicate directory errors.
>>
> 
> So can you actually recreate this issue? Or is it just theoretical?
Yes, it can recreate, such as quickly replacing a disk or swapping two 
disk. However, during normal use, we recommend that customers wait for 
one minute before inserting a new disk when replacing a disk to avoid 
this issue.

The following are example of similar exception logs:
log1：

[ 7957.283194][T67794] sas: ex 500e004aaaaaaa1f phy19 replace 
5001882016000000
[ 7957.290960][T67794] sysfs: cannot create duplicate filename 
'/devices/pci0000:74/0000:74:02.0/host1/port-1:2/expander-1:2/port-1:2:19'
[ 7957.317973][T67794] Hardware name: Huawei Technologies Co., Ltd. 
EVBCS/EVBCS, BIOS CS B055 2P TA 02/19/2020
[ 7957.328900][T67794] Workqueue: 0000:74:02.0_disco_q 
sas_revalidate_domain [libsas]
[ 7957.337636][T67794] Call trace:
[ 7957.341419][T67794]  dump_backtrace+0x0/0x200
[ 7957.346317][T67794]  show_stack+0x20/0x30
[ 7957.350887][T67794]  dump_stack+0xf0/0x138
[ 7957.355511][T67794]  sysfs_warn_dup+0x6c/0x90
[ 7957.360410][T67794]  sysfs_create_dir_ns+0xf8/0x11c
[ 7957.365795][T67794]  create_dir+0x30/0x18c
[ 7957.370416][T67794]  kobject_add_internal+0x5c/0x190
[ 7957.375877][T67794]  kobject_add+0x98/0x110
[ 7957.380566][T67794]  device_add+0x100/0x4a0
[ 7957.385255][T67794]  sas_port_add+0x30/0x74 [scsi_transport_sas]
[ 7957.391722][T67794]  sas_ex_discover_end_dev+0x328/0x630 [libsas]
[ 7957.398328][T67794]  sas_ex_discover_dev+0x230/0x320 [libsas]
[ 7957.404599][T67794]  sas_ex_discover_devices+0x60/0x100 [libsas]
[ 7957.411116][T67794]  sas_discover_new+0xa4/0x150 [libsas]
[ 7957.416986][T67794]  sas_rediscover_dev+0x198/0x260 [libsas]
[ 7957.423125][T67794]  sas_rediscover+0xb8/0x100 [libsas]
[ 7957.428854][T67794]  sas_ex_revalidate_domain+0x5c/0xe0 [libsas]
[ 7957.435320][T67794]  sas_revalidate_domain+0x1ac/0x1b4 [libsas]
[ 7957.441714][T67794]  process_one_work+0x1d8/0x4cc
[ 7957.446884][T67794]  worker_thread+0x158/0x410
[ 7957.451769][T67794]  kthread+0x108/0x13c
[ 7957.456089][T67794]  ret_from_fork+0x10/0x18
[ 7957.460800][T67794] kobject_add_internal failed for port-1:2:19 with 
-EEXIST, don't try to register things with the same name in the same 
directory.
[ 7957.474864][T67794] sas: ex 500e004aaaaaaa1f phy19 failed to discover

log2：
[ 8608.766031][T66335] sas: ex 500e004aaaaaaa1f phy17 change count has 
changed
[ 8608.774390][T66335] sysfs: cannot create duplicate filename 
'/devices/pci0000:74/0000:74:02.0/host1/port-1:2/expander-1:3/port-1:3:17'
[ 8608.800667][T66335] Hardware name: Huawei Technologies Co., Ltd. 
EVBCS/EVBCS, BIOS CS B055 2P TA 02/19/2020
[ 8608.811270][T66335] Workqueue: 0000:74:02.0_disco_q 
sas_revalidate_domain [libsas]
[ 8608.819685][T66335] Call trace:
[ 8608.823235][T66335]  dump_backtrace+0x0/0x200
[ 8608.827990][T66335]  show_stack+0x20/0x30
[ 8608.832387][T66335]  dump_stack+0xf0/0x138
[ 8608.836858][T66335]  sysfs_warn_dup+0x6c/0x90
[ 8608.841580][T66335]  sysfs_create_dir_ns+0xf8/0x11c
[ 8608.846814][T66335]  create_dir+0x30/0x18c
[ 8608.851257][T66335]  kobject_add_internal+0x5c/0x190
[ 8608.856566][T66335]  kobject_add+0x98/0x110
[ 8608.861083][T66335]  device_add+0x100/0x4a0
[ 8608.865588][T66335]  sas_port_add+0x30/0x74 [scsi_transport_sas]
[ 8608.871919][T66335]  sas_ex_discover_end_dev+0x328/0x630 [libsas]
[ 8608.878345][T66335]  sas_ex_discover_dev+0x230/0x320 [libsas]
[ 8608.884430][T66335]  sas_ex_discover_devices+0x60/0x100 [libsas]
[ 8608.890768][T66335]  sas_discover_new+0xa4/0x150 [libsas]
[ 8608.896506][T66335]  sas_rediscover+0xd8/0x100 [libsas]
[ 8608.902075][T66335]  sas_ex_revalidate_domain+0x5c/0xe0 [libsas]
[ 8608.908438][T66335]  sas_revalidate_domain+0x1ac/0x1b4 [libsas]
[ 8608.914708][T66335]  process_one_work+0x1d8/0x4cc
[ 8608.919757][T66335]  worker_thread+0x158/0x410
[ 8608.924533][T66335]  kthread+0x108/0x13c
[ 8608.928778][T66335]  ret_from_fork+0x10/0x18
[ 8608.933377][T66335] kobject_add_internal failed for port-1:3:17 with 
-EEXIST, don't try to register things with the same name in the same 
directory.
[ 8608.947364][T66335] sas: ex 500e004aaaaaaa1f phy17 failed to discover


> About this following code:
> 
> +        if (need_rediscover) {
> +            set_bit(SAS_DEV_GONE, &child_dev->state);
> +            phy->phy_change_count = -1;
> +            ex->ex_change_count = -1;
> +            sas_unregister_devs_sas_addr(dev, phy_id, true);
> +            sas_discover_event(dev->port, DISCE_REVALIDATE_DOMAIN);
> +        } else {
> 
> 
> Can we factor it out with other code? AFAICR, this can pattern can be 
> seen elsewhere.

Yes, in the updated v4 version, I refined it into a function.

In the v4 test log, the disk is gone and then connected again.
test case:
phy=phy-10:0:0
echo 1.5 Gbit > /sys/class/sas_phy/$phy/maximum_linkrate

The details are as follows:

[  541.880156] sas: broadcast received: 0
[  541.880712] sas: REVALIDATING DOMAIN on port 0, pid:8995
[  541.882509] sas: ex 500e004aaaaaaa1f phy00 change count has changed
[  541.883680] sas: ex 500e004aaaaaaa1f phy00 originated BROADCAST(CHANGE)
[  541.883703] sas: ex 500e004aaaaaaa1f rediscovering phy00
[  541.884838] sas: ex 500e004aaaaaaa1f phy00:U:8 attached: 
500e004aaaaaaa00 (stp pending)
[  541.884844] sas: ex 500e004aaaaaaa1f phy00 broadcast flutter, needs 
recovery
[  541.898893] sas: done REVALIDATING DOMAIN on port 0, pid:8995, res 0x0
[  541.899444] sas: broadcast received: 0
[  541.899506] sas: REVALIDATING DOMAIN on port 0, pid:8995
[  541.899659] sas: done REVALIDATING DOMAIN on port 0, pid:8995, res 0x0
[  541.900213] sas: broadcast received: 0
[  541.900282] sas: REVALIDATING DOMAIN on port 0, pid:8995
[  541.900367] sas: done REVALIDATING DOMAIN on port 0, pid:8995, res 0x0
[  541.900992] sas: broadcast received: 0
[  541.901041] sas: REVALIDATING DOMAIN on port 0, pid:8995
[  541.901132] sas: done REVALIDATING DOMAIN on port 0, pid:8995, res 0x0
[  541.901160] sas: broadcast received: 0
[  541.901195] sas: REVALIDATING DOMAIN on port 0, pid:8995
[  541.901278] sas: done REVALIDATING DOMAIN on port 0, pid:8995, res 0x0
[  541.901887] sas: broadcast received: 0
[  541.901948] sas: REVALIDATING DOMAIN on port 0, pid:8995
[  541.902035] sas: done REVALIDATING DOMAIN on port 0, pid:8995, res 0x0
[  541.902673] sas: broadcast received: 0
[  541.902741] sas: REVALIDATING DOMAIN on port 0, pid:8995
[  541.902836] sas: done REVALIDATING DOMAIN on port 0, pid:8995, res 0x0
[  541.903467] sas: broadcast received: 0
[  541.903536] sas: REVALIDATING DOMAIN on port 0, pid:8995
[  541.903625] sas: done REVALIDATING DOMAIN on port 0, pid:8995, res 0x0
[  541.919967] sas: broadcast received: 0
[  541.920036] sas: REVALIDATING DOMAIN on port 0, pid:8995
[  541.920385] sas: ex 500e004aaaaaaa1f phy00 change count has changed
[  541.920494] sas: ex 500e004aaaaaaa1f phy00 originated BROADCAST(CHANGE)
[  541.920504] sas: ex 500e004aaaaaaa1f rediscovering phy00
[  541.920687] sas: ex 500e004aaaaaaa1f phy00:U:8 attached: 
500e004aaaaaaa00 (stp)
[  541.920697] sas: ex 500e004aaaaaaa1f phy00 linkrate changed from 9 to 8
[  541.920710] sas: ex 500e004aaaaaaa1f phy00 replace 500e004aaaaaaa00
[  541.922648] sas: done REVALIDATING DOMAIN on port 0, pid:8995, res 0x0
[  542.007031] sd 10:0:0:0: [sdd] Stopping disk
[  542.007122] sd 10:0:0:0: [sdd] Start/Stop Unit failed: Result: 
hostbyte=0x04 driverbyte=DRIVER_OK
[  542.027347] hisi_sas_v3_hw 0000:70:04.0: dev[2:5] is gone
[  542.039000] sas: REVALIDATING DOMAIN on port 0, pid:8995
[  542.039358] sas: ex 500e004aaaaaaa1f phy00 change count has changed
[  542.039436] sas: broadcast received: 0
[  542.039470] sas: ex 500e004aaaaaaa1f phy00 originated BROADCAST(CHANGE)
[  542.039482] sas: ex 500e004aaaaaaa1f phy00 new device attached
[  542.039569] sas: ex 500e004aaaaaaa1f phy00:U:8 attached: 
500e004aaaaaaa00 (stp)
[  542.040152] hisi_sas_v3_hw 0000:70:04.0: dev[15:5] found
[  542.042112] sas: done REVALIDATING DOMAIN on port 0, pid:8995, res 0x0
[  542.153137] sas: Enter sas_scsi_recover_host busy: 0 failed: 0
[  542.153900] sas: ata10: end_device-10:0:1: dev error handler
[  542.153972] sas: ata11: end_device-10:0:2: dev error handler
[  542.153994] sas: ata12: end_device-10:0:5: dev error handler
[  542.154010] sas: ata13: end_device-10:0:6: dev error handler
[  542.154021] sas: ata14: end_device-10:0:9: dev error handler
[  542.154032] sas: ata15: end_device-10:0:10: dev error handler
[  542.154044] sas: ata9: end_device-10:0:0: dev error handler
[  542.519243] ata9.00: ATA-10: ST4000NM0035-1V4107, TN03, max UDMA/133
[  542.522538] ata9.00: 7814037168 sectors, multi 0: LBA48 NCQ (depth 32)
[  542.522561] ata9.00: Features: DIPM NCQ-sndrcv
[  542.527315] ata9.00: configured for UDMA/133
[  542.527976] sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 0 
tries: 1
[  542.570193] scsi 10:0:13:0: Direct-Access     ATA 
ST4000NM0035-1V4 TN03 PQ: 0 ANSI: 5
[  542.571771] scsi 10:0:13:0: Attached scsi generic sg3 type 0


Thanks,
Xingui
