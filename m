Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BD16FC3A5A7
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Dec 2022 09:24:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229684AbiLHJYr (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Dec 2022 04:24:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55148 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiLHJYq (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Dec 2022 04:24:46 -0500
Received: from mta-01.yadro.com (mta-02.yadro.com [89.207.88.252])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 399455C751;
        Thu,  8 Dec 2022 01:24:45 -0800 (PST)
Received: from mta-01.yadro.com (localhost.localdomain [127.0.0.1])
        by mta-01.yadro.com (Proxmox) with ESMTP id AE789341736;
        Thu,  8 Dec 2022 12:24:43 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yadro.com; h=cc
        :cc:content-type:content-type:date:from:from:in-reply-to
        :message-id:mime-version:references:reply-to:subject:subject:to
        :to; s=mta-01; bh=z5Ezz4TH4G51fc8ASR9v5fIPqQcZhc5rqkuGX7ueQ9s=; b=
        GaYgT0NQanz+Dt6N7Ss5vUdOXXKAKpgWwxg71K0pcsx4U8/bZ7mEc4wFtXxIXEVn
        wH9s20vGpvc+dLqn3VjkSTBS7QZ0kBQ9QDEVJzoOcg3S3tf0+MYSKRbhrcrEMALF
        xK14e0MsL19kuRy/zmnXsDV2UcckyhUBmtHLCFAQbyc=
Received: from T-EXCH-08.corp.yadro.com (unknown [172.17.10.14])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mta-01.yadro.com (Proxmox) with ESMTPS id A3F1A341730;
        Thu,  8 Dec 2022 12:24:43 +0300 (MSK)
Received: from yadro.com (10.199.18.20) by T-EXCH-08.corp.yadro.com
 (172.17.11.58) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.1118.9; Thu, 8 Dec 2022
 12:24:43 +0300
Date:   Thu, 8 Dec 2022 12:24:42 +0300
From:   Dmitry Bogdanov <d.bogdanov@yadro.com>
To:     Mike Christie <michael.christie@oracle.com>
CC:     <mlombard@redhat.com>, <martin.petersen@oracle.com>,
        <linux-scsi@vger.kernel.org>, <target-devel@vger.kernel.org>
Subject: Re: [PATCH 6/7] scsi: target: drop tas arg from
 __transport_wait_for_tasks
Message-ID: <20221208092442.GC15327@yadro.com>
References: <20221208031002.106700-1-michael.christie@oracle.com>
 <20221208031002.106700-7-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20221208031002.106700-7-michael.christie@oracle.com>
X-Originating-IP: [10.199.18.20]
X-ClientProxiedBy: T-EXCH-01.corp.yadro.com (172.17.10.101) To
 T-EXCH-08.corp.yadro.com (172.17.11.58)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Dec 07, 2022 at 09:10:01PM -0600, Mike Christie wrote:
> 
> The tas arg is no longer used by callers of __transport_wait_for_tasks
> so drop it.
> 
> Signed-off-by: Mike Christie <michael.christie@oracle.com>
> ---
>  drivers/target/target_core_transport.c | 20 ++++++++------------
>  1 file changed, 8 insertions(+), 12 deletions(-)
> 
> diff --git a/drivers/target/target_core_transport.c b/drivers/target/target_core_transport.c
> index 8bbf0c834b74..d42ba260f197 100644
> --- a/drivers/target/target_core_transport.c
> +++ b/drivers/target/target_core_transport.c
> @@ -2902,15 +2902,14 @@ static void transport_write_pending_qf(struct se_cmd *cmd)
>  }
> 
>  static bool
> -__transport_wait_for_tasks(struct se_cmd *, bool, bool *, bool *,
> -                          unsigned long *flags);
> +__transport_wait_for_tasks(struct se_cmd *, bool, bool *, unsigned long *flags);
> 
> -static void target_wait_free_cmd(struct se_cmd *cmd, bool *aborted, bool *tas)
> +static void target_wait_free_cmd(struct se_cmd *cmd, bool *aborted)
>  {
>         unsigned long flags;
> 
>         spin_lock_irqsave(&cmd->t_state_lock, flags);
> -       __transport_wait_for_tasks(cmd, true, aborted, tas, &flags);
> +       __transport_wait_for_tasks(cmd, true, aborted, &flags);
>         spin_unlock_irqrestore(&cmd->t_state_lock, flags);
>  }
> 
> @@ -2955,10 +2954,10 @@ int transport_generic_free_cmd(struct se_cmd *cmd, int wait_for_tasks)
>  {
>         DECLARE_COMPLETION_ONSTACK(compl);
>         int ret = 0;
> -       bool aborted = false, tas = false;
> +       bool aborted = false;
> 
>         if (wait_for_tasks)
> -               target_wait_free_cmd(cmd, &aborted, &tas);
> +               target_wait_free_cmd(cmd, &aborted);
> 
>         if (cmd->se_cmd_flags & SCF_SE_LUN_CMD) {
>                 /*
> @@ -3237,7 +3236,7 @@ void transport_clear_lun_ref(struct se_lun *lun)
> 
>  static bool
>  __transport_wait_for_tasks(struct se_cmd *cmd, bool fabric_stop,
> -                          bool *aborted, bool *tas, unsigned long *flags)
> +                          bool *aborted, unsigned long *flags)
>         __releases(&cmd->t_state_lock)
>         __acquires(&cmd->t_state_lock)
>  {
> @@ -3249,9 +3248,6 @@ __transport_wait_for_tasks(struct se_cmd *cmd, bool fabric_stop,
>         if (cmd->transport_state & CMD_T_ABORTED)
>                 *aborted = true;
> 
> -       if (cmd->transport_state & CMD_T_TAS)
> -               *tas = true;
> -
>         if (!(cmd->se_cmd_flags & SCF_SE_LUN_CMD) &&
>             !(cmd->se_cmd_flags & SCF_SCSI_TMR_CDB))
>                 return false;
> @@ -3292,10 +3288,10 @@ __transport_wait_for_tasks(struct se_cmd *cmd, bool fabric_stop,
>  bool transport_wait_for_tasks(struct se_cmd *cmd)
>  {
>         unsigned long flags;
> -       bool ret, aborted = false, tas = false;
> +       bool ret, aborted = false;
> 
>         spin_lock_irqsave(&cmd->t_state_lock, flags);
> -       ret = __transport_wait_for_tasks(cmd, false, &aborted, &tas, &flags);
> +       ret = __transport_wait_for_tasks(cmd, false, &aborted, &flags);
>         spin_unlock_irqrestore(&cmd->t_state_lock, flags);
> 
>         return ret;
> --
> 2.25.1
> 
>

Reviewed-by: Dmitry Bogdanov <d.bogdanov@yadro.com>
 

