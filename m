Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 590D1C43334
	for <linux-scsi@archiver.kernel.org>; Tue, 21 Jun 2022 22:13:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229868AbiFUWNA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 21 Jun 2022 18:13:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230194AbiFUWM4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 21 Jun 2022 18:12:56 -0400
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20C19E19
        for <linux-scsi@vger.kernel.org>; Tue, 21 Jun 2022 15:12:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1655849573; x=1687385573;
  h=message-id:date:mime-version:subject:to:references:from:
   in-reply-to:content-transfer-encoding;
  bh=2YdjSyXdtAlPmAv8WQhydNn+Hsj90wFDk7YivN/TXZU=;
  b=lHTjZnTeBhyUHvoP5zKoVYavRnhzvOWMwGCUMBOnY5uFl7AkOYWy3qut
   pAiocBJJjEwpzgBgT39CQ0Ob/Yjdx1b+ync7NnvmAM33uu5ATcz/rVd2b
   PydXwk5+KfaUxMCM+72kTGuK0ggKcgWrWomkgAkFFeJW2GCTo4aAB7kFw
   lzZfWEfVvWcujCc3K+MAQ71UtjM2GdWkavJMLOeyFFHRMowRcxbNc2mgc
   KVvuQkENz7pHLHzA83N7bqwtvp8PGZCI4X1XcMqrsbrXNN2nY6eLh/BJ5
   MtKdKzZWKBOM0fVoyGD3UFt/Sz8OZ8wU7eOHD613oQS2+KwfMczISpFyU
   w==;
X-IronPort-AV: E=Sophos;i="5.92,210,1650902400"; 
   d="scan'208";a="203760188"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 22 Jun 2022 06:12:48 +0800
IronPort-SDR: yTiVyxQQ9yEYhaCivTGXrloLDrXlAnhb67s4v8XzlRDizFf7GRk1wGS/IiMII+/Sc9uBfww6RN
 Ny9P6vV2M4JQ8Rp+IkMb+LJcpret2xpBzL2HdDVFhfWmLbYgk1KOunWyPoLkaDzZxV1pok67wB
 Hl3zS544SO5jILANuycMPfpJLrCaHMgm8qRpwkikTQXBL6RhVA2Lftk/b8ROsaETJXCF698H3u
 PJjbIRdu8TKECgfvEsoDsRWFviEKESN+w/RFYU4gPqbxbO4xxO9ghOy/dMxfU2wrVayseAtw9z
 XSpYYNhDVpy6Lade9iBtdpLe
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 21 Jun 2022 14:30:55 -0700
IronPort-SDR: 0MXnQ/p2Yta/gDV34oAEXHkf9oltSsyB95DGE89Zh9v6d/YQkWRHLFidplOGTBc1CJIG26vrO5
 M//88OzScfBgn8rG/D0SZoPGd/joafcugu6CYLiIB6fQgigeVviG+mvwyEVRST1YkF1UfGgcHR
 0uIGBLCVfaHvjwUh/LQ0E8tjex0KlWPnvfczX/XnKUJk0bWub8qd7wQh01SYUWPJ4J7bvPK6gE
 xcgPS1q2t7fbyEBhzP0pWqdz47h1nTGvOgwsWk/VoA0nkcwX9pmpo7wtf03YQc6ou1S0IcelNm
 bJA=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 21 Jun 2022 15:12:49 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4LSLNv66Bqz1RwqM
        for <linux-scsi@vger.kernel.org>; Tue, 21 Jun 2022 15:12:47 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1655849566; x=1658441567; bh=2YdjSyXdtAlPmAv8WQhydNn+Hsj90wFDk7Y
        ivN/TXZU=; b=jyGUb+1DDZcEATwAD6vKSOoTaTw/HRqDLTXBGFzFvtSQ2djp+2c
        80Q9vZYattEAF5m9XKR52BChG39Bcs+i4IbGxeT0UhkLuU2E6+INX195RIH6kDiN
        WL9HDcZqF83egXL8UZoKkiFDol7aEdjcTp6oq6vyUaz/MAPcOa6XJRuVygkIIQN/
        ff/tSakfaw/bfQmYTxrQjTwN++xOCw075XEJJsdYPNkGSSaUZANyH/nPINMFXe7v
        A3ml6ZjLnP9ut2sVvXM3Ingg/ff3BIheKn1phL9yQm4DxtW5DFthPWpbO9HPFzTA
        93GG/BAqNz2tvhAEQwAzKEripfwL92KI3fg==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id LEMqrwiJN4BE for <linux-scsi@vger.kernel.org>;
        Tue, 21 Jun 2022 15:12:46 -0700 (PDT)
Received: from [10.225.163.90] (unknown [10.225.163.90])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4LSLNs69w1z1RtVk;
        Tue, 21 Jun 2022 15:12:45 -0700 (PDT)
Message-ID: <369448ed-f89a-c2db-1850-91450d8b5998@opensource.wdc.com>
Date:   Wed, 22 Jun 2022 07:12:44 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: Do we still need the scsi IPR driver ?
Content-Language: en-US
To:     Brian King <brking@linux.vnet.ibm.com>,
        Brian King <brking@us.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
References: <a5a3527c-d662-5bd1-e1dd-ad4930d10b3a@opensource.wdc.com>
 <3dbd9ae4-a101-e55d-79c8-9b3a96ab5b17@linux.vnet.ibm.com>
 <be79092f-fdd6-9f0f-4ffa-95ffc4b778c5@linux.vnet.ibm.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <be79092f-fdd6-9f0f-4ffa-95ffc4b778c5@linux.vnet.ibm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/22/22 05:52, Brian King wrote:
> On 6/21/22 3:36 PM, Brian King wrote:
>> On 6/19/22 11:48 PM, Damien Le Moal wrote:
>>>
>>> Polling people here: Do we still need the scsi IPR driver for IBM Power
>>> Linux RAID adapters (IBM iSeries: 5702, 5703, 2780, 5709, 570A, 570B
>>> adapters) ?
>>>
>>> The reason I am asking is because this driver is the *only* libsas/ata
>>> driver that does not define a ->error_handler port operation. If this
>>> driver is removed, or if it is modified to use a ->error_handler operation
>>> to handle failed commands, then a lot of code simplification can be done
>>> in libata, which I am trying to do to facilitate the processing of some
>>> special error completion for commands using a command duration limit.
>>
>> We still need it around for now. IBM still sells these adapters
>> and they can still be ordered even on our latest Power 10 systems.
> 
> At one point I did look into modifying ipr to use an ->error_handler.
> I recall I ran into some issues that resulted in this getting put
> on the shelf, but its been a while. I'll go dig that code up and
> see what it looks like.

Thanks. It would be really great if you can convert to using
error_handler. This is really the last ata/libsas driver that does not use
this.

> 
> Thanks,
> 
> Brian
> 
> 


-- 
Damien Le Moal
Western Digital Research
