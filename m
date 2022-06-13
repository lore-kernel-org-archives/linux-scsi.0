Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7513AC43334
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jun 2022 07:28:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239431AbiFMH2i (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jun 2022 03:28:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239346AbiFMH23 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jun 2022 03:28:29 -0400
Received: from esa3.hgst.iphmx.com (esa3.hgst.iphmx.com [216.71.153.141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BBF71B793
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jun 2022 00:28:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1655105306; x=1686641306;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=ioVbeCZUDKKWK4KyDAA+d0UWPzUSkKFLUq/QnEjSJTk=;
  b=q20lehoPwBfImxmIlDNb4I2g7ivLkvjmYSG++Pf4JyJmIjxo6Om8IIKX
   2qRiHjT1ejTLA6LSfUHJ6uXumT1EEWgn7YwFLqHnLa5SABySchxGo7vYA
   6nQm1iq+mrLdEhkFaWzUR53mm2q89a2oYB8HtmAsiq0ZhS6mxWWUy6jVi
   7mRPEaaE9fyzf18yVD8OS40hq/Ph1XrVEwAntt2v2AMzJ9FbRmKydOlRQ
   Ux7A4Gtr/91cczUcgVkybhdP+B4nAovquVZcnJuawmdVzQ2xiuTW8w1C0
   v3+yUEJR1j9G2dAAAux7WjBGH4iBtquzO7L1pXhdJeOlFIKebAGkfxJiW
   A==;
X-IronPort-AV: E=Sophos;i="5.91,296,1647273600"; 
   d="scan'208";a="207827388"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 13 Jun 2022 15:28:26 +0800
IronPort-SDR: SBu9EzGDP6P1nGtAiZmTJCJGvzVpKjp7fHyUk+aoT1KfaSKnxGDgUvvczEQBSu35Hanxec/Uvw
 yUqWLQ0PFLdnsf5mVhn9G+JgWlsmWmxFZeEahCAfOGY21+M9kQRVA2jDFz/NmT1cwJ5FdP/tVa
 ItcCe9BfxprkicoNTYwzI/yb2szfu+pNOJkxWnUjNgZZqPkH98Xwlr0rWSKNg3pgfbsreV0m8y
 opPgqKdcXbuZfvqFdL7CojFTjc3UH5LAAjOMqBY2j8K+uOtqWGQn2DklKx4dXBFMTlCOQm49gX
 PeKh9EmkqyxiKSJiTrC+J5Ls
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 12 Jun 2022 23:51:31 -0700
IronPort-SDR: VSucjlzopK4bxO1s3wWt0xkprMSdQbuL9VpPIhyPNvmu5NpWiMfTM6K24NNm30VaMhdXy7kPGl
 2YyaeS7FhjgyfiQoP+j2/C37Vj1QfWQFRha6JOBucmz+kpp6AUz3rEGR/M7S0j/fBAY0A1s7Oo
 0z+gljkRp7S01cBA/kOgWEjZUTOYQW+iS6XIVP4ZhHU4v5R69bvIBE5d6zFHyOviyLsozuEjqI
 M1LqPgGHr9RL6ru3kFWPPq5C5pyadW8iv+NAeA6YFgcn/A9HiG45yAV4wsU+MwcuDjLniQf2U5
 qDo=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 13 Jun 2022 00:28:28 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4LM38C3xKDz1SVp1
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jun 2022 00:28:27 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1655105307; x=1657697308; bh=ioVbeCZUDKKWK4KyDAA+d0UWPzUSkKFLUq/
        QnEjSJTk=; b=ZLIYkurlcWMcd3KRU8iJpMcCMEwUiAuiT7HdDS0pSkufNRpAsuu
        DP9quFszcuFbJ734A5HH37ieeQqs0DsDRhFa44O6jdNOZPFRo0goGWOmQ8mz2HhY
        karvD8eXhDBOfvaloELwy4CaEFmTKt9CXW/EnfqBN1SNjam9jr85xzIzgq9E/MWE
        PmiPeO9lv2gyQqzAWZNh9E/RDrNDJ9z4QUHZm86/j4RTHhkzdcmTRwvg+ydz7vvZ
        KkL+YhauXYZkLq6x2F9XQ3uV05d0aBL404BKw0LXCiW09ECGL2CYJoJWNE+UOQdi
        meUCdkhRDlK4KHcOaT6/dIBdA+c3D4UBrTg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id saPAr-mUiL0k for <linux-scsi@vger.kernel.org>;
        Mon, 13 Jun 2022 00:28:27 -0700 (PDT)
Received: from [10.225.163.77] (unknown [10.225.163.77])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4LM3895YRtz1Rvlc;
        Mon, 13 Jun 2022 00:28:25 -0700 (PDT)
Message-ID: <671ce4c0-77b0-5d39-5f65-dce6e47ac48e@opensource.wdc.com>
Date:   Mon, 13 Jun 2022 16:28:24 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 0/4] pm8001 driver improvements
Content-Language: en-US
To:     John Garry <john.garry@huawei.com>, jinpu.wang@cloud.ionos.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        hare@suse.de, Ajish.Koshy@microchip.com
References: <1654879602-33497-1-git-send-email-john.garry@huawei.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <1654879602-33497-1-git-send-email-john.garry@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/11/22 01:46, John Garry wrote:
> This small series includes the following:
> - Rework how some shost values are set
> - Fix a longstanding bug that the driver attempts to use tags before they
>   are configured
> - Stop using {set, clear}_bit()
> - Expose HW queues
> 
> Any testing would be appreciated as this driver is still broken for my
> arm64 system, i.e. just broken.
> 
> John Garry (4):
>   scsi: pm8001: Rework shost initial values
>   scsi: pm8001: Setup tags before using them
>   scsi: pm8001: Use non-atomic bitmap ops for tag alloc + free
>   scsi: pm8001: Expose HW queues for pm80xx hw
> 
>  drivers/scsi/pm8001/pm8001_hwi.c  |  5 +++
>  drivers/scsi/pm8001/pm8001_init.c | 73 +++++++++++++++++++++----------
>  drivers/scsi/pm8001/pm8001_sas.c  | 10 +++--
>  drivers/scsi/pm8001/pm8001_sas.h  |  3 ++
>  drivers/scsi/pm8001/pm80xx_hwi.c  | 46 +++++++++++++++----
>  5 files changed, 101 insertions(+), 36 deletions(-)
> 

Tested-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

-- 
Damien Le Moal
Western Digital Research
