Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-20.8 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=unavailable autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BA6A2C433B4
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Apr 2021 19:22:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8174A61353
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Apr 2021 19:22:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355606AbhDGTXE (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 7 Apr 2021 15:23:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56366 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1355600AbhDGTXE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Apr 2021 15:23:04 -0400
Received: from mail-pg1-x531.google.com (mail-pg1-x531.google.com [IPv6:2607:f8b0:4864:20::531])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 683D4C061761
        for <linux-scsi@vger.kernel.org>; Wed,  7 Apr 2021 12:22:54 -0700 (PDT)
Received: by mail-pg1-x531.google.com with SMTP id q10so13819627pgj.2
        for <linux-scsi@vger.kernel.org>; Wed, 07 Apr 2021 12:22:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=Ke0rc9XfMf9BcEhOIRjBDFSOHCSu8Insw4la98udkfI=;
        b=dkn2z9paIb5VYx0wtP5aKvdI23w7VMZ1O7ju3Ca/pZzlkns43wwtyfBWl5DKnfcUpz
         wr7X5Hf/BjaaCgvjQwbIqLRWndt+MItgIzOGEZhpnX70qcFNN6audlLSe8gS6z1DADdf
         iU11sqKHX1CtZ6PY/r6enXrWbZVVhr/GAfoYU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=Ke0rc9XfMf9BcEhOIRjBDFSOHCSu8Insw4la98udkfI=;
        b=NnG3ROpt1tRfwinJWCTM1sRFwiHmRhdiQCZAZWVQJaLDIUEsmgMN9ED3CYBV8z1fjU
         dhtlYUjW3vhQxkn7OXOyPD+ZNVjs9BePRinPYLowDSIGbhSS1SKq5OutlykaBxfesJGa
         1sGvwXDcf5qeyvJAOWZ7drfGyR8RL+T5jwtL1zwYfUcaZ2OnqfvydhHDwO+WYlXS9KyK
         8eaKwSMh8FUvG8FMp9aUsBrptXnZBNW4edMnmT+WOvNqQicNP5m/A6FS/mMglvOJ5T/+
         AoZT9tjWoYZpWz0xSJ33RaQBKJ5n5G5LNe5kMiadDseGAHs5rukP2AmaovKErPuIkovf
         5p2A==
X-Gm-Message-State: AOAM530MieK/fGUSwKcMAzV8BPAm4F8ZdYmdGdY3WpxpuLi3kvyq/Ojb
        T9Ij7EtFvbC9xVGBDl7ATLrjSQ==
X-Google-Smtp-Source: ABdhPJw3gwG8i+ZTCLIXPStASuu7D+EAq3vNs4JWpjSG/O34E4hVG4WXQ3XIWlQKIJJlCyJnmouMKw==
X-Received: by 2002:aa7:96bc:0:b029:1f6:9937:fe43 with SMTP id g28-20020aa796bc0000b02901f69937fe43mr4376117pfk.68.1617823373801;
        Wed, 07 Apr 2021 12:22:53 -0700 (PDT)
Received: from www.outflux.net (smtp.outflux.net. [198.145.64.163])
        by smtp.gmail.com with ESMTPSA id h16sm21556115pfc.194.2021.04.07.12.22.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 07 Apr 2021 12:22:53 -0700 (PDT)
Date:   Wed, 7 Apr 2021 12:22:52 -0700
From:   Kees Cook <keescook@chromium.org>
To:     "Gustavo A. R. Silva" <gustavoars@kernel.org>
Cc:     Adaptec OEM Raid Solutions <aacraid@microsemi.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
Subject: Re: [PATCH][next] scsi: aacraid: Replace one-element array with
 flexible-array member
Message-ID: <202104071216.5BEA350@keescook>
References: <20210304203822.GA102218@embeddedor>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210304203822.GA102218@embeddedor>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Mar 04, 2021 at 02:38:22PM -0600, Gustavo A. R. Silva wrote:
> There is a regular need in the kernel to provide a way to declare having
> a dynamically sized set of trailing elements in a structure. Kernel code
> should always use “flexible array members”[1] for these cases. The older
> style of one-element or zero-length arrays should no longer be used[2].
> 
> Refactor the code according to the use of a flexible-array member in
> struct aac_raw_io2 instead of one-element array, and use the
> struct_size() and flex_array_size() helpers.
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
>  drivers/scsi/aacraid/aachba.c  | 13 +++++++------
>  drivers/scsi/aacraid/aacraid.h |  2 +-
>  2 files changed, 8 insertions(+), 7 deletions(-)
> 
> diff --git a/drivers/scsi/aacraid/aachba.c b/drivers/scsi/aacraid/aachba.c
> index 4ca5e13a26a6..0f5617e40b94 100644
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

readcmd2 is struct aac_raw_io2, and sge is the struct sge_ieee1212
array, so this looks correct to me with the change to struct
aac_raw_io2..

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

writecmd2 is struct aac_raw_io2, and sge is the struct sge_ieee1212
array, so this looks correct to me with the change to struct
aac_raw_io2.

>  	} else {
>  		struct aac_raw_io *writecmd;
>  		writecmd = (struct aac_raw_io *) fib_data(fib);
> @@ -4003,7 +4003,7 @@ static int aac_convert_sgraw2(struct aac_raw_io2 *rio2, int pages, int nseg, int
>  	if (aac_convert_sgl == 0)
>  		return 0;
>  
> -	sge = kmalloc_array(nseg_new, sizeof(struct sge_ieee1212), GFP_ATOMIC);
> +	sge = kmalloc_array(nseg_new, sizeof(*sge), GFP_ATOMIC);

Technically, this is unrelated (struct sge_ieee1212 has not changed),
but sge is a struct sge_ieee1212 pointer, so this is good robustness
change, IMO.

>  	if (sge == NULL)
>  		return -ENOMEM;
>  
> @@ -4020,7 +4020,8 @@ static int aac_convert_sgraw2(struct aac_raw_io2 *rio2, int pages, int nseg, int
>  		}
>  	}
>  	sge[pos] = rio2->sge[nseg-1];
> -	memcpy(&rio2->sge[1], &sge[1], (nseg_new-1)*sizeof(struct sge_ieee1212));
> +	memcpy(&rio2->sge[1], &sge[1],
> +	       flex_array_size(rio2, sge, nseg_new - 1));

This was hard to validate, but looks correct to me. The flex array
helper here is the same as the prior code (but now tied to the
variables, which is more robust IMO). The use of seg[1] here appears to
be just how this code works -- the loop above is rewriting the 1 through
nseg_new - 1 array entries, and then this copies back the results.

>  
>  	kfree(sge);
>  	rio2->sgeCnt = cpu_to_le32(nseg_new);
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
> -- 
> 2.27.0
> 

Thanks!

Reviewed-by: Kees Cook <keescook@chromium.org>

-- 
Kees Cook
