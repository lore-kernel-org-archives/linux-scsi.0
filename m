Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 91922C64EC4
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Mar 2023 03:30:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229645AbjCGD3u (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Mar 2023 22:29:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229525AbjCGD3t (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Mar 2023 22:29:49 -0500
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2F7E301B2
        for <linux-scsi@vger.kernel.org>; Mon,  6 Mar 2023 19:29:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1678159788; x=1709695788;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=b7SaN5IdN/OzmSd3eqcZSh9llVNmyd/tU2X3V+3Bu8Q=;
  b=HYlTRAyNQUvoLsI/32YzZdhF6tPQy3H8aQI5C5/TokjoIokDQfnldQkb
   BupI7htEZLhsXw3foean5U1wc7BI2yyrM/d+Z8BzIKI2pVf5NUMqZ9mK2
   VxjVFzq4XkpZt5zujz4CqEB2WcmoP2euEC5xGIujegH/ddhbKpn9/kq7J
   mExGBEBgfbsCeKMgByl5QgvOVX3l47v4K9qEh3n8yZXhnOvfjkrmaA88G
   Oljh9+wLqnu/5KJxarQ4wScfRDzNkwYE60Wk9d1FdRXqdX9Fxm9ndjrW8
   PJteYj++tI0vLzOnV44LN9YPeZyG20yc3bQE7tcL1a8Jk1T47JFsNuPtv
   A==;
X-IronPort-AV: E=Sophos;i="5.98,238,1673884800"; 
   d="scan'208";a="223246643"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 07 Mar 2023 11:29:48 +0800
IronPort-SDR: 1YqeC9JNF04kFyZXPbnzvpRwby7+RVsYZw/XNUhx4WzbzK60mnRrkFhdhRfyl2jrN8Vg6L/bNk
 pQYKJh0cKHTxMe49XI1HMsGLzT6K3Pia0wvb9qlxqMrumOCUaH3IBNRfloEeyvLKS+e5QCMPBU
 VMR/TvPFbUpx2wHWHI8zK20RoD/FMQzGA3B85rBEiHs3zrNoJRImiyr2xfe8tX+rrO9Fzm/M5v
 jKiaci7IQy42bcQaZoAsm/L1xOyUc/ULV7FMrI+eSIB1WuoM5RgFkAqrCp2WAXRXi//YvG9F58
 UoE=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 06 Mar 2023 18:40:47 -0800
IronPort-SDR: FW/YeMiIPl8qvmJByy8aSEzaiqBfIaVIhApgJpurT9mkeEpm1iQlDEW922qtN0lBfep0TZ67Et
 vCDP8pIxb3WWz93lbxav5L8ZyuQmUmHID7vHsH+liAN8cl2FwsZP4bTOVQYY+CrTA6XYSenQCz
 ErwF3H+x2Bf9gEJpsZduhsoVwQcWXo0Yr9JTbE0BZvV/dPTjCaaUWwLiu73zodsGbgHQ5IU8an
 rooX/xD34O423R/hFdNlkhGYEcCXNpN8GexBC2s/du1S0Jp4Oti5MnrBozjQauudxjn93AVYKM
 PXE=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 06 Mar 2023 19:29:48 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4PW1Cb2BGRz1RwvL
        for <linux-scsi@vger.kernel.org>; Mon,  6 Mar 2023 19:29:47 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1678159786; x=1680751787; bh=b7SaN5IdN/OzmSd3eqcZSh9llVNmyd/tU2X
        3V+3Bu8Q=; b=lF9KQrzkAEPMLdhTpHGfoCkgBqmdEt6Tnjiz5M4s5fJHs35AsCa
        coSfyBHKcK5/g/ZFxGF/jB0zfCpaVUz0V7UPzOcvjVVMhzIf+/DntaOgvfbPGCB0
        0kKzvPPlnKlbmYCXMl77PWevHHdDdt0ylyWDfifaKxTWfida/avOfNCqBE39d08K
        oDbaVF3juNMPjltwWllPLFVhhR1k+GHGeJZMPgBJegs1jOq7+l9lW0KAiW85Y0fw
        nIPsWmrIWwqrcRyWJue8RelAoN5p4ENqXaQvUDpb3iyDpVCaal3DBmxGOdVbAdmw
        22fl45S7zTXBq8esMMjV2x8YhpMCjrNm8Gw==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id TV1p05_wEaUD for <linux-scsi@vger.kernel.org>;
        Mon,  6 Mar 2023 19:29:46 -0800 (PST)
Received: from [10.225.163.60] (unknown [10.225.163.60])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4PW1CW1Dzqz1RvLy;
        Mon,  6 Mar 2023 19:29:42 -0800 (PST)
Message-ID: <468e7c96-5911-91aa-dfbd-8fabc0db7575@opensource.wdc.com>
Date:   Tue, 7 Mar 2023 12:29:41 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 04/81] ata: Declare SCSI host templates const
Content-Language: en-US
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Bart Van Assche <bvanassche@acm.org>
Cc:     linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Ming Lei <ming.lei@redhat.com>, Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>,
        Mike Christie <michael.christie@oracle.com>,
        Shawn Guo <shawnguo@kernel.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Hans de Goede <hdegoede@redhat.com>,
        Jens Axboe <axboe@kernel.dk>,
        Patrice Chotard <patrice.chotard@foss.st.com>,
        Chen-Yu Tsai <wens@csie.org>,
        Jernej Skrabec <jernej.skrabec@gmail.com>,
        Samuel Holland <samuel@sholland.org>,
        Thierry Reding <thierry.reding@gmail.com>,
        Jonathan Hunter <jonathanh@nvidia.com>,
        Viresh Kumar <vireshk@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mikael Pettersson <mikpelinux@gmail.com>
References: <20230304003103.2572793-1-bvanassche@acm.org>
 <20230304003103.2572793-5-bvanassche@acm.org>
 <yq1bkl5migf.fsf@ca-mkp.ca.oracle.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <yq1bkl5migf.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/7/23 11:00, Martin K. Petersen wrote:
> 
> Hi Bart!
> 
>> Make it explicit that ATA host templates are not modified.
> 
>>  drivers/ata/pata_atiixp.c       |   2 +-
>>  drivers/ata/pata_atp867x.c      |   2 +-
>>  drivers/ata/pata_bk3710.c       | 380 ++++++++++++++++++++++++++++++++
>    ^^^^^^^^^^^^^^^^^^^^^^^^^
> Don't believe you meant to add this...

Oops. Yes, indeed, good catch !

>>  drivers/ata/pata_buddha.c       |   2 +-
>>  drivers/ata/pata_cmd640.c       |   2 +-
> 

-- 
Damien Le Moal
Western Digital Research

