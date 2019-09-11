Return-Path: <SRS0=uqxd=XG=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 380D5C49ED9
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Sep 2019 00:19:56 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id EEEAC216F4
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Sep 2019 00:19:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="akA/vbBz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726208AbfIKATz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 10 Sep 2019 20:19:55 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:36144 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726192AbfIKATz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 10 Sep 2019 20:19:55 -0400
Received: by mail-qt1-f194.google.com with SMTP id o12so23126417qtf.3
        for <linux-scsi@vger.kernel.org>; Tue, 10 Sep 2019 17:19:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:date:in-reply-to:references:user-agent
         :mime-version:content-transfer-encoding;
        bh=YHsllVmM1U5UEmFyW7Jko3c9OqtV1lJpGOTtci4FVvg=;
        b=akA/vbBzGH+fVg59MpJ2dAC3HL8g6b+UTaPoPy6niZwe2noQYhGUV6sRlR1tRRZubU
         sdnWpe90bk9x7bBkle8RFpEYuXsWiLjrsxscir3zBXLUlPbtOBwBw8IX95krjI9pvFcO
         Xxo8rERLg40hy7U1ntrRBYzG2DcZaLdn+x9NtHbMlnoaakreDk4CMPhwwxe36WpJwYZP
         Do9u44yOodHt+DHlGmWbh8q4OarCDi7BqwegjYzCjHob14lqmChpbVly8YJVIkBUvUWI
         nhJjgAYgnlXFbv+vkH1GrhiiRyIObGf5LNUgIjTi1staIEcH4JUUtz1qULTOiX5RT8jZ
         ZJYQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=YHsllVmM1U5UEmFyW7Jko3c9OqtV1lJpGOTtci4FVvg=;
        b=kAsiGMyVpLwiUxrJb3Z6t0ocS1eOvr4weThl5zXQd6+h15Fr080oMnnXwE7tb4dYAo
         VcwXInhvYlvOrQimgKvt8JFOhrasZI2M53lSAy98DTdQZKIg2a0lzY4riIDtq12zD6mJ
         tXKYdWE00g6K0J5V2s3oacjhGL3zmm+YYQYt4i7i0Xo/l/QDsQAX189hwIIu1zjPeWsG
         R1+vt2/wG/V1htkA79966egp/UjRY8kevVAQ8GNwMKJ2E+1E64Hc99ZtPuWYu9ljVgUe
         ZPqypLQ87RE2QNLW3/E6qfKQA+BJ2zcVtibo6+tu82ihBeDcq02oQrgWlNL4nxd3OljX
         70aw==
X-Gm-Message-State: APjAAAWGal4mL1Q+BBf6H5HCGUEJHhVJUrpGwY0Pfo+oA9wuwQxC52iS
        SvO3dH4HOr9atypWuxOZles=
X-Google-Smtp-Source: APXvYqzaFjUPUDJ5QADYBzHO1qUg68NCUP55E9U/lX62SESeJjjTFsrrRFbI9MFtvZev+am++4xTKg==
X-Received: by 2002:ac8:4548:: with SMTP id z8mr32192663qtn.258.1568161192508;
        Tue, 10 Sep 2019 17:19:52 -0700 (PDT)
Received: from localhost.localdomain (pool-96-230-166-208.prvdri.fios.verizon.net. [96.230.166.208])
        by smtp.gmail.com with ESMTPSA id t9sm8761285qkt.26.2019.09.10.17.19.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Sep 2019 17:19:51 -0700 (PDT)
Message-ID: <cbd790d7bea8b374726e176db04efe37b62309d1.camel@gmail.com>
Subject: Re: [PATCH] bnx2fc: Handle scope bits when array returns BUSY or
 TASK_SET_FULL
From:   cdupuis1@gmail.com
To:     Laurence Oberman <loberman@redhat.com>,
        QLogic-Storage-Upstream@qlogic.com, linux-scsi@vger.kernel.org
Date:   Tue, 10 Sep 2019 20:19:50 -0400
In-Reply-To: <1568030756-17428-1-git-send-email-loberman@redhat.com>
References: <1568030756-17428-1-git-send-email-loberman@redhat.com>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.32.4 (3.32.4-1.fc30) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 2019-09-09 at 08:05 -0400, Laurence Oberman wrote:
> The qla2xxx driver had this issue as well when the newer array
> firmware returned the retry_delay_timer in the fcp_rsp.
> The bnx2fc is not handling the masking of the scope bits either
> so the retry_delay_timestamp value lands up being a large value
> added to the timer timestamp delaying I/O for up to 27 Minutes.
> This patch adds similar code to handle this to the
> bnx2fc driver to avoid the huge delay.
> 
> V2. Indent comments as suggested
> 
> Signed-off-by: Laurence Oberman <loberman@redhat.com>
> ---
>  drivers/scsi/bnx2fc/bnx2fc_io.c | 23 ++++++++++++++++++++---
>  1 file changed, 20 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/bnx2fc/bnx2fc_io.c
> b/drivers/scsi/bnx2fc/bnx2fc_io.c
> index 9e50e5b..39f4aeb 100644
> --- a/drivers/scsi/bnx2fc/bnx2fc_io.c
> +++ b/drivers/scsi/bnx2fc/bnx2fc_io.c
> @@ -1928,6 +1928,7 @@ void bnx2fc_process_scsi_cmd_compl(struct
> bnx2fc_cmd *io_req,
>  	struct bnx2fc_rport *tgt = io_req->tgt;
>  	struct scsi_cmnd *sc_cmd;
>  	struct Scsi_Host *host;
> +	u16 scope, qualifier = 0;
>  
>  
>  	/* scsi_cmd_cmpl is called with tgt lock held */
> @@ -1997,12 +1998,28 @@ void bnx2fc_process_scsi_cmd_compl(struct
> bnx2fc_cmd *io_req,
>  
>  			if (io_req->cdb_status ==
> SAM_STAT_TASK_SET_FULL ||
>  			    io_req->cdb_status == SAM_STAT_BUSY) {
> +				/* Newer array firmware with BUSY or
> +				 * TASK_SET_FULL may return a status
> that needs
> +				 * the scope bits masked.
> +				 * Or a huge delay timestamp up to 27
> minutes
> +				 * can result.
> +				*/
> +				if (fcp_rsp->retry_delay_timer) {
> +					/* Upper 2 bits */
> +					scope = fcp_rsp-
> >retry_delay_timer
> +						& 0xC000;
> +					/* Lower 14 bits */
> +					qualifier = fcp_rsp-
> >retry_delay_timer
> +						& 0x3FFF;
> +				}
> +				if (scope > 0 && qualifier > 0 &&
> +					qualifier <= 0x3FEF) {
>  					/* Set the jiffies + 
> 					retry_delay_timer * 100ms
>  				   	for the rport/tgt 
> 					*/
> -				tgt->retry_delay_timestamp = jiffies +
> -					fcp_rsp->retry_delay_timer * HZ
> / 10;
> +					tgt->retry_delay_timestamp =
> jiffies +
> +						(qualifier * HZ / 10);
> +				}
>  			}
> -
>  		}
>  		if (io_req->fcp_resid)
>  			scsi_set_resid(sc_cmd, io_req->fcp_resid);

V2 looks good.

Reviewed-by: Chad Dupuis <cdupuis1@gmail.com>

