Return-Path: <SRS0=Qtkh=6S=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AFC1BC3A5A9
	for <linux-scsi@archiver.kernel.org>; Mon,  4 May 2020 08:47:19 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8BA2624958
	for <linux-scsi@archiver.kernel.org>; Mon,  4 May 2020 08:47:19 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="XqVbssx5"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727929AbgEDIrT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 4 May 2020 04:47:19 -0400
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:27748 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726351AbgEDIrT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 4 May 2020 04:47:19 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1588582038;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=bNIaFZOC6fRp0zu6sz7jCXxL57iQi3VDVV9OWFjxzeI=;
        b=XqVbssx59Jw02Kgwmf0V946JwortzEfXwsiz7CYm/o33jk/brmeAjQKM+db1I4NABTUYwB
        xiFCMiicccUr4TKQBOP0cumKoLJkFMRpHMn+tdK2DUDCsGpRmZ54jybXQxTCAq9uWCgpiY
        OMP259wQodLzqPgMRtieB8ZyuONFY0Y=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-117-nCNJwIowMeK0hGexu0mBwA-1; Mon, 04 May 2020 04:47:15 -0400
X-MC-Unique: nCNJwIowMeK0hGexu0mBwA-1
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 209FEA0BE5;
        Mon,  4 May 2020 08:47:14 +0000 (UTC)
Received: from T590 (ovpn-8-16.pek2.redhat.com [10.72.8.16])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3DA491000322;
        Mon,  4 May 2020 08:47:05 +0000 (UTC)
Date:   Mon, 4 May 2020 16:47:00 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Hannes Reinecke <hare@suse.de>
Cc:     Christoph Hellwig <hch@lst.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        John Garry <john.garry@huawei.com>,
        Bart van Assche <bvanassche@acm.org>,
        linux-scsi@vger.kernel.org, Hannes Reinecke <hare@suse.com>
Subject: Re: [PATCH RFC v3 04/41] csiostor: use reserved command for LUN reset
Message-ID: <20200504084700.GB1139563@T590>
References: <20200430131904.5847-1-hare@suse.de>
 <20200430131904.5847-5-hare@suse.de>
 <20200430151546.GB1005453@T590>
 <cd0f88db-96ec-d69f-f33e-b10a1cb3756d@suse.de>
 <20200501150129.GB1012188@T590>
 <20200501174505.GC23795@lst.de>
 <eea98eb5-1779-cf06-e930-e47fb4918306@suse.de>
 <20200502142907.GE1013372@T590>
 <8795fedc-8b07-fbfc-89f5-0cb76ee054b0@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8795fedc-8b07-fbfc-89f5-0cb76ee054b0@suse.de>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, May 04, 2020 at 08:55:05AM +0200, Hannes Reinecke wrote:
> On 5/2/20 4:29 PM, Ming Lei wrote:
> > On Sat, May 02, 2020 at 10:49:32AM +0200, Hannes Reinecke wrote:
> > > On 5/1/20 7:45 PM, Christoph Hellwig wrote:
> > > > On Fri, May 01, 2020 at 11:01:29PM +0800, Ming Lei wrote:
> > > > > > We cannot increase MAX_QUEUE arbitrarily as this is a compile time variable,
> > > > > > which seems to relate to a hardware setting.
> > > > > > 
> > > > > > But I can see to update the reserved command functionality for allowing to
> > > > > > fetch commands from the normal I/O tag pool; in the case of LUN reset it
> > > > > > shouldn't make much of a difference as the all I/O is quiesced anyway.
> > > > > 
> > > > > It isn't related with reset.
> > > > > 
> > > > > This patch reduces active IO queue depth by 1 anytime no matter there is reset
> > > > > or not, and this way may cause performance regression.
> > > > 
> > > > But isn't it the right thing to do?  How else do we guarantee that
> > > > there always is a tag available for the LU reset?
> > > > 
> > > Precisely. One could argue that this is an issue with the current driver,
> > > too; if all tags have timed-out there is no way how we can send a LUN reset
> > > even now. Hence we need to reserve a tag for us to reliably send a LUN
> > > reset.
> > > And this was precisely the problem what sparked off this entire patchset;
> > > some drivers require a valid tag to send internal, non SCSI commands to the
> > > hardware.
> > 
> > Could you explain a bit how you conclude that csio_scsi reset hander has to
> > use one unique tag? At least we don't allocate request from block layer for
> > ioctl(SG_SCSI_RESET), see scsi_ioctl_reset(). Also this patch doesn't
> > use the reserved rq->tag too.
> > 
> > > And with the current design it requires some really ugly hacks to make this
> > > to work.
> > 
> > You also don't explain how csio_eh_lun_reset_handler() is broken and where
> > the ugly hack is in csio scsi too, and how this patch fixes the issue, could
> > you document the exact reason in the commit log?
> > 
> The problem is the ioctl path.
> When issuing TMF commands from the ioctl path we currently do not have a
> valid SCSI command to pass to the various SCSI EH functions.
> This requires the SCSI LLDDs to check for every EH function whether the
> passed in SCSI command is valid (ie coming from SCSI EH), or a made up one
> coming from the ioctl path.

Could you point out where the check is in csio driver?

> And having to code various ways to work around this issue.
> 
> With this patchset I'm implementing a standardized way how these functions
> can be coded. By using a reserved command the EH functions and the driver
> internal command handling will always have a valid command, so the
> workarounds can be removed.

It depends if every HBA really requires unique tag for sending reset command.

If some HBAs don't require unique tag for resetting device or host, the
reserved tag is wasted.

thanks, 
Ming

