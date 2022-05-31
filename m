Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EA5CC433EF
	for <linux-scsi@archiver.kernel.org>; Tue, 31 May 2022 08:40:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240926AbiEaIkM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 31 May 2022 04:40:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242926AbiEaIj7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 31 May 2022 04:39:59 -0400
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8CBAD880E2
        for <linux-scsi@vger.kernel.org>; Tue, 31 May 2022 01:39:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1653986397; x=1685522397;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=2mZUXSGJvvFoPa0dzTvOCIF8z4EVn10NGrP311QJ8Mc=;
  b=DMggo7Js+LTq95wX3AWCUihfIevqaej1a11HDWzzcPrTZ1Zq38+pfJKV
   bI+SsTJ8H78aufEwTlxfwRchGdvUSR/q8hcwFWIXXlPtKOMGOYzwqROUx
   2l/INhORUrhsu37k+rE0Q6BGhz/tinKLgKKV3wCogmi86wu3la5lkVq5F
   ZlyJNF/a+bwhG3qL0+SggDxx1oYaoVH+ikFiGXAxP2VMjHUC3BQTGTaaD
   jr55p6Cda1pVgT1KPlIo5hLQNXpxSexEd/FbKAGt+3Lm0P22PDgg7GY00
   S9v+uf62hoVYTtcqG3xTic0L5iGvdTonDKmSPUCs7Z3Xw1g8/ElNX+7VX
   Q==;
X-IronPort-AV: E=Sophos;i="5.91,264,1647273600"; 
   d="scan'208";a="200625374"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 31 May 2022 16:39:56 +0800
IronPort-SDR: F58SAdtuKNl6x5Ag8cNIvxKyHg3aepDQSfv3hR+MBuH83E+oQNmDs9W3qKLrSOKdD0D42RZ+Gx
 W5A0u1o1NmMeQMp5hhGMs6P5l1rSqoqL3prnuDVugXjLvrMv/EBKHVxzd8XxrbLBtbPlzI6VGL
 M5/ivyKzJHrXSLScEdeKNc0/N3iKe14r+LwjUTC4wRUptT6fP5lITMONhqxc9HkhotrIGER9P8
 pS0N0Z6GBsu81ZDRwbulDGysArTOKQJ12ZcDuhY5bZr2qF6/OIY6c3jltv+XQWiSZ/bwYkH8+I
 4JcyqUCaqTRkCFFRTnVi3Q+N
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 31 May 2022 00:59:17 -0700
IronPort-SDR: 1ocADeze3X32AZj7cyBOWDVJp1XZE1uRTYMuYYe7xkcJvtmtZvFvOBvLw+PA5Af87bFXwCyYo5
 cdGbQzR0RH0Hc0RBQMC+m7Pz4O+Z4PJK3r8qgJOn40Ogo/Fd5o86f3IX2XZGiROxgg1577Tlpv
 xS2Gkx7CdoPOEZEQLLrrMeXkdwUdo9/8nNRE8nfERKol6Qv+gBqWc+e4nxScwBxxsl80Q3jxfy
 H60T8THu4beVd8m3GzATtDTXK0HImslC8ONl7KTteAZVEVSGnRGFS9Yg9z9QrfY6OXbcnMzt6B
 pmg=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 31 May 2022 01:39:57 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4LC5Lh1tvDz1Rwrw
        for <linux-scsi@vger.kernel.org>; Tue, 31 May 2022 01:39:56 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1653986395; x=1656578396; bh=2mZUXSGJvvFoPa0dzTvOCIF8z4EVn10NGrP
        311QJ8Mc=; b=RrndGPBy74a81JrIir7fFiCbuRx1VSWJ+5TyWlpacE78E2djxnt
        TzC6xSZG2FgB2ZEajTO7+Js0T9pTzpFRXuwlf6Cmt+Wi7NPmh7mey+xw+zxQuB4P
        u8SvLg+zmpuKUqmWGDtIe3/0D0h/5moN0kmYQXN1EyJwOWKUqeFM1rD2Jy+tKxmq
        1YCa8hi65GUkvQTi1/NbqsWGVNNZswQNLYUV1rZMUl4hF5ypDJBB/ipLtHyIuJTx
        9ymz3Do3BKmDp9tQWWfXzy2Ai7zCObwWBBDeeivLODe+K0WurI4tie5eOmURV3bK
        NBNVqMOuu7xHkFHrYIas8K4pU+eETG3lRWQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id YSKDbo9kUfv9 for <linux-scsi@vger.kernel.org>;
        Tue, 31 May 2022 01:39:55 -0700 (PDT)
Received: from [10.225.163.61] (unknown [10.225.163.61])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4LC5Lf6qgKz1Rvlc;
        Tue, 31 May 2022 01:39:54 -0700 (PDT)
Message-ID: <52723df4-ef27-4559-a9e4-63bc48959d3b@opensource.wdc.com>
Date:   Tue, 31 May 2022 17:39:53 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH v2 1/2] scsi: sd: Fix potential NULL pointer dereference
Content-Language: en-US
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Dongliang Mu <mudongliangabcd@gmail.com>
References: <20220531002812.527368-1-damien.lemoal@opensource.wdc.com>
 <20220531002812.527368-2-damien.lemoal@opensource.wdc.com>
 <YpXNFfwtPyGt5eVT@infradead.org>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <YpXNFfwtPyGt5eVT@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/31/22 17:08, Christoph Hellwig wrote:
> On Tue, May 31, 2022 at 09:28:11AM +0900, Damien Le Moal wrote:
>> If sd_probe() sees an error before sdkp->device is initialized,
>> sd_zbc_release_disk() is called, which causes a NULL pointer dereference
>> when sd_is_zoned() is called. Avoid this by also testing if a scsi disk
>> device pointer is set in sd_is_zoned().
> 
> Wouldn't a fix like the one below make more sense?  Until
> sd_revalidate_disk and thus sd_zbc_revalidate_zones is called none of
> the zone information is filled out, and thus we don't need to clear it.

Indeed, very good point. Will send a v3 with that instead of the current fix.

> 
> But at that point we've already initialized the device and thus the
> release will handler deal with all the real cleanup:
> 
> diff --git a/drivers/scsi/sd.c b/drivers/scsi/sd.c
> index 749316462075e..dabdc0eeb3dca 100644
> --- a/drivers/scsi/sd.c
> +++ b/drivers/scsi/sd.c
> @@ -3542,7 +3542,6 @@ static int sd_probe(struct device *dev)
>   out_put:
>  	put_disk(gd);
>   out_free:
> -	sd_zbc_release_disk(sdkp);
>  	kfree(sdkp);
>   out:
>  	scsi_autopm_put_device(sdp);


-- 
Damien Le Moal
Western Digital Research
