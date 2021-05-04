Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.1 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 615B3C433ED
	for <linux-scsi@archiver.kernel.org>; Tue,  4 May 2021 00:40:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 337C0611C9
	for <linux-scsi@archiver.kernel.org>; Tue,  4 May 2021 00:40:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229582AbhEDAl2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 3 May 2021 20:41:28 -0400
Received: from gateway30.websitewelcome.com ([192.185.194.16]:22619 "EHLO
        gateway30.websitewelcome.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229497AbhEDAl2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 3 May 2021 20:41:28 -0400
X-Greylist: delayed 1266 seconds by postgrey-1.27 at vger.kernel.org; Mon, 03 May 2021 20:41:28 EDT
Received: from cm16.websitewelcome.com (cm16.websitewelcome.com [100.42.49.19])
        by gateway30.websitewelcome.com (Postfix) with ESMTP id 8E48526476
        for <linux-scsi@vger.kernel.org>; Mon,  3 May 2021 19:19:26 -0500 (CDT)
Received: from gator4166.hostgator.com ([108.167.133.22])
        by cmsmtp with SMTP
        id dimclDl6lb8Lydimcl4VJr; Mon, 03 May 2021 19:19:26 -0500
X-Authority-Reason: nr=8
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=embeddedor.com; s=default; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Ig3CIZ/xmFOthwSo8EhRMfGFFJSSDrU9KPABQLO3bKw=; b=aCCPuf0rrTzuThkDJZ/b5GIA2p
        s3MQoip/HAnHcpu36zFanRHfJXuAHeS6aNB9xrUMOK5rgw8MyAPB201Dr3d06X7pXcBM9Q9hy7ZI7
        xKxTWvkiZMVPuBDthn4XqnCAaLAJ6+Z9DVE5wzUlBr1qANp3JTjQzVS8JkxlbH/gcZ08vasjhcG8K
        A3CHwZX3Jf5f+UERSOTEUEIfNWsyNJQeSv9EvDRIPmGtzNimjj1p5B/wkZndMaD32Bf2EPnHFT+bu
        avcZ8lyKUB/a94W4ZbnUq6GExQIBu0eYQPLzmVEn1Kr9/huDBUhkoMdgqL8l+LjrBNxNYD1/x+C3d
        9VFynPOA==;
Received: from 187-162-31-110.static.axtel.net ([187.162.31.110]:48728 helo=[192.168.15.8])
        by gator4166.hostgator.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.94)
        (envelope-from <gustavo@embeddedor.com>)
        id 1ldimZ-001mFB-0t; Mon, 03 May 2021 19:19:23 -0500
Subject: Re: [PATCH v3][next] scsi: aacraid: Replace one-element array with
 flexible-array member
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org, Kees Cook <keescook@chromium.org>
References: <20210421185611.GA105224@embeddedor>
From:   "Gustavo A. R. Silva" <gustavo@embeddedor.com>
Message-ID: <d26823dd-5248-4965-cc30-f9e6294536ee@embeddedor.com>
Date:   Mon, 3 May 2021 19:19:25 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210421185611.GA105224@embeddedor>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
X-AntiAbuse: This header was added to track abuse, please include it with any abuse report
X-AntiAbuse: Primary Hostname - gator4166.hostgator.com
X-AntiAbuse: Original Domain - vger.kernel.org
X-AntiAbuse: Originator/Caller UID/GID - [47 12] / [47 12]
X-AntiAbuse: Sender Address Domain - embeddedor.com
X-BWhitelist: no
X-Source-IP: 187.162.31.110
X-Source-L: No
X-Exim-ID: 1ldimZ-001mFB-0t
X-Source: 
X-Source-Args: 
X-Source-Dir: 
X-Source-Sender: 187-162-31-110.static.axtel.net ([192.168.15.8]) [187.162.31.110]:48728
X-Source-Auth: gustavo@embeddedor.com
X-Email-Count: 5
X-Source-Cap: Z3V6aWRpbmU7Z3V6aWRpbmU7Z2F0b3I0MTY2Lmhvc3RnYXRvci5jb20=
X-Local-Domain: yes
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Martin,

Friendly ping: could you take this patch, please? :)

Thanks!
--
Gustavo

