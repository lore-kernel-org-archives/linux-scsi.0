Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5348C07E9D
	for <linux-scsi@archiver.kernel.org>; Tue, 27 Sep 2022 02:32:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229832AbiI0CcS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 26 Sep 2022 22:32:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229729AbiI0CcM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 26 Sep 2022 22:32:12 -0400
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2877BE7E0E
        for <linux-scsi@vger.kernel.org>; Mon, 26 Sep 2022 19:32:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1664245929; x=1695781929;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=uJlTkEEruO+4B+/IkDjfWJ48o9FBDv2KefDND1Ujq5g=;
  b=OYqBm0/avBHiXI8NuyCO0/+3Sehwa40ITcriAZ1aGtfRDTQzLw2YwkbF
   aPHcTwMYLL7RoFXIsVbi8K04F/jH2Ra4RPlpwM59Bkh88/Kp9wmZwtn4y
   DmVZTXUfiCS0TxgtCB/hV8gUsBIsXwcDL9CER7soynP4dm9FJMzusirkY
   S3VFoqFdTSzkEqF4VeBimY4ULhaTKjDmWmopfRLqm3p/Ec7fRM+esgObT
   hhO+uQ/dYHOWTKqU51VyxFFcumYEPw6E4SpaHEqk+/06P+/E6VHscdZC+
   sj1iMAuqph/6TV148uby237/huvJv7V2uvhPeFvxu7ow9ToJzAbcaNzR8
   w==;
X-IronPort-AV: E=Sophos;i="5.93,347,1654531200"; 
   d="scan'208";a="210705103"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 27 Sep 2022 10:32:07 +0800
IronPort-SDR: qnHlrVSycRvJGYIH6X6GNS48uTRNIocCT6dKjH+N5ogpKr7F+txAM64RWvZRPLTN65fYdjxgVx
 ek4ZdfBcWJ7jrAmSV2dhmH2PwMvx63clOeB7NJsMBSDQfN8ogdAABgu8eC2XLPABxlyVkeB/Jf
 VhOVnFA1u//1eGl4KKLkTGh6yxPXTzHoqgbberM8NmaYvvikDjVtJoN3P8nOhPKhsMRLn8r9LF
 yCpGb51WXuNjivOc3BVhyk8CMXIeeaI7MZ9WX9dWkGWq/6y8eAouf0AnMDRFxAzVTkh4O8h1ON
 5fmgLOfcKl+UMD++nf6DWAI+
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 26 Sep 2022 18:46:33 -0700
IronPort-SDR: IN5uR3fpdJzFWNbJH4XKlDX2CSBdZiJ1dMwTH/C0qTn18rHrQW2Ppqi1xbVk3rjy5QobFXo5ib
 KwJVQye6mKKkoyOggLmvQsVyGD1sDDwxNvpzKj1gUY2SNsOMGwjKhlT+FDjg3YirkcXS634pU6
 PZyaGJOrvwF+qG+Im9a1u3g+Pgpl0EF97yyTaPF5d3jZgErSqzwMdxlbMUtscTY8e6MI03vaRI
 V9OioeCCbAmPAiY/7CGzgyILAFVFFNS7259/rt27ik1PSya7uSimQUnzhHIUW0WyybMuKif2kG
 S9o=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 26 Sep 2022 19:32:08 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Mc3YM3yxSz1RwtC
        for <linux-scsi@vger.kernel.org>; Mon, 26 Sep 2022 19:32:07 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1664245926; x=1666837927; bh=uJlTkEEruO+4B+/IkDjfWJ48o9FBDv2KefD
        ND1Ujq5g=; b=KVCh2SyQwM/mILMTWMFKyXTo4slhR6mNor1qTp/Zmwb9lIl1kJz
        HEsmkivvZ4h3nu9xJSOOIoV+vQ7+EYjL0JRhP47DY592d3HGTPym2ctGv7i4ja5c
        z5J/tRhJp4IAFGIrcGEPeIMKbG6nx6EtT4skz3IpD5tqRcmuiv5bRvISGYay9stZ
        t/pQDnC3DiDkgwOESqjxO3fTpqSlA56+7ROdoVpah0oSunQIng+hXf7PdROIuRjM
        U1S91gTUl+v7sWoFYy5S28quNWYWGjUsfhl8UfuF/Acy62aQjfCaU0cWgvjlUcHr
        Cpb5Wrrc9OjtzKvvvyCJV/1+waLjqYqUBxw==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id eAZ_X_b8Jru8 for <linux-scsi@vger.kernel.org>;
        Mon, 26 Sep 2022 19:32:06 -0700 (PDT)
Received: from [10.225.163.91] (unknown [10.225.163.91])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Mc3YK35Vpz1RvLy;
        Mon, 26 Sep 2022 19:32:05 -0700 (PDT)
Message-ID: <654fe6d2-4556-8d15-bacc-b6ee1e927d91@opensource.wdc.com>
Date:   Tue, 27 Sep 2022 11:32:04 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.0
Subject: Re: [PATCH v3 8/8] scsi: libsas: use sas_phy_match_port_addr()
 instead of open coded
Content-Language: en-US
To:     Jason Yan <yanaijie@huawei.com>, martin.petersen@oracle.com,
        jejb@linux.ibm.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        hare@suse.com, hch@lst.de, bvanassche@acm.org,
        john.garry@huawei.com, jinpu.wang@cloud.ionos.com
References: <20220927022941.4029476-1-yanaijie@huawei.com>
 <20220927022941.4029476-9-yanaijie@huawei.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220927022941.4029476-9-yanaijie@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/27/22 11:29, Jason Yan wrote:
> The sas address comparation of asd_sas_port and expander phy is open
> coded. Now we can replace it with sas_phy_match_port_addr().

Comparison typo again.

> 
> Signed-off-by: Jason Yan <yanaijie@huawei.com>

With that fixed,

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

> ---
>  drivers/scsi/libsas/sas_expander.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/libsas/sas_expander.c b/drivers/scsi/libsas/sas_expander.c
> index f268291b7584..eabc56966f36 100644
> --- a/drivers/scsi/libsas/sas_expander.c
> +++ b/drivers/scsi/libsas/sas_expander.c
> @@ -1005,8 +1005,7 @@ static int sas_ex_discover_dev(struct domain_device *dev, int phy_id)
>  	}
>  
>  	/* Parent and domain coherency */
> -	if (!dev->parent && (SAS_ADDR(ex_phy->attached_sas_addr) ==
> -			     SAS_ADDR(dev->port->sas_addr))) {
> +	if (!dev->parent && sas_phy_match_port_addr(dev->port, ex_phy)) {
>  		sas_add_parent_port(dev, phy_id);
>  		return 0;
>  	}

-- 
Damien Le Moal
Western Digital Research

