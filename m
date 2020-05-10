Return-Path: <SRS0=m8SI=6Y=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=unavailable
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 482A9C54E8B
	for <linux-scsi@archiver.kernel.org>; Sun, 10 May 2020 07:33:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 278AF20801
	for <linux-scsi@archiver.kernel.org>; Sun, 10 May 2020 07:33:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1589095986;
	bh=OhPzK8XvsgbaPEDXqL+qrrB3wHcSJuyDPUOAY9QGoSs=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=un0ltZ7RWhYnxYABfIVJiyzhsUPKmZeQppNCcsVN0PYFHQDKaz36vFyFm9/PeyCXZ
	 dCBkzvQtMeQ4SF+C/4ulu2GZpW6YO3AJaeBLmOoliAIGFip1AQmZKVgunpCZCYLndt
	 pn8h50PKhqJvn+nCgwOdzeO84iEpim6hS8m5TP9M=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726629AbgEJHdC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 10 May 2020 03:33:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:33682 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725810AbgEJHdC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 10 May 2020 03:33:02 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D7DA420801;
        Sun, 10 May 2020 07:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589095981;
        bh=OhPzK8XvsgbaPEDXqL+qrrB3wHcSJuyDPUOAY9QGoSs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=AwPkx+XOlkgPmm1u/VxrKPB2XtBOo7KThsn7W3xTHMSasLGE2cUAQ6R7m2bOvcs+g
         NpEwM5UT2g7roXeQDMgvv7Zh2rczQqJ3uHX8Yo+Lv+Iy6xoMliTQFRBFlnpBE8t/jM
         HafNTlreBYEmfjI69z0B7znDajewadxfgt2oDtHw=
Date:   Sun, 10 May 2020 09:32:58 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Dio Putra <dioput12@gmail.com>
Cc:     oneukum@suse.com, linux-usb@vger.kernel.org,
        linux-scsi@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
        stern@rowland.harvard.edu, linux-kernel@vger.kernel.org
Subject: Re: USB Attached SCSI breakage due no udev involvement
Message-ID: <20200510073258.GA3474912@kroah.com>
References: <CAOyCV0zW_20Jq6Rrb9=fhZQAHeqMMs_oHBJdTVt8Nqje0Zoeig@mail.gmail.com>
 <20200510054717.GA3365021@kroah.com>
 <1f9c0b30-f440-de43-366f-28ccba6a22e2@gmail.com>
 <20200510065416.GA3434442@kroah.com>
 <e409bbfe-c446-2ba3-423d-c6e198abef33@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e409bbfe-c446-2ba3-423d-c6e198abef33@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, May 10, 2020 at 02:10:04PM +0700, Dio Putra wrote:
> On 5/10/20 1:54 PM, Greg KH wrote:
> > On Sun, May 10, 2020 at 01:48:24PM +0700, Dio Putra wrote:
> >> On 5/10/20 12:47 PM, Greg KH wrote:
> >>> On Sun, May 10, 2020 at 09:55:57AM +0700, Dio Putra wrote:
> >>>> Hi, it's first time for me to report user-space breakage in here, so
> >>>> i'm begging your pardon.
> >>>>
> >>>> I want to report that Linux 5.4 breaking my USB mount workflow due
> >>>> udevadm monitor report here (I'm using vanilla kernel 5.4.39 on
> >>>> Slackware64 Current and vanilla kernel 4.4.221 on Slackware64 14.2):
> >>>
> >>> <snip>
> >>>
> >>> Sorry, but what actually changed that you can see in the logs?
> >> Sorry, what do you mean? The dmesg log or the kernel changelogs?
> > 
> > Either, your message made them pretty impossible to compare with all of
> > the line-wrapping :(
> > 
> I'm so sorry for first message mess, because that message has been sent by
> Gmail Website. Can I send my logs as attachment? I try to convenient everyone
> here. ( FYI, I just switched to Thunderbird with these settings:
> https://www.kernel.org/doc/html/v4.12/process/email-clients.html#thunderbird-gui ) 

Sure, attachments work, but better yet, if you can show the difference
in a few lines that is much nicer than having to dig through large
numbers of log files.

> >>> What functionality broke?  What used to work that no longer does work?
> >>>
> >> Yes, it supposed that just work and kernel could talk with udev, not just handled by the kernel.
> > 
> > I don't understand, what functionality changed?  What exactly used to
> > work that no longer does?
> linux-5.4 has been never called the udev dependencies whereas
> linux-4.4 will call any udev dependencies if necessary, that's the problem.

I do not understand what exactly you mean by "call udev dependencies".

udev is used to create symlinks and set user/group permissions on device
nodes in /dev/ which is created by devtmpfs.  What exactly is not
happening in your /dev/ with the move to a newer kernel?

> > Did you change anything else other than the kernel on your system?  Did
> > you change to a newer version of udev/systemd or anything else?
> > 
> I'm using eudev-master from their official mirror github:
> https://github.com/gentoo/eudev

Have you contacted the eudev developers to see if something different
needs to be set in your kernel when moving 4 years in kernel development
forward?  Are you sure you have all the correct config options enabled?

Why such a huge leap forward all at once, how about going from 4.4.y to
4.9.y and then 4.14.y and then 5.4.y?  That might help narrow things
down a bit easier.

thanks,

greg k-h
