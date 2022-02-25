Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47221C433EF
	for <linux-scsi@archiver.kernel.org>; Fri, 25 Feb 2022 10:49:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239811AbiBYKuU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Feb 2022 05:50:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233863AbiBYKuT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Feb 2022 05:50:19 -0500
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF91223533C
        for <linux-scsi@vger.kernel.org>; Fri, 25 Feb 2022 02:49:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1645786187; x=1677322187;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=fkslOx6VV8zbWt6pzpj5x35APOoH4cYCL5WZd3OealI=;
  b=prNZhur5wCuYJ2TXQIyBaSxrX6l2QKU7vjU1oCu1fjnD9inp+Y9ZJtfi
   LmtG7+ESxPvdJnPewSCsa2V9BU7bFZhSbfZB64snumm9GyZHnWb6KEwDB
   QhtOflQMUj6Dfu7d3bNGOdESYg+ASSk9I/KHnOWkBO6xI+KDhSmV1NstA
   dNSEijZH6RaxMVtcVQ28PFd6CMGjdE4VXyBXJ335G9okduPwZAcPRcIwq
   ew1RlyiGjJxy06MsbBoXb/Hgad9PQkdqYCjEaeI+IB+1w4TlGiuzwJ5oj
   rNIlcGgFeA7d9ndE2pf827VCRd+3RLjuB210ZQi0aEe1Vc+pNztYHBViS
   g==;
X-IronPort-AV: E=Sophos;i="5.90,136,1643644800"; 
   d="scan'208";a="192861362"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 25 Feb 2022 18:49:47 +0800
IronPort-SDR: Sw6BRSoqReR1+wtVpsvXv7k9nC3g5CJ7klStafjsH55KovfaYDaoizT1zDcAnTRnlHxYAe8EJq
 LmGZ00XUSynro5oTUtWtMJALfBmweAWKmeuyT0z0wIzt872MSm9shzR1P2Ob8SYtHhG1ecV4rf
 L7W8v6FPVkt4KGzgcG5BvzngGCJrjrwcVieNJQl26+KHabxtXaoEnuI8Byc6fOaCOYRfFKQnDs
 rTn6GKj2MNem4QBY9T0J1BJhlBMq0YOaKn2S+45xWLAou5lVbBji3/tQdAyS+41CLkKN6PxX1P
 MF3q9lhFIXUFyhnlhd1aJJk/
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2022 02:21:16 -0800
IronPort-SDR: 8auC0pJlUsd0ttIAGVCFQtVK/uUmlqTVwhaPo2TgfBgGQ/NMjGXSdgWgz6BFKoyA7cT05yxDSn
 /8asaoxFRX45l8/nhKOrg3t45EJdHrTm8nTBnY7GmFbZaGLGpV3FH+PRbRpY+E4fHXTqVmzOYR
 hO+BJRi+yd8+m7x9UAK6dJELQLpjE9KYFnp5GgD8i0RGClu2iY0F1fmvjvaniXtjEs/WPCnde9
 EI2K08lhe7l160VI7qOhGHpHEybfbFpgiNwIfJJIsQXtID+pC7kU3gx6Ow51BFnEXGdxhZ8rnj
 ZxA=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 25 Feb 2022 02:49:48 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4K4mkL6r77z1SHwl
        for <linux-scsi@vger.kernel.org>; Fri, 25 Feb 2022 02:49:46 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1645786186; x=1648378187; bh=fkslOx6VV8zbWt6pzpj5x35APOoH4cYCL5W
        Zd3OealI=; b=W6hppHdTtBrzrkMuE8Xk6IsZ4P8EeDIHmw22EQ3sRm8C5CP6Qwe
        Pwkl5ju9W0T+SSaalWUHQHERdVgep4v0gVZciWp65/TjGkF6xcwM26RdyARHFGCv
        UHJYgBYyDnlAVn1Y3wWkRqo+fp5I9h6lu5X6q27aOe2m/kQB9jmOK5sxBUoXYCU5
        Nc3b3sMc/Afk4gKip2qztlXo9DDNxlDuPBdiE11sd/tpFgeI4G1/T9+HbRYI/1Ym
        P36+/Au3vHyWpG6NyzTQuQPM7OYXT5LWw2/fYXjTjobQsArarL19sDuUssO90IKe
        DXuWLbAzdKCcOsi3n4NnIcNwfYBQTYkYG4Q==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id gW4-Vbq7KAZj for <linux-scsi@vger.kernel.org>;
        Fri, 25 Feb 2022 02:49:46 -0800 (PST)
