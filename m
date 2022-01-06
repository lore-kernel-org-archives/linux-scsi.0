Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FDFCC433F5
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Jan 2022 15:35:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240509AbiAFPfq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Jan 2022 10:35:46 -0500
Received: from smtp-out2.suse.de ([195.135.220.29]:46518 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240432AbiAFPfq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Jan 2022 10:35:46 -0500
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 6EB131F397;
        Thu,  6 Jan 2022 15:35:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1641483345; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=fVsk0/ogWlE6vOSLkAfd7Tqzy1X3kZGtKnoMruk6zqY=;
        b=TXAuiWzYA+LO04sszQzt+45Nqhg5n5/vBm4e8oOJFFiixLf9v02eTi0/GqGKgIWikdrzDm
        q/7ASfB6nFLXsZJhlxJtF4yfg3FBYBJqi0BSSQya6NNMw1z+J8uzQ+nSZrx5c1WXdwXsXI
        RS+eq0u966WZOXTLh13ssiLH8fFJgMg=
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 338F013C5A;
        Thu,  6 Jan 2022 15:35:45 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id R4sdClEM12GGeQAAMHmgww
        (envelope-from <mwilck@suse.com>); Thu, 06 Jan 2022 15:35:45 +0000
Message-ID: <47f85b06e77c6aa2b1f11130760c4eb7177a7309.camel@suse.com>
Subject: Re: [PATCH] qla2xxx: fix error status checking in
 qla24xx_modify_vp_config()
From:   Martin Wilck <mwilck@suse.com>
To:     Dirk =?ISO-8859-1?Q?M=FCller?= <dmueller@suse.de>,
        linux-scsi@vger.kernel.org
Cc:     Nilesh Javali <njavali@marvell.com>,
        GR-QLogic-Storage-Upstream@marvell.com
Date:   Thu, 06 Jan 2022 16:35:44 +0100
In-Reply-To: <20220105130337.31758-1-dmueller@suse.de>
References: <20220105130337.31758-1-dmueller@suse.de>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.42.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2022-01-05 at 14:03 +0100, Dirk Müller wrote:
> The function was checking vpmod->comp_status and reported it as error
> status, which is however already checked a few lines below.
> 
> Guessing from other occurrences it was supposed to check entry_status
> instead.
> 
> Fixes: 2c3dfe3f6ad8 ("[SCSI] qla2xxx: add support for NPIV")
> Signed-off-by: Dirk Müller <dmueller@suse.de>
> ---
>  drivers/scsi/qla2xxx/qla_mbx.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_mbx.c
> b/drivers/scsi/qla2xxx/qla_mbx.c
> index 10d2655ef676..e0dce38b65cf 100644
> --- a/drivers/scsi/qla2xxx/qla_mbx.c
> +++ b/drivers/scsi/qla2xxx/qla_mbx.c
> @@ -4253,7 +4253,7 @@ qla24xx_modify_vp_config(scsi_qla_host_t *vha)
>         if (rval != QLA_SUCCESS) {
>                 ql_dbg(ql_dbg_mbx, vha, 0x10bd,
>                     "Failed to issue VP config IOCB (%x).\n", rval);
> -       } else if (vpmod->comp_status != 0) {
> +       } else if (vpmod->entry_status != 0) {
>                 ql_dbg(ql_dbg_mbx, vha, 0x10be,
>                     "Failed to complete IOCB -- error status
> (%x).\n",
>                     vpmod->comp_status);

Your suggestion makes sense, but you should also change the value
passed to ql_dbg(), and cc the driver maintainers.

Thanks,
Martin


