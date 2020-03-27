Return-Path: <SRS0=+SnX=5M=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,
	SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6E854C43331
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Mar 2020 09:27:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 397B920737
	for <linux-scsi@archiver.kernel.org>; Fri, 27 Mar 2020 09:27:28 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="DVgEUxNe"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727336AbgC0J11 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 27 Mar 2020 05:27:27 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:48128 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726920AbgC0J11 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Mar 2020 05:27:27 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=xjrvjnBd9VyLIzwJo3kEd8W1vawMgBtcfI1ETpNUmT0=; b=DVgEUxNe1bprJxhhAvAyr6/aH/
        j4mdXaUkyx75LdBY0eSdZIlDbH+xCXNVDS6NRq8p/0zIrfRKban+P5v1+bK5tj9aDqQNJTcqzYO4g
        6EwBYCSECiO4ZUxScGgyB6m/lItgU1hourYlm4J8VVpmdEaIm5iz4UIk6Ef6YfZWPu8Km/j3cRRNB
        JJSuaKQQuQ4WFuio6bugI7s0KwcDIS9j3PJb9jcusCrQxuIQBtE0VZSUQdUaBdSl7rHWKeo4nPOvr
        VEhk1zxg2LMzs5DK38wH/4o77cjoOurFFlJEZDqffsmv4biWmZiD+hTvxqdzHw5Q2fUeVZdXvH6ZE
        k8Ggh85g==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jHlGx-000411-Ar; Fri, 27 Mar 2020 09:27:27 +0000
Date:   Fri, 27 Mar 2020 02:27:27 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     David Disseldorp <ddiss@suse.de>
Cc:     target-devel@vger.kernel.org, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, bvanassche@acm.org
Subject: Re: [PATCH v2 5/5] scsi: target: use the stack for XCOPY passthrough
 cmds
Message-ID: <20200327092727.GB7952@infradead.org>
References: <20200326221505.5303-1-ddiss@suse.de>
 <20200326221505.5303-6-ddiss@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200326221505.5303-6-ddiss@suse.de>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Mar 26, 2020 at 11:15:05PM +0100, David Disseldorp wrote:
> Reads and writes in the XCOPY loop are synchronous, so needn't be
> heap allocated / freed with each loop.
> 
> Signed-off-by: David Disseldorp <ddiss@suse.de>

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>

But a few cleanup opportunities if you don't mind a respin:

> -	rc = target_xcopy_setup_pt_cmd(xpt_cmd, xop, src_dev, &cdb[0],
> +	rc = target_xcopy_setup_pt_cmd(&xpt_cmd, xop, src_dev, &cdb[0],
>  				remote_port);
>  	if (rc < 0) {
> -		ec_cmd->scsi_status = xpt_cmd->se_cmd.scsi_status;
> +		ec_cmd->scsi_status = se_cmd->scsi_status;
>  		transport_generic_free_cmd(se_cmd, 0);
>  		return rc;
>  	}
> @@ -603,13 +598,14 @@ static int target_xcopy_read_source(
>  	pr_debug("XCOPY-READ: Saved xop->xop_data_sg: %p, num: %u for READ"
>  		" memory\n", xop->xop_data_sg, xop->xop_data_nents);
>  
> -	rc = target_xcopy_issue_pt_cmd(xpt_cmd);
> +	rc = target_xcopy_issue_pt_cmd(&xpt_cmd);
>  	if (rc < 0) {
> -		ec_cmd->scsi_status = xpt_cmd->se_cmd.scsi_status;
> +		ec_cmd->scsi_status = se_cmd->scsi_status;
>  		transport_generic_free_cmd(se_cmd, 0);
>  		return rc;
>  	}
>  
> +	transport_generic_free_cmd(se_cmd, 0);
>  	return 0;

I think this should use a common label to free the command.  Same
for the write side.

>  		if (rc < 0) {
> -			transport_generic_free_cmd(&xop->src_pt_cmd->se_cmd, 0);
>  			goto out;
>  		}

No need for the braces now.
