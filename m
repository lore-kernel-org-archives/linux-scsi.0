Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 90333C352A1
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Dec 2022 03:28:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbiLGD2R (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Dec 2022 22:28:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57510 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229607AbiLGD2Q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Dec 2022 22:28:16 -0500
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 94CB13FBAF
        for <linux-scsi@vger.kernel.org>; Tue,  6 Dec 2022 19:28:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1670383695; x=1701919695;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=M+aJ6y5sHpDcdAt5RuWYZg1pKiQiXsJCn87DsyxivS0=;
  b=K86feuXlkOrIlEA2uimdRJohHLSTBl09FKYTZQvPBYDGZdLfjSbSDf/d
   oEqgmdXkFtoi+Sm/KTKt45lQvSXupOHy48QAGF3jTO2DwyuhvqW1D52g8
   3aoMhUiNCBWgzXzXJ8YmuFlU1KxLpTDg0VOSNAlf3L8IQjcSNM7P7gBUZ
   ydUwVoaLL+hU/H7CzZ42xXgCGNpfJcuJUFGyDOMjAPJZj8MT+syajKOsP
   BQY9fUZlUkv7QOFTH2fuOu8erFEIGyuQLaPSCXGGhyHvRt2Myk7FcS2/S
   /N0G9Ugo43tpsES9EFqMpkFAPSYdosnQC08pohQvwRoYq/af/sfxZ1yud
   Q==;
X-IronPort-AV: E=Sophos;i="5.96,223,1665417600"; 
   d="scan'208";a="218329297"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 07 Dec 2022 11:28:12 +0800
IronPort-SDR: E3b434ZarSl+kBMafi///GNtZ+S+OtNy9gD+oHbSR9rROIwI0aS8ZS6w5gJZpSP11hnCn8vSHP
 QzMKgrBmpxB36PZ1u2SUQh7aYqsSyCBG/fAW6yw7+t7YIUmuIfBQnMlFqC9Hgy2OZPDEvRTH7k
 7Zd40IpHpi6WyCrs5B+dMD87V4XvsobwsJezb/6dH6Ziz0i1WZNuw0aIbDmhPVwpcudTcQxSTK
 PbLbsXmFRDWGvnn0UhcL6pgieBf69/54ZFlkRYrSDLK8/Bh32Z8Zj9UFa3ipoDbbE4S1+p2il8
 FIE=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 06 Dec 2022 18:40:58 -0800
IronPort-SDR: 5DSkBz5GnYhQRjQj5D/4rq0eEFRo4xlOm7oO5GWeA9dwjR+7PMhkgXmKxDgN9yqIim4/8lcHB3
 30pNh8RR4p8AQD4OT1exNRZddoqpbQtwdYjcG5BJQHuhrQNDFuNLB5cSB1Pgadl177eMjwt7rq
 tHpQfddhgeow54k/gAgxnhIBOurVZS11V3rZ752mzVEcjUrRIKWvUXExBexZyIxx8zGZPJG2XD
 Qb6+e+WwD+DRzHBWLKazzXwz/Eephn/HpGUnTiahMMrtcDbsK8Cw2Zi2VXP/4+83NENxdBDu8k
 sLI=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 06 Dec 2022 19:28:11 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4NRjRG4690z1Rwrq
        for <linux-scsi@vger.kernel.org>; Tue,  6 Dec 2022 19:28:10 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1670383690; x=1672975691; bh=M+aJ6y5sHpDcdAt5RuWYZg1pKiQiXsJCn87
        DsyxivS0=; b=rHNj2azHToExlWXtoARmMwYd99XkgGsOc1ssy9lI0HKLIMImKdO
        L9ZdKan8EpS/n2BbUsYJuTKlRMXVhO7B7Mi0APNFnRGVmU9z4elwZ0ZqBtz7TaDu
        59gpnHlJqgdbeOWz2niwZ/rftGTGbuU+rhLEd4uH/oYIfPSVqd5MYcDlLvESmlhT
        He+9k2cNjafywP/7wdmz4zn2BcELHRg6md+HCM5Eo6mZgSwHNM1zOFohjIXOyutY
        tiQ/S2Uk6lT+iIXZLuQrXBIz22822d9pxEQ7Sh9bEv3f7+9ocx9Gw04NlQqdwclJ
        jFRaUddsgvYmrVuNy6k3Ltrz7MC/LzyY8Lg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id TlX8G_ZXLOvi for <linux-scsi@vger.kernel.org>;
        Tue,  6 Dec 2022 19:28:10 -0800 (PST)
Received: from [10.225.54.48] (unknown [10.225.54.48])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4NRjRD5tb3z1RvLy;
        Tue,  6 Dec 2022 19:28:08 -0800 (PST)
Message-ID: <51cf6207-fbc7-0a67-7ca0-dabbac8442ff@opensource.wdc.com>
Date:   Wed, 7 Dec 2022 12:28:07 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.0
Subject: Re: [PATCH] scsi: mpi3mr: refer CONFIG_SCSI_MPI3MR in makefile
Content-Language: en-US
To:     Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        linux-scsi@vger.kernel.org, mpi3mr-linuxdrv.pdl@broadcom.com
Cc:     Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
References: <20221207023659.2411785-1-shinichiro.kawasaki@wdc.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20221207023659.2411785-1-shinichiro.kawasaki@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2022/12/07 11:36, Shin'ichiro Kawasaki wrote:
> When kconfig item CONFIG_SCSI_MPI3MR was introduced for mpi3mr driver,
> makefile of the driver was not modified to refer the kconfig item. Then
> mpi3mr.ko is built regardless of the kconfig item value y or m. Also
> "make localmodconfig" can not find the kconfig item in the makefile,
> then it does not generate CONFIG_SCSI_MPI3MR=m even when mpi3mr.ko is
> loaded on the system. Refer the kconfig item to avoid the issues.
> 
> Fixes: c4f7ac64616e ("scsi: mpi3mr: Add mpi30 Rev-R headers and Kconfig")
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> ---
>  drivers/scsi/mpi3mr/Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/mpi3mr/Makefile b/drivers/scsi/mpi3mr/Makefile
> index ef86ca46646b..3bf8cf34e1c3 100644
> --- a/drivers/scsi/mpi3mr/Makefile
> +++ b/drivers/scsi/mpi3mr/Makefile
> @@ -1,5 +1,5 @@
>  # mpi3mr makefile
> -obj-m += mpi3mr.o
> +obj-$(CONFIG_SCSI_MPI3MR) += mpi3mr.o
>  mpi3mr-y +=  mpi3mr_os.o     \
>  		mpi3mr_fw.o \
>  		mpi3mr_app.o \

Looks good to me.

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

-- 
Damien Le Moal
Western Digital Research

