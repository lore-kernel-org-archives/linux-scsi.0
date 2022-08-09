Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6D76C19F2D
	for <linux-scsi@archiver.kernel.org>; Tue,  9 Aug 2022 14:51:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243594AbiHIOvT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 9 Aug 2022 10:51:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37846 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239238AbiHIOvS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Aug 2022 10:51:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B90DBC9F;
        Tue,  9 Aug 2022 07:51:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D8842B8136E;
        Tue,  9 Aug 2022 14:51:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BFA3C433D6;
        Tue,  9 Aug 2022 14:51:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660056674;
        bh=iGCp19kVvCXGqnPjcIt+mU0Lhz4Q6PTrXmOH3mmJO/s=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=a26OssopesPq+maldubMeZ4Qo99gS0ynwF2G9FKqXWILrFsckZFVJqerLDEJXT301
         TfwiPf+Gs5EKOMITBcK4RECDHtYhZcMKhsvUjR4BqNyeh5zeGXu6IRDDah6cB8YP1b
         C5xr6hkiNuqXTD+Jkqb7l4B7bjfg9tmGwjTo1WR9Rs8qkJiJUsBTiuXHfY47GHFaFj
         werR14RDCwbFSeQv9Ttqw8f9Gz3wIvJJXF/p3VBDi9tBZcrKb6EVglRec4A5bLvfOB
         XSrMZKUo/JLKsv/lbt/I3Z85iPFT1L8EEsnLgF9MdQEQNwfXIPgiGnE3W9b6CWBEig
         20tkeBKbMZYwQ==
Date:   Tue, 9 Aug 2022 08:51:10 -0600
From:   Keith Busch <kbusch@kernel.org>
To:     Chaitanya Kulkarni <chaitanyak@nvidia.com>
Cc:     Mike Christie <michael.christie@oracle.com>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "dm-devel@redhat.com" <dm-devel@redhat.com>,
        "snitzer@kernel.org" <snitzer@kernel.org>,
        "axboe@kernel.dk" <axboe@kernel.dk>, "hch@lst.de" <hch@lst.de>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "james.bottomley@hansenpartnership.com" 
        <james.bottomley@hansenpartnership.com>
Subject: Re: [PATCH v2 09/20] nvme: Add helper to execute Reservation Report
Message-ID: <YvJ0Xh61npH+M9HP@kbusch-mbp.dhcp.thefacebook.com>
References: <20220809000419.10674-1-michael.christie@oracle.com>
 <20220809000419.10674-10-michael.christie@oracle.com>
 <12b99b10-8353-0f72-f314-c453a4fc5b6a@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <12b99b10-8353-0f72-f314-c453a4fc5b6a@nvidia.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Aug 09, 2022 at 10:56:55AM +0000, Chaitanya Kulkarni wrote:
> On 8/8/22 17:04, Mike Christie wrote:
> > +
> > +	c.common.opcode = nvme_cmd_resv_report;
> > +	c.common.cdw10 = cpu_to_le32(nvme_bytes_to_numd(data_len));
> > +	c.common.cdw11 = 1;
> > +	*eds = true;
> > +
> > +retry:
> > +	if (IS_ENABLED(CONFIG_NVME_MULTIPATH) &&
> > +	    bdev->bd_disk->fops == &nvme_ns_head_ops)
> > +		ret = nvme_send_ns_head_pr_command(bdev, &c, data, data_len);
> > +	else
> > +		ret = nvme_send_ns_pr_command(bdev->bd_disk->private_data, &c,
> > +					      data, data_len);
> > +	if (ret == NVME_SC_HOST_ID_INCONSIST && c.common.cdw11) {
> > +		c.common.cdw11 = 0;
> > +		*eds = false;
> > +		goto retry;
> 
> Unconditional retries without any limit can create problems,
> perhaps consider adding some soft limits.

It's already conditioned on cdw11, which is cleared to 0 on the 2nd try. Not
that that's particularly clear. I'd suggest naming an enum value for it so the
code tells us what the signficance of cdw11 is in this context (it's the
Extended Data Structure control flag).
