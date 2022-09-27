Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39635C07E9D
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Sep 2022 02:24:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230073AbiI0CY1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Sep 2022 22:24:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229552AbiI0CY0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Sep 2022 22:24:26 -0400
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FF50AB19A
        for <linux-scsi@vger.kernel.org>; Mon, 26 Sep 2022 19:24:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1664245463; x=1695781463;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=0iSGZW8cmukJH3UL3PwqWyDwnkfTJaj1NMHHrP/i+As=;
  b=NySM6YhBfF5VR8bwZb9SoFjyGx1UBcQ5MRbTatuVKc/OTdOvZWLLpV4h
   41AUzsppMz94kVmMIvlhN6wdPQFSqVlpKJO181e/akl5HVrEiX+qnANPb
   JHL8esehv9vdqOCRE/u3izftjIWBs+UdjiKh2x8ES7hcX2OO7XuElB0xs
   1xV4DFH7PyIKVEWDdAQ+TYqvaKCmXm6rfBmtZYRNCY8cPePeigdJ48L18
   AOAffSznnjtcNwDqtFmtysmee6qy4Q6hB8kvABVtDIAEdn5TT2Z0qc9WD
   MzK8MXWHc+PFX14Z37ZFsby8T+mLV1ow95YS9jW27ipCXvv8BoFagiALm
   Q==;
X-IronPort-AV: E=Sophos;i="5.93,347,1654531200"; 
   d="scan'208";a="324440595"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 27 Sep 2022 10:24:22 +0800
IronPort-SDR: LJCjGX3VlJ6UrUivD+nOAbYOssKmbete0MNnyEDCnCWzIf3raEDGiRyXOUV913WXUWcEF57nRY
 sJhqw51NiUZcG5kL8mHTvdbxjRKAI4mEEKkU+NQ8M1keqjKtrLkEBAQA2oxMsPVlGhaUGSiHjm
 zzVdds6PUr+9zv78fT2CDJwXZdmJllzCa8RwqGdeqqAEXKgJTgdZf9mc/36Sy073/rOrUpAFUm
 wH6hzTF0JA4ngFjoLIibaCOyDitT/Hcn1WMIIBLf3FCqS11LkkcV3Pzo33nbLpUbd/lF83Ka1n
 SAxAjX8tYZVw5EOkwCfyvdfR
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 26 Sep 2022 18:38:48 -0700
IronPort-SDR: LlSNC0fVa7y8fkGrWxd0zS5UN2CbZR0dSvxYDtRq68Xdgbi+2VnbN+yIojROlKsiDVu6XGg5SY
 l4aknVMhSb0CNap7QecRmGxlO+jAYIVw9u8u+A5moCVjuTl7o96+b8Jk15si+1yQUwhjYWkc6H
 YRQSuYYpOy6Osnx09ojdTXr2zo6HkVRBeZbCfsct2fbb2pn7WtFokjsHVshi6gBmhWV2q5EUJ2
 9c1DIE2sg6p2rVgw1+Wi3H3WCwLKA2hVMGAsqVNBAx2AfY54ezoItu+E/mEwtI7fgafyPQAX/a
 Wqk=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 26 Sep 2022 19:24:22 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Mc3NQ1yrcz1Rwt8
        for <linux-scsi@vger.kernel.org>; Mon, 26 Sep 2022 19:24:22 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1664245461; x=1666837462; bh=0iSGZW8cmukJH3UL3PwqWyDwnkfTJaj1NMH
        HrP/i+As=; b=EiVEoKOWXSjiVURoS0JrEpq9nzO62yscc8KL1cxsJaZr4dN3C5o
        6/3JvNpIuKtSzw7ivz3mj9efCGnyMRlVnKZDMXmeq/0So0qDOgDMO4VJyl4uMo3q
        MFd20oodm1/8SZDvPnM2unpLlU3fHdx+kRc+20sMDWrhNDpx25QSW06mF3L40MGx
        QMI13MBnhvK2NUEZz+68TUbwt77fqQcAmBNkkwIhvcGa3gyYG/6MppCYOsC/N7P2
        trJ7r978d1EHgdYcd9rohaI+Kk0t/C+7sQ18G1hM1/JuEZer9Y92Xo2BOIoD+rNz
        UQm/LbFRLoDwZ1GTtbPGHedoi1HMu7RjGhQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 5qlzb7HrHMnQ for <linux-scsi@vger.kernel.org>;
        Mon, 26 Sep 2022 19:24:21 -0700 (PDT)
