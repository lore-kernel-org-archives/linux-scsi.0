Return-Path: <SRS0=VRpU=44=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 48E0BC10F29
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Mar 2020 08:00:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1DCC3205C9
	for <linux-scsi@archiver.kernel.org>; Wed, 11 Mar 2020 08:00:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="LslJIrMG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728525AbgCKIAv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 11 Mar 2020 04:00:51 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:40541 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728195AbgCKIAs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 11 Mar 2020 04:00:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583913647;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=BTQ/qk+PVYNZHsKM28XRoYcuNh5fpwlLGdRZPJQp7IM=;
        b=LslJIrMGyeY2qzQm10qSrcGvSYRN8FBQ5Hne4C9WZ7XT0uncO0TxbFEXclI+C5cpC57Rsy
        bXACM3pIn9caWatPyzNNfKi6V1BkVPnNisU36dUWbjYbaHT5IlTDejF23SOYr0cSUq9EqN
        Y/rlARvVePkrWt7DrapHVS12B6esNKw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-8-QGvsN90iOsqhbPUTuUsqug-1; Wed, 11 Mar 2020 04:00:43 -0400
X-MC-Unique: QGvsN90iOsqhbPUTuUsqug-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6EAB418B5F8A;
        Wed, 11 Mar 2020 08:00:41 +0000 (UTC)
Received: from ming.t460p (ovpn-8-26.pek2.redhat.com [10.72.8.26])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 69F7D60C18;
        Wed, 11 Mar 2020 08:00:30 +0000 (UTC)
Date:   Wed, 11 Mar 2020 16:00:26 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Hannes Reinecke <hare@suse.de>
Cc:     John Garry <john.garry@huawei.com>, axboe@kernel.dk,
        jejb@linux.ibm.com, martin.petersen@oracle.com, bvanassche@acm.org,
        hch@infradead.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        esc.storagedev@microsemi.com, chenxiang66@hisilicon.com,
        Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCH RFC v2 01/24] scsi: add 'nr_reserved_cmds' field to the
 SCSI host template
Message-ID: <20200311080026.GB31504@ming.t460p>
References: <1583857550-12049-1-git-send-email-john.garry@huawei.com>
 <1583857550-12049-2-git-send-email-john.garry@huawei.com>
 <20200310230835.GA16056@ming.t460p>
 <fecc400c-fe6b-144a-51f9-1b3b2704c1a2@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <fecc400c-fe6b-144a-51f9-1b3b2704c1a2@suse.de>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Mar 11, 2020 at 07:55:46AM +0100, Hannes Reinecke wrote:
> On 3/11/20 12:08 AM, Ming Lei wrote:
> > On Wed, Mar 11, 2020 at 12:25:27AM +0800, John Garry wrote:
> >> From: Hannes Reinecke <hare@suse.com>
> >>
> >> Add a new field 'nr_reserved_cmds' to the SCSI host template to
> >> instruct the block layer to set aside a tag space for reserved
> >> commands.
> >>
> >> Signed-off-by: Hannes Reinecke <hare@suse.com>
> >> ---
> >>  drivers/scsi/scsi_lib.c  | 1 +
> >>  include/scsi/scsi_host.h | 6 ++++++
> >>  2 files changed, 7 insertions(+)
> >>
> >> diff --git a/drivers/scsi/scsi_lib.c b/drivers/scsi/scsi_lib.c
> >> index 610ee41fa54c..2967325df7a0 100644
> >> --- a/drivers/scsi/scsi_lib.c
> >> +++ b/drivers/scsi/scsi_lib.c
> >> @@ -1896,6 +1896,7 @@ int scsi_mq_setup_tags(struct Scsi_Host *shost)
> >>  		shost->tag_set.ops = &scsi_mq_ops_no_commit;
> >>  	shost->tag_set.nr_hw_queues = shost->nr_hw_queues ? : 1;
> >>  	shost->tag_set.queue_depth = shost->can_queue;
> >> +	shost->tag_set.reserved_tags = shost->nr_reserved_cmds;
> > 
> > You reserve tags for special usage, meantime the whole queue depth
> > isn't increased, that means the tags for IO request is decreased given
> > reserved tags can't be used for IO, so IO performance may be effected.
> > 
> > If not the case, please explain a bit in commit log.
> > 
> The overall idea of this patchset is to fold _existing_ management
> command handling into using the blk-mq bitmap.
> Currently, quite a lot of drivers are using management commands
> internally, which typically use the same hardware tag pool (ie they are
> being allocated from the same hardware resources) than the 'normal' I/O
> commands.
> But as they are using the same tagpool these drivers already decrement
> the available number of commands; check eg. hpsa:
> 
> static int hpsa_scsi_host_alloc(struct ctlr_info *h)
> {
> 	struct Scsi_Host *sh;
> 
> 	sh = scsi_host_alloc(&hpsa_driver_template, sizeof(h));
> 	if (sh == NULL) {
> 		dev_err(&h->pdev->dev, "scsi_host_alloc failed\n");
> 		return -ENOMEM;
> 	}
> 
> 	sh->io_port = 0;
> 	sh->n_io_port = 0;
> 	sh->this_id = -1;
> 	sh->max_channel = 3;
> 	sh->max_cmd_len = MAX_COMMAND_SIZE;
> 	sh->max_lun = HPSA_MAX_LUN;
> 	sh->max_id = HPSA_MAX_LUN;
> 	sh->can_queue = h->nr_cmds - HPSA_NRESERVED_CMDS;
> 	sh->cmd_per_lun = sh->can_queue;
> 
> So the idea of this patchset is to convert existing use-cases; seeing
> that they already reserve commands internally performance will not be
> affected.
> 

OK, got it.

I'd suggest to add comment about this idea in commit log, cause
it is one fundamental thing about this change.

Thanks,
Ming

