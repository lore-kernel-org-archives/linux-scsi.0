Return-Path: <SRS0=m8SI=6Y=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C1344C54E7E
	for <linux-scsi@archiver.kernel.org>; Sun, 10 May 2020 06:54:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A18E220801
	for <linux-scsi@archiver.kernel.org>; Sun, 10 May 2020 06:54:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1589093662;
	bh=/edb8zjwngEdhJ5t41N4PDEYJsCLC1RhKAaqwWDWPJY=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=17HB7v6IEJYiPBjpVETNFbpNqpKh9ty+ZVNA8sxIL4JyGJoAY3uSbWuS69z2Y0J5O
	 23nqiqir9m4AziTo2qPPZ+T4ZM9xCrw1nojz54eWVLb55w6qIfHGy9/nkkIPHtxbHB
	 L+LsXSDKYTVQJZs/8wjFX6A7oFSGfHkzHT8XOqq4=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726743AbgEJGyU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 10 May 2020 02:54:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:57300 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725810AbgEJGyT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Sun, 10 May 2020 02:54:19 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id CF10F20801;
        Sun, 10 May 2020 06:54:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1589093659;
        bh=/edb8zjwngEdhJ5t41N4PDEYJsCLC1RhKAaqwWDWPJY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Y7ll5aDoT7iIfFNanfn/ul9JXX+LwbD7H+4XK3eaFzkljKWSRKNkJONsldc66K+XH
         kY+sZhEho1XnmAB0Jv2/SN5duWNwrS+C6kw+RWEOGK1XV24IJJrkbfQeZj1JJHeIie
         OG9JyhDWJJnxtSlIMZEEVooxbKy+MNsGExul8ObI=
Date:   Sun, 10 May 2020 08:54:16 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Dio Putra <dioput12@gmail.com>
Cc:     oneukum@suse.com, linux-usb@vger.kernel.org,
        linux-scsi@vger.kernel.org, usb-storage@lists.one-eyed-alien.net,
        stern@rowland.harvard.edu, linux-kernel@vger.kernel.org
Subject: Re: USB Attached SCSI breakage due no udev involvement
Message-ID: <20200510065416.GA3434442@kroah.com>
References: <CAOyCV0zW_20Jq6Rrb9=fhZQAHeqMMs_oHBJdTVt8Nqje0Zoeig@mail.gmail.com>
 <20200510054717.GA3365021@kroah.com>
 <1f9c0b30-f440-de43-366f-28ccba6a22e2@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1f9c0b30-f440-de43-366f-28ccba6a22e2@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sun, May 10, 2020 at 01:48:24PM +0700, Dio Putra wrote:
> On 5/10/20 12:47 PM, Greg KH wrote:
> > On Sun, May 10, 2020 at 09:55:57AM +0700, Dio Putra wrote:
> >> Hi, it's first time for me to report user-space breakage in here, so
> >> i'm begging your pardon.
> >>
> >> I want to report that Linux 5.4 breaking my USB mount workflow due
> >> udevadm monitor report here (I'm using vanilla kernel 5.4.39 on
> >> Slackware64 Current and vanilla kernel 4.4.221 on Slackware64 14.2):
> > 
> > <snip>
> > 
> > Sorry, but what actually changed that you can see in the logs?
> Sorry, what do you mean? The dmesg log or the kernel changelogs?

Either, your message made them pretty impossible to compare with all of
the line-wrapping :(

> > What functionality broke?  What used to work that no longer does work?
> > 
> Yes, it supposed that just work and kernel could talk with udev, not just handled by the kernel.

I don't understand, what functionality changed?  What exactly used to
work that no longer does?

Did you change anything else other than the kernel on your system?  Did
you change to a newer version of udev/systemd or anything else?

thanks,

greg k-h