On 4/21/21 13:56, Gustavo A. R. Silva wrote:
> There is a regular need in the kernel to provide a way to declare having
> a dynamically sized set of trailing elements in a structure. Kernel code
> should always use “flexible array members”[1] for these cases. The older
> style of one-element or zero-length arrays should no longer be used[2].
> 
> Refactor the code according to the use of a flexible-array member in
> struct aac_raw_io2 instead of one-element array, and use the
> struct_size() helper.
> 
> Also, this helps with the ongoing efforts to enable -Warray-bounds by
> fixing the following warnings:
> 
> drivers/scsi/aacraid/aachba.c: In function ‘aac_build_sgraw2’:
> drivers/scsi/aacraid/aachba.c:3970:18: warning: array subscript 1 is above array bounds of ‘struct sge_ieee1212[1]’ [-Warray-bounds]
>  3970 |     if (rio2->sge[j].length % (i*PAGE_SIZE)) {
>       |         ~~~~~~~~~^~~
> drivers/scsi/aacraid/aachba.c:3974:27: warning: array subscript 1 is above array bounds of ‘struct sge_ieee1212[1]’ [-Warray-bounds]
>  3974 |     nseg_new += (rio2->sge[j].length / (i*PAGE_SIZE));
>       |                  ~~~~~~~~~^~~
> drivers/scsi/aacraid/aachba.c:4011:28: warning: array subscript 1 is above array bounds of ‘struct sge_ieee1212[1]’ [-Warray-bounds]
>  4011 |   for (j = 0; j < rio2->sge[i].length / (pages * PAGE_SIZE); ++j) {
>       |                   ~~~~~~~~~^~~
> drivers/scsi/aacraid/aachba.c:4012:24: warning: array subscript 1 is above array bounds of ‘struct sge_ieee1212[1]’ [-Warray-bounds]
>  4012 |    addr_low = rio2->sge[i].addrLow + j * pages * PAGE_SIZE;
>       |               ~~~~~~~~~^~~
> drivers/scsi/aacraid/aachba.c:4014:33: warning: array subscript 1 is above array bounds of ‘struct sge_ieee1212[1]’ [-Warray-bounds]
>  4014 |    sge[pos].addrHigh = rio2->sge[i].addrHigh;
>       |                        ~~~~~~~~~^~~
> drivers/scsi/aacraid/aachba.c:4015:28: warning: array subscript 1 is above array bounds of ‘struct sge_ieee1212[1]’ [-Warray-bounds]
>  4015 |    if (addr_low < rio2->sge[i].addrLow)
>       |                   ~~~~~~~~~^~~
> 
> [1] https://en.wikipedia.org/wiki/Flexible_array_member
> [2] https://www.kernel.org/doc/html/v5.9/process/deprecated.html#zero-length-and-one-element-arrays
> 
> Link: https://github.com/KSPP/linux/issues/79
> Link: https://github.com/KSPP/linux/issues/109
> Build-tested-by: kernel test robot <lkp@intel.com>
> Link: https://lore.kernel.org/lkml/60414244.ur4%2FkI+fBF1ohKZs%25lkp@intel.com/
> Signed-off-by: Gustavo A. R. Silva <gustavoars@kernel.org>
> ---
> Changes in v3:
>  - Use (nseg_new-1)*sizeof(struct sge_ieee1212) to calculate
>    size in call to memcpy() in order to avoid any confusion.
> 
> Changes in v2:
>  - Add code comment for clarification.
> 
>  drivers/scsi/aacraid/aachba.c  | 10 +++++-----
>  drivers/scsi/aacraid/aacraid.h |  2 +-
>  2 files changed, 6 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
> index f1f62b5da8b7..46b8dffce2dd 100644
> --- a/drivers/scsi/aacraid/aachba.c
> +++ b/drivers/scsi/aacraid/aachba.c
> @@ -1235,8 +1235,8 @@ static int aac_read_raw_io(struct fib * fib, struct scsi_cmnd * cmd, u64 lba, u3
>  		if (ret < 0)
>  			return ret;
>  		command = ContainerRawIo2;
> -		fibsize = sizeof(struct aac_raw_io2) +
> -			((le32_to_cpu(readcmd2->sgeCnt)-1) * sizeof(struct sge_ieee1212));
> +		fibsize = struct_size(readcmd2, sge,
> +				     le32_to_cpu(readcmd2->sgeCnt));
>  	} else {
>  		struct aac_raw_io *readcmd;
>  		readcmd = (struct aac_raw_io *) fib_data(fib);
> @@ -1366,8 +1366,8 @@ static int aac_write_raw_io(struct fib * fib, struct scsi_cmnd * cmd, u64 lba, u
>  		if (ret < 0)
>  			return ret;
>  		command = ContainerRawIo2;
> -		fibsize = sizeof(struct aac_raw_io2) +
> -			((le32_to_cpu(writecmd2->sgeCnt)-1) * sizeof(struct sge_ieee1212));
> +		fibsize = struct_size(writecmd2, sge,
> +				      le32_to_cpu(writecmd2->sgeCnt));
>  	} else {
>  		struct aac_raw_io *writecmd;
>  		writecmd = (struct aac_raw_io *) fib_data(fib);
> @@ -3998,7 +3998,7 @@ static int aac_convert_sgraw2(struct aac_raw_io2 *rio2, int pages, int nseg, int
>  	if (aac_convert_sgl == 0)
>  		return 0;
>  
> -	sge = kmalloc_array(nseg_new, sizeof(struct sge_ieee1212), GFP_ATOMIC);
> +	sge = kmalloc_array(nseg_new, sizeof(*sge), GFP_ATOMIC);
>  	if (sge == NULL)
>  		return -ENOMEM;
>  
> diff --git a/drivers/scsi/aacraid/aacraid.h b/drivers/scsi/aacraid/aacraid.h
> index e3e4ecbea726..3733df77bc65 100644
> --- a/drivers/scsi/aacraid/aacraid.h
> +++ b/drivers/scsi/aacraid/aacraid.h
> @@ -1929,7 +1929,7 @@ struct aac_raw_io2 {
>  	u8		bpComplete;	/* reserved for F/W use */
>  	u8		sgeFirstIndex;	/* reserved for F/W use */
>  	u8		unused[4];
> -	struct sge_ieee1212	sge[1];
> +	struct sge_ieee1212	sge[];
>  };
>  
>  #define CT_FLUSH_CACHE 129
> 
