Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ACE96C43334
	for <linux-scsi@archiver.kernel.org>; Mon, 20 Jun 2022 04:48:07 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237902AbiFTEsH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 20 Jun 2022 00:48:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229908AbiFTEsF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 20 Jun 2022 00:48:05 -0400
Received: from esa2.hgst.iphmx.com (esa2.hgst.iphmx.com [68.232.143.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1DB4113C
        for <linux-scsi@vger.kernel.org>; Sun, 19 Jun 2022 21:48:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1655700484; x=1687236484;
  h=message-id:date:mime-version:to:from:subject:
   content-transfer-encoding;
  bh=Fp1YV/H54fWKae49QTYpj5CNXERWqHTEkZJXLZ2XPUA=;
  b=lz3eZR+GQA35Py06Vle/BcmqZ5eeVS9r/CiI6mwJADk0EQXmGPhm6p6s
   2GbiXM6/89cK1BjlsJ2xWIkn4JtyFaNv91RKA6BcDsIYIRlg2QAhBIWD1
   orJy/J10NLVE1o5QBkhLToeto5mu6VhZvVncTmhCJdv72/DGfF/rjuby1
   0AaHP1UnwBTAukScg0Lfkgh+rAqNMMWIR/0w3svBRqVM8cyElh8NEZQxO
   qCPmowZ/RCHlRCm+MYcWeGC1kauYZgZ9lPrRSHc88BikDipIHNeYvsFdD
   e/eRvxuQnWB29vMpsctsBcUNURESjUI0HUCECOsy4zIsSMQ0IBVh9c/d2
   A==;
X-IronPort-AV: E=Sophos;i="5.92,306,1650902400"; 
   d="scan'208";a="307907155"
Received: from h199-255-45-14.hgst.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 20 Jun 2022 12:48:04 +0800
IronPort-SDR: UcO87NTxwaSvqaSCWK0i0H1kDuAPJ3h9BOJvMgzPT4ln1x2nBt3NU4drxivncK8p2n7KjIdkjQ
 EWCLRYGpXAtPoswMgbA6E3nscCDIpt0ongIhJpmMP3o7au8xJbr7ytort3+0jg2eq819ZkBkWQ
 2hjmGrFHwJ1u8Zb9C7c3JFPcGdFJq0rEebtcfk8wptmMZ1G3Dv9Bk9UQdu2ujmYrVZBmDNv0F9
 w5ePSd1/UI1NM8qQzQokz6bgdv1CrcrUoQtuHlwnCLsW60HZFnO1zZXhWD4X8he/2FEZP7QNec
 4Ioesi1OncpEyB5prcIdhnKK
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 19 Jun 2022 21:10:36 -0700
IronPort-SDR: 6UgWwxH4vrkCtgyXnG8W/kMEAKqjNlX8MkvBz44JkPIuimxINxGuPCL3w9DmJbvc8gGsqchp/e
 45VCBZWQ1TspLuZv7QEKopq8l5VkXUhx1qF1uVBsziBhG0n3RpILjdSZ9xYpMxvKoSp8wY+1IY
 6sJZdSznMwF4CMGHjzJiqbcTibL409mUF7ejD6kNiFXNG00KmkwOA40IPi4pWZne06j94R3BuS
 LP1wFJKoMcmnoRrkw/IeZ/8yclLdjmKP8Z5ZYcqZmC2cfy7SFxLdKGGd4bcufR3iOhNLYKylBx
 JJ8=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 19 Jun 2022 21:48:04 -0700
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4LRHFv54Knz1Rvlx
        for <linux-scsi@vger.kernel.org>; Sun, 19 Jun 2022 21:48:03 -0700 (PDT)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :organization:subject:from:to:content-language:user-agent
        :mime-version:date:message-id; s=dkim; t=1655700483; x=
        1658292484; bh=Fp1YV/H54fWKae49QTYpj5CNXERWqHTEkZJXLZ2XPUA=; b=b
        Gqd4TEb8JP+lCMu8J3DFzP3uENPdLUsVfqp6+PJFvvRZmAbdDCR8By4r3RZH+0LD
        xlDjJE/vvMm/3q+P8KRt9qrULDhZhKY3Knql9QKE980Ovx66+2IsAiWEqTO/2Ou2
        2imQb4fchUMiCtYfjPRTdyJn8dWhAKbZmJfEWwA04LvYyF3Up+Ws+sC7FlkzAXv4
        pAJWadaWP1xzegB5fjGuM/rOupEhixpIDxfWTqCBaHnyHo0s8pDzrVHbT9W28whw
        oYQeoqcuFZy91vMCy6CXdfARKM7wmDdQuA4z2sWzZ69mCYcRAZWoIkr6YJeK/qTT
        d5K7ydPOS7Xkd9q0MCPyw==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 8VwTb4OzMXSy for <linux-scsi@vger.kernel.org>;
        Sun, 19 Jun 2022 21:48:03 -0700 (PDT)
Received: from [10.225.163.87] (unknown [10.225.163.87])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4LRHFt55WDz1Rvlc;
        Sun, 19 Jun 2022 21:48:02 -0700 (PDT)
Message-ID: <a5a3527c-d662-5bd1-e1dd-ad4930d10b3a@opensource.wdc.com>
Date:   Mon, 20 Jun 2022 13:48:01 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Content-Language: en-US
To:     Brian King <brking@us.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Subject: Do we still need the scsi IPR driver ?
Organization: Western Digital Research
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


Polling people here: Do we still need the scsi IPR driver for IBM Power
Linux RAID adapters (IBM iSeries: 5702, 5703, 2780, 5709, 570A, 570B
adapters) ?

The reason I am asking is because this driver is the *only* libsas/ata
driver that does not define a ->error_handler port operation. If this
driver is removed, or if it is modified to use a ->error_handler operation
to handle failed commands, then a lot of code simplification can be done
in libata, which I am trying to do to facilitate the processing of some
special error completion for commands using a command duration limit.

Thoughts ?

-- 
Damien Le Moal
Western Digital Research
