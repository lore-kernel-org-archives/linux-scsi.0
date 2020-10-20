Return-Path: <SRS0=ehq5=D3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EE1CC4363A
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Oct 2020 18:45:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id CDD152222C
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Oct 2020 18:45:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="PsF5LGs3"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437564AbgJTSpI (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 20 Oct 2020 14:45:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:35074 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389167AbgJTSpI (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 20 Oct 2020 14:45:08 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603219506;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4YA8TDs5MZBVuYVbg+zidK32k5r+FRBAeHYYz7IvBsE=;
        b=PsF5LGs3TW0O8m3GRanX+YxafLHp2pE/x2Hccedr5ueWUi5Yi1V0q+k11JdCFfaHwXweJR
        ow295rB8Q5rlCCVFWo1jiOGJeZmMl+ps6Qscpk9k7bPwRRN02tB1gRQGdx4tu8Fa17Aiil
        Ht98iXfj5Syh2lsk64+ugEYKRlLi95E=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-35-n5V3X5YyOweXD7wh0XG4iA-1; Tue, 20 Oct 2020 14:45:02 -0400
X-MC-Unique: n5V3X5YyOweXD7wh0XG4iA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 94C7C108E1A0;
        Tue, 20 Oct 2020 18:45:00 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 65A9227BDD;
        Tue, 20 Oct 2020 18:45:00 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
        by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 09KIiwPn020650;
        Tue, 20 Oct 2020 13:44:58 -0500
Received: (from bmarzins@localhost)
        by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 09KIivgH020649;
        Tue, 20 Oct 2020 13:44:57 -0500
Date:   Tue, 20 Oct 2020 13:44:57 -0500
From:   Benjamin Marzinski <bmarzins@redhat.com>
To:     Muneendra Kumar M <muneendra.kumar@broadcom.com>
Cc:     Mike Christie <michael.christie@oracle.com>,
        Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org,
        jsmart2021@gmail.com, emilne@redhat.com, mkumar@redhat.com
Subject: Re: [PATCH v3 05/17] scsi_transport_fc: Added a new rport state
 FC_PORTSTATE_MARGINAL
Message-ID: <20201020184457.GN3384@octiron.msp.redhat.com>
References: <5ca752c2-94e1-444a-7755-f48b09b38577@oracle.com>
 <c3d65f732be0b73e4d4ebb742bc754cd@mail.gmail.com>
 <3803E6D0-68D6-407F-80AB-A17E7E0E69E3@oracle.com>
 <CE70AE32-4318-4FB2-AEED-3606DEF59B79@oracle.com>
 <a9b958fb-3c06-c385-f7ce-ce0fc863e64b@suse.de>
 <e031f239c4bc02cafde13ad573523559@mail.gmail.com>
 <0863bb07-1f74-ba14-50dc-717c7f68af7e@oracle.com>
 <9e48826470ef61e2d56922c4290c2c0b@mail.gmail.com>
 <d7b26c01-3f82-66a3-b530-10589472404d@oracle.com>
 <5a030f04efbd58e704d080d8db2278ba@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5a030f04efbd58e704d080d8db2278ba@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Oct 20, 2020 at 10:49:56PM +0530, Muneendra Kumar M wrote:
> HI Michael,
> 
> > AFIK As long as the paths are available irrespective of  the path is
> > moved to marginal path group or not multipathd  will keep sending the
> > send path tester IO (TUR) to check the health status.
> >
> 
> >You can change the multipathd code.
> You mean to say don't send the TUR commands for the devices under marginal
> path groups ?

Multipath does need to keep checking the marginal paths. For one thing,
just because a path is marginal, doesn't mean it belongs in the same
path group as every other marginal path. If you have an active/passive
array, then it's quite possible that you will have multiple marginal
path groups. A path's priority is updated when it is checked, and many
devices use this to determine the correct path groups. Also the checker
is what determines if a path is in a ghost (passive) state, which tells
multipath which path group to try next. For another thing, if all the
non-marginal paths fail, then the marginal path group will also be the
active path group, and we definitely want to be checking the paths on
the active path group.

-Ben

> 
> At present the multipathd checks the device state. If the device state is
> "running" then the check_path
> Will issue a TUR commands at regular intervals to check the path health
> status.
> 
> Regards,
> Muneendra.
> 
> 
> 
> > -----Original Message-----
> > From: Mike Christie [mailto:michael.christie@oracle.com]
> > Sent: Tuesday, October 20, 2020 12:15 AM
> > To: Muneendra Kumar M <muneendra.kumar@broadcom.com>; Hannes Reinecke
> > <hare@suse.de>
> > Cc: linux-scsi@vger.kernel.org; jsmart2021@gmail.com;
> > emilne@redhat.com; mkumar@redhat.com
> > Subject: Re: [PATCH v3 05/17] scsi_transport_fc: Added a new rport
> > state FC_PORTSTATE_MARGINAL
> >
> > On 10/19/20 1:03 PM, Muneendra Kumar M wrote:
> >> Hi Michael,
> >> Regarding the TUR (Test Unit Ready)command which I was mentioning .
> >> Multipath daemon issues TUR commands on a regular intervals to check
> >> the path status.
> >> When a port_state is set to marginal we are not suppose to end up
> >> failing the cmd  with DID_TRANSPORT_MARGINAL with out proceeding it.
> >> This may  leads to give wrong health status.
> >
> >
> > If your daemon works such that you only move paths from marginal to
> > active if you get an ELS indicating the path is ok or you get a link
> > up, then why have multipathd send path tester IO to the paths in the
> > marginal path group?
> > They do not do anything do they?
> >
> >
> >
> >> Hannes/James Correct me if this is wrong.
> >>
> >> Regards,
> >> Muneendra.
> >>
> >> -----Original Message-----
> >> From: Muneendra Kumar M [mailto:muneendra.kumar@broadcom.com]
> >> Sent: Monday, October 19, 2020 11:01 PM
> >> To: 'Hannes Reinecke' <hare@suse.de>; 'Michael Christie'
> >> <michael.christie@oracle.com>
> >> Cc: 'linux-scsi@vger.kernel.org' <linux-scsi@vger.kernel.org>;
> >> 'jsmart2021@gmail.com' <jsmart2021@gmail.com>; 'emilne@redhat.com'
> >> <emilne@redhat.com>; 'mkumar@redhat.com' <mkumar@redhat.com>
> >> Subject: RE: [PATCH v3 05/17] scsi_transport_fc: Added a new rport
> >> state FC_PORTSTATE_MARGINAL
> >>
> >> Hi Michael,
> >>
> >>
> >>>
> >>>
> >>> Oh yeah, to be clear I meant why try to send it on the marginal path
> >>> when you are setting up the path groups so they are not used and
> >>> only the optimal paths are used.
> >>> When the driver/scsi layer fails the IO then the multipath layer
> >>> will make sure it goes on a optimal path right so you do not have to
> >>> worry about hitting a cmd timeout and firing off the scsi eh.
> >>>
> >>> However, one other question I had though, is are you setting up
> >>> multipathd so the marginal paths are used if the optimal ones were
> >>> to fail (like the optimal paths hit a link down, dev_loss_tmo or
> >>> fast_io_fail fires, etc) or will they be treated like failed paths?
> >>>
> >>> So could you end up with 3 groups:
> >>>
> >>> 1. Active optimal paths
> >>> 2. Marginal
> >>> 3. failed
> >>>
> >>> If the paths in 1 move to 3, then does multipathd handle it like a
> >>> all paths down or does multipathd switch to #2?
> >>>
> >>> Actually, marginal path work similar to the ALUA non-optimized state.
> >>> Yes, the system can sent I/O to it, but it'd be preferable for the
> >>> I/O to be moved somewhere else.
> >>> If there is no other path (or no better path), yeah, tough.
> >>
> >>> Hence the answer would be 2)
> >>
> >>
> >> [Muneendra]As Hannes mentioned if there are no active paths, the
> >> marginal paths will be moved to normal and the system will send the io.
> >>
> >> Regards,
> >> Muneendra.
> >>


