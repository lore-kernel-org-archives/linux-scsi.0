Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ADE18C63797
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Jan 2023 08:15:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236065AbjAQIPc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Jan 2023 03:15:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236099AbjAQIPH (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Jan 2023 03:15:07 -0500
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D24692A174
        for <linux-scsi@vger.kernel.org>; Tue, 17 Jan 2023 00:15:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1673943306; x=1705479306;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=/A9f5uVbu/7B67PEgsZ+dQ2Yu9WMa+tclhDOagcGEy4=;
  b=ib3Ib6md600zo3PDAOqrjHSGJ9Lw1S/RVjRNwgynIMewVD04VlH0207z
   01LiO4Ed0RBuR/VBn3SYRk6C94m2zYzg/zhUZUVpXL153kNB8dWzgZD8Z
   F1SQYY8bKmvuBux6XpJOu/oIGOXPI/sQ+si6QB4sMxVXmwwrtIVkfuVnb
   OdYlkyu+fpKUpJv/VMN4PoVpkIUkRnFxqtU1dh4EvtToKS/jDGmi2kc/1
   +4xhJ+Gbi9cz2Heqz2GOorkWttjaV6Z5tJq8njHopFBnx4H4/Rl8zk2Mi
   QvkGlvxVnLtF22/hrfutgtnT/KgbL6MufTVm0pHJIEGHL/U1DkqJwiV2O
   A==;
X-IronPort-AV: E=Sophos;i="5.97,222,1669046400"; 
   d="scan'208";a="332983670"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 17 Jan 2023 16:15:04 +0800
IronPort-SDR: Kn62dvRMh+Jk57ohOmeAyjqHZ0n/2XZDq33+RrZ9RdZSftzKl5rUEa69q0a7uIrhz7o0GGXQqh
 J7R1TwUwVSQrcV7j+psCVlK5wFWr/XiG6U+rD2AdYTsSlvd8mE1uIx9wHPEi6GXUDHY4q3y4w2
 5WVa8iZP9gTTQYOKIY/MDS5tFVgR5md2qDirJh9tPnpPfMid1VhjW0p6xB4GPKdPIwsFgSE/K9
 MDRBL83e0kwwzj9zcDpFgYn6LbL674SP+0kN9b/pZYtmdbYnFljNwdGP6z3mnOjQHBxLRtc0DA
 9fk=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 16 Jan 2023 23:32:44 -0800
IronPort-SDR: tfMNoaYlWIG0jRNefWba9NJoSJkdHzCuCC5s2FdnRDPoUTNRpcjym/vxF9cw8nQRE34qfp2rMx
 FAhHathThnZBy2Hd2qyHryeiH4HD4sGVXvTlK7F4w50xGW0ldXfkDuny5CwbOwLTnq5suDbIo0
 X+7UYyeZx/qN1Q0vk1LLGGSUteTv9aCCkF7s/4kH3KjcHFtYF/fzKTOyIoQ0hZDypO3T4HK/la
 L8CUsdOUBgcfgtYI11//1VQiy+CyWAx0jSpJX9+YjVJS/6fW5aQ8RTw5rRsE4WPyJ4c3qOFBKR
 98E=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 17 Jan 2023 00:15:04 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Nx1sK6NNLz1RvTr
        for <linux-scsi@vger.kernel.org>; Tue, 17 Jan 2023 00:15:01 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1673943301; x=1676535302; bh=/A9f5uVbu/7B67PEgsZ+dQ2Yu9WMa+tclhD
        OagcGEy4=; b=ZgLmQKi7bp6pKRV5biECgmnlsNOFc2Z2FF0uq8CUMOCC2A+ypL9
        vi8A896UhXGGVKtSPgiWuHVvzyHQCohG0Ql6Plm1exrnr0RMapRGw7VPrZUN1XvW
        GQ+Ix5bmow2Lw7eWMkXblLJ0rk1Aho2+77bWUqPW5+BbGoGXw7d9qIGfIJrk1Euo
        xXGyxjmj4e6ZZzoZunl7s3LbVB3TJOmhmvroKUTB5FctXIZlnhtkH7sXFTekOM2h
        Iu2n38HPign66pXqfitKXmXTW8vz+74KtmAQtA9u/Boh2z952NwM7QFJLEOftpkN
        zVExjt8/PIxTs81h/hREJn20w02xnY/GoGA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id RhCgAAi8gPQo for <linux-scsi@vger.kernel.org>;
        Tue, 17 Jan 2023 00:15:01 -0800 (PST)
Received: from [10.225.163.30] (unknown [10.225.163.30])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Nx1sJ0V7Bz1RvLy;
        Tue, 17 Jan 2023 00:14:59 -0800 (PST)
Message-ID: <f5d2f1d1-94a7-1b14-fc0d-d2497155893a@opensource.wdc.com>
Date:   Tue, 17 Jan 2023 17:14:58 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.0
Subject: Re: [PATCH v2 07/18] block: introduce duration-limits priority class
Content-Language: en-US
To:     Christoph Hellwig <hch@infradead.org>
Cc:     Niklas Cassel <niklas.cassel@wdc.com>,
        Paolo Valente <paolo.valente@linaro.org>,
        Jens Axboe <axboe@kernel.dk>, Hannes Reinecke <hare@suse.de>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org
References: <20230112140412.667308-1-niklas.cassel@wdc.com>
 <20230112140412.667308-8-niklas.cassel@wdc.com>
 <Y8ZNftvsEIuPqMFP@infradead.org>
 <2bd49412-de68-91d3-e710-0b24fed625d2@opensource.wdc.com>
 <Y8ZYuIlxC3Ui0LMP@infradead.org>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <Y8ZYuIlxC3Ui0LMP@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/17/23 17:13, Christoph Hellwig wrote:
> On Tue, Jan 17, 2023 at 05:06:52PM +0900, Damien Le Moal wrote:
>> They can, by using a large limit for "low priority" IOs. But then, these
>> would still have a limit while any IO issued simultaneously without a CDL
>> index specified would have no limit at all. So strictly speaking, the no
>> limit IOs should be considered as even lower priority that CDL IOs with
>> large limits.
>>
>> The other aspect here is that on ATA drives, CDL and NCQ priority cannot
>> be used together. A mix of CDL and high priority commands cannot be sent
>> to a device. Combining this with the above thinking, it made sense to me
>> to have the CDL priority class handled the same as the RT class (as that
>> is the one that maps to ATA NCQ high prio commands).
> 
> Ok.  Maybe document this a bit better in the commit log.

OK. Will do.

-- 
Damien Le Moal
Western Digital Research

