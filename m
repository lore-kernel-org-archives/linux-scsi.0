Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3E880C4332F
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Dec 2022 05:32:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230364AbiLLF1J (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Dec 2022 00:27:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54046 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229839AbiLLF1H (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Dec 2022 00:27:07 -0500
Received: from esa1.hgst.iphmx.com (esa1.hgst.iphmx.com [68.232.141.245])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9A8B9BC92
        for <linux-scsi@vger.kernel.org>; Sun, 11 Dec 2022 21:27:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1670822826; x=1702358826;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=8A0XaoicbJmiJ9RD5wYJmmGOJ407IzJfDwOJefYMwBQ=;
  b=BaImY8UU8LGSHLszM+Z6Glxd9kZlnDy5L37BlTsJMvfyYo4SR2KqSx9R
   TTEFW5lDzmeY8PgqC810eCkPxBO93KWOYmUfKWyYjDzxE1aJlqada10sg
   d0aftJFUHPV2h2zL1V+fTZvr0dIOMJZnxuUp89IDg3cu4YhiaUZ9geJD1
   7qcT3ozPEZ6LgudJX+bKVMGkI3LgTXlXwLuD6nObABeFZmX5zDarQyrXW
   bUMnPI1g8ZsR5oNcki9K90G5D9QoRkp/5aZROm+rYgBU/Wm9j2o+Ktk1a
   OHsILVnl7EE9FJ7wwDrc4jj2ZrHc0E2UpVUt74F/DafQ9tYtDlK0Vc8be
   w==;
X-IronPort-AV: E=Sophos;i="5.96,237,1665417600"; 
   d="scan'208";a="330504855"
Received: from uls-op-cesaip02.wdc.com (HELO uls-op-cesaep02.wdc.com) ([199.255.45.15])
  by ob1.hgst.iphmx.com with ESMTP; 12 Dec 2022 13:27:06 +0800
IronPort-SDR: vLcERAdBdURtpi+pdbznCe6txLEnmV3x6+IccPiYRpohp2srsaxAbPU21jn6Gdp4VYnqxsvfkB
 0Fyu962S3r3j76jo+klcI/oNFG/21bGLrwQUL+oJaBWdkd7SjwzFUyheiqKIy3tU2EWeDLfAuz
 Ke8I+PfjqgZXM7mQFX0gWZaNHeRaYOVd5lIMM5t0COYUBLOds+sCZ7EkH1hZRZukfSeVDchnVe
 FAg7Hc815309NagFmm5mapQ959Bs5QhLzUGxo5JLeBFTbYrg0bsnFOdyHunaPKAyOd8JVNBV0S
 6kQ=
Received: from uls-op-cesaip01.wdc.com ([10.248.3.36])
  by uls-op-cesaep02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 11 Dec 2022 20:39:46 -0800
IronPort-SDR: r+CUT/2OBhC16h3kc+thKoCf3r3BWADG5qLCRefBTtThrotsjwn/G2sirQ3E2jV4iPStptbMk4
 ZRO2u1nW0xJ29a88SRrXW+Oh+KnIlnsi+HQKgvFTXlnKNAodEcBL6bmIPgOKdPCASPnwxDEzap
 LMXtC2oZ2wtGKETA6BuOhlotE3dEiu26LWz796rgKsHohTCgIcfcoqB8rtKKmrEkq47Kliyx6M
 2PQ/nWhMah/HgHMEFMl2n4mHh8fd4snGHdCmD7j5Czzkk7TwAhNU3nH/7P5tBNBP6GG/iZ9LD/
 WY8=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 11 Dec 2022 21:27:06 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4NVqr91MRJz1RvTp
        for <linux-scsi@vger.kernel.org>; Sun, 11 Dec 2022 21:27:05 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1670822824; x=1673414825; bh=8A0XaoicbJmiJ9RD5wYJmmGOJ407IzJfDwO
        JefYMwBQ=; b=WM8qa6ad0ye9aU5U+X+zFaFKWkDbMpAaqIK1hFJhC5NRNopUVU8
        djSsT7X/eyJFLycvRsuCCPJY1XWXW+AiG1/YmqTILu0mm4tXK+JuMq6Iynk/JNPQ
        WwS/GRXz9tKeLALn/wPm0LtXJTd8H1jVAc3SUeJmvDOc2g/mimqFWVJYkipOZ70H
        eR5rOl0AkHgZG2NYO3oFouLNg+3saGGTLZZsS6GC2r3x64o91WvbunhWl06WgI6S
        kTmPWj/ZsUx/iQhuCtp1vqulHSridWZoN+7KvzKKP8KZS+WkbzM/c5A5ADS4s2o9
        aiNfYaNCKZ7vrV9QF/1tqOAPynXf6Y54E/g==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id EKWvL_XhAT84 for <linux-scsi@vger.kernel.org>;
        Sun, 11 Dec 2022 21:27:04 -0800 (PST)
Received: from [10.225.163.90] (unknown [10.225.163.90])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4NVqr72z8Rz1RvLy;
        Sun, 11 Dec 2022 21:27:03 -0800 (PST)
Message-ID: <9768526f-5f14-6851-1d93-81d4a0fc8565@opensource.wdc.com>
Date:   Mon, 12 Dec 2022 14:27:02 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH 1/3] scsi: mpi3mr: fix alltgt_info copy size in
 mpi3mr_get_all_tgt_info
Content-Language: en-US
To:     Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        linux-scsi@vger.kernel.org, mpi3mr-linuxdrv.pdl@broadcom.com
Cc:     Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
References: <20221212015706.2609544-1-shinichiro.kawasaki@wdc.com>
 <20221212015706.2609544-2-shinichiro.kawasaki@wdc.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20221212015706.2609544-2-shinichiro.kawasaki@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/12/22 10:57, Shin'ichiro Kawasaki wrote:
> The function mpi3mr_get_all_tgt_info calculates size of alltgt_info and
> allocate memory for it. After preparing valid data in alltgt_info, it
> calls sg_copy_from_buffer to copy alltgt_info to job->request_payload,
> specifying length of the payload as copy length. This length is larger
> than the calculated alltgt_info size. It causes memory access to invalid
> address and results in "BUG: KASAN: slab-out-of-bounds". The BUG was
> observed during boot using systems with eHBA-9600. By updating the HBA
> firmware to latest version 8.3.1.0 the BUG was not observed during boot,
> but still observed when command "storcli2 /c0 show" is executed.
> 
> Fix the BUG by specifying the calculated alltgt_info size as copy
> length. Also check that the copy destination payload length is larger
> than the copy length.
> 
> Fixes: f5e6d5a34376 ("scsi: mpi3mr: Add support for driver commands")
> Cc: stable@vger.kernel.org
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> ---
>  drivers/scsi/mpi3mr/mpi3mr_app.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_app.c b/drivers/scsi/mpi3mr/mpi3mr_app.c
> index 9baac224b213..f14556d50832 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_app.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_app.c
> @@ -322,6 +322,13 @@ static long mpi3mr_get_all_tgt_info(struct mpi3mr_ioc *mrioc,
>  
>  	kern_entrylen = (num_devices - 1) * sizeof(*devmap_info);
>  	size = sizeof(*alltgt_info) + kern_entrylen;
> +
> +	if (size > job->request_payload.payload_len) {
> +		dprint_bsg_err(mrioc, "%s: too small payload length\n",

"%s: payload length is too small\n" maybe ?

> +			       __func__);
> +		return rval;
> +	}
> +
>  	alltgt_info = kzalloc(size, GFP_KERNEL);
>  	if (!alltgt_info)
>  		return -ENOMEM;
> @@ -358,7 +365,7 @@ static long mpi3mr_get_all_tgt_info(struct mpi3mr_ioc *mrioc,
>  
>  	sg_copy_from_buffer(job->request_payload.sg_list,
>  			    job->request_payload.sg_cnt,
> -			    alltgt_info, job->request_payload.payload_len);
> +			    alltgt_info, size);
>  	rval = 0;
>  out:
>  	kfree(alltgt_info);

Otherwise, looks OK to me.

Reviewed-by: Damien Le Moal

-- 
Damien Le Moal
Western Digital Research

