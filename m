Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 74B33C433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Jan 2022 09:06:10 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352821AbiASJGK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Jan 2022 04:06:10 -0500
Received: from esa3.hgst.iphmx.com ([216.71.153.141]:53005 "EHLO
        esa3.hgst.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1352816AbiASJGJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Jan 2022 04:06:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1642583168; x=1674119168;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=0CocAx8tlTLs37GwRSP9HoDppNe7iSxiXWXBeB57nyQ=;
  b=oE37/atnsWJyWTvF4bwEDSiDtCIcjqyXhXRH1uRUtW0Qn+pqDGTqeLJQ
   CbHhX+OliWP0bzCB17NLp+JbRvRk6lprpEBZtACcxfhP6vBMpNtmwPYqp
   SVlTaRZWKI9X7iRZN9iHQfuWadY+z7LoAQwCEYsGxHnmr7lK5jS57/6Fy
   8/WyK42vfz02eodeFolzX4GYuLpnNq5ybwX5FAuYUUjwhJwM9dai9BfoF
   KR0D9uNbJF03nCwV1bQN2FfVsd7C+EPjDJriPAAXX23tZuoc8MM7Y1G/p
   +Ump8RZQJSks6/bv5NIgj6L69TElQIV3+N7WZM4Oh4cB4OkOC8Pj9qFbU
   w==;
X-IronPort-AV: E=Sophos;i="5.88,299,1635177600"; 
   d="scan'208";a="195629005"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 19 Jan 2022 17:06:08 +0800
IronPort-SDR: +icRcKrPSmeuHJBQUTY/XEIet+M1zabvyGEHmTyFZCZipp83NOV4b4Suo4GcJAnM+H1veeLdS4
 Dtg3WuvGi1WwDUz4z9dZ/c2ZwYwAbAaUow7gXImQEbRRBtQZcQAxmOhG6mZhkRUzJ0AxrkAW9/
 EX5JPDb/YI2P5GmDCvw9cLgdUQBuw9MBGu1WNSPt7r6iqcyxEqKZLoszntrTuqp8H8nJedGp+R
 S78nV/XOcLbdrb+cG6eWVMgf9mLobO/UckS4BsXjp2U0ExVer0twioURngcVFuAy145FQBDFr0
 LqE=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2022 00:39:34 -0800
IronPort-SDR: yMglCFfmha+5fJJ15zuAuE3UWtd5ql50RUUaZDHNAVf/eMhM9xXvZDht3HAF4aKTG60WXuMV7K
 re2jkikTDH6fklaabN81e688zBd2j5sIV7okFik/lRyL62TVYzJS7ltlt3tSFQpof+hTnI7ob9
 5UA39KSOgDewebv10bBFVlRK2ZGraL39gkYqIlVse6xOxUuUNW1MzOXP4lOmU3w6Yt1WMEJ88w
 UM36XAAoxGiDsJFgcdKFLf0hO5mLWAs1s+t/9RG7YLIuodaQkY3YOWkchkEtuyLp1q8/fJOEkg
 8aQ=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Jan 2022 01:06:02 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4Jf09j5kkRz1SVp4
        for <linux-scsi@vger.kernel.org>; Wed, 19 Jan 2022 01:06:01 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1642583161; x=1645175162; bh=0CocAx8tlTLs37GwRSP9HoDppNe7iSxiXWX
        BeB57nyQ=; b=XsdieHxHC/4GAplLkJXyKj2FCVpFsEPmpaL1sYu5J6TxPT16IU/
        09rP+Lts2ZwOfEOLmn8jJKmv3yQTdQPZMBhZI9GUcbVNMX+R0cVEIq7nuQaYYrz9
        bhtQoTkbtuhmlEgQk/EfscGvy7KBS6jASQnGgjZrZUyN4+Bo+VHavht45vhYDI6L
        EhCQMj4nRZtLP2YVrSllvQFXbqt09sJBpXanjYkmhovfRJYg2LQWOyqMg88cAUIK
        smXn5OdkgxdFrB4e+lLJfmoCv8SrGAnTxX6bVK9GTNglM815rHm+C4LHQbjc0/oK
        sUOPtw9yPJ1v8Su8PD6S9uJn0IuiJzmTFhQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id UGrWKgT3sGw3 for <linux-scsi@vger.kernel.org>;
        Wed, 19 Jan 2022 01:06:01 -0800 (PST)
Received: from [10.225.163.50] (unknown [10.225.163.50])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4Jf09h1sbbz1Rwrw;
        Wed, 19 Jan 2022 01:06:00 -0800 (PST)
Message-ID: <9f5428b2-4d36-29a1-ef1a-d544cec25bd7@opensource.wdc.com>
Date:   Wed, 19 Jan 2022 18:05:58 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH] drivers/scsi/csiostor: do not sleep with a spin lock held
Content-Language: en-US
To:     cgel.zte@gmail.com
Cc:     chi.minghao@zte.com.cn, jejb@linux.ibm.com,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, zealci@zte.com.cn
References: <f68657d6-027c-c842-ce35-5524cd782c7e@opensource.wdc.com>
 <20220119085754.932168-1-chi.minghao@zte.com.cn>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20220119085754.932168-1-chi.minghao@zte.com.cn>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/19/22 17:57, cgel.zte@gmail.com wrote:
> 
> The might_sleep_if(gfp_mask & __GFP_DIRECT_RECLAIM) in the 
> mempool_alloc function uses __GFP_DIRECT_RECLAIM.

But the call to mempool_alloc() specifies GFP_ATOMIC, which does not
have __GFP_DIRECT_RECLAIM, so "gfp_mask & __GFP_DIRECT_RECLAIM" should
be false, and the might_sleep_if() not triggering. How can you see the
might sleep warning ?

-- 
Damien Le Moal
Western Digital Research
