Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6FB69C433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Jun 2022 05:47:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234058AbiFHFrO (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Jun 2022 01:47:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234449AbiFHFoB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Jun 2022 01:44:01 -0400
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F28D3D4620
        for <linux-scsi@vger.kernel.org>; Tue,  7 Jun 2022 20:20:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1654658423; x=1686194423;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=5aTc0zGIBR98gSkiP6r5YNvDp2b/8RM0NgQI3dhvwvE=;
  b=e5y7sn6dSEpIRZEE2NOVAg3narCOjanoor64UOhHcdrPrUVNB1ldSMBv
   sl4mCp4DylV/zx5gDYhFANAo5aQgM8CFjMTIaK1FDIluuxB5laFGY8Y9S
   aDlKgjekBGWKXjqaSXh0maykPVejsBxLT6hqWcTQkNwQBNu0efeaIcysT
   m79t+XtHckmHytM1DBEyjpnHCNrIzM8TSF0hRBfLzXGu2Sw5oGD4BVLEk
   RdRu3yQSXdXAyZcvlkGJiiovgn97X9bBZ1jT8NMFn4Bi2Q/6RaVFyRkWC
   dbFliRe6lMWOWVzIVLCWud3XdvRxlW/Kd9tjaROMTPTjS64nOynMCVtzP
   A==;
X-IronPort-AV: E=Sophos;i="5.91,285,1647273600"; 
   d="scan'208";a="207407094"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 08 Jun 2022 11:20:17 +0800
IronPort-SDR: j0iPZ84nPSyGlgVzQKaql1SAnY1w5Ev/0bA07gOEBMDmeYpI68gH1C1MUFChWzEB+O2yHxiwNy
 nWYpYPT3hNSJfHKsSuJGifOCLGbMnqJLxNVsR2VuUYzckmnW1VBeG30u1es8AKTOls0kBq15Y3
 xCqP//3NvU/RBbi5CdIM8g3uoFc7NkYsePYtWUniPoKVEi2oQto8RvsS9h2Mresszn1S0qIyk2
 /I8LPahjUDScqKzbRvD76tNmDvgxV9B5uRvpr09OpYiba2J0sAZhnCggsZBawKJ8GydtM+XRbS
 cFUm5cIE2cxd+kwg5yphyAbg
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 07 Jun 2022 19:39:07 -0700
IronPort-SDR: RctIxrWkvdQIlc4vdWCoGFxYm/+Y9Lepx5A1ZfJSIegu842UoCEa2fr5RbG1dsslxhp9MfSgEP
 AGdBH1+kAcOgnPYKDBMGysLfH0Tbr0u3Oj7zUSHGt9vbIdmjUgxpqdBvWUJFpW3jiA5KcIGEvs
 sl843ZbPLxL+3vPAloqNeHg3pNUVJmXkNeRaVgKNbEk+D15+pOSXjlv2+UHLfoWiKqOtO9Zi7/
 edZ+3DdbLQbJjpa0tSQDWxWVEGeyytUAxb4fJfXGsypvyKW2XAycZVWhD+cnv97Lj2WA53tH2j
 leo=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 07 Jun 2022 20:20:18 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4LHst93j5Bz1SVnx
        for <linux-scsi@vger.kernel.org>; Tue,  7 Jun 2022 20:20:17 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1654658417; x=1657250418; bh=5aTc0zGIBR98gSkiP6r5YNvDp2b/8RM0NgQ
        I3dhvwvE=; b=sMak6/lgEQZQwRCXtBHwbUPN/xB8///9DZfFe95CBPc709AGUlx
        Vhx/+GCa/qz6ZwF9DK5kBP4atYObTZ/qgH5LjncWb1bpW2ehAlj+xc/PGs4NYcy9
        Phgk7SFQ0WTSPlN1HLc+oQQ1zRYTADzWZheMOzJ1CtDzPuT3P5TSoyp4M72Fb9I+
        odCJv3Z1C7v+80PWRpSNiTSPP0z+QiPVj36/WQP0gJcJ5CWF5+LJEwnqT9R6K/Qa
        cjvr6UVqg27MuDtAX4Q6G/KpV0+lqxzbpmxD7pL/2enJQomwloHR1V/bsmGVlx0p
        AeVZHXJp8tRMTym52OIQPDeAVcBxUR+sYnA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 9bYZxcycWb_v for <linux-scsi@vger.kernel.org>;
        Tue,  7 Jun 2022 20:20:17 -0700 (PDT)
Received: from [10.225.163.72] (unknown [10.225.163.72])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4LHst80tNSz1Rvlc;
        Tue,  7 Jun 2022 20:20:15 -0700 (PDT)
Message-ID: <d20bc449-874d-a133-6f16-ef6c02732d6f@opensource.wdc.com>
Date:   Wed, 8 Jun 2022 12:20:14 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH v2 0/3] ata,sd: Fix reading concurrent positioning ranges
Content-Language: en-US
To:     Tyler Erickson <tyler.erickson@seagate.com>, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        muhammad.ahmad@seagate.com
References: <20220602225113.10218-1-tyler.erickson@seagate.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220602225113.10218-1-tyler.erickson@seagate.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/3/22 07:51, Tyler Erickson wrote:
> This patch series fixes reading the concurrent positioning ranges.
> 
> The first patch fixes reading this in libata, where it was reading
> more data than a drive necessarily supports, resulting in a 
> command abort. 
> 
> The second patch fixes the SCSI translated data to put the VPD page
> length in the correct starting byte.
> 
> The third patch in sd, the fix is adding 4 instead of 3 for the header
> length. Using 3 will always result in an error and was likely used
> incorrectly as T10 specifications list all tables starting at byte 0,
> and byte 3 is the page length, which would mean there are 4 total
> bytes before the remaining data that contains the ranges and other
> information.
> 
> Tyler Erickson (3):
>   libata: fix reading concurrent positioning ranges log
>   libata: fix translation of concurrent positioning ranges
>   scsi: sd: Fix interpretation of VPD B9h length

Applied 1-2 to for-5.19-fixes. Thanks !

> 
>  drivers/ata/libata-core.c | 21 +++++++++++++--------
>  drivers/ata/libata-scsi.c |  2 +-
>  drivers/scsi/sd.c         |  2 +-
>  3 files changed, 15 insertions(+), 10 deletions(-)
> 
> 
> base-commit: 700170bf6b4d773e328fa54ebb70ba444007c702


-- 
Damien Le Moal
Western Digital Research
