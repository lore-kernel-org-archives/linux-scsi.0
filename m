Return-Path: <SRS0=w7Bx=WI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.0 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B4D9BC433FF
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Aug 2019 14:23:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8561220679
	for <linux-scsi@archiver.kernel.org>; Mon, 12 Aug 2019 14:23:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="cIFDEs4j"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727497AbfHLOXG (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 12 Aug 2019 10:23:06 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:43488 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726702AbfHLOXF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 12 Aug 2019 10:23:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=pQV5X99xODJ5p3mJa7lE949TbkgH89jLpneIazvs2uk=; b=cIFDEs4jYSF9QQAArGsDkHfzj
        75G8hK5b5wxiQj57y++1wh1x/Ubfl5MMCAd818L9LkM3308RidyxRnNTrrdo1c3yxigj13yjtgflY
        dEqtTkkXOS2+QuormwK5Bpa3g2vCXHmsa7AaBo5+HpA7s/TBzILpIQf8uQZUcJD4UGRd7g9R3qwmH
        ho5wL/f6v1gBZKbCWkfqPLiSjZock8VGL/CyMPLVkRE4ZF9J+C5phX4wEGk91J243vQmmL4e715pf
        zBdxmtYaO0NPuW4E3Ek5Bte26Wd8A+cmWy8pUigk2pj/iB6XKykpZRI8+PVSNRPKKoPZKNc8gQdKd
        DVkHJsJhQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92 #3 (Red Hat Linux))
        id 1hxBE1-0002oz-9P; Mon, 12 Aug 2019 14:23:05 +0000
Date:   Mon, 12 Aug 2019 07:23:05 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Douglas Gilbert <dgilbert@interlog.com>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        jejb@linux.vnet.ibm.com, hare@suse.de, bvanassche@acm.org
Subject: Re: [PATCH v3 03/20] sg: sg_log and is_enabled
Message-ID: <20190812142305.GC8105@infradead.org>
References: <20190807114252.2565-1-dgilbert@interlog.com>
 <20190807114252.2565-4-dgilbert@interlog.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190807114252.2565-4-dgilbert@interlog.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Aug 07, 2019 at 01:42:35PM +0200, Douglas Gilbert wrote:
> Replace SCSI_LOG_TIMEOUT macros with SG_LOG macros across the driver.
> The definition of SG_LOG calls SCSI_LOG_TIMEOUT if given and derived
> pointers are non-zero, calls pr_info otherwise. SG_LOGS additionally
> prints the sg device name and the thread id. The thread id is very
> useful, even in single threaded invocations because the driver not
> only uses the invocer's thread but also uses work queues and the
> main callback (i.e. sg_rq_end_io()) may hit any thread. Some
> interesting cases arise when the callback hits its invocer's
> thread.
> 
> SG_LOGS takes 48 bytes on the stack to build this printf format
> string: "sg%u: tid=%d" whose size is clearly bounded above by
> the maximum size of those two integers.
> Protecting against the 'current' pointer being zero is for safety
> and the case where the boot device is SCSI and the sg driver is
> built into the kernel. Also when debugging, getting a message
> from a compromised kernel can be very useful in pinpointing the
> location of the failure.
> 
> The simple fact that the SG_LOG macro is shorter than
> SCSI_LOG_TIMEOUT macro allow more error message "payload" per line.
> 
> Also replace #if and #ifdef conditional compilations with
> the IS_ENABLED macro.
> 
> Signed-off-by: Douglas Gilbert <dgilbert@interlog.com>
> ---
>  drivers/scsi/sg.c | 252 +++++++++++++++++++++++-----------------------
>  1 file changed, 125 insertions(+), 127 deletions(-)
> 
> diff --git a/drivers/scsi/sg.c b/drivers/scsi/sg.c
> index 6615777931f7..d14ba4a5441c 100644
> --- a/drivers/scsi/sg.c
> +++ b/drivers/scsi/sg.c
> @@ -57,6 +57,15 @@ static char *sg_version_date = "20190606";
>  
>  #define SG_MAX_DEVS 32768
>  
> +/* Comment out the following line to compile out SCSI_LOGGING stuff */
> +#define SG_DEBUG 1
> +
> +#if !IS_ENABLED(SG_DEBUG)
> +#if IS_ENABLED(DEBUG)	/* If SG_DEBUG not defined, check for DEBUG */
> +#define SG_DEBUG DEBUG
> +#endif
> +#endif

IS_ENABLED is mostly useful for checking it from C-level if statements.
No need to use this from cpp.  But even more importantly we generally
try to avoid cpp checks that aren't driven from Kconfig.  Please make
these an actual CONFIG_ options.

>  static int sg_read_oxfer(struct sg_request *srp, char __user *outp,
> -			 int num_read_xfer);
> +			 int num_xfer);

This looks like a random unrelated change.

> -#define SZ_SG_HEADER sizeof(struct sg_header)
> -#define SZ_SG_IO_HDR sizeof(sg_io_hdr_t)
> -#define SZ_SG_IOVEC sizeof(sg_iovec_t)
> -#define SZ_SG_REQ_INFO sizeof(sg_req_info_t)
> +#define SZ_SG_HEADER ((int)sizeof(struct sg_header))	/* v1 and v2 header */
> +#define SZ_SG_IO_HDR ((int)sizeof(struct sg_io_hdr))	/* v3 header */
> +#define SZ_SG_REQ_INFO ((int)sizeof(struct sg_req_info))

Doesn't look related to the patch.  But more importantly there should
be no point to cast or even have the macros wrapping the sizeof to
start with.

