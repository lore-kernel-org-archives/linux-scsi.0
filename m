Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 78B98C433FE
	for <linux-scsi@archiver.kernel.org>; Thu, 10 Nov 2022 08:31:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232107AbiKJIbL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 10 Nov 2022 03:31:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229960AbiKJIbK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Nov 2022 03:31:10 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCC0FA47D
        for <linux-scsi@vger.kernel.org>; Thu, 10 Nov 2022 00:31:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1668069066; x=1699605066;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=saaMzcNsEeCTmfojMfKgKb6MSQKlOF/ZRAAPV9jGrqI=;
  b=mT/kaiA7cF4Yb1VF8UDDT1AD1FsjJ7XqNi/FLpvENhuAY80DHxR0q0A9
   km3cyuRJir4bqYXjFom7Mqdc4t331lDDMY2uLdonQXtXEvPZui56ix9bP
   9MmWLzJntphBkdYT3gwV7J0XZBr81BcCHhHAyltPjd3lKOfDVHzFlA/0U
   /c1SHeSK+oTELnZjObGVyNuv5lw/DBWbW/Y3xyxWI8GXuu3lTggegnLkE
   +cAvmCDx3Y2BpfJbVBTwvB+CDd4Nm7BbbDlow0QbLcmHzwVyyeMBs1b5n
   P0FxQYVi5Sd7u2PMPmul2k3SMcJTWGKaG1szSxevI1/NC3GCXPWqvSpTW
   g==;
X-IronPort-AV: E=Sophos;i="5.96,153,1665417600"; 
   d="scan'208";a="215938908"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 10 Nov 2022 16:31:05 +0800
IronPort-SDR: I5M+QttdJ9jtDfv9WDw/nMUxo09rD9i8H1kNnmuEdPFOu2/pDyDZ8D6+eFNeBGIeUxN4L2rE5+
 STMmXNicieAfxmeV7yvxQwP7cwjAMTe0p6fHIeadB2EDCoGpN+YDYzry7ONNuCvBEaUe/sAokF
 47dRkoH84PQInvKInRgfYPKxYtbYC+HiovCH87YGFbboohfyZA6Dq76ONG0xrdpAdziHsv9eBD
 tee5zUhXTTacuVU0HjftBqI/RVX/O2Kf40Fwioaa+f4kL4BPzkWkNmL7IKhRhfsMmE1gobBVAx
 WEQ=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 09 Nov 2022 23:44:24 -0800
IronPort-SDR: DNnu8uK37fZDqD6CNWyl5U4NWTjL4YkNtZL/TD5Q2502hTdqx+JsydiqPuTVQN96TsKSx5po2J
 TKs4yc9FTAxRwNy8ypMtXT1WH8FNAqz420emz9T7FF/Ov6cUhYS/cqIkXwfX1TP/wb7+WUrMXh
 LRaBPUH8AmpaU0Gzn9PpI979OWu23s+9sn8LpCEbFRRao4EqW5WQyoE7G7i0kZkrUTpwEdTOvs
 ftzkBZ9WQBFFQybSxi4shxlo53PX0+7Tv0jl+kdVKVASZJ23/BS8ct+paO6Z2YH+ZfpD1uarEg
 1Qg=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 10 Nov 2022 00:31:06 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4N7FRF3774z1RvTr
        for <linux-scsi@vger.kernel.org>; Thu, 10 Nov 2022 00:31:05 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1668069064; x=1670661065; bh=saaMzcNsEeCTmfojMfKgKb6MSQKlOF/ZRAA
        PV9jGrqI=; b=c47gOUrrn1hKJ8X3TrqVdj3V0LN66ujMhve9FxEQ6OxHB1If8YM
        XVKUXddAsKGI4XAKwho7JUaPX+dFgae1p9rPSKhJ9aW08D/ALHUcCUs6skzZaNGT
        3y5Kl+6/ADcRyVr1ziYXSSMslK+vMj173dw7x/ozq+SuqcFbzo+m05F0hQNpAEWd
        mnuu5t1By6aKrYGzPJmVt30IwS1Zk96MzAuYPr4d9rlbOPD1yLPNEJPWum38SbRf
        jAwZxnlgIK7CyTNmNz0M9lF5ZY65N2IBkkh+8OuwyJudxqRvUQujfvxYStEej4MV
        c7CMiCoJ/z08WS/tOzq+iAX8oIq27KFrniQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id jxz87lVFzDHx for <linux-scsi@vger.kernel.org>;
        Thu, 10 Nov 2022 00:31:04 -0800 (PST)
Received: from [10.149.53.254] (washi.fujisawa.hgst.com [10.149.53.254])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4N7FRD10gSz1RvLy;
        Thu, 10 Nov 2022 00:31:03 -0800 (PST)
Message-ID: <797133cf-ed12-233e-8148-a08bf1261a35@opensource.wdc.com>
Date:   Thu, 10 Nov 2022 17:31:02 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH 0/2] scsi: sd: use READ/WRITE/SYNC (16) commands per ZBC
Content-Language: en-US
To:     "hch@infradead.org" <hch@infradead.org>,
        Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Cc:     "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Dmitry Fomichev <Dmitry.Fomichev@wdc.com>
References: <20221109025941.1594612-1-shinichiro.kawasaki@wdc.com>
 <Y2ue2rZzf74/1V+U@infradead.org> <20221110022009.xdfmlpdpw2kyu32x@shindev>
 <Y2y0AhBCm+O4HoRg@infradead.org>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <Y2y0AhBCm+O4HoRg@infradead.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 11/10/22 17:19, hch@infradead.org wrote:
> On Thu, Nov 10, 2022 at 02:20:09AM +0000, Shinichiro Kawasaki wrote:
>> My point was to make the check strictly follow the ZBC spec. But now I see that
>> it's the better to keep enforcing 16 byte commands to host-aware devices. I will
>> drop the first patch and revise the second patch to enforce SYNC 16 on both
>> host-aware and host-managed devices.
> 
> We don't "enforce" anything.  We just don't send the legacy commands for
> devices that are guaranteed to be modern.  What is the advantage of
> ever sending 10 bytes commands (inluding SYNCHRONIZE CACHE) to a modern
> device?

The ZBC specs define SYNC 16 as optional while SYNC 10 is mandatory. So
the device may not support SYNC 16 and we would get an invalid opcode
error. For SYNC, no advantages between SYNC 10 and SYNC 16. Not even
sure why they both exist. The point here is making sure we use the one
that the drive MUST support. That is, SYNC 16 for host managed and SYNC
10 for host aware (but these likely all also support SYNC 16, but we
cannot be sure of it).

-- 
Damien Le Moal
Western Digital Research

