Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A78EC433F5
	for <linux-scsi@archiver.kernel.org>; Sun, 17 Apr 2022 23:23:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235366AbiDQXZx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 17 Apr 2022 19:25:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231848AbiDQXZw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 17 Apr 2022 19:25:52 -0400
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2E0D065B6
        for <linux-scsi@vger.kernel.org>; Sun, 17 Apr 2022 16:23:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1650237795; x=1681773795;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=hWIpmZ3BWnWdnzFQGJ2a39vEYRHB//6KS+SOKFcj3Sc=;
  b=LN1Ib3SebzCz035TK9oUpiW3LiL69sVYRu4mcyrS0Y/qSu6Fold2h+QW
   pC6ZHuWcXGoBS2BwHPRDIq8e0ZjE6TcJqKyBIiFB4Kp4FY5DKQ3ixBobD
   0y2gUzQV4YMarQKAQmTt4Rv5ZVYNs4NUgWhngwxERzae/rRB3+WShg0YB
   zlq/t9EA9i6PBY7vD2u5adF+sknTWaN2tuK8fMU2rzr+OK8gHpVAxd3m2
   O0PUAfjyqdo1UimSm9D808Nx0YNFmaTfDhzSny9AwCPKTvwhojsdMsrrN
   nikdogsjoyCznOBNLE3R3bIthkK0Z5Ahdlh/9TpDJRFGG4OJwBvORsFk7
   Q==;
X-IronPort-AV: E=Sophos;i="5.90,267,1643644800"; 
   d="scan'208";a="196976579"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 18 Apr 2022 07:23:15 +0800
IronPort-SDR: sSezPNuZnjswo60QvP5nDShNb+mjHOwxl3X6ZcRQYQnbyRp/oZP3BtLfO99KXh5+DB3Wq8DUxw
 ulDBrRo0N0U9Yfi7PcM9HkJOiK799poiB7Y59I86Ke25/R32LZITaiLo5spZrgrlngwb3eUy/r
 w4QMKTCkRaewaGl/nWu7UNNJR8DVOgyMAZrAc66bbEZtnIS6/djH0z5AGXdQ5VshCrBE9tdyxo
 uud4n/5f49xl7+d9Kb3HQyhqOKUhRyU6FAFPcGym59TN8x6x4804n+9v/+CpIv0AczsKo9ZCC4
 S/LZlZcTEyozLaTsHhI7hWy5
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 17 Apr 2022 15:53:37 -0700
IronPort-SDR: diMqVou3qqMKNUt94MESzS1rYl6CuLM4g1IegEEzIZct3qn/++AEYJjqha8EHjColkf0TmQToh
 6ge4gtvRAIFBm/8t7rfyixinO2gjr6Z6fYQk3nDjMhB12zYPYl72Enm441SSo+whzbxQQKFJfU
 k67Xqr8cAxWo37igqionez+LgcYqHzYldIl8o9AU8Vs+24JPT8lk/M1hcBY+Cp4FzJu7c3HTv/
 xklJQhR6+VHBf3TkryrTB82yr14iebHftVnZWr2C71Sbm6ML/t79lkH853P2q+z1mDhX02FT5d
 a58=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 17 Apr 2022 16:23:16 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4KhR2C2zvgz1SVny
        for <linux-scsi@vger.kernel.org>; Sun, 17 Apr 2022 16:23:15 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1650237794; x=1652829795; bh=hWIpmZ3BWnWdnzFQGJ2a39vEYRHB//6KS+S
        OKFcj3Sc=; b=U6A13PoYWg8jYvWQE2FyuYSbIegeLped957LTp0AxpBnpeAvRRs
        hTSBSHFlGFl5EmR71swbHIDuU2xpJwq9UfpAtrJ6xwDSaucFJDOP36/RanTJz+hn
        ewAy8sJcgBMbOhy0LFDcgYwK0pmlqgCCF80fOmPpWZcVXbU1y4RWmEtSdt+sv0uV
        X01WHfroWwlLm/R5banLBL71TrN9GUNfXxb1ZW5NKQuItD+1QiHCuBQDujunKsHl
        923gS75pUiYBftPu4hsBjUIP1RLWC78FpHmnnncnqnVxKBgCF5+CyIN2XPZEnkvY
        PZdJPF0fZcL16MVwfXk5fw/pWB7vSpyvqzw==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id OoIFoNOMkAKQ for <linux-scsi@vger.kernel.org>;
        Sun, 17 Apr 2022 16:23:14 -0700 (PDT)
Received: from [10.225.163.14] (unknown [10.225.163.14])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4KhR29701Qz1Rvlx;
        Sun, 17 Apr 2022 16:23:13 -0700 (PDT)
Message-ID: <8de7ab41-9efd-c6f8-c7f3-170f1037f705@opensource.wdc.com>
Date:   Mon, 18 Apr 2022 08:23:12 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH 6/8] scsi_debug: Fix a typo
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, Hannes Reinecke <hare@suse.de>,
        Shaun Tancheff <shaun.tancheff@seagate.com>,
        linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20220415201752.2793700-1-bvanassche@acm.org>
 <20220415201752.2793700-7-bvanassche@acm.org>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220415201752.2793700-7-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/16/22 05:17, Bart Van Assche wrote:
> Change a single occurrence of "nad" into "and".
> 
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>  drivers/scsi/scsi_debug.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/scsi_debug.c b/drivers/scsi/scsi_debug.c
> index c607755cce00..7cfae8206a4b 100644
> --- a/drivers/scsi/scsi_debug.c
> +++ b/drivers/scsi/scsi_debug.c
> @@ -4408,7 +4408,7 @@ static int resp_verify(struct scsi_cmnd *scp, struct sdebug_dev_info *devip)
>  
>  #define RZONES_DESC_HD 64
>  
> -/* Report zones depending on start LBA nad reporting options */
> +/* Report zones depending on start LBA and reporting options */
>  static int resp_report_zones(struct scsi_cmnd *scp,
>  			     struct sdebug_dev_info *devip)
>  {

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

-- 
Damien Le Moal
Western Digital Research
