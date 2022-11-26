Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9811C4321E
	for <linux-scsi@archiver.kernel.org>; Sat, 26 Nov 2022 02:35:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229958AbiKZCfo (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 25 Nov 2022 21:35:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34888 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229953AbiKZCfn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 25 Nov 2022 21:35:43 -0500
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 607513F042
        for <linux-scsi@vger.kernel.org>; Fri, 25 Nov 2022 18:35:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1669430142; x=1700966142;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=JNCi3LJwfinnZKzD9y0LmfbvVSPVLhyEvFpV8dzXlKU=;
  b=j8LKbooAZWvedZKc+/QV/942s7yIFqMbYTUTbwrrtx7HfaIkabPbwYMr
   /hRsmfUOJC4s4coyJGqflyu6ZpTo+iJ5raPLxKhQgJbj7La/oaaGPRBsf
   DsfM5dGtNtzVpjBeYoHxNytcw5vn1ikkonPOmOowdWM9E68/jz6c51e6b
   4lTitJdP8NrmpNFPctWRfwT98MHVfZ/kUc0zoMW06stZlL5LtWdMsTXXP
   jIvovQpREvSOOVNEQkfK+b44YAfAQj+wT9iuz5nwaEsWpyECiqsl3d2dc
   +8jKZjmrmawYJ7AfTN0RvKcZVlXWqqzQYDUz/MvOdtXwRwj3xde1nTaq5
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,194,1665417600"; 
   d="scan'208";a="215450031"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 26 Nov 2022 10:35:41 +0800
IronPort-SDR: 8GEF3PT4KU2bu3L/GUcrAZ6dyWE4l2/Z2HMQQB8cHBgmlypRBwuyrThLyuuu0GHRsfnX7eke4m
 botvyE9IUipq88ly6fJrnQD/edYKGbpshUcq/2n83M6dD2YgETwCY/M21Fd916BNNxOt+LjUKu
 LmjuV6bxBALhbTAqHwLgMd740xr3nFwcgcSdWtTP6eXi/pcOWxPimelsewzG6aRicx+6DCKyS4
 6mwpPkDFPZxc688wtjVAkVkqkaOJti/DCPiOAQ7Pxxe+Xvio3WjM8vqVagV/7hjXf50+SGsgzi
 Dqs=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 25 Nov 2022 17:48:41 -0800
IronPort-SDR: NweZl51PEMNYIWIDzfyM8P1lsxci6w87edUqbR94oDjE+I8v/Cf7mBQC68c0D84u3D7QzHCKRo
 dNvhs+HoSdquF0vzV+6KzeEtwEf1C2ZW4W6HmYBFKRKukHqYeG2Z6im4FrLoLoGvlOqSQdiyDK
 GZLWzeiAX14rmZcQ3BjWVwJEgbZfUB+palGQkFSu49gsk5IVwoggHXAxpO82jwQlHtEXtlBcwO
 SMdjOWICkbxkBDSSic9CoVMJst+bGOUqU9mSuaMHexu81bjzhLwGDM9JntfaGPROTDM0GsGKMU
 62s=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 25 Nov 2022 18:35:41 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4NJwnn1t4zz1RvTp
        for <linux-scsi@vger.kernel.org>; Fri, 25 Nov 2022 18:35:41 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1669430140; x=1672022141; bh=JNCi3LJwfinnZKzD9y0LmfbvVSPVLhyEvFp
        V8dzXlKU=; b=KaH6c1zurSp45XL40cO1gQU9DIBRtkyfX7OJNc5KB2QwzU8Yk7A
        kwEjTO/VVM6faxeb1kNEDx5LEeyPHe6vpC45L6w22P6UYcW1oYt+euW4P+zWvqa9
        JDunmygcRPcN5+3Yip63GHCt/S76ql3SzukzD0rgtx8KwnLbcQXwdJCjE9mvwq4p
        WoS3wHII9NJQLdhak9eguWHS+egF+K2APJ4ySn8oKP6D5xTDlORk80SubUxa9FkW
        PnE36Q1ydvkpjGOQoJD46Ql37R/biYt5AQbiDR/RGfp0HaAsi/RvJiN8O55vEYpI
        u6nQYqVt1kR4gDd9G9NcIMrNx/CEkrIMt0Q==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 3d7F4PVNo2ar for <linux-scsi@vger.kernel.org>;
        Fri, 25 Nov 2022 18:35:40 -0800 (PST)
Received: from [10.225.163.56] (unknown [10.225.163.56])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4NJwnl67ddz1RvLy;
        Fri, 25 Nov 2022 18:35:39 -0800 (PST)
Message-ID: <969cf476-d732-9566-63e4-01fb23fa74fe@opensource.wdc.com>
Date:   Sat, 26 Nov 2022 11:35:38 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v2] scsi: sd_zbc: trace zone append emulation
Content-Language: en-US
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Johannes Thumshirn <Johannes.Thumshirn@wdc.com>
Cc:     kernel test robot <lkp@intel.com>,
        "oe-kbuild-all@lists.linux.dev" <oe-kbuild-all@lists.linux.dev>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        Hannes Reinecke <hare@suse.de>
