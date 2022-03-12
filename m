Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C517C433FE
	for <linux-scsi@archiver.kernel.org>; Sat, 12 Mar 2022 21:45:13 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232783AbiCLVqR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 12 Mar 2022 16:46:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41484 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232730AbiCLVqQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 12 Mar 2022 16:46:16 -0500
Received: from relay.hostedemail.com (relay.a.hostedemail.com [64.99.140.24])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71C496E4D3;
        Sat, 12 Mar 2022 13:45:10 -0800 (PST)
Received: from omf09.hostedemail.com (a10.router.float.18 [10.200.18.1])
        by unirelay07.hostedemail.com (Postfix) with ESMTP id 0F8BD20EF6;
        Sat, 12 Mar 2022 21:45:09 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf09.hostedemail.com (Postfix) with ESMTPA id 8F47420028;
        Sat, 12 Mar 2022 21:45:02 +0000 (UTC)
Message-ID: <846e22e76ba9e4c620df159b073bbf4e058a35f0.camel@perches.com>
Subject: Re: [PATCH 4/6] scsi: lpfc: use kzalloc
From:   Joe Perches <joe@perches.com>
To:     Julia Lawall <Julia.Lawall@inria.fr>,
        James Smart <james.smart@broadcom.com>
Cc:     kernel-janitors@vger.kernel.org,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Sat, 12 Mar 2022 13:45:01 -0800
In-Reply-To: <20220312102705.71413-5-Julia.Lawall@inria.fr>
References: <20220312102705.71413-1-Julia.Lawall@inria.fr>
         <20220312102705.71413-5-Julia.Lawall@inria.fr>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.4-1ubuntu2 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Stat-Signature: p6yih6y7q3hu9hsxzjjetq7mn7b659cd
X-Rspamd-Server: rspamout07
X-Rspamd-Queue-Id: 8F47420028
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX19DJWJu0mr74IBHBM/nl8mkWSl5saQ3BR8=
X-HE-Tag: 1647121502-545075
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, 2022-03-12 at 11:27 +0100, Julia Lawall wrote:
> Use kzalloc instead of kmalloc + memset.
[]
> diff --git a/drivers/scsi/lpfc/lpfc_debugfs.c b/drivers/scsi/lpfc/lpfc_debugfs.c
[]
> @@ -6272,10 +6272,8 @@ lpfc_debugfs_initialize(struct lpfc_vport *vport)
>  				 phba->hba_debugfs_root,
>  				 phba, &lpfc_debugfs_op_slow_ring_trc);
>  		if (!phba->slow_ring_trc) {
> -			phba->slow_ring_trc = kmalloc(
> -				(sizeof(struct lpfc_debugfs_trc) *
> -				lpfc_debugfs_max_slow_ring_trc),
> -				GFP_KERNEL);
> +			phba->slow_ring_trc = kzalloc((sizeof(struct lpfc_debugfs_trc) * lpfc_debugfs_max_slow_ring_trc),
> +						      GFP_KERNEL);

kcalloc


