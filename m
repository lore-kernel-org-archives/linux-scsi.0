Return-Path: <SRS0=ehq5=D3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4D6F6C4363A
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Oct 2020 18:14:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D31A920BED
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Oct 2020 18:14:27 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Wg/cxi1C"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408979AbgJTSO1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 20 Oct 2020 14:14:27 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:59884 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2408970AbgJTSO0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 20 Oct 2020 14:14:26 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603217664;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=6Hj5xwtXk4fL92mL3YhjtLxsL/u+Y03xy7hrmwtML8U=;
        b=Wg/cxi1CTWPw0f9gGwXn8TLsD5gQoEQut2pTdF1KS/HXSo9RgP1q9BiIQQ95vmFFxz26Fe
        3MRw+1qCDcwPvn3CHl8EC56OKmqzwA/07mqPlajQVVYkeTfSZK9BVQbt49yuNQqaiR8j90
        5Lfz18iOp5fgIBPykxLB1Up6VGdcVD8=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-360-ExRyg_zOPwCp62Vs4XDvGg-1; Tue, 20 Oct 2020 14:14:23 -0400
X-MC-Unique: ExRyg_zOPwCp62Vs4XDvGg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D9F871009E2B;
        Tue, 20 Oct 2020 18:14:20 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 3B9AE6EF62;
        Tue, 20 Oct 2020 18:14:18 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
        by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 09KIEGTm020605;
        Tue, 20 Oct 2020 13:14:16 -0500
Received: (from bmarzins@localhost)
        by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 09KIEFtU020604;
        Tue, 20 Oct 2020 13:14:15 -0500
Date:   Tue, 20 Oct 2020 13:14:15 -0500
From:   Benjamin Marzinski <bmarzins@redhat.com>
To:     Muneendra Kumar M <muneendra.kumar@broadcom.com>
Cc:     Mike Christie <michael.christie@oracle.com>,
        Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org,
        jsmart2021@gmail.com, emilne@redhat.com, mkumar@redhat.com
Subject: Re: [PATCH v3 05/17] scsi_transport_fc: Added a new rport state
 FC_PORTSTATE_MARGINAL
Message-ID: <20201020181415.GL3384@octiron.msp.redhat.com>
References: <1602732462-10443-1-git-send-email-muneendra.kumar@broadcom.com>
 <1602732462-10443-6-git-send-email-muneendra.kumar@broadcom.com>
 <5ca752c2-94e1-444a-7755-f48b09b38577@oracle.com>
 <c3d65f732be0b73e4d4ebb742bc754cd@mail.gmail.com>
 <3803E6D0-68D6-407F-80AB-A17E7E0E69E3@oracle.com>
 <CE70AE32-4318-4FB2-AEED-3606DEF59B79@oracle.com>
 <a9b958fb-3c06-c385-f7ce-ce0fc863e64b@suse.de>
 <e031f239c4bc02cafde13ad573523559@mail.gmail.com>
 <0863bb07-1f74-ba14-50dc-717c7f68af7e@oracle.com>
 <9e48826470ef61e2d56922c4290c2c0b@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <9e48826470ef61e2d56922c4290c2c0b@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Oct 20, 2020 at 12:25:42AM +0530, Muneendra Kumar M wrote:
> Hi Micheal,
> AFIK As long as the paths are available irrespective of  the path is moved
> to marginal path group or not multipathd  will keep sending the send path
> tester IO (TUR) to check the health status.
> 
> Benjamin,
> Please let me know if iam wrong.

You are correct. If a path is part of a multipath device, multipathd
will run periodic checks on it.

-Ben

> 
> Regards,
> Muneendra.
> 
> 
> -----Original Message-----
> From: Mike Christie [mailto:michael.christie@oracle.com]
> Sent: Tuesday, October 20, 2020 12:15 AM
> To: Muneendra Kumar M <muneendra.kumar@broadcom.com>; Hannes Reinecke
> <hare@suse.de>
> Cc: linux-scsi@vger.kernel.org; jsmart2021@gmail.com; emilne@redhat.com;
> mkumar@redhat.com
> Subject: Re: [PATCH v3 05/17] scsi_transport_fc: Added a new rport state
> FC_PORTSTATE_MARGINAL
> 
> On 10/19/20 1:03 PM, Muneendra Kumar M wrote:
> > Hi Michael,
> > Regarding the TUR (Test Unit Ready)command which I was mentioning .
> > Multipath daemon issues TUR commands on a regular intervals to check
> > the path status.
> > When a port_state is set to marginal we are not suppose to end up
> > failing the cmd  with DID_TRANSPORT_MARGINAL with out proceeding it.
> > This may  leads to give wrong health status.
> 
> 
> If your daemon works such that you only move paths from marginal to active
> if you get an ELS indicating the path is ok or you get a link up, then why
> have multipathd send path tester IO to the paths in the marginal path group?
> They do not do anything do they?
> 
> 
> 
> > Hannes/James Correct me if this is wrong.
> >
> > Regards,
> > Muneendra.
> >
> > -----Original Message-----
> > From: Muneendra Kumar M [mailto:muneendra.kumar@broadcom.com]
> > Sent: Monday, October 19, 2020 11:01 PM
> > To: 'Hannes Reinecke' <hare@suse.de>; 'Michael Christie'
> > <michael.christie@oracle.com>
> > Cc: 'linux-scsi@vger.kernel.org' <linux-scsi@vger.kernel.org>;
> > 'jsmart2021@gmail.com' <jsmart2021@gmail.com>; 'emilne@redhat.com'
> > <emilne@redhat.com>; 'mkumar@redhat.com' <mkumar@redhat.com>
> > Subject: RE: [PATCH v3 05/17] scsi_transport_fc: Added a new rport
> > state FC_PORTSTATE_MARGINAL
> >
> > Hi Michael,
> >
> >
> >>
> >>
> >> Oh yeah, to be clear I meant why try to send it on the marginal path
> >> when you are setting up the path groups so they are not used and only
> >> the optimal paths are used.
> >> When the driver/scsi layer fails the IO then the multipath layer will
> >> make sure it goes on a optimal path right so you do not have to worry
> >> about hitting a cmd timeout and firing off the scsi eh.
> >>
> >> However, one other question I had though, is are you setting up
> >> multipathd so the marginal paths are used if the optimal ones were to
> >> fail (like the optimal paths hit a link down, dev_loss_tmo or
> >> fast_io_fail fires, etc) or will they be treated like failed paths?
> >>
> >> So could you end up with 3 groups:
> >>
> >> 1. Active optimal paths
> >> 2. Marginal
> >> 3. failed
> >>
> >> If the paths in 1 move to 3, then does multipathd handle it like a
> >> all paths down or does multipathd switch to #2?
> >>
> >> Actually, marginal path work similar to the ALUA non-optimized state.
> >> Yes, the system can sent I/O to it, but it'd be preferable for the
> >> I/O to be moved somewhere else.
> >> If there is no other path (or no better path), yeah, tough.
> >
> >> Hence the answer would be 2)
> >
> >
> > [Muneendra]As Hannes mentioned if there are no active paths, the
> > marginal paths will be moved to normal and the system will send the io.
> >
> > Regards,
> > Muneendra.
> >


