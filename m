Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0F2D0C433DB
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Dec 2020 06:24:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C574523120
	for <linux-scsi@archiver.kernel.org>; Tue, 22 Dec 2020 06:24:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725785AbgLVGYr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 22 Dec 2020 01:24:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725300AbgLVGYr (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 22 Dec 2020 01:24:47 -0500
Received: from mail-io1-xd2a.google.com (mail-io1-xd2a.google.com [IPv6:2607:f8b0:4864:20::d2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE99EC0613D3;
        Mon, 21 Dec 2020 22:24:06 -0800 (PST)
Received: by mail-io1-xd2a.google.com with SMTP id q137so11027110iod.9;
        Mon, 21 Dec 2020 22:24:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=dvYfLYsFfS43bvrF26hnW/hEbzAkRm7Scm+LXEgVfVU=;
        b=bYLuiH1oTcVZ/I6H0OVBdf9f3YqrefhYZAyEJdB5TC6xIKwxPhaupenWHD8bSvukj0
         He9SW7p+RSa3NctkxTKoYhyCXsQPtHrNaN3konj8LhUdsMyFg6dYKP9JkwuJcwIKBX+x
         LQNKv/FIMS3Jp/cK8Y2hSSLoJ8L7CRNV6OFIS+9oh51CT6iIyayvGHHtGV6tNw1tkCXo
         yY4qAYEgguc8HVzEP2A0py/XKMmpWcWza2KurgLXLItdf2rSC9YVrmEErjlfj+dTJPxY
         nZn42AO/OFiptOlofA5Z7FguNSPvqFi8mtf0cDfV7fU65ZLc/y39YQY+S+600ASWJrYp
         uWYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=dvYfLYsFfS43bvrF26hnW/hEbzAkRm7Scm+LXEgVfVU=;
        b=jstAl/RpQZMleNbPM6yhdNNPEBbJdmS5aZEQXoadTVtMF9YIWoAVAQxrV4DVkyp3zX
         qKm7lHwneXwa5cP6o299OzR5Ylr4BlSwi+bjOBMBGgJgkXTZfjZA8gZMZ6xUyt3VuOyp
         b//WKvaEtQmy0JGY/zIBMbv/6rhBHhHuA75SKnr3uYeqqGtC6RNwcCOOncfGbkM5hfAY
         PdtmS7hzCFSgMmx1ZBrzjP6FI8OUzceLBmba7tRw40v7YpOlwy3GYgJ7swwyYkqYYSZt
         An2s65HSX1835PFcVGRv1xKUdsssIn7t/99dfLIgjr28lI3cVY9zZmcuy6PyBaFTPixL
         jmjA==
X-Gm-Message-State: AOAM531jNOV8xNlYQIMIHOtY+W36prNOWvh1tmSHrv6EiczLUuIeN0Qh
        PTFsVJNmBSXPX0vXIfQLiU/lQjd2zoQ=
X-Google-Smtp-Source: ABdhPJxB9wDBA5Ngh+kgnMjiLRbev4Rw8UPKgrWjlAhWtRksNN90MssBBP9rj+JfCQ0GrrHiwWXSRw==
X-Received: by 2002:a6b:3bc3:: with SMTP id i186mr16958974ioa.192.1608618245892;
        Mon, 21 Dec 2020 22:24:05 -0800 (PST)
Received: from ubuntu-m3-large-x86 ([2604:1380:45f1:1d00::1])
        by smtp.gmail.com with ESMTPSA id x5sm14561731ilm.22.2020.12.21.22.24.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 21 Dec 2020 22:24:05 -0800 (PST)
Date:   Mon, 21 Dec 2020 23:24:03 -0700
From:   Nathan Chancellor <natechancellor@gmail.com>
To:     Tyrel Datwyler <tyreld@linux.ibm.com>
Cc:     james.bottomley@hansenpartnership.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, brking@linux.ibm.com,
        clang-built-linux@googlegroups.com
Subject: Re: [PATCH 3/3] ibmvfc: use correlation token to tag commands
Message-ID: <20201222062403.GA2190683@ubuntu-m3-large-x86>
References: <20201117185031.129939-1-tyreld@linux.ibm.com>
 <20201117185031.129939-3-tyreld@linux.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201117185031.129939-3-tyreld@linux.ibm.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Nov 17, 2020 at 12:50:31PM -0600, Tyrel Datwyler wrote:
> The vfcFrame correlation field is 64bit handle that is intended to trace
> I/O operations through both the client stack and VIOS stack when the
> underlying physical FC adapter supports tagging.
> 
> Tag vfcFrames with the associated ibmvfc_event pointer handle.
> 
> Signed-off-by: Tyrel Datwyler <tyreld@linux.ibm.com>
> ---
>  drivers/scsi/ibmvscsi/ibmvfc.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/scsi/ibmvscsi/ibmvfc.c b/drivers/scsi/ibmvscsi/ibmvfc.c
> index 0cab4b852b48..3922441a117d 100644
> --- a/drivers/scsi/ibmvscsi/ibmvfc.c
> +++ b/drivers/scsi/ibmvscsi/ibmvfc.c
> @@ -1693,6 +1693,8 @@ static int ibmvfc_queuecommand_lck(struct scsi_cmnd *cmnd,
>  		vfc_cmd->iu.pri_task_attr = IBMVFC_SIMPLE_TASK;
>  	}
>  
> +	vfc_cmd->correlation = cpu_to_be64(evt);
> +
>  	if (likely(!(rc = ibmvfc_map_sg_data(cmnd, evt, vfc_cmd, vhost->dev))))
>  		return ibmvfc_send_event(evt, vhost, 0);
>  
> @@ -2370,6 +2372,8 @@ static int ibmvfc_abort_task_set(struct scsi_device *sdev)
>  		tmf->iu.tmf_flags = IBMVFC_ABORT_TASK_SET;
>  		evt->sync_iu = &rsp_iu;
>  
> +		tmf->correlation = cpu_to_be64(evt);
> +
>  		init_completion(&evt->comp);
>  		rsp_rc = ibmvfc_send_event(evt, vhost, default_timeout);
>  	}
> -- 
> 2.27.0
> 

This patch introduces a clang warning, is this intentional behavior?

$ make -skj"$(nproc)" ARCH=powerpc CROSS_COMPILE=powerpc64le-linux-gnu- LLVM=1 O=out distclean ppc64le_defconfig drivers/scsi/ibmvscsi/ibmvfc.o
Using ../arch/powerpc/configs/ppc64_defconfig as base
Merging ../arch/powerpc/configs/le.config
#
# merged configuration written to .config (needs make)
#
../drivers/scsi/ibmvscsi/ibmvfc.c:1747:25: warning: incompatible pointer to integer conversion passing 'struct ibmvfc_event *' to parameter of type '__u64' (aka 'unsigned long long') [-Wint-conversion]
        vfc_cmd->correlation = cpu_to_be64(evt);
                               ^~~~~~~~~~~~~~~~
../include/linux/byteorder/generic.h:92:21: note: expanded from macro 'cpu_to_be64'
#define cpu_to_be64 __cpu_to_be64
                    ^
../include/uapi/linux/byteorder/little_endian.h:37:52: note: expanded from macro '__cpu_to_be64'
#define __cpu_to_be64(x) ((__force __be64)__swab64((x)))
                                          ~~~~~~~~~^~~~
../include/uapi/linux/swab.h:133:12: note: expanded from macro '__swab64'
        __fswab64(x))
                  ^
../include/uapi/linux/swab.h:66:57: note: passing argument to parameter 'val' here
static inline __attribute_const__ __u64 __fswab64(__u64 val)
                                                        ^
../drivers/scsi/ibmvscsi/ibmvfc.c:2421:22: warning: incompatible pointer to integer conversion passing 'struct ibmvfc_event *' to parameter of type '__u64' (aka 'unsigned long long') [-Wint-conversion]
                tmf->correlation = cpu_to_be64(evt);
                                   ^~~~~~~~~~~~~~~~
../include/linux/byteorder/generic.h:92:21: note: expanded from macro 'cpu_to_be64'
#define cpu_to_be64 __cpu_to_be64
                    ^
../include/uapi/linux/byteorder/little_endian.h:37:52: note: expanded from macro '__cpu_to_be64'
#define __cpu_to_be64(x) ((__force __be64)__swab64((x)))
                                          ~~~~~~~~~^~~~
../include/uapi/linux/swab.h:133:12: note: expanded from macro '__swab64'
        __fswab64(x))
                  ^
../include/uapi/linux/swab.h:66:57: note: passing argument to parameter 'val' here
static inline __attribute_const__ __u64 __fswab64(__u64 val)
                                                        ^
2 warnings generated.

Cheers,
Nathan
