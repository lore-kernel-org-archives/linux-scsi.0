Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3F1A2C4332F
	for <linux-scsi@archiver.kernel.org>; Tue, 13 Dec 2022 04:12:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234004AbiLMEMd (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Dec 2022 23:12:33 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230002AbiLMEMb (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Dec 2022 23:12:31 -0500
Received: from esa6.hgst.iphmx.com (esa6.hgst.iphmx.com [216.71.154.45])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06FFC186C0
        for <linux-scsi@vger.kernel.org>; Mon, 12 Dec 2022 20:12:29 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1670904749; x=1702440749;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=NC2B84pVBoszuStc0/iPeIDMhkkCV4nFHNs4FsoN4qE=;
  b=pSVcutkVy4xTNfsCn83hcG+bB6xKj2j1rAaGkivkVFckg9stP2gBUzTs
   goXtFakgCZKxKXyGbPVuQJBC9f4/No9+mubDYQ3VM5fb0uP6sjQXeT8fN
   WhzfBvUOa/MSUFavdt5LbTrDc3aNw2c26LleMMU+2WBLpoiLLrzMbgxA8
   PbXoiKAap73Fhtkof+1i0L5kSuo0LvhtvX4Y06NUoa51+zJH7cw9B7e/s
   8UlMUR+n4ChxMLtRhjUsoz+AslhyYXkt0it42gNmqD2fyvf2gtXK94sav
   NJqLuBUZB8zYEp13z7JxH3GGPNREu4xE6Idl1AexBR5zsjZ/qUK4kUZLg
   w==;
X-IronPort-AV: E=Sophos;i="5.96,240,1665417600"; 
   d="scan'208";a="218761442"
Received: from h199-255-45-15.hgst.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 13 Dec 2022 12:12:28 +0800
IronPort-SDR: 5/sJg8+KwxEAY/BBPMAar7q+jkI5u2ly0+CttNd2vWRazSKRWYRavyozvPFbrwIGXeUj3x/pV/
 QBxjd3McX3BycYiPYDuNk/C25S4taldAEkD92Fm9+rwNnUmnqWHE8wfyLa7+NlISvbm7ofwkKa
 Zjv21tBEyQwmP6ISIXHOTRj+o8xuBDa/w7WWQDdBdLGODWQ7pqHtq6jRfJmatJSqqhIZh7ouok
 jeIliDqshI7lJO5OHxEMKCm6eFl9vPLoBJuDExnYVDK/kaaIOj38OkqubfnQ2t5Dwas2IfNFvS
 ZlY=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 12 Dec 2022 19:25:08 -0800
IronPort-SDR: vLPec2t5UqNiuJwW39D22EaehUrL5qOzW0rB+MHL3F+Fx03IHMb/euyWsGEk4gIMRBrpOMATIv
 AYlpixl9qn6lth0lho3de2IB0CK1ou43i1hZsN5+uCxEo4xwx1nY7bZUaeQYd08+gUoELadnkF
 qoAyA96dsTLyTV3D7ISEqVw+aT9OakpGT1LhjTIVrkHkrte2QlpH8teebDR+QWQNt8tnwH+7ld
 mVEU/sChDCQO+EtL/YOZh9y/m7h1XduDqm7ixg7ZWz3ikR+kKGxyU8J5kbyp+pdU0widZODIfw
 muk=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 12 Dec 2022 20:12:30 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4NWQ7c3xPfz1RvTp
        for <linux-scsi@vger.kernel.org>; Mon, 12 Dec 2022 20:12:28 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1670904748; x=1673496749; bh=NC2B84pVBoszuStc0/iPeIDMhkkCV4nFHNs
        4FsoN4qE=; b=RU06Dycp6obVNTDMoRY0hjX2ueWZg9bbx0BAK+OF1IMYXeYF8BR
        auzvWCVdw8mUoQbqQC/D4Vgu9WbmUlrB3sWZAikBrdqg+VypjVF07cd2XOyByWwp
        HifH2Vt7RDD+ldY/Tp7JEwYdf+kgucHkGaFl6NEnarTKDZT2xCEZtCCaWph4T7eG
        nGsUUteyud6HyVQJdyGmX8Oi+nQ4BwlxdaXUM/nOCIPT9sy6QXAcR7R+GRfnVloU
        CnvPjONJ+mzIdjwQF64D3C4F7Q7+yETTUpjj7O6H+xfit3r7JgS/6vp0ZJ4STxX6
        CpCown/WHy23PeKUecYBeDcZBQDIlLaFcFQ==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id 0VBXXvhpWaeD for <linux-scsi@vger.kernel.org>;
        Mon, 12 Dec 2022 20:12:28 -0800 (PST)
Received: from [10.225.163.90] (unknown [10.225.163.90])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4NWQ7Z5nmkz1RvLy;
        Mon, 12 Dec 2022 20:12:26 -0800 (PST)
Message-ID: <c744c75b-a37b-3610-218e-69f0cb8bc7fa@opensource.wdc.com>
Date:   Tue, 13 Dec 2022 13:12:25 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH v2 2/3] scsi: mpi3mr: use number of bits to manage bitmap
 sizes
Content-Language: en-US
To:     Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        linux-scsi@vger.kernel.org, mpi3mr-linuxdrv.pdl@broadcom.com
Cc:     Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
References: <20221213005243.2727877-1-shinichiro.kawasaki@wdc.com>
 <20221213005243.2727877-3-shinichiro.kawasaki@wdc.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20221213005243.2727877-3-shinichiro.kawasaki@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/13/22 09:52, Shin'ichiro Kawasaki wrote:
> To allocate bitmaps, the mpi3mr driver calculates sizes of bitmaps using
> byte as unit. However, bitmap helper functions assume that bitmaps are
> allocated using unsigned long as unit. This gap causes memory access
> beyond the bitmap sizes and results in "BUG: KASAN: slab-out-of-bounds".
> The BUG was observed at firmware download to eHBA-9600. Call trace
> indicated that the out-of-bounds access happened in find_first_zero_bit
> called from mpi3mr_send_event_ack for miroc->evtack_cmds_bitmap.
> 
> To fix the BUG, do not use bytes to manage bitmap sizes. Instead, use
> number of bits, and call bitmap helper functions which take number of
> bits as arguments. For memory allocation, call bitmap_zalloc instead of
> kzalloc. For zero clear, call bitmap_clear instead of memset. For
> resize, call bitmap_zalloc and bitmap_copy instead of krealloc.
> 
> Remove three fields for bitmap byte sizes in struct scmd_priv, which are
> no longer required. Replace the field dev_handle_bitmap_sz with
> dev_handle_bitmap_bits to keep number of bits of removepend_bitmap
> across resize.
> 
> Fixes: c5758fc72b92 ("scsi: mpi3mr: Gracefully handle online FW update operation")
> Fixes: e844adb1fbdc ("scsi: mpi3mr: Implement SCSI error handler hooks")
> Fixes: c1af985d27da ("scsi: mpi3mr: Add Event acknowledgment logic")
> Fixes: 824a156633df ("scsi: mpi3mr: Base driver code")
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>

Looks good to me.

Reviewed-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>

-- 
Damien Le Moal
Western Digital Research

