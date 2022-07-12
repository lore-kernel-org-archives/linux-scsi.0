Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6D9A5C43334
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jul 2022 00:53:54 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231403AbiGLAxy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 11 Jul 2022 20:53:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229974AbiGLAxw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 11 Jul 2022 20:53:52 -0400
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F0914DFF7
        for <linux-scsi@vger.kernel.org>; Mon, 11 Jul 2022 17:53:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1657587231; x=1689123231;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=Oj9658Qgm4Pjsv00cQy94+EU2i2b1YhHxG7ihN9K01E=;
  b=TIPGVpvi89AbBmAaZ9zsEyJZeyGUEiv9rsE1u8vhm9JwZkBABtonz9ZY
   w60Dg1oYYFhmvVjw2nZcUPiV3FsJKQtFqUNeCiUWXAJzP5Hc3/5/6+f+Z
   C7QhmtHlaVxJ3jQKJmLvm26KpzXPR49OsZNvPE46jcrVtEMHXs5O3O7dk
   ikk/iGwXaRzZ6iZQnUINjRYnUE2LqsZbiJa5psUCLt8r3aAZ683dRf0UQ
   tDCV7FyorMbxtAHURmZjedjMGzWcurYeUqVxzj7cVNYsv+rXzOuALOklK
   3Lz4VclA9EIThjN7DunnoNWnpr0yM+qaeKcYebxyAOAIGytucBj0NEh2M
   A==;
X-IronPort-AV: E=Sophos;i="5.92,264,1650902400"; 
   d="scan'208";a="317567993"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 12 Jul 2022 08:53:51 +0800
IronPort-SDR: xlVRKYc0lj0pQPN0p0hVogQQ8YNTIF1w8kfPDKh4PYUAIo1Ezd4rnlRXeUDhJ+Xc4hdh3r2QgO
 pN2OHJqQgROuPCy6j75OmsK/pYANBXPKl+nZv+l8FGIYl+H/mj5oN520LWTF6FrpGT7NIaYPj4
 nm5pfnug7wL1XVOub7MKxLy/OmxywsOid2T+KpOmRnISsSH2cknoVYR5B4Eu3uEqZdhR0dgFE+
 rFqsldS3sIfK6m6SgD3lQrtMMXgFZPkU2MeUcCv22NGKGacJho8sMuJv6A291y6Vh7uHCjGUYr
 2iJ8YgTo39htRgSj/rCr5e+l
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 11 Jul 2022 17:10:49 -0700
IronPort-SDR: /GacXWeCxzshKkmWT82p1G4BCD3rsxub1uMKMh9KL34hArnxqaa7dN0O4WKD23aJeeQBYBjynC
 qFWT0CUf58vtmXhP8ndMiRhykvJhuXWHWDpv6idQ8CaHPzLTcKSk9XTMIOGyJOsVl71i7lRVbi
 4oFnBKgSEKIvjiQPhOKAfVGG2TwY5c8hJUl1Kuuxs0Qd7Btt83GLXTo92d3djOqvnUFi+4r/Hj
 y/gVW/ECpta6XEHjwMw4QOxRHwZp1FTeeU5SZurHNedbPJ+kJN//JWQ10GBgN5otH4BnELKxj1
 Fq8=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 11 Jul 2022 17:53:52 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Lhj1W2LFqz1Rwnx
        for <linux-scsi@vger.kernel.org>; Mon, 11 Jul 2022 17:53:51 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1657587230; x=1660179231; bh=Oj9658Qgm4Pjsv00cQy94+EU2i2b1YhHxG7
        ihN9K01E=; b=k4wHV6UzcG35B300ro+3b78ELuzm3mzTcCvkvs+3ZIIsJYvOZlc
        HjtsxaMYhq2G4CEa08GoMMXQwgYY2Bm5yqcKgqO0efykRvAfWw1BFhbFD6gcypvB
        zEtZGwwNsRb3PFqm24RP55Aulc965RxJIIqxMz2AfNGJ8li1CZElDSN6ff+susO7
        thDnwi7aG1AvmSRx4QItae4n4FDshTYeZ/fPkgPuuMZURlvk+/6dJrRMlPMz7juf
        YYrmWm/K0AGYRFTsHAWZEl0AIHXE8P5/9QkwUDb9WL6xHEoGG98ipKW55fjATtL1
        2ppQ1ZCzSCmVHmB04yHXNjEGVVmZoLB5eGA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id w3QKeFwM6zWY for <linux-scsi@vger.kernel.org>;
        Mon, 11 Jul 2022 17:53:50 -0700 (PDT)
Received: from [10.225.163.116] (unknown [10.225.163.116])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Lhj1V0CnYz1RtVk;
        Mon, 11 Jul 2022 17:53:49 -0700 (PDT)
Message-ID: <8e69a9f9-b0ef-b129-da6a-9ea7bfbd58a6@opensource.wdc.com>
Date:   Tue, 12 Jul 2022 09:53:48 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH 2/3] scsi_debug: Make the READ CAPACITY response compliant
 with ZBC
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>, linux-scsi@vger.kernel.org,
        Douglas Gilbert <dgilbert@interlog.com>
References: <20220711230051.15372-1-bvanassche@acm.org>
 <20220711230051.15372-3-bvanassche@acm.org>
 <625056aa-0604-d1a9-e1a1-0efef70a5de1@opensource.wdc.com>
 <35c22b90-13d5-10b9-4677-fd3214298105@acm.org>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <35c22b90-13d5-10b9-4677-fd3214298105@acm.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/12/22 09:33, Bart Van Assche wrote:
> On 7/11/22 16:19, Damien Le Moal wrote:
>> Note that I think this entire patch could be reduced to just doing this:
>>
>> 	if (devip->zmodel == BLK_ZONED_HM) {
>> 		/* Set RC BASIS = 1 */
>> 		arr[12] |= 0x01 << 4;
>> 	}
>>
>> No ?
> 
> Hi Damien,
> 
> The above looks valid to me from the point-of-view of the ZBC-spec. 
> However, reducing patch 2/3 to the above would reduce the number of code 
> paths in the sd_zbc.c code that can be triggered with the scsi_debug driver.

You lost me... I do not understand what you are trying to say here.
You patch as is repeatedly sets devid->rc_basis to one for every zone in
the zone initialization loop. Not a big problem, but not necessary either.

> 
> Thanks,
> 
> Bart.


-- 
Damien Le Moal
Western Digital Research
