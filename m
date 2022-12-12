Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F4140C4332F
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Dec 2022 05:35:37 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230393AbiLLFfh (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Dec 2022 00:35:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54788 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229537AbiLLFff (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Dec 2022 00:35:35 -0500
Received: from esa5.hgst.iphmx.com (esa5.hgst.iphmx.com [216.71.153.144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 735BBBC1F
        for <linux-scsi@vger.kernel.org>; Sun, 11 Dec 2022 21:35:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=wdc.com; i=@wdc.com; q=dns/txt; s=dkim.wdc.com;
  t=1670823333; x=1702359333;
  h=message-id:date:mime-version:subject:to:cc:references:
   from:in-reply-to:content-transfer-encoding;
  bh=eXCxVPYKMBuAbzPUkXZtdjHWmxfeiEX3y8m8YFwwXEI=;
  b=jD+yE0LnW/8JrfHdHUeyqSIZBoGxe+kbftFJvcY7RtrDc3xCHkyJzueM
   yOAlnBGzABEJaOfx9rYKG7MUI2VLwqx+lynbvibqTlreA+pDGAz56TSAk
   2C0RKL33bCQw5Ub+XpTg97jETiBeeuTNFtQXe3CaA5L4JpQC6gbh/UutO
   uRr1xDRbSQ+HigCjbG14YzS3tS3f/CifQGAPfEBzlHgwiuKOfIL+bSK7G
   rpX795M0PC0NVRY0KtfYUag+nb+Uxo86ygUO8CgOkm2bP7gU7yXrAIX7r
   qs1w59/uxzsS1UAsqq8MiuHimEru0VdkIQROEqvmS0cN59tzwrPEpGeF+
   g==;
X-IronPort-AV: E=Sophos;i="5.96,237,1665417600"; 
   d="scan'208";a="218411725"
Received: from uls-op-cesaip01.wdc.com (HELO uls-op-cesaep01.wdc.com) ([199.255.45.14])
  by ob1.hgst.iphmx.com with ESMTP; 12 Dec 2022 13:35:32 +0800
IronPort-SDR: UZR45+XS2zul8wxCn8sSeL1b/9PNLzQ9yU/uPRrC39I/mzOHzJupcRvyPTyqVJsbc652mnqRQl
 oMNAQoAdXDj89Fvrx5twAROpkN4zOX63kOJNKMR+52nLVgm3aal8/aDdgPATxAMLg72Te9nwh6
 IOVV0OJv3fNrIYEcefRYNkhjZ8Pm3tPzRLVbJjWN8HTEWGeAaD5Uhz4Nq/RESqen/4JLEA10lv
 DBwPlcmrzOxzPjow2SDFKT1Nxm6y74DKX7lnUJ5QISXOloEXGqYYM6N3f0wX3KoPcBXfBBUvVD
 3cE=
Received: from uls-op-cesaip02.wdc.com ([10.248.3.37])
  by uls-op-cesaep01.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 11 Dec 2022 20:53:57 -0800
IronPort-SDR: diGHIHbH2vXqokNS9s2SI8r52ci6TK1NOWnBEOVx+buumf7U959uauVlUboyRpMKS5TLurMRQ/
 S+JbkxzpKWsK3FKmY1vRlQvBoNpYCOQI/m2LMRPFPlpC1RG0G0/S2i7mt0sj/03siQsds4Pxm3
 ZBfdwgs8n18/+rUS7W5elJcwHmMuAfTVAZjA0JhBAoZ71AhyjwuzDue3FQkTj/iZVnJN470KPW
 7u7Wv+h6FD0L7H9n5pFg6uWW91bMb1txcae3T0GMWMOAFH5sYz9frR5ddmhNvRIIx+F1t4wrH7
 WfQ=
WDCIronportException: Internal
Received: from usg-ed-osssrv.wdc.com ([10.3.10.180])
  by uls-op-cesaip02.wdc.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 11 Dec 2022 21:35:32 -0800
Received: from usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTP id 4NVr1w2gWJz1RwqL
        for <linux-scsi@vger.kernel.org>; Sun, 11 Dec 2022 21:35:32 -0800 (PST)
Authentication-Results: usg-ed-osssrv.wdc.com (amavisd-new); dkim=pass
        reason="pass (just generated, assumed good)"
        header.d=opensource.wdc.com
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=
        opensource.wdc.com; h=content-transfer-encoding:content-type
        :in-reply-to:organization:from:references:to:content-language
        :subject:user-agent:mime-version:date:message-id; s=dkim; t=
        1670823331; x=1673415332; bh=eXCxVPYKMBuAbzPUkXZtdjHWmxfeiEX3y8m
        8YFwwXEI=; b=LuelyHHuEFuiIxwrGiirHjhqXP0cPXTOP1KeCfeIpvLB6FvfPaB
        JUe6a7bb0j0gvx8WKZp/PdPriK+0JDToy7BDQoKbpZNRWGfAgzlaxXS4eiCqVVJo
        pVgB++c1P6oO95x37PE0O8JvuZIxq4c92hdMFMtOxagRNXqT6uIF3WH3fzgN1Q4V
        7soSTkRrnKs319XcZ13UYYkN1GzfOpABSre96ijvXwLqfeNbPTVTIqboBNrXA+hj
        9RzFInixwRVu1EIEsIJoM8wL5IClE+/srcDy8XP3P5WulAOzF3oFzU7FfX/KAHzQ
        r8ySN4G6XdsdmoZ5JjKeWfx38nxpBIjnedA==
X-Virus-Scanned: amavisd-new at usg-ed-osssrv.wdc.com
Received: from usg-ed-osssrv.wdc.com ([127.0.0.1])
        by usg-ed-osssrv.wdc.com (usg-ed-osssrv.wdc.com [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id KEDutRkjTnFA for <linux-scsi@vger.kernel.org>;
        Sun, 11 Dec 2022 21:35:31 -0800 (PST)
Received: from [10.225.163.90] (unknown [10.225.163.90])
        by usg-ed-osssrv.wdc.com (Postfix) with ESMTPSA id 4NVr1t1jnzz1RvLy;
        Sun, 11 Dec 2022 21:35:30 -0800 (PST)
Message-ID: <c65beb54-7ff3-1a95-f255-916c25ef03d3@opensource.wdc.com>
Date:   Mon, 12 Dec 2022 14:35:29 +0900
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.5.1
Subject: Re: [PATCH 2/3] scsi: mpi3mr: fix bitmap memory size calculation
Content-Language: en-US
To:     Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
        linux-scsi@vger.kernel.org, mpi3mr-linuxdrv.pdl@broadcom.com
Cc:     Sathya Prakash Veerichetty <sathya.prakash@broadcom.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
References: <20221212015706.2609544-1-shinichiro.kawasaki@wdc.com>
 <20221212015706.2609544-3-shinichiro.kawasaki@wdc.com>
From:   Damien Le Moal <damien.lemoal@opensource.wdc.com>
Organization: Western Digital Research
In-Reply-To: <20221212015706.2609544-3-shinichiro.kawasaki@wdc.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/12/22 10:57, Shin'ichiro Kawasaki wrote:
> To allocate memory for bitmaps, the mpi3mr driver calculates sizes of
> each bitmap using byte as unit. However, bit operation helper functions
> assume that bitmaps are allocated using unsigned long as unit. This gap
> causes memory access beyond the bitmap memory size and results in "BUG:
> KASAN: slab-out-of-bounds". The BUG was observed at firmware download to
> eHBA-9600. Call trace indicated that the out-of-bounds access happened
> in find_first_zero_bit called from mpi3mr_send_event_ack for the bitmap
> miroc->evtack_cmds_bitmap.
> 
> To avoid the BUG, fix bitmap size calculations using unsigned long as
> unit. Apply this fix to five places to cover all bitmap size
> calculations in the driver.
> 
> Fixes: c5758fc72b92 ("scsi: mpi3mr: Gracefully handle online FW update operation")
> Fixes: e844adb1fbdc ("scsi: mpi3mr: Implement SCSI error handler hooks")
> Fixes: c1af985d27da ("scsi: mpi3mr: Add Event acknowledgment logic")
> Fixes: 824a156633df ("scsi: mpi3mr: Base driver code")
> Signed-off-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
> ---
>  drivers/scsi/mpi3mr/mpi3mr_fw.c | 25 ++++++++++---------------
>  1 file changed, 10 insertions(+), 15 deletions(-)
> 
> diff --git a/drivers/scsi/mpi3mr/mpi3mr_fw.c b/drivers/scsi/mpi3mr/mpi3mr_fw.c
> index 0c4aabaefdcc..272c318387b7 100644
> --- a/drivers/scsi/mpi3mr/mpi3mr_fw.c
> +++ b/drivers/scsi/mpi3mr/mpi3mr_fw.c
> @@ -1160,9 +1160,8 @@ mpi3mr_revalidate_factsdata(struct mpi3mr_ioc *mrioc)
>  		    "\tcontroller while sas transport support is enabled at the\n"
>  		    "\tdriver, please reboot the system or reload the driver\n");
>  
> -	dev_handle_bitmap_sz = mrioc->facts.max_devhandle / 8;
> -	if (mrioc->facts.max_devhandle % 8)
> -		dev_handle_bitmap_sz++;
> +	dev_handle_bitmap_sz = sizeof(unsigned long) *
> +		DIV_ROUND_UP(mrioc->facts.max_devhandle, BITS_PER_LONG);
>  	if (dev_handle_bitmap_sz > mrioc->dev_handle_bitmap_sz) {
>  		removepend_bitmap = krealloc(mrioc->removepend_bitmap,
>  		    dev_handle_bitmap_sz, GFP_KERNEL);
> @@ -2957,25 +2956,22 @@ static int mpi3mr_alloc_reply_sense_bufs(struct mpi3mr_ioc *mrioc)
>  	if (!mrioc->pel_abort_cmd.reply)
>  		goto out_failed;
>  
> -	mrioc->dev_handle_bitmap_sz = mrioc->facts.max_devhandle / 8;
> -	if (mrioc->facts.max_devhandle % 8)
> -		mrioc->dev_handle_bitmap_sz++;

mrioc->dev_handle_bitmap_sz = (mrioc->facts.max_devhandle + 7) >> 3;

would be a lot simpler...

> +	mrioc->dev_handle_bitmap_sz = sizeof(unsigned long) *
> +		DIV_ROUND_UP(mrioc->facts.max_devhandle, BITS_PER_LONG);
>  	mrioc->removepend_bitmap = kzalloc(mrioc->dev_handle_bitmap_sz,
>  	    GFP_KERNEL);

What about using bitmap_alloc() here and keep the dev_handle_bitmap_sz
value as is ?

(same for the other bitmaps)

>  	if (!mrioc->removepend_bitmap)
>  		goto out_failed;
>  
> -	mrioc->devrem_bitmap_sz = MPI3MR_NUM_DEVRMCMD / 8;
> -	if (MPI3MR_NUM_DEVRMCMD % 8)
> -		mrioc->devrem_bitmap_sz++;
> +	mrioc->devrem_bitmap_sz = sizeof(unsigned long) *
> +		DIV_ROUND_UP(MPI3MR_NUM_DEVRMCMD, BITS_PER_LONG);
>  	mrioc->devrem_bitmap = kzalloc(mrioc->devrem_bitmap_sz,
>  	    GFP_KERNEL);
>  	if (!mrioc->devrem_bitmap)
>  		goto out_failed;
>  
> -	mrioc->evtack_cmds_bitmap_sz = MPI3MR_NUM_EVTACKCMD / 8;
> -	if (MPI3MR_NUM_EVTACKCMD % 8)
> -		mrioc->evtack_cmds_bitmap_sz++;
> +	mrioc->evtack_cmds_bitmap_sz = sizeof(unsigned long) *
> +		DIV_ROUND_UP(MPI3MR_NUM_EVTACKCMD, BITS_PER_LONG);
>  	mrioc->evtack_cmds_bitmap = kzalloc(mrioc->evtack_cmds_bitmap_sz,
>  	    GFP_KERNEL);
>  	if (!mrioc->evtack_cmds_bitmap)
> @@ -3415,9 +3411,8 @@ static int mpi3mr_alloc_chain_bufs(struct mpi3mr_ioc *mrioc)
>  		if (!mrioc->chain_sgl_list[i].addr)
>  			goto out_failed;
>  	}
> -	mrioc->chain_bitmap_sz = num_chains / 8;
> -	if (num_chains % 8)
> -		mrioc->chain_bitmap_sz++;
> +	mrioc->chain_bitmap_sz = sizeof(unsigned long) *
> +		DIV_ROUND_UP(num_chains, BITS_PER_LONG);
>  	mrioc->chain_bitmap = kzalloc(mrioc->chain_bitmap_sz, GFP_KERNEL);
>  	if (!mrioc->chain_bitmap)
>  		goto out_failed;

-- 
Damien Le Moal
Western Digital Research

