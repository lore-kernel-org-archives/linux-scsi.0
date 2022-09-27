Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B9D85C07E9D
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Sep 2022 02:30:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230163AbiI0CaQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Sep 2022 22:30:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56956 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230207AbiI0CaO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Sep 2022 22:30:14 -0400
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9C16901B9
        for <linux-scsi@vger.kernel.org>; Mon, 26 Sep 2022 19:30:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1664245812; x=1695781812;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=96lxJGCdpwYCl6P8l6RqZfZAsJgBQCmCcyStRhiqL/4=;
  b=F/z3BqgEr1saNH/rrYmaUAwFBtfm38IKHvjKr2kKIhp/ZtdArCUlrefT
   ZEcRP9SXn5/hK1+vuP3reeViwvIeEN/KHbQ/JsNRxaLp2G13z6solR7mP
   gOf8OpnW7ZklsPO7cGgUA0c7UCz/HNyCx6vgTl//NhSHs/Av0oPYr2nVb
   wbUws4xJvQ6auEN3yohQePdue9yAMeIToabjokoKT9S/6q+hB3jHZwcRX
   5QM5pvLN7VvtF1N8Aw61tDpfNcQfsVLjfw3uHZky1TKMCUcslzPy9uGxF
   ua9GpxbkZsOiviaM9IfJMljxWcY8v7JmvajwrTVgZhzmh3WZmb7vh+7xC
   g==;
X-IronPort-AV: E=Sophos;i="5.93,347,1654531200"; 
   d="scan'208";a="212759639"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 27 Sep 2022 10:30:07 +0800
IronPort-SDR: D9ou0gegdZN+VkuxwZwU6gxJH3vz2vu33XheTMOTBkZRRiZO05qV0scLsboZVK0/6HfYohW7B2
 rTfjLNdd1QZXDGemB+rd3Powx4NPUyKanWR5WFHkL+noCSIoh6E+mHz+nomqGtxTjk/b0C+jj/
 gF9JPqleh1NCbx5v4mAy3tX5O+zYbHeDHWTOayVmetr+utstmeZc4bydjpstp/CarrnCh9CtlI
 DmTkbuuVBGm3eu0TU45h7gyZMSGZCQohc60hH+4aMjljw+upY1ec1F6Sdti+fA1Ni4z/N36AGe
 Da/nlIh1UeBQ5pDw0WagYldn
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 26 Sep 2022 18:50:05 -0700
IronPort-SDR: +DlAVVSSf4lpnccqY1oZh2CbgHbD1Q0X2aUlqdgXipgYqIKwqODsB87ddSxHI9nwrmqIW1ISo7
 oA/7mlHnWzFv94owiuUjJYUxKScO3ii6062bOjU8kxAIcL1pndpxjTh5FnlwGEUgJ8quVEA1Ak
 oxscnQs8nsp3QAedzZt4HvQ9JIDzWETtiY547pcIYLzQM6DNoIhT5uYt6SZNhLZh4jRhAUa+cd
 dNDUo67UsMqA+uf/yR2M8xG6UAbyChQXhNaeUPt53/bkhbMmrCSNwUodwXgFLGCWhGcpo3lj7X
 /Vs=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 26 Sep 2022 19:30:08 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Mc3W33W5Xz1RwvL
        for <linux-scsi@vger.kernel.org>; Mon, 26 Sep 2022 19:30:07 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1664245806; x=1666837807; bh=96lxJGCdpwYCl6P8l6RqZfZAsJgBQCmCcyS
        tRhiqL/4=; b=NuCGJ4OY4or3+cIZ0sh+htrMgD202kS1LCx6u3HQOmmHT10HsIA
        0NtQQAyKDbV3miL5V1sCDiY2eyEwR0Ne9ipNSOrgIfVzZUmmuKQuq+siA4WjpnCy
        sIC4ZpgNmwp60Z6EG4p3oY+jUlUSaQWPeoVI6FOyGsc53NQL5ZUtB6cB9q5OM2p1
        DV5NQlIwv1G6Vk6f/CD3aC4nnHEpptpEEv8WppVRzTq3JKPNKNVdO32qRfRo6mpo
        Yhs1A12oZUrazpj4iAs/Gul47l45os5IOgKvcKHurLwW1jsul1uXAHN9arET3EQt
        5/Q4RD/ezxQPnD5+7OXXlkHziThMeCTTkcA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id LJRIuSOYsnSh for <linux-scsi@vger.kernel.org>;
        Mon, 26 Sep 2022 19:30:06 -0700 (PDT)
Received: from [10.225.163.91] (unknown [10.225.163.91])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Mc3W072ppz1RvLy;
        Mon, 26 Sep 2022 19:30:04 -0700 (PDT)
Message-ID: <585db20d-8530-d605-ebf2-e8d669e693a8@opensource.wdc.com>
Date:   Tue, 27 Sep 2022 11:30:03 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH v3 6/8] scsi: libsas: use sas_phy_match_dev_addr() instead
 of open coded