References: <6a21e78a188e5a0d630acd771afee11c7d45d183.1668427228.git.johannes.thumshirn@wdc.com>
 <202211151344.VGP4HoGU-lkp@intel.com>
 <7c758dc6-692c-3aeb-a0de-05e4134f839f@wdc.com>
 <yq1h6ymo3wp.fsf@ca-mkp.ca.oracle.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <yq1h6ymo3wp.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/26/22 11:18, Martin K. Petersen wrote:
> 
> Johannes,
> 
>>>>> ERROR: modpost: "__tracepoint_scsi_prepare_zone_append" [drivers/scsi/sd_mod.ko] undefined!
>>>>> ERROR: modpost: "__SCK__tp_func_scsi_prepare_zone_append" [drivers/scsi/sd_mod.ko] undefined!
>>>>> ERROR: modpost: "__SCK__tp_func_scsi_zone_wp_update" [drivers/scsi/sd_mod.ko] undefined!
>>>>> ERROR: modpost: "__SCT__tp_func_scsi_zone_wp_update" [drivers/scsi/sd_mod.ko] undefined!
>>>>> ERROR: modpost: "__tracepoint_scsi_zone_wp_update" [drivers/scsi/sd_mod.ko] undefined!
>>>>> ERROR: modpost: "__SCT__tp_func_scsi_prepare_zone_append" [drivers/scsi/sd_mod.ko] undefined!
>>>
>>
>> I have no clue what modpost is trying to tell me here. These tracepoints aren't
>> in any way different to the other tracepoints in SCSI.
> 
> Haven't investigated. But I get the same errors building scsi-staging
> with your patch applied. Builds fine without it. gcc 12.1.
> 

This is missing:

diff --git a/drivers/scsi/scsi_trace.c b/drivers/scsi/scsi_trace.c
index 41a950075913..224b38c0fb0f 100644
--- a/drivers/scsi/scsi_trace.c
+++ b/drivers/scsi/scsi_trace.c
@@ -389,3 +389,4 @@ scsi_trace_parse_cdb(struct trace_seq *p, unsigned
char *cdb, int len)
                return scsi_trace_misc(p, cdb, len);
        }
 }
+EXPORT_SYMBOL(scsi_trace_parse_cdb);
diff --git a/drivers/scsi/sd_zbc.c b/drivers/scsi/sd_zbc.c
index 956d1982c51b..e7a0e1ace6d0 100644
--- a/drivers/scsi/sd_zbc.c
+++ b/drivers/scsi/sd_zbc.c
@@ -18,6 +18,7 @@
 #include <scsi/scsi.h>
 #include <scsi/scsi_cmnd.h>

+#define CREATE_TRACE_POINTS
 #include <trace/events/scsi.h>

 #include "sd.h"

With that, it compiles fine.

-- 
Damien Le Moal
Western Digital Research

