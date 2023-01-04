Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4C1FAC4708D
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Jan 2023 04:44:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230297AbjADEoD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 3 Jan 2023 23:44:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49686 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233477AbjADEoA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Jan 2023 23:44:00 -0500
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 38C7A13DF4
        for <linux-scsi@vger.kernel.org>; Tue,  3 Jan 2023 20:43:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1672807439; x=1704343439;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=PQgM4ru4EBImllGV+1RP6lK0PqWbLhfzRnpDMQkTjv4=;
  b=oFTshIw84zd2TolIUGK8Du0Jx6lEqF1+SG1fYB/odXIvz/0dceZcV8SJ
   99TpuQA7GqMk0vwB7+dj+bzSBSlqU4op4wURCpD770MSWizmuHKCz8hoe
   M+bUFnEBvS/6naaULWKnNVwasSXnCs9p6G1B217k6ihdaRPUO8/XDopK7
   EzUytvhv+YqxIK7R7SQy5YCXv2idX+KcI70UlL0QQOVR0V+E7ssBPmXz/
   OhVl9nliMvHmDVmKe8BJws45P0vwyX38XJ1ePH5FiT6CkHy15Y4Di3Q8q
   STqJL7BwHgjQzx295UspbJUuJoziPZqOkldldOcFlUCwekJbn/N8KT+6N
   w==;
X-IronPort-AV: E=Sophos;i="5.96,297,1665417600"; 
   d="scan'208";a="331980741"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 04 Jan 2023 12:43:57 +0800
IronPort-SDR: UF71HLDGzKxe9U5yU5LvIiZZm80hymaScqXKi+D58ypD4olsw0hiJEAQpVyrDDN82UBLZ6DS4k
 +DkSH9e5PRIYDsi2rkOLqdfSk4Q61aGmLg9qk/DdtTKl8m7bawzSi999jP2oPGPRPbuubRMhuI
 WIbrpAV8mEaNbMJeyf5WeZ7t6XKyEnqQ1Dw47+PqvDREeFVbtvrcYmDusfPvRMZjZvja5yESsJ
 0FOA9wzFGVloHF0b0l9NcxfVOeYyygPF32nzWnXlPTgghpg4abMZLhmH13E3MftL0R1QsypezY
 WdI=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 03 Jan 2023 20:01:54 -0800
IronPort-SDR: gNvFS3LvLwhESRjMdiqHsva1Ea8RWZm78xDiOPhAdF5ATMVakNVpPn0ZLCtGKp65JI/BHgRr81
 Wuv3uhGCRlF3yV9UIZIRRGwX2zS/antEiUBLH4ms606lnVGG4dt7ySq9CvBMTbL9Cko/xR/gsj
 F7Y1DgfGefzwzXR8b+XpLDJJCEgYP7wU3zF5LJ/g4iGLPKjaxHUM1SLO+xgnL652jKAdQS/NMw
 QwGjTjMxNWZ8/IjRiXUSpxleU8v0g1MlsZt0A0F8iTTHtP1Y3gBvmmBKSTF4oW3tQPBfTteu5r
 pn8=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 03 Jan 2023 20:43:57 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Nmxnn1ZQRz1RwqL
        for <linux-scsi@vger.kernel.org>; Tue,  3 Jan 2023 20:43:57 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1672807436; x=1675399437; bh=PQgM4ru4EBImllGV+1RP6lK0PqWbLhfzRnp
        DMQkTjv4=; b=W+9MMxyLM+flzdLoYfFmqY0yFwv3lD79ekRXbFpL83ZttR3fVO9
        Yudm/b16IbEfYGZyr4Cc73mnJYcYOB0Avc05FpL9XyrfhDUyhjwGWpE71xFefVlm
        q60+6CCEzxwIKZ5tuITQStEnsgoWlRoYkjYWcVrTpN/4x7V9I+OBjf8tI7JX9x6w
        OdnXAilRofAOH97OZ+maPk6OfpS66IHyZt3eBUNF715Bib2+JmAevsvfytkV7YHZ
        GeSzQxqS6E+SlMhTcrP2WpzLK6FqSOGnVeP7bzkHOww8eqXNVLEXxLaC2wmh4Klo
        N+mtLU2ae36CLHcEZPNz+D0Ymcv6dW6i+wA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id uieuue4vjqqt for <linux-scsi@vger.kernel.org>;
        Tue,  3 Jan 2023 20:43:56 -0800 (PST)
