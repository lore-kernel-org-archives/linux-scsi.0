Received: from szxga05-in.huawei.com (szxga05-in.huawei.com [45.249.212.191])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15A7113A3F2;
	Thu, 27 Feb 2025 08:33:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=45.249.212.191
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740645221; cv=none; b=SY6+wrmXxyXsl+G2TFEKyMmRtABT2VbO/tCBo3ZaJGIF/9FSjjZXkizPVay0SICP15AkM6zs+tIzXQ+MH7JNBuOpRX/ed4gLZu03/KWtcwDOaqu2b9glvg4oA1BBOPZSDqs9LLMsmiCTKRmZPP8Z4IMzvJRfoKFN0DHIBAddQXY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740645221; c=relaxed/simple;
	bh=tTU8BPQogB7QOOex7t9c3MRyP9OwxduI4shfP+gPs1c=;
	h=Message-ID:Date:MIME-Version:Subject:To:CC:References:From:
	 In-Reply-To:Content-Type; b=jYr4oRG6tgcVQXzCGUynoQxePgJWKHNOvRd0fEDRHQEydTxADiT25TTRXEJSxvyXOxQBRCWJKMha6vOt+g0/mgXdpvj/xDjoAKgSezSQ7QWfPCqAj6MlnUuCM4WA7o8mojkoX2Z5euR7S6No8B1iZJuDHBpsgB+AA+EekGTQd0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com; spf=pass smtp.mailfrom=huawei.com; arc=none smtp.client-ip=45.249.212.191
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=quarantine dis=none) header.from=huawei.com
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=huawei.com
Received: from mail.maildlp.com (unknown [172.19.88.214])
	by szxga05-in.huawei.com (SkyGuard) with ESMTP id 4Z3Pdd4tz8z1ltYR;
	Thu, 27 Feb 2025 16:29:25 +0800 (CST)
Received: from kwepemg100017.china.huawei.com (unknown [7.202.181.58])
	by mail.maildlp.com (Postfix) with ESMTPS id 5CCE51A016C;
	Thu, 27 Feb 2025 16:33:30 +0800 (CST)
Received: from [10.67.120.108] (10.67.120.108) by
 kwepemg100017.china.huawei.com (7.202.181.58) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.2.1544.11; Thu, 27 Feb 2025 16:33:29 +0800
Message-ID: <9765d9c7-959f-3611-4093-89f7e941e2ba@huawei.com>
Date: Thu, 27 Feb 2025 16:33:29 +0800
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.1
Subject: Re: [PATCH v3 1/3] scsi: hisi_sas: Enable force phy when SATA disk
 directly connected
Content-Language: en-CA
To: John Garry <john.g.garry@oracle.com>, <liyihang9@huawei.com>,
	<yanaijie@huawei.com>
CC: <jejb@linux.ibm.com>, <martin.petersen@oracle.com>,
	<linux-scsi@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
	<linuxarm@huawei.com>, <prime.zeng@huawei.com>, <liuyonglong@huawei.com>,
	<kangfenglong@huawei.com>, <liyangyang20@huawei.com>,
	<f.fangjian@huawei.com>, <xiabing14@h-partners.com>
References: <20250220130546.2289555-1-yangxingui@huawei.com>
 <20250220130546.2289555-2-yangxingui@huawei.com>
 <4bf89b6c-8730-4ae8-8b26-770b2aab2c13@oracle.com>
 <5a4384dc-4edb-9e29-d1dd-190d69b9e313@huawei.com>
 <1e98a1eb-a763-4190-94c5-a867cdf0e09b@oracle.com>
 <235e7ad8-1e19-4b7b-c64b-b6703851ca65@huawei.com>
 <d233a108-a46e-47dd-86ad-756c60c8665e@oracle.com>
 <cc9ba6f8-1efb-4910-8952-9ca07c707658@huawei.com>
 <5d34595f-ff57-4679-b263-fa3fea006ce3@oracle.com>
 <25552c7d-858d-ea1e-0987-55f71642a503@huawei.com>
 <420fde94-28ec-4321-943b-5cb84cf14f0e@oracle.com>
 <d4b7ae14-5b60-883a-c4f8-be11fc51a4f7@huawei.com>
 <4f287a32-d24f-47dc-bec5-a4b94895e135@oracle.com>
From: yangxingui <yangxingui@huawei.com>
In-Reply-To: <4f287a32-d24f-47dc-bec5-a4b94895e135@oracle.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-ClientProxiedBy: kwepemh500008.china.huawei.com (7.202.181.139) To
 kwepemg100017.china.huawei.com (7.202.181.58)

Hi, John

On 2025/2/26 16:57, John Garry wrote:

> 
> The lldd_dev_found CB is where you should set the itct, and it is only 
> possible to do that if you report the device gone first. So that seems 
> like a simpler solution.
Solution as follow?
+static bool hisi_sas_hw_port_id_changed(struct hisi_hba *hisi_hba, int 
phy_no)
+{
+       struct hisi_sas_phy *phy = &hisi_hba->phy[phy_no];
+       struct asd_sas_phy *sas_phy = &phy->sas_phy;
+       struct device *dev = hisi_hba->dev;
+       struct asd_sas_port *sas_port;
+       struct hisi_sas_port *port;
+
+       if (!sas_phy->port)
+               return false;
+
+       sas_port = sas_phy->port;
+       port = to_hisi_sas_port(sas_port);
+       if (phy->port_id == port->id)
+               return false;
+
+       dev_info(dev, "phy%d's hw port id changed from %d to %llu\n",
+                phy_no, port->id, phy->port_id);
+
+       return true;
+}
+
  static void hisi_sas_slot_index_clear(struct hisi_hba *hisi_hba, int 
slot_idx)
  {
         void *bitmap = hisi_hba->slot_index_tags;
@@ -856,6 +878,14 @@ static void hisi_sas_phyup_work_common(struct 
work_struct *work,
         struct asd_sas_phy *sas_phy = &phy->sas_phy;
         int phy_no = sas_phy->id;

+       if (hisi_sas_hw_port_id_changed(hisi_hba, phy_no)) {
+               sas_phy_disconnected(sas_phy);
+               phy->phy_attached = 0;
+               sas_notify_port_event(sas_phy, PORTE_LINK_RESET_ERR, 
GFP_ATOMIC);
+               hisi_sas_notify_phy_event(phy, HISI_PHYE_LINK_RESET);
+               return;
+       }
+

Thanks,
Xingui