Received: from [10.225.163.81] (unknown [10.225.163.81])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4K4mkK2b3xz1Rvlx;
        Fri, 25 Feb 2022 02:49:45 -0800 (PST)
Message-ID: <c79ef1ac-da29-81ad-ac3e-7058b94cc82e@opensource.wdc.com>
Date:   Fri, 25 Feb 2022 19:49:44 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH] scsi: libsas: cleanup sas_form_port()
Content-Language: en-US
To:     John Garry <john.garry@huawei.com>, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Jason Yan <yanaijie@huawei.com>
References: <20220225055621.410896-1-damien.lemoal@opensource.wdc.com>
 <d879dee5-e3b2-3dfa-a7b9-ee4ac7b4aa05@huawei.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <d879dee5-e3b2-3dfa-a7b9-ee4ac7b4aa05@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/25/22 18:54, John Garry wrote:
> On 25/02/2022 05:56, Damien Le Moal wrote:
>> Sparse throws a warning about context imbalance ("different lock
>> contexts for basic block") in sas_form_port() as it gets confused with
>> the fact that a port is locked within one of the 2 search loop and
>> unlocked afterward outside of the search loops once the phy is added to
>> the port. Since this code is not easy to follow, improve it by factoring
>> out the code adding the phy to the port once the port is locked into the
>> helper function __sas_form_port(). This helper can then be called
>> directly within the port search loops, avoiding confusion and clearing
>> the sparse warning.
>>
>> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
>> ---
>>   drivers/scsi/libsas/sas_port.c | 76 ++++++++++++++++++++--------------
>>   1 file changed, 45 insertions(+), 31 deletions(-)
>>
>> diff --git a/drivers/scsi/libsas/sas_port.c b/drivers/scsi/libsas/sas_port.c
>> index 67b429dcf1ff..90bd1666f888 100644
>> --- a/drivers/scsi/libsas/sas_port.c
>> +++ b/drivers/scsi/libsas/sas_port.c
>> @@ -67,6 +67,39 @@ static void sas_resume_port(struct asd_sas_phy *phy)
>>   	sas_discover_event(port, DISCE_RESUME);
>>   }
>>   
>> +static struct domain_device *__sas_form_port(struct asd_sas_port *port,
>> +					     struct asd_sas_phy *phy,
>> +					     bool wideport)
> 
> How about a more obvious name, like "sas_form_port_add_phy()"?
> 
> And returning a domain_device is strange. We don't assign/evaluate that 
> in this function. Instead I think that you may just use port->port_dev 
> outside later, right?

OK. Will send V2. Thanks for the review.

> 
>> +{
>> +	struct domain_device *port_dev = port->port_dev;
>> +
>> +	list_add_tail(&phy->port_phy_el, &port->phy_list);
>> +	sas_phy_set_target(phy, port_dev);
>> +	phy->port = port;
>> +	port->num_phys++;
>> +	port->phy_mask |= (1U << phy->id);
> 
> nit: no need for ()
> 
>> +
>> +	if (wideport)
>> +		pr_debug("phy%d matched wide port%d\n", phy->id,
>> +			 port->id);
>> +	else
>> +		memcpy(port->sas_addr, phy->sas_addr, SAS_ADDR_SIZE);
>> +
>> +	if (*(u64 *)port->attached_sas_addr == 0) {
>> +		port->class = phy->class;
>> +		memcpy(port->attached_sas_addr, phy->attached_sas_addr,
>> +		       SAS_ADDR_SIZE);
>> +		port->iproto = phy->iproto;
>> +		port->tproto = phy->tproto;
>> +		port->oob_mode = phy->oob_mode;
>> +		port->linkrate = phy->linkrate;
>> +	} else {
>> +		port->linkrate = max(port->linkrate, phy->linkrate);
>> +	}
>> +
>> +	return port_dev;
>>
> Thanks,
> John


-- 
Damien Le Moal
Western Digital Research