Content-Language: en-US
To:     Jason Yan <yanaijie@huawei.com>, martin.petersen@oracle.com,
        jejb@linux.ibm.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        hare@suse.com, hch@lst.de, bvanassche@acm.org,
        john.garry@huawei.com, jinpu.wang@cloud.ionos.com
References: <20220927022941.4029476-1-yanaijie@huawei.com>
 <20220927022941.4029476-7-yanaijie@huawei.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220927022941.4029476-7-yanaijie@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/27/22 11:29, Jason Yan wrote:
> The sas address comparation of domain device and expander phy is open
> coded. Now we can replace it with sas_phy_match_dev_addr().
> 
> Signed-off-by: Jason Yan <yanaijie@huawei.com>
> ---
>  drivers/scsi/libsas/sas_expander.c | 18 ++++++------------
>  1 file changed, 6 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
> index df5a64ad902f..b2b5103c3e76 100644
> --- a/drivers/scsi/libsas/sas_expander.c
> +++ b/drivers/scsi/libsas/sas_expander.c
> @@ -738,9 +738,7 @@ static void sas_ex_get_linkrate(struct domain_device *parent,
>  		    phy->phy_state == PHY_NOT_PRESENT)
>  			continue;
>  
> -		if (SAS_ADDR(phy->attached_sas_addr) ==
> -		    SAS_ADDR(child->sas_addr)) {
> -
> +		if (sas_phy_match_dev_addr(child, phy)) {
>  			child->min_linkrate = min(parent->min_linkrate,
>  						  phy->linkrate);
>  			child->max_linkrate = max(parent->max_linkrate,
> @@ -1012,8 +1010,7 @@ static int sas_ex_discover_dev(struct domain_device *dev, int phy_id)
>  		sas_add_parent_port(dev, phy_id);
>  		return 0;
>  	}
> -	if (dev->parent && (SAS_ADDR(ex_phy->attached_sas_addr) ==
> -			    SAS_ADDR(dev->parent->sas_addr))) {
> +	if (dev->parent && sas_phy_match_dev_addr(dev->parent, ex_phy)) {
>  		sas_add_parent_port(dev, phy_id);
>  		if (ex_phy->routing_attr == TABLE_ROUTING)
>  			sas_configure_phy(dev, phy_id, dev->port->sas_addr, 1);
> @@ -1312,7 +1309,7 @@ static int sas_check_parent_topology(struct domain_device *child)
>  		    parent_phy->phy_state == PHY_NOT_PRESENT)
>  			continue;
>  
> -		if (SAS_ADDR(parent_phy->attached_sas_addr) != SAS_ADDR(child->sas_addr))
> +		if (sas_phy_match_dev_addr(child, parent_phy))

This changes the test. This should be:

		if (!sas_phy_match_dev_addr(child, parent_phy))

No ?

>  			continue;
>  
>  		child_phy = &child_ex->ex_phy[parent_phy->attached_phy_id];
> @@ -1522,8 +1519,7 @@ static int sas_configure_parent(struct domain_device *parent,
>  		struct ex_phy *phy = &ex_parent->ex_phy[i];
>  
>  		if ((phy->routing_attr == TABLE_ROUTING) &&
> -		    (SAS_ADDR(phy->attached_sas_addr) ==
> -		     SAS_ADDR(child->sas_addr))) {
> +		    sas_phy_match_dev_addr(child, phy)) {
>  			res = sas_configure_phy(parent, i, sas_addr, include);
>  			if (res)
>  				return res;
> @@ -1858,8 +1854,7 @@ static void sas_unregister_devs_sas_addr(struct domain_device *parent,
>  	if (last) {
>  		list_for_each_entry_safe(child, n,
>  			&ex_dev->children, siblings) {
> -			if (SAS_ADDR(child->sas_addr) ==
> -			    SAS_ADDR(phy->attached_sas_addr)) {
> +			if (sas_phy_match_dev_addr(child, phy)) {
>  				set_bit(SAS_DEV_GONE, &child->state);
>  				if (dev_is_expander(child->dev_type))
>  					sas_unregister_ex_tree(parent->port, child);
> @@ -1941,8 +1936,7 @@ static int sas_discover_new(struct domain_device *dev, int phy_id)
>  	if (res)
>  		return res;
>  	list_for_each_entry(child, &dev->ex_dev.children, siblings) {
> -		if (SAS_ADDR(child->sas_addr) ==
> -		    SAS_ADDR(ex_phy->attached_sas_addr)) {
> +		if (sas_phy_match_dev_addr(child, ex_phy)) {
>  			if (dev_is_expander(child->dev_type))
>  				res = sas_discover_bfs_by_root(child);
>  			break;

-- 
Damien Le Moal
Western Digital Research

