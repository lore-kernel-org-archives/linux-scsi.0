Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 307BBC433FE
	for <linux-scsi@archiver.kernel.org>; Mon, 17 Oct 2022 03:09:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231824AbiJQDJB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 16 Oct 2022 23:09:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231852AbiJQDI4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 16 Oct 2022 23:08:56 -0400
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 85AAC4B4B2
        for <linux-scsi@vger.kernel.org>; Sun, 16 Oct 2022 20:08:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1665976134; x=1697512134;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=zdGDit6VbajQE1JfRgF4jk9WK+KtUbNZ7NMxckSNG3Q=;
  b=p3FWDe96m8dOZR9YekDnFzI12HiLM5xGXLBQFGtLN9lHNW2iy27BKXQ6
   xJxHdzg2TjxHC/l4pWSBMTc/NfHZk/1/+P/kj1JRYROBQkczhcVYhvomD
   I6lm7Pp/xuRHiXBIi7iKkG6ZKxQQE18QY9/3Y6jgPxwMdufNfxM89ydpz
   u/LLVEwlQcjTA14YKpFg/Qephd79tQHwmglxu+hyyeC/dumUtHHllrC7D
   wCdBdGrP/QDUwpD72+NYtnAbMyDZCtCRIZraUJlG/qEGNc2IoCBvhvhoG
   QUmfshchtPqYNMAbSG545A0t/EMMfagUs2Du5MVx3DEKDMZ5wzT+cePK4
   w==;
X-IronPort-AV: E=Sophos;i="5.95,190,1661788800"; 
   d="scan'208";a="318297512"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 17 Oct 2022 11:08:53 +0800
IronPort-SDR: 1WmWm39YFY0EjpKVhNzvix377yJ/DDIcSfbUz9pWBppXPfyyl4sX+/2AvK38wDtHCWB2OhkZsw
 Ln0wIOmWTOyoa+slaClvt8m2DrYWoggwFaQRmEoxW+jP0d5PFONg/GsOSSfgCwT+NweOR1m4u/
 iKR5aExxhUSRaxCf8cWjdIyPProdTy9J1PNgaYdXs/Ds9pOWFmz571VEJExc3ZumyIVTA1VfjG
 poT7jxo+m6lWw6tQ/NPzE8/bdZMcx8MTuT8byAADhNmV9rM8LaZ3/k2Ombhc1OL8veo1M82TFC
 o8nHaDtt4FP/UZFMA48FWmcC
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 16 Oct 2022 19:28:26 -0700
IronPort-SDR: 9iNzetQFJu2sj/y5wZ+gwQvtYz+fA72b4et21JmYlglJYzgyEuitQ1sE+wcJdfTskDfXY0WGHf
 ppcq1xcPNqVlYqkoulC6Yrb5CWozEWeM4zdrrIByhZGjmNIydIP2U32LoaNtq94F+8no+x7796
 p7Zz7ursUEtxjamAzzhbfKY+YZ96XboQDMZhvOhydI0EtBUvyenhpcRb93dAlRB3iE5LVgbwxz
 sItU/bBa7pU8qz8t66S9J3QGgIGeSSDna1xis7W5f6bHw/5bIn0Nt0CQY+WWTN6D1hl+2nVV1L
 z1Q=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 16 Oct 2022 20:08:54 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4MrMQX6vSMz1RvTp
        for <linux-scsi@vger.kernel.org>; Sun, 16 Oct 2022 20:08:52 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1665976132; x=1668568133; bh=zdGDit6VbajQE1JfRgF4jk9WK+KtUbNZ7NM
        xckSNG3Q=; b=ZjEwAyMdNGzHVeUaWXQ7Fg40M6V/Bj2H70RM27rGazkNb9HpYXl
        cM0/xkV98aFUGXgI1u9WVhqgGhVCEXvSHl+fleZIq+UPJtWd4ncut0h9Tf5r08lM
        oNwC55QOgHzXNt7ZVa5t6X2pE7I+/Q88wRDaAADxDTw2cs0MoYICo46gf3WbH64A
        GrGdbgDcSFIMSSQ3gRPvptyhqaIjRocpjt3ciXLhrnCYORHviHERwhgbBLBYtDwq
        exdZXc0AN/seqm+sznpLJY9w+y/+YqlxMUQru1EQ3n0Mh4AJ25tr6gKyS9OuIrYN
        9oHn5NPBFHiPh527GA0hO2wobWrLbzzkEKQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 99lbr98yK5XC for <linux-scsi@vger.kernel.org>;
        Sun, 16 Oct 2022 20:08:52 -0700 (PDT)
Received: from [10.225.163.121] (unknown [10.225.163.121])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4MrMQW5VJmz1RvLy;
        Sun, 16 Oct 2022 20:08:51 -0700 (PDT)
Message-ID: <dfe6eea2-ff1d-efd2-7508-cbeb5f7abeb7@opensource.wdc.com>
Date:   Mon, 17 Oct 2022 12:08:50 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.3.1
Subject: Re: [PATCH 3/4] scsi: libsas: make use of ata_port_is_frozen() helper
Content-Language: en-US
To:     John Garry <john.garry@huawei.com>,
        Niklas Cassel <niklas.cassel@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org
References: <20221007132342.1590367-1-niklas.cassel@wdc.com>
 <20221007132342.1590367-4-niklas.cassel@wdc.com>
 <cfb9e10a-5d42-4c76-952d-dd1f871dab64@huawei.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <cfb9e10a-5d42-4c76-952d-dd1f871dab64@huawei.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/10/22 17:03, John Garry wrote:
> On 07/10/2022 14:23, Niklas Cassel wrote:
>> Clean up the code by making use of the newly introduced
>> ata_port_is_frozen() helper function.
>>
>> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
> 
> Reviewed-by: John Garry <john.garry@huawei.com>

Martin,

I can take this one through the libata tree as that would avoid test build
errors. If you agree, can you send your ack please ?

-- 
Damien Le Moal
Western Digital Research

