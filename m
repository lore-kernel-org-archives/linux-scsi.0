Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9E636C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Feb 2022 09:54:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239285AbiBYJyt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Feb 2022 04:54:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239280AbiBYJys (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Feb 2022 04:54:48 -0500
Received: from frasgout.his.huawei.com (frasgout.his.huawei.com [185.176.79.56])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 935DC26148B
        for <linux-scsi@vger.kernel.org>; Fri, 25 Feb 2022 01:54:16 -0800 (PST)
Received: from fraeml734-chm.china.huawei.com (unknown [172.18.147.207])
        by frasgout.his.huawei.com (SkyGuard) with ESMTP id 4K4lTF1Vh7z67RHv;
        Fri, 25 Feb 2022 17:53:21 +0800 (CST)
Received: from lhreml724-chm.china.huawei.com (10.201.108.75) by
 fraeml734-chm.china.huawei.com (10.206.15.215) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2308.21; Fri, 25 Feb 2022 10:54:13 +0100
Received: from [10.47.84.151] (10.47.84.151) by lhreml724-chm.china.huawei.com
 (10.201.108.75) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id 15.1.2308.21; Fri, 25 Feb
 2022 09:54:12 +0000
Message-ID: <d879dee5-e3b2-3dfa-a7b9-ee4ac7b4aa05@huawei.com>
Date:   Fri, 25 Feb 2022 09:54:11 +0000
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.1
Subject: Re: [PATCH] scsi: libsas: cleanup sas_form_port()
To:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        "Jason Yan" <yanaijie@huawei.com>
References: <20220225055621.410896-1-damien.lemoal@opensource.wdc.com>
From:   John Garry <john.garry@huawei.com>
In-Reply-To: <20220225055621.410896-1-damien.lemoal@opensource.wdc.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.47.84.151]
X-ClientProxiedBy: lhreml737-chm.china.huawei.com (10.201.108.187) To
 lhreml724-chm.china.huawei.com (10.201.108.75)
X-CFilter-Loop: Reflected
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 25/02/2022 05:56, Damien Le Moal wrote:
> Sparse throws a warning about context imbalance ("different lock
> contexts for basic block") in sas_form_port() as it gets confused with
> the fact that a port is locked within one of the 2 search loop and
> unlocked afterward outside of the search loops once the phy is added to
> the port. Since this code is not easy to follow, improve it by factoring
> out the code adding the phy to the port once the port is locked into the
> helper function __sas_form_port(). This helper can then be called
> directly within the port search loops, avoiding confusion and clearing
> the sparse warning.
> 
> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> ---
>   drivers/scsi/libsas/sas_port.c | 76 ++++++++++++++++++++--------------
>   1 file changed, 45 insertions(+), 31 deletions(-)
> 
> diff --git a/drivers/scsi/libsas/sas_port.c b/drivers/scsi/libsas/sas_port.c
> index 67b429dcf1ff..90bd1666f888 100644
> --- a/drivers/scsi/libsas/sas_port.c
> +++ b/drivers/scsi/libsas/sas_port.c
> @@ -67,6 +67,39 @@ static void sas_resume_port(struct asd_sas_phy *phy)
>   	sas_discover_event(port, DISCE_RESUME);
>   }
>   
> +static struct domain_device *__sas_form_port(struct asd_sas_port *port,
> +					     struct asd_sas_phy *phy,
> +					     bool wideport)

How about a more obvious name, like "sas_form_port_add_phy()"?

And returning a domain_device is strange. We don't assign/evaluate that 
in this function. Instead I think that you may just use port->port_dev 
outside later, right?

> +{
> +	struct domain_device *port_dev = port->port_dev;
> +
> +	list_add_tail(&phy->port_phy_el, &port->phy_list);
> +	sas_phy_set_target(phy, port_dev);
> +	phy->port = port;
> +	port->num_phys++;
> +	port->phy_mask |= (1U << phy->id);

nit: no need for ()

> +
> +	if (wideport)
> +		pr_debug("phy%d matched wide port%d\n", phy->id,
> +			 port->id);
> +	else
> +		memcpy(port->sas_addr, phy->sas_addr, SAS_ADDR_SIZE);
> +
> +	if (*(u64 *)port->attached_sas_addr == 0) {
> +		port->class = phy->class;
> +		memcpy(port->attached_sas_addr, phy->attached_sas_addr,
> +		       SAS_ADDR_SIZE);
> +		port->iproto = phy->iproto;
> +		port->tproto = phy->tproto;
> +		port->oob_mode = phy->oob_mode;
> +		port->linkrate = phy->linkrate;
> +	} else {
> +		port->linkrate = max(port->linkrate, phy->linkrate);
> +	}
> +
> +	return port_dev;
> 
Thanks,
John
