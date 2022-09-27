Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E1568C07E9D
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Sep 2022 04:25:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229914AbiI0EZ2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 27 Sep 2022 00:25:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229869AbiI0EZY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Sep 2022 00:25:24 -0400
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD58F5E54B
        for <linux-scsi@vger.kernel.org>; Mon, 26 Sep 2022 21:25:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1664252723; x=1695788723;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ZX5ScZxEDRRPrjPNxZCwWnXDrfGgHDWgIXxYCuy/rXg=;
  b=Lm2pFxaGs2u9yrRjKoDbhxfS29Ld/rrnje7q+aZZyGq6vm7HVIbb52Yq
   eMwgVpgoApwwOF/hp1iZxkd9FqjJ1wz0LRifW9dq/AYdL5hhOWJUtg8I4
   U3wNVc5PaJihuXqlYI/IY8VzloGlNJ4SFiF9WLckAPmHJg4gtR4H9JM7Y
   CwmRt4N2+InoCsvobbfTr+m3ywMui5dm06wTWZBzq2Zta3x0QUBe0JPeL
   6bCGhe9YiG9Sjcn8hkPOg/GnIJmU+SLhx/UP/yZ9xqlZNlF4ZDbWKf1Xz
   lg1c1c38A18RSiy1PRCcMK81bdBgt3j2y4ybTAPhHlXm0LudySSP4+xN+
   Q==;
X-IronPort-AV: E=Sophos;i="5.93,348,1654531200"; 
   d="scan'208";a="212767270"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 27 Sep 2022 12:25:21 +0800
IronPort-SDR: RjY3t1Hk29hH1UZ/hkvpdZAlfndeJxncPHxynlfA2fYbtii3GQ/fu65ZkxhgGm0PS5BddK1SOk
 b/q4pwOJbSTeuk40SM+tzvwE2b6hlh0SGttyVx2N7CoV30q4c4OqVBP72RTuS8mLga55vXxSKy
 pBufPkwrJ7FhUYUe/MRfsK266Z2i1Xxcb/uHEOPX+Elzx2OkqD4iFb2fj+qxnzytT8yCMzdjh9
 Gdd9FJd+JtyPKI96qVjltK/oXrRWj5NRtRYzIv67MCq5+siFZ/3G+sTjwuIpowxeezeSagqPN1
 i09+OGigxIoBWGgDGnUSZGLk
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 26 Sep 2022 20:39:47 -0700
IronPort-SDR: 2FC50JPO3l6VSDFwO1hRtL2/5mgoZ7A5PDB696AMZcXiF1x3vhP3QMOcWkI/XniD7KKJvUE72g
 PCAUKYuBzqfjR13fCjAHTLMFM4PWlBarbyHxZTu0Ayp+AeRVoxlFVr53Oull8em7QtYryJb8/q
 M+Vk2g1bj07fBsaTwc4t0AYpKwpsbh21EQHTVMWqoBd1V1wz2RgP42UHESO/xbko4a+LEKeMok
 E3zaGAmSclZgJFwB5KS4zk9Fn3EeGAfR44NeAzj5ZicEzy6R4eDw4wsPaCfrKCIIuxJQmgt31w
 glU=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 26 Sep 2022 21:25:20 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Mc6402Yqpz1RwtC
        for <linux-scsi@vger.kernel.org>; Mon, 26 Sep 2022 21:25:20 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1664252719; x=1666844720; bh=ZX5ScZxEDRRPrjPNxZCwWnXDrfGgHDWgIXx
        YCuy/rXg=; b=qKcD8V6JDfpnkoO3PsUh3Du4DG9rH0NqQ6dUoy1OZ2H/GiQeOT8
        hvXeSzgbCTncSgvaGXU1dUsK6hFS7kg+zuop3RZGlhFelr8xnmpSiHmkC6JGsRoo
        WUqH+SFVWLH7HkNFmfvDuJ+J3MxBAuifozjHljJhdCDOdcAYP24q3Q1B4w89SyUH
        5LOydn75D5hsl2H6aMB4Rz+jUo8hazkr5dnAt114VizOyI4S1kRqVoiKE0+ULE9K
        nMsKo+0d0iATQO/FMv2A3AdZEqoQA9lB1VXUdwPMh/GlBzIMFureK0bSgh9c7ovS
        6WDSAKq3fsqF+sfYGRn7mIuNoVLJIuVTiBA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id ONbMmrIJ0nB6 for <linux-scsi@vger.kernel.org>;
        Mon, 26 Sep 2022 21:25:19 -0700 (PDT)
Received: from [10.225.163.91] (unknown [10.225.163.91])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Mc63x6bkyz1RvLy;
        Mon, 26 Sep 2022 21:25:17 -0700 (PDT)
Message-ID: <390e2a2f-c54e-69f6-a0fd-27e00adcf214@opensource.wdc.com>
Date:   Tue, 27 Sep 2022 13:25:16 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH v4 6/8] scsi: libsas: use sas_phy_match_dev_addr() instead
 of open coded
Content-Language: en-US
To:     Jason Yan <yanaijie@huawei.com>, martin.petersen@oracle.com,
        jejb@linux.ibm.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        hare@suse.com, hch@lst.de, bvanassche@acm.org,
        john.garry@huawei.com, jinpu.wang@cloud.ionos.com
References: <20220927032605.78103-1-yanaijie@huawei.com>
 <20220927032605.78103-7-yanaijie@huawei.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220927032605.78103-7-yanaijie@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/27/22 12:26, Jason Yan wrote:
> The sas address comparison of domain device and expander phy is open
> coded. Now we can replace it with sas_phy_match_dev_addr().
> 
> Signed-off-by: Jason Yan <yanaijie@huawei.com>

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

> ---
>  drivers/scsi/libsas/sas_expander.c | 18 ++++++------------
>  1 file changed, 6 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
> index df5a64ad902f..06efdfc11d2e 100644
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
> +		if (!sas_phy_match_dev_addr(child, parent_phy))
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

