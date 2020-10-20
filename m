Return-Path: <SRS0=ehq5=D3=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.4 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1A082C4363A
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Oct 2020 18:24:53 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 962FA20BED
	for <linux-scsi@archiver.kernel.org>; Tue, 20 Oct 2020 18:24:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Gf+AVyYh"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389949AbgJTSYw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 20 Oct 2020 14:24:52 -0400
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:48429 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S2389933AbgJTSYw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 20 Oct 2020 14:24:52 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1603218290;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=XAyXp9HPGvvdmFxNzuHjKtmnIK4GC0/ZTZgWRZIFru8=;
        b=Gf+AVyYhYvUh9CmIkN9jQmZMnmvWmplwTZTwbJY00yIEVP1kk+gW8M0+aamvqPEhb1QY1W
        tfH9yTsf9ihDPjtFSK6qyMh0pv6k5zOxPe6YlIXlzk00b2NTIEmQ1D+IhZYwoTlDsMf7Yu
        26tdW4karZ23tFB5VUl8PQnGlhj1qws=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-470-YujPkAhZNtup_7Pb2rW4Jw-1; Tue, 20 Oct 2020 14:24:46 -0400
X-MC-Unique: YujPkAhZNtup_7Pb2rW4Jw-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 5DBDD57052;
        Tue, 20 Oct 2020 18:24:45 +0000 (UTC)
Received: from octiron.msp.redhat.com (octiron.msp.redhat.com [10.15.80.209])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 40E595C1C2;
        Tue, 20 Oct 2020 18:24:45 +0000 (UTC)
Received: from octiron.msp.redhat.com (localhost.localdomain [127.0.0.1])
        by octiron.msp.redhat.com (8.14.9/8.14.9) with ESMTP id 09KIOh8T020619;
        Tue, 20 Oct 2020 13:24:43 -0500
Received: (from bmarzins@localhost)
        by octiron.msp.redhat.com (8.14.9/8.14.9/Submit) id 09KIOhjb020618;
        Tue, 20 Oct 2020 13:24:43 -0500
Date:   Tue, 20 Oct 2020 13:24:37 -0500
From:   Benjamin Marzinski <bmarzins@redhat.com>
To:     Muneendra Kumar M <muneendra.kumar@broadcom.com>
Cc:     Mike Christie <michael.christie@oracle.com>,
        Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org,
        jsmart2021@gmail.com, emilne@redhat.com, mkumar@redhat.com
Subject: Re: [PATCH v3 05/17] scsi_transport_fc: Added a new rport state
 FC_PORTSTATE_MARGINAL
Message-ID: <20201020182437.GM3384@octiron.msp.redhat.com>
References: <1602732462-10443-1-git-send-email-muneendra.kumar@broadcom.com>
 <1602732462-10443-6-git-send-email-muneendra.kumar@broadcom.com>
 <5ca752c2-94e1-444a-7755-f48b09b38577@oracle.com>
 <c3d65f732be0b73e4d4ebb742bc754cd@mail.gmail.com>
 <3803E6D0-68D6-407F-80AB-A17E7E0E69E3@oracle.com>
 <CE70AE32-4318-4FB2-AEED-3606DEF59B79@oracle.com>
 <a9b958fb-3c06-c385-f7ce-ce0fc863e64b@suse.de>
 <bf347ae232d73c4a21af6514085a92f2@mail.gmail.com>
 <8c59834c-e46c-fde3-13d7-b60a82452148@oracle.com>
 <55e2eb834223041a7c755ac314e25f97@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <55e2eb834223041a7c755ac314e25f97@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Oct 20, 2020 at 12:33:39AM +0530, Muneendra Kumar M wrote:
> HI Michael,
> 
> > [Muneendra]As Hannes mentioned if there are no active paths, the
> > marginal paths will be moved to normal and the system will send the io.
> >What do you mean by normal?
> 
> >- You don't mean the the fc remote port state will change to online right?
> Fc remote port state will not change to online.
> 
> - Do you just mean the the marginal path group will become the active group
> in the dm-multipath layer?
> 
> Yes
> 

Correct. The path group is still marginal. Being marginal simply means
that the path group has a lower priority than all the non-marginal path
groups.  However, if there are no usable paths in any non-marginal path
group, then a marginal path group will become the active path group (the
path group that the kernel will send IO to).

-Ben

> Regards,
> Muneendra.


