Return-Path: <SRS0=BOnk=6Q=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 00C81C3A5A9
	for <linux-scsi@archiver.kernel.org>; Sat,  2 May 2020 14:29:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CA2BE21974
	for <linux-scsi@archiver.kernel.org>; Sat,  2 May 2020 14:29:37 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="fyrZFcjm"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728117AbgEBO3h (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 2 May 2020 10:29:37 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:58902 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728020AbgEBO3h (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 2 May 2020 10:29:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588429775;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=b7WJ+MKLLyGXB/QGxxlXuCezmOY5h7z9Abvr4yfXTSs=;
        b=fyrZFcjmgUNv+faY/6Gy1o2sflLuOLgu3Tq216J/3N8GUwxSbb3w89p6bBzxV+3NS6/SFw
        GE2gAKOMpnuUvSTepNqLXDtb0W2129mOwkphu+7ont9ytOotaBunj0E7gc+t2ACrt4Mhas
        VPnbXpyfPXRCk0PXjQ9JTPs14itva0A=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-379-utRsQoBbOIGMQgDq1-VJTw-1; Sat, 02 May 2020 10:29:31 -0400
X-MC-Unique: utRsQoBbOIGMQgDq1-VJTw-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 0D6301052508;
        Sat,  2 May 2020 14:29:30 +0000 (UTC)
Received: from T590 (ovpn-8-21.pek2.redhat.com [10.72.8.21])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 98A905D70C;
        Sat,  2 May 2020 14:29:12 +0000 (UTC)
Date:   Sat, 2 May 2020 22:29:07 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Hannes Reinecke <hare@suse.de>
Cc:     Christoph Hellwig <hch@lst.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        John Garry <john.garry@huawei.com>,
        Bart van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCH RFC v3 04/41] csiostor: use reserved command for LUN reset
Message-ID: <20200502142907.GE1013372@T590>
References: <20200430131904.5847-1-hare@suse.de>
 <20200430131904.5847-5-hare@suse.de>
 <20200430151546.GB1005453@T590>
 <cd0f88db-96ec-d69f-f33e-b10a1cb3756d@suse.de>
 <20200501150129.GB1012188@T590>
 <20200501174505.GC23795@lst.de>
 <eea98eb5-1779-cf06-e930-e47fb4918306@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <eea98eb5-1779-cf06-e930-e47fb4918306@suse.de>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, May 02, 2020 at 10:49:32AM +0200, Hannes Reinecke wrote:
> On 5/1/20 7:45 PM, Christoph Hellwig wrote:
> > On Fri, May 01, 2020 at 11:01:29PM +0800, Ming Lei wrote:
> > > > We cannot increase MAX_QUEUE arbitrarily as this is a compile time variable,
> > > > which seems to relate to a hardware setting.
> > > > 
> > > > But I can see to update the reserved command functionality for allowing to
> > > > fetch commands from the normal I/O tag pool; in the case of LUN reset it
> > > > shouldn't make much of a difference as the all I/O is quiesced anyway.
> > > 
> > > It isn't related with reset.
> > > 
> > > This patch reduces active IO queue depth by 1 anytime no matter there is reset
> > > or not, and this way may cause performance regression.
> > 
> > But isn't it the right thing to do?  How else do we guarantee that
> > there always is a tag available for the LU reset?
> > 
> Precisely. One could argue that this is an issue with the current driver,
> too; if all tags have timed-out there is no way how we can send a LUN reset
> even now. Hence we need to reserve a tag for us to reliably send a LUN
> reset.
> And this was precisely the problem what sparked off this entire patchset;
> some drivers require a valid tag to send internal, non SCSI commands to the
> hardware.

Could you explain a bit how you conclude that csio_scsi reset hander has to
use one unique tag? At least we don't allocate request from block layer for
ioctl(SG_SCSI_RESET), see scsi_ioctl_reset(). Also this patch doesn't
use the reserved rq->tag too.

> And with the current design it requires some really ugly hacks to make this
> to work.

You also don't explain how csio_eh_lun_reset_handler() is broken and where
the ugly hack is in csio scsi too, and how this patch fixes the issue, could
you document the exact reason in the commit log?


Thanks,
Ming