Received: from [10.225.163.91] (unknown [10.225.163.91])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Mc3NM6LGQz1RvLy;
        Mon, 26 Sep 2022 19:24:19 -0700 (PDT)
Message-ID: <0939e5df-9e2c-8471-b704-9520225b5759@opensource.wdc.com>
Date:   Tue, 27 Sep 2022 11:24:18 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH v3 2/8] scsi: libsas: introduce sas_find_attached_phy()
 helper
Content-Language: en-US
To:     Jason Yan <yanaijie@huawei.com>, martin.petersen@oracle.com,
        jejb@linux.ibm.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        hare@suse.com, hch@lst.de, bvanassche@acm.org,
        john.garry@huawei.com, jinpu.wang@cloud.ionos.com,
        Jack Wang <jinpu.wang@ionos.com>
References: <20220927022941.4029476-1-yanaijie@huawei.com>
 <20220927022941.4029476-3-yanaijie@huawei.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220927022941.4029476-3-yanaijie@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/27/22 11:29, Jason Yan wrote:
> LLDDs are implementing their own attached phy finding code repeatedly.
> Factor it out to libsas.
> 
> Signed-off-by: Jason Yan <yanaijie@huawei.com>
> Reviewed-by: Jack Wang <jinpu.wang@ionos.com>

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

> ---
>  drivers/scsi/libsas/sas_expander.c | 16 ++++++++++++++++
>  include/scsi/libsas.h              |  2 ++
>  2 files changed, 18 insertions(+)
> 
> diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
> index fa2209080cc2..df5a64ad902f 100644
> --- a/drivers/scsi/libsas/sas_expander.c
> +++ b/drivers/scsi/libsas/sas_expander.c
> @@ -2107,6 +2107,22 @@ int sas_ex_revalidate_domain(struct domain_device *port_dev)
>  	return res;
>  }
>  
> +int sas_find_attached_phy(struct expander_device *ex_dev,
> +			  struct domain_device *dev)
> +{
> +	struct ex_phy *phy;
> +	int phy_id;
> +
> +	for (phy_id = 0; phy_id < ex_dev->num_phys; phy_id++) {
> +		phy = &ex_dev->ex_phy[phy_id];
> +		if (sas_phy_match_dev_addr(dev, phy))
> +			return phy_id;
> +	}
> +
> +	return -ENODEV;
> +}
> +EXPORT_SYMBOL_GPL(sas_find_attached_phy);
> +
>  void sas_smp_handler(struct bsg_job *job, struct Scsi_Host *shost,
>  		struct sas_rphy *rphy)
>  {
> diff --git a/include/scsi/libsas.h b/include/scsi/libsas.h
> index 2dbead74a2af..75faf2308eae 100644
> --- a/include/scsi/libsas.h
> +++ b/include/scsi/libsas.h
> @@ -750,6 +750,8 @@ int sas_clear_task_set(struct domain_device *dev, u8 *lun);
>  int sas_lu_reset(struct domain_device *dev, u8 *lun);
>  int sas_query_task(struct sas_task *task, u16 tag);
>  int sas_abort_task(struct sas_task *task, u16 tag);
> +int sas_find_attached_phy(struct expander_device *ex_dev,
> +			  struct domain_device *dev);
>  
>  void sas_notify_port_event(struct asd_sas_phy *phy, enum port_event event,
>  			   gfp_t gfp_flags);

-- 
Damien Le Moal
Western Digital Research

