Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2A31AC47088
	for <linux-scsi@archiver.kernel.org>; Wed, 30 Nov 2022 09:59:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232803AbiK3J7u (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 30 Nov 2022 04:59:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233627AbiK3J7s (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Nov 2022 04:59:48 -0500
Received: from esa4.hgst.iphmx.com (esa4.hgst.iphmx.com [216.71.154.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F9BD2F38E
        for <linux-scsi@vger.kernel.org>; Wed, 30 Nov 2022 01:59:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1669802387; x=1701338387;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=nSSxTiPpD3lcTrNnFH6mrivCTPSW7tZBM25/YxQ4IPo=;
  b=UFZPpJKE1OhiQzX4b6OQOOXdCaStszBr6KsG/LBzNZvsvZWgDI/SQV9P
   eKURoG4ek6NMpPbiv6d2ozOhKLrIode1uFyNtT2y6zCxZ+g7vDdqKUziF
   EFtTtOsLC1WOjQ0vLjfty6othE1DyKui/8gxu+IctQL3Nu7ggb7pKEbck
   s5P/f3cG4It50ygwq9AaCU0dfjR20UhPZ7mBiPRQb0STgdxHSO7ROFCu/
   0FguLXpN9ALH0jM1ZB2ja2/EXU6KX2OOLohBMDM+lR1stTC4pf+dQ4u76
   Aix3cewEWF+3oB72s8VlE8bcd0AISTnVdCL5mkpCHeYEX4Pnc53cIb7LB
   g==;
X-IronPort-AV: E=Sophos;i="5.96,206,1665417600"; 
   d="scan'208";a="215772345"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 30 Nov 2022 17:59:46 +0800
IronPort-SDR: RQyF4PnmkyPkfn2Y/qAqc8YxwL80NheGx1vbF9TswFcUUbTz2OxTzgLZMG7bMqV+O8dtsIcrXO
 qdnVaLqGcO/sa8IIzG8oHvVJqCKAqW0FpVRVSWF3skr5uXoNU03bg4r1hOlWvCYCMNyVi2lsoq
 GH4JpEV+e69mEUvGeZE1/lw0nb205t592Y7K19LrxF4Mzqd/AnSN4w0DYcz9ltfdX1ydToeHQp
 uSVmt9q2IWsw+Hl0pY4aC4z4rSc1k265U4/lihpCi6VpKob24wKM9evGEpHrHLsJ9QJb4qjiT/
 Xjg=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 30 Nov 2022 01:18:25 -0800
IronPort-SDR: 5fHgmMkkyniYjluSaIQozLj3UEEhEGKzxFdiAbqIOllYD3HcdkLig0ID0TYHQnJWrDkEcHWCx4
 Q9jkeDHV6uKLsZh7vfoOsd/1j81e8Uba5vGKMAqqJE+mL03y6HXsnkUWtJtVmLe4e2rN/ECSM7
 jvTQmfxzI4nDgQXTzdJqgHAV0b2ZEEbSaCh/fjpeQVa7g9pY8rRNGU71j73RP2MBCxafYA/fj1
 Sn/+GI58hRNbvyVMweUFyTnOlU90r4FU+EKs33nAVGAeMbAIW4qpoZFktSzUApgaxirnhDxno3
 N0k=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 30 Nov 2022 01:59:47 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4NMZSL0x53z1RvTr
        for <linux-scsi@vger.kernel.org>; Wed, 30 Nov 2022 01:59:46 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1669802385; x=1672394386; bh=nSSxTiPpD3lcTrNnFH6mrivCTPSW7tZBM25
        /YxQ4IPo=; b=MZQzB7fiFB1ok67KpExv25WRjQHEKVM5/4KWx5kzcsM31IUwN3k
        k+xQUE7J51ZetrPefUOcGmF7U/I7kdEJ7xHCifSDRWj89ko6CePp2QBk9FiQo/U7
        8DwXmeM5OCj5fVQXmkDQ6hntvl++7tcZHW/ba02uVeBC1Q6g+KWpBMFB0EUeJrEK
        2A1AY9lJJDZCxFWvHUr9AkANnYxIwaCFMF7csZyDcnbuJ9y4l2YrL/TlyEPTBIH0
        gTCs8D1RiJkedGdo1cxlFm0ja2YMJ54omMMVm5NxZHi5LFvJq8yR2tqcqkscdwHF
        qYIcP/UMv+G5Oy2/UMskzV46wnXRpfKXi6A==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 6wU_1NdW_bDm for <linux-scsi@vger.kernel.org>;
        Wed, 30 Nov 2022 01:59:45 -0800 (PST)
Received: from [10.225.163.66] (unknown [10.225.163.66])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4NMZSK0hcrz1RvLy;
        Wed, 30 Nov 2022 01:59:44 -0800 (PST)
Message-ID: <a60e44ec-a262-d668-4410-60518091f514@opensource.wdc.com>
Date:   Wed, 30 Nov 2022 18:59:43 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.0
Subject: Re: [PATCH v4] scsi: sd_zbc: trace zone append emulation
Content-Language: en-US
To:     Johannes Thumshirn <johannes.thumshirn@wdc.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.de>
References: <39540065afb936255236311fc6c93f67a7805bf6.1669797508.git.johannes.thumshirn@wdc.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <39540065afb936255236311fc6c93f67a7805bf6.1669797508.git.johannes.thumshirn@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/30/22 17:39, Johannes Thumshirn wrote:
> Add tracepoints to the SCSI zone append emulation, in order to trace the
> zone start to write-pointer aligned LBA translation and the corresponding
> completion.
> 
> Signed-off-by: Johannes Thumshirn <johannes.thumshirn@wdc.com>

[...]

> diff --git a/include/trace/events/sd.h b/include/trace/events/sd.h
> new file mode 100644
> index 000000000000..0b11fed8327b
> --- /dev/null
> +++ b/include/trace/events/sd.h

Why not drivers/scsi/sd_trace.h ? That would work too, no ? Do we need
that header as a common thing under include/trace/events/ ?
-- 
Damien Le Moal
Western Digital Research

