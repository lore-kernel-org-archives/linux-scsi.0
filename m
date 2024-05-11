Received: from szxga02-in.huawei.com (szxga02-in.huawei.com [45.249.212.188])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 11F4126AC1
	for <linux-scsi@vger.kernel.org>; Sat, 11 May 2024 03:41:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.188
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715398890; cv=none; b=m+8bTpSso0888GnaCi1nn1behn9PXCgXFwZrV28oQRMPoKc5d9hnQvmje2vWq45tKMQxvF0mDdrlULlrB9cnuKEoEyeG6Cb4T5yX9Oylk6G+qHPG2PwgE3yunUgIKvX6rdJX9F9ox5ZgFvsmha277f+dn7hbPwxi42/cbcOXqB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715398890; c=relaxed/simple;
	bh=nliTbCtikCRz9HdIXTVeNq40RsRmVieoTJIGZkExtCA=;
	h=Subject:To:CC:References:From:Message-ID:Date:MIME-Version:
	 In-Reply-To:Content-Type; b=OMYl/Prf+05LbM5WbHAKDS3PU6ksmNgOQmkhv+OYclW5VME521OEiVdNdpnvqdyMeMj9+tIbbaUyL4o8b+KTP06GEmAKcw3+vqLPQL3SBAX5hNCraXlfulCwTuulR5eUKzi6QsJdAzJIYsmA0tEsNrOhXFVMg0TaH1MYFYzwmiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.188
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.162.254])
	by szxga02-in.huawei.com (SkyGuard) with ESMTP id 4VbrzR2WqczgYvy;
	Sat, 11 May 2024 11:37:23 +0800 (CST)
Received: from canpemm500010.china.huawei.com (unknown [7.192.105.118])
	by mail.maildlp.com (Postfix) with ESMTPS id 2CE1F1800AA;
	Sat, 11 May 2024 11:41:18 +0800 (CST)
Received: from canpemm500004.china.huawei.com (7.192.104.92) by
 canpemm500010.china.huawei.com (7.192.105.118) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Sat, 11 May 2024 11:41:11 +0800
Received: from [10.174.179.14] (10.174.179.14) by
 canpemm500004.china.huawei.com (7.192.104.92) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2507.35; Sat, 11 May 2024 11:41:10 +0800
Subject: Re: Issue in sas_ex_discover_dev() for multiple level of SAS
 expanders in a domain
To: "Li, Eric (Honggang)" <Eric.H.Li@Dell.com>, John Garry
	<john.g.garry@oracle.com>, "james.bottomley@hansenpartnership.com"
	<James.Bottomley@HansenPartnership.com>, "Martin K . Petersen"
	<martin.petersen@oracle.com>
CC: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
References: <SJ0PR19MB5415BBBE841D8272DB2C67D6C4102@SJ0PR19MB5415.namprd19.prod.outlook.com>
 <SJ0PR19MB5415831DB91059696672B163C4172@SJ0PR19MB5415.namprd19.prod.outlook.com>
 <SJ0PR19MB54152CB3D611259510902505C41A2@SJ0PR19MB5415.namprd19.prod.outlook.com>
 <c004da1f-b9fe-4641-9d0f-162eabde0101@oracle.com>
 <PH0PR19MB54115A3BDCD9319781FA652FC41F2@PH0PR19MB5411.namprd19.prod.outlook.com>
 <823ab904-33a3-4ed0-8794-cb36b9ad636b@oracle.com>
 <SJ0PR19MB5415F1D35AFB4039A426079CC41C2@SJ0PR19MB5415.namprd19.prod.outlook.com>
 <PH0PR19MB5411390C5A29A953CAA70062C4E42@PH0PR19MB5411.namprd19.prod.outlook.com>
 <7081399f-d4e8-4af9-9cff-2bcb1e4c6064@oracle.com>
 <SJ0PR19MB5415A5F70B0D51BA96CBC76DC4E42@SJ0PR19MB5415.namprd19.prod.outlook.com>
 <b82bee4f-67b7-4355-a152-1f13d4918220@oracle.com>
 <SJ0PR19MB5415CFA77DCC17E0BFAEEF76C4E52@SJ0PR19MB5415.namprd19.prod.outlook.com>
 <eb90005b-1ef7-4bb6-bc62-84af5a03e3e7@oracle.com>
 <SJ0PR19MB54152471D18241A020914B2AC4E52@SJ0PR19MB5415.namprd19.prod.outlook.com>
From: Jason Yan <yanaijie@huawei.com>
Message-ID: <ec087459-ae19-f593-f046-846c041e397d@huawei.com>
Date: Sat, 11 May 2024 11:41:10 +0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
In-Reply-To: <SJ0PR19MB54152471D18241A020914B2AC4E52@SJ0PR19MB5415.namprd19.prod.outlook.com>
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: dggems704-chm.china.huawei.com (10.3.19.181) To
 canpemm500004.china.huawei.com (7.192.104.92)

