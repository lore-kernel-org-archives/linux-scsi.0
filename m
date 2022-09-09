Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3DB8FECAAA1
	for <linux-scsi@archiver.kernel.org>; Fri,  9 Sep 2022 06:03:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230125AbiIIGDN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 9 Sep 2022 02:03:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230076AbiIIGDM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Sep 2022 02:03:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FC4C98D30
        for <linux-scsi@vger.kernel.org>; Thu,  8 Sep 2022 23:03:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D2F2B61E8E
        for <linux-scsi@vger.kernel.org>; Fri,  9 Sep 2022 06:03:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2031C433D6;
        Fri,  9 Sep 2022 06:03:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1662703389;
        bh=kpSpYPBq4s02LFf9Br5MVJ3rwpXBovi3rKtzBfSP3N0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=kADsIqZGBVTAvypoIQSGWN1gTZGrPTm7tWGlcz8WIziLkdpKRLmGW5jyTLTl5NsYb
         OqfmioIJnx5LV8tT6h8L1rx0kxRHj8wB8L8+h4UROe/o8BfvtZ8e1BL3YCO7myPhoE
         XRztcjUYwjk7CweZavuwEK3WVBLEIrtm22vYGHQo=
Date:   Fri, 9 Sep 2022 08:03:06 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     James Bottomley <James.Bottomley@hansenpartnership.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        hdthky <hdthky0@gmail.com>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: PATCH] scsi: stex: properly zero out the passthrough command
 structure
Message-ID: <YxrXGvTCEJuL3+K+@kroah.com>
References: <CAHk-=wjXO3=VDjwrtWPCdzQtmWS19UmoUGEXy-zbg5R0fMpJkg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHk-=wjXO3=VDjwrtWPCdzQtmWS19UmoUGEXy-zbg5R0fMpJkg@mail.gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Sep 08, 2022 at 02:16:33PM -0400, Linus Torvalds wrote:
> Sorry for bad message ID threading, but I don't have the original
> email from Greg in my email, just a link to it on lore..
> 
> I'd suggest perhaps a slightly bigger patch than just adding the memset().
> 
> Something like the attached?
> 
> Entirely untested, but it would seem to be the cleaner way to go about this. No?
> 
>             Linus

>  drivers/scsi/stex.c      | 17 +++++++++--------
>  include/scsi/scsi_cmnd.h |  2 +-
>  2 files changed, 10 insertions(+), 9 deletions(-)
> 
> diff --git a/drivers/scsi/stex.c b/drivers/scsi/stex.c
> index e6420f2127ce..8def242675ef 100644
> --- a/drivers/scsi/stex.c
> +++ b/drivers/scsi/stex.c
> @@ -665,16 +665,17 @@ static int stex_queuecommand_lck(struct scsi_cmnd *cmd)
>  		return 0;
>  	case PASSTHRU_CMD:
>  		if (cmd->cmnd[1] == PASSTHRU_GET_DRVVER) {
> -			struct st_drvver ver;
> +			const struct st_drvver ver = {
> +				.major = ST_VER_MAJOR,
> +				.minor = ST_VER_MINOR,
> +				.oem = ST_OEM,
> +				.build = ST_BUILD_VER,
> +				.signature[0] = PASSTHRU_SIGNATURE,
> +				.console_id = host->max_id - 1,
> +				.host_no = hba->host->host_no,
> +			};
>  			size_t cp_len = sizeof(ver);
>  
> -			ver.major = ST_VER_MAJOR;
> -			ver.minor = ST_VER_MINOR;
> -			ver.oem = ST_OEM;
> -			ver.build = ST_BUILD_VER;
> -			ver.signature[0] = PASSTHRU_SIGNATURE;
> -			ver.console_id = host->max_id - 1;
> -			ver.host_no = hba->host->host_no;
>  			cp_len = scsi_sg_copy_from_buffer(cmd, &ver, cp_len);
>  			if (sizeof(ver) == cp_len)
>  				cmd->result = DID_OK << 16;
> diff --git a/include/scsi/scsi_cmnd.h b/include/scsi/scsi_cmnd.h
> index bac55decf900..7d3622db38ed 100644
> --- a/include/scsi/scsi_cmnd.h
> +++ b/include/scsi/scsi_cmnd.h
> @@ -201,7 +201,7 @@ static inline unsigned int scsi_get_resid(struct scsi_cmnd *cmd)
>  	for_each_sg(scsi_sglist(cmd), sg, nseg, __i)
>  
>  static inline int scsi_sg_copy_from_buffer(struct scsi_cmnd *cmd,
> -					   void *buf, int buflen)
> +					   const void *buf, int buflen)
>  {
>  	return sg_copy_from_buffer(scsi_sglist(cmd), scsi_sg_count(cmd),
>  				   buf, buflen);


Sure, this looks a bit "nicer" than just the memset, let me resend this
as a v2.

thanks,

greg k-h