Received: from [10.225.163.5] (unknown [10.225.163.5])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Nmxnl2P4pz1RvLy;
        Tue,  3 Jan 2023 20:43:55 -0800 (PST)
Message-ID: <49c92e50-5452-8c3e-1517-a0bb1e4e72a0@opensource.wdc.com>
Date:   Wed, 4 Jan 2023 13:43:54 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v2 0/7] misc libata improvements
Content-Language: en-US
To:     Niklas Cassel <niklas.cassel@wdc.com>,
        Mikael Pettersson <mikpelinux@gmail.com>,
        Brian King <brking@us.ibm.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
References: <20221229170005.49118-1-niklas.cassel@wdc.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20221229170005.49118-1-niklas.cassel@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/30/22 01:59, Niklas Cassel wrote:
> Hello there,
> 
> This series contains misc libata improvements.
> 
> These improvements were identified while developing support for Command
> Duration Limits (CDL). All patches in this series (i.e. V1 of these
> patches) were orignally sent out as part of the CDL series, found here:
> https://lore.kernel.org/linux-scsi/510732e0-7962-cf54-c22c-f1d7066895f5@opensource.wdc.com/T/
> 
> However, as these improvements are completely unrelated to CDL, they can
> be merged independently, and should not need to wait for other patches.

Applied the series to for-6.3. Patch 1 had a small conflict that I fixed
up. Thanks !

> 
> 
> Kind regards,
> Niklas
> 
> 
> Changes since V1:
> -Added missing chain sign-off (in addition to author sign-off).
> -Picked up tags from John.
> -Rephrased commit message for patch 1/7 as suggested by John.
> -Rephrased commit subject for patch 3/7 to more clearly hightlight
>  that this is simply an improvement, and not strictly a bug fix.
> 
> Damien Le Moal (2):
>   ata: libata: simplify qc_fill_rtf port operation interface
>   ata: libata-scsi: improve ata_scsiop_maint_in()
> 
> Niklas Cassel (5):
>   ata: scsi: rename flag ATA_QCFLAG_FAILED to ATA_QCFLAG_EH
>   ata: libata: read the shared status for successful NCQ commands once
>   ata: libata: respect successfully completed commands during errors
>   ata: libata: move NCQ related ATA_DFLAGs
>   ata: libata-scsi: do not overwrite SCSI ML and status bytes
> 
>  drivers/ata/acard-ahci.c      |   8 +-
>  drivers/ata/libahci.c         | 171 ++++++++++++++++++++++++++--------
>  drivers/ata/libata-core.c     |  12 +--
>  drivers/ata/libata-eh.c       |  22 ++---
>  drivers/ata/libata-sata.c     |   7 +-
>  drivers/ata/libata-scsi.c     |  11 ++-
>  drivers/ata/libata-sff.c      |  10 +-
>  drivers/ata/libata-trace.c    |   2 +-
>  drivers/ata/sata_fsl.c        |   5 +-
>  drivers/ata/sata_inic162x.c   |  14 ++-
>  drivers/ata/sata_promise.c    |   2 +-
>  drivers/ata/sata_sil24.c      |   7 +-
>  drivers/ata/sata_sx4.c        |   2 +-
>  drivers/scsi/ipr.c            |  11 +--
>  drivers/scsi/libsas/sas_ata.c |  11 +--
>  include/linux/libata.h        |  25 ++---
>  16 files changed, 201 insertions(+), 119 deletions(-)
> 

-- 
Damien Le Moal
Western Digital Research

