Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B38D5C433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  6 Apr 2022 16:31:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237556AbiDFQdF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 6 Apr 2022 12:33:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238170AbiDFQct (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Apr 2022 12:32:49 -0400
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3927DD44
        for <linux-scsi@vger.kernel.org>; Tue,  5 Apr 2022 18:29:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1649208593; x=1680744593;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=vJXgKSZZcMrTRsd4WzB8fRzLIQjJjhTfDb97PbHj6V8=;
  b=aE/hoECLtXoH+LKwyw3xKiVrlGDY1yJvLdX1bzGHxE05JXDBHCfHnBiS
   DxHGMGmcr3wf883OKna1dltvrpMRfECNa2UShIV4aDN2M+j3yzQ2kxPNa
   oebdWmOr4+uaHz0UCwwGezPwMgcoPPmDzFA0p+fQy6jdUo9YRVH/uz9E+
   GZ0OUjTECMJmYkjiW7KY9DtAG3Lt3i+Y8+FVm450TfS+L0K8kW0JuHaPP
   SOyFgXeIyC+Nemkhs98jmAmZW426q8bgG1xUNEwhAmRqXLKFRvPOBw0D9
   CvCQKSHQKmcLRk2/4qGji4Fr9BX+q19e62bqEc1U5za39aTzzUgW9TsFo
   w==;
X-IronPort-AV: E=Sophos;i="5.90,238,1643644800"; 
   d="scan'208";a="197192584"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 06 Apr 2022 09:29:53 +0800
IronPort-SDR: XVTtpc1GdCqe2jOJreHSAoDGUFIKcKmSu8mJEHcK62kPmxex+uasK9MTndn4pG0Gee9iVlsXaP
 0bZQaaOoQXEKGB0+Ba7v3GWMchaSefHEGk1hCo5dLZXB4WvnshKAnA92ufmOvJ/mogD3BPlYp/
 E4dp8stn2zWuo2LfTlwfG5beW+5Z5nClfAk0MzaV3OnRtQJUerRPHJThNKeTl/Hriq4jjmLsXV
 vMnGZutHfZYN5N6oneL9HStXSRg74gVDQv/czBx6JloS7+75JSGvorUim+ebaO/BazVrjAjiej
 1TEFEBCHUZ04NAZ3N+8BoKbj
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 05 Apr 2022 18:01:26 -0700
IronPort-SDR: 6kg+LlPS/hDi7F4Ih1r7+VrCBDbihzD3aS2Wtu8Hbhuu4H5tCFQQwLn+F75Kc5JUxmDA7PBkmA
 V/oi8nkAuNiZsFJom793QJkwtlVW9Ke55bINz/vlRekfU70tBZN/U2wQkLL8KzHfhUD0YjMKmv
 M2Sx0xTnU9QAvZ4sR6IjoLuz/sN9/US+5glAQ9R/S6YPd8wPyp0w3ZpAgt+jwN3HPDH214nyyS
 BDGKYDY3z5AuenJLds7kdkg64reAkFxmVTOjDGJVNoYaC88d+MABp54VtfQ9ntFLDMfXeD/w8G
 API=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 05 Apr 2022 18:29:54 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4KY6Pt1jv7z1Rwrw
        for <linux-scsi@vger.kernel.org>; Tue,  5 Apr 2022 18:29:54 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1649208593; x=1651800594; bh=vJXgKSZZcMrTRsd4WzB8fRzLIQjJjhTfDb9
        7PbHj6V8=; b=Bfx8nc2da03IVWazzwiFF59e5bGoAOje+yvExet7dJUWb+OdR3K
        g4Ivu/1Sdk7c4zy4NuLKD3CMGFLgN5shmeF/Iye+KCnr+TQBCk2ZN6519TKQUXSA
        5OzD5jW1gGeyi4MvT9Stn1HQBW/mO+Xd+vRMVzV0xRgEezQf6mzAMoMJTZBts5UY
        MBHKuQEoZuMAGltq5GGP1QAZU+cRTLAZBKFMkx7fz1lVaC+Vv90kEHXJJhpuSdqz
        3DX32iYg8nrocgV52LoLLFQBSIym1i+Mt+8vUhtZMOX5M+aNDpUQ/ZpfASmhiI9p
        4lDC02acq4geY5BYLaooKJ9MyjxF9dAaeww==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id Q-YY36OQ_qDo for <linux-scsi@vger.kernel.org>;
        Tue,  5 Apr 2022 18:29:53 -0700 (PDT)
Received: from [10.149.53.254] (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4KY6Ps16PRz1Rvlx;
        Tue,  5 Apr 2022 18:29:52 -0700 (PDT)
Message-ID: <45050814-f512-f764-007f-5fe52e224467@opensource.wdc.com>
Date:   Wed, 6 Apr 2022 10:29:51 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH 12/14] scsi: sd: sd_read_cpr() requires VPD pages
Content-Language: en-US
To:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
References: <20220302053559.32147-1-martin.petersen@oracle.com>
 <20220302053559.32147-13-martin.petersen@oracle.com>
 <fa37071c-3e68-9435-5f8b-6f3920e59ae1@wdc.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <fa37071c-3e68-9435-5f8b-6f3920e59ae1@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/2/22 19:45, Damien Le Moal wrote:
> On 2022/03/02 7:35, Martin K. Petersen wrote:
>> As such it should be called inside the scsi_device_supports_vpd()
>> conditional.
>>
>> Cc: Damien Le Moal <damien.lemoal@wdc.com>
>> Fixes: e815d36548f0 ("scsi: sd: add concurrent positioning ranges support")
>> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> 
> I thought this was already queued :)
> 
> Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

Martin,

I still do not see this patch in 5.18-rc1... Did it fell through the 
cracks ? It also needs cc stable...
See: https://bugzilla.kernel.org/show_bug.cgi?id=215788

> 
>> ---
>>   drivers/scsi/sd.c | 2 +-
>>   1 file changed, 1 insertion(+), 1 deletion(-)
>>
>> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
>> index 2c2e86738578..9d6b2205339d 100644
>> --- a/drivers/scsi/sd.c
>> +++ b/drivers/scsi/sd.c
>> @@ -3396,6 +3396,7 @@ static int sd_revalidate_disk(struct gendisk *disk)
>>   			sd_read_block_limits(sdkp);
>>   			sd_read_block_characteristics(sdkp);
>>   			sd_zbc_read_zones(sdkp, buffer);
>> +			sd_read_cpr(sdkp);
>>   		}
>>   
>>   		sd_print_capacity(sdkp, old_capacity);
>> @@ -3405,7 +3406,6 @@ static int sd_revalidate_disk(struct gendisk *disk)
>>   		sd_read_app_tag_own(sdkp, buffer);
>>   		sd_read_write_same(sdkp, buffer);
>>   		sd_read_security(sdkp, buffer);
>> -		sd_read_cpr(sdkp);
>>   		sd_config_write_same(sdkp);
>>   		sd_config_discard(sdkp, SD_LBP_DEFAULT);
>>   		sd_config_write_zeroes(sdkp, SD_ZERO_DEFAULT);
> 
> 


-- 
Damien Le Moal
Western Digital Research
