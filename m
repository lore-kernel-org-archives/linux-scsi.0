Return-Path: <SRS0=ZMHN=ZI=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F1F7C432C3
	for <linux-scsi@archiver.kernel.org>; Sat, 16 Nov 2019 16:31:23 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 7D71A216F4
	for <linux-scsi@archiver.kernel.org>; Sat, 16 Nov 2019 16:31:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727893AbfKPQbX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 16 Nov 2019 11:31:23 -0500
Received: from verein.lst.de ([213.95.11.211]:49379 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727606AbfKPQbW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sat, 16 Nov 2019 11:31:22 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 45ADB68BE1; Sat, 16 Nov 2019 17:31:21 +0100 (CET)
Date:   Sat, 16 Nov 2019 17:31:20 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 2/5] dpt_i2o: use midlayer tcq implementation
Message-ID: <20191116163120.GC23951@lst.de>
References: <20191115122757.132006-1-hare@suse.de> <20191115122757.132006-3-hare@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191115122757.132006-3-hare@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Nov 15, 2019 at 01:27:54PM +0100, Hannes Reinecke wrote:
> +	cmd->result = (DID_OK << 16) | SAM_STAT_TASK_SET_FULL;
> +	cmd->scsi_done(cmd);
>  
> +	return true;
> +}
> +
> +static void adpt_fail_posted_scbs(adpt_hba* pHba)
> +{
> +	scsi_host_busy_iter(pHba->host, fail_posted_scbs_iter, NULL);

I still think that SAM_STAT_TASK_SET_FULL is a very strange error here,
and that we should have a helper like adpt_fail_posted_scbs in the
core SCSI code.  Also your * placement is wrong above.