On 2024/5/8 16:29, Li, Eric (Honggang) wrote:
>> -----Original Message-----
>> From: John Garry <john.g.garry@oracle.com>
>> Sent: Wednesday, May 8, 2024 3:48 PM
>> To: Li, Eric (Honggang) <Eric.H.Li@Dell.com>; Jason Yan <yanaijie@huawei.com>;
>> james.bottomley@hansenpartnership.com; Martin K . Petersen <martin.petersen@oracle.com>
>> Cc: linux-scsi@vger.kernel.org
>> Subject: Re: Issue in sas_ex_discover_dev() for multiple level of SAS expanders in a domain
>>
>>
>> [EXTERNAL EMAIL]
>>
>> On 08/05/2024 01:59, Li, Eric (Honggang) wrote:
>>>>> Call to sas_ex_join_wide_port() makes the rest PHYs associated with
>>>>> that existing port
>>>> (making it become wideport) and set up sysfs between the PHY and
>>>> port. > Set PHY_STATE_DISCOVERED would make the rest PHYs not being
>>>> scanned/discovered again (as this wide port is already scanned).
>>>>
>>>> If you can just confirm that re-adding the code to set phy_state =
>>>> DISCOVERED is good enough to see the SAS disks again, then this can
>>>> be further discussed. >>
>>> OK. I will work on that and keep you updated.
>>
>> I expect a flow like this for scanning of the downstream expander:
>>
>> sas_discover_new(struct domain_device *dev [upstream expander], int
>> phy_id_a) -> sas_ex_discover_devices(single = -1) ->
>> sas_ex_discover_dev(phy_id_b) for each phy in @dev non-vacant and non-discovered ->
>> sas_ex_discover_expander( [downstream expander]) for first phy scanned which belongs to
>> downstream expander.
>>
>> And following that we have continue to scan phys in sas_ex_discover_devices(single = -1) ->
>> sas_ex_discover_dev(phy_id_b) ->
>> sas_ex_join_wide_port() ->  for each non-vacant and non-discovered phy in phy_id_b which
>> matches that downstream expander.
>>
>> Can you see why this does not actually work/occur?
>>
> 
> before calling sas_ex_join_wide_port(), sas_dev_present_in_domain() finds the attached_sas_address of PHY (phy_id_b) is already in the domain of that root port, and then disable all PHYs to that downstream expander (in sas_ex_disable_port(dev, attached_sas_addr))
> Therefore, I think we need to switch the order of function call to sas_ex_join_wide_port() and sas_dev_present_in_domain().

Hi Eric,

Can you test the following patch to see if it works?

Author: Jason Yan <yanaijie@huawei.com>
Date:   Sat May 11 11:33:35 2024 +0800

     scsi: libsas: Skip disable PHYs which can form wide ports

     Signed-off-by: Jason Yan <yanaijie@huawei.com>

diff --git a/drivers/scsi/libsas/sas_expander.c 
b/drivers/scsi/libsas/sas_expander.c
index f6e6db8b8aba..39a86857bc52 100644
--- a/drivers/scsi/libsas/sas_expander.c
+++ b/drivers/scsi/libsas/sas_expander.c
@@ -618,15 +618,17 @@ static void sas_ex_disable_port(struct 
domain_device *dev, u8 *sas_addr)
         }
  }

-static int sas_dev_present_in_domain(struct asd_sas_port *port,
+static int sas_dev_present_in_domain(struct domain_device *dev,
                                             u8 *sas_addr)
  {
-       struct domain_device *dev;
+       struct domain_device *tmp;

         if (SAS_ADDR(port->sas_addr) == SAS_ADDR(sas_addr))
                 return 1;
-       list_for_each_entry(dev, &port->dev_list, dev_list_node) {
-               if (SAS_ADDR(dev->sas_addr) == SAS_ADDR(sas_addr))
+       list_for_each_entry(tmp, &dev->port->dev_list, dev_list_node) {
+               if (tmp->parent == dev)
+                       continue;
+               if (SAS_ADDR(tmp->sas_addr) == SAS_ADDR(sas_addr))
                         return 1;
         }
         return 0;
@@ -973,7 +975,7 @@ static int sas_ex_discover_dev(struct domain_device 
*dev, int phy_id)
                 return 0;
         }

-       if (sas_dev_present_in_domain(dev->port, ex_phy->attached_sas_addr))
+       if (sas_dev_present_in_domain(dev, ex_phy->attached_sas_addr))
                 sas_ex_disable_port(dev, ex_phy->attached_sas_addr);

         if (ex_phy->attached_dev_type == SAS_PHY_UNUSED) {




