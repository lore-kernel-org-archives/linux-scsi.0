Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8485BC4332B
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Feb 2021 15:21:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 63B4B64EF7
	for <linux-scsi@archiver.kernel.org>; Thu, 11 Feb 2021 15:21:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbhBKPUz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 11 Feb 2021 10:20:55 -0500
Received: from verein.lst.de ([213.95.11.211]:55799 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230235AbhBKPSe (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 11 Feb 2021 10:18:34 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 995DE68CFC; Thu, 11 Feb 2021 16:17:50 +0100 (CET)
Date:   Thu, 11 Feb 2021 16:17:50 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     hch@lst.de, loberman@redhat.com, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org,
        mst@redhat.com, stefanha@redhat.com
Subject: Re: [PATCH 14/14] target: remove target_submit_cmd_map_sgls
Message-ID: <20210211151750.GL22082@lst.de>
References: <20210211122728.31721-1-michael.christie@oracle.com> <20210211122728.31721-15-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210211122728.31721-15-michael.christie@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> + * This function must only be used by drivers that do their own
> + * sync during shutdown and does not use target_stop_session. If there
> + * is a failure this function will call into the fabric driver's
> + * queue_status with a CHECK_CONDITION.
>   */
> -int target_submit_cmd(struct se_cmd *se_cmd, struct se_session *se_sess,
> +void target_submit_cmd(struct se_cmd *se_cmd, struct se_session *se_sess,
>  		unsigned char *cdb, unsigned char *sense, u64 unpacked_lun,
>  		u32 data_length, int task_attr, int data_dir, int flags)
>  {
> +	target_init_cmd(se_cmd, se_sess, sense, unpacked_lun, data_length,
> +			task_attr, data_dir, flags);
> +	target_submit_prep(se_cmd, cdb, NULL, 0, NULL, 0, NULL, 0);

Do we want a WARN_ON_ONCE here to catch the case where the API is
misued?
