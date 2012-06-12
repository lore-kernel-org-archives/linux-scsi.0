From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH] scsi: allow persistent reservations without
 CAP_SYS_RAWIO
Date: Tue, 12 Jun 2012 18:20:57 +0100
Message-ID: <1339521657.3050.13.camel@dabdike.int.hansenpartnership.com>
References: <1339517312-18134-1-git-send-email-pbonzini@redhat.com>
	 <1339518069.3050.8.camel@dabdike.int.hansenpartnership.com>
	 <4FD76D57.5020709@redhat.com> <4FD77438.6090202@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:58660 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752634Ab2FLRVB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Jun 2012 13:21:01 -0400
In-Reply-To: <4FD77438.6090202@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: linux-kernel@vger.kernel.org, axboe@kernel.dk, linux-scsi@vger.kernel.org

On Tue, 2012-06-12 at 18:54 +0200, Paolo Bonzini wrote:
> Il 12/06/2012 18:24, Paolo Bonzini ha scritto:
> > Il 12/06/2012 18:21, James Bottomley ha scritto:
> >>>> Persistent reservations commands cannot be issued right now without
> >>>> giving CAP_SYS_RAWIO to the process who wishes to send them.  This
> >>>> is a bit heavy-handed, allow these two commands.
> >>
> >> Why is this heavy handed?  If you remove CAP_SYS_RAWIO, any userspace
> >> process can send these, which would allow any user to completely disrupt
> >> a SAN by injecting spurious reservations ... that doesn't look to be
> >> terribly safe for an operating system running in a data centre.
> > 
> > It is heavy-handed because:
> > 
> > 1) there are still other protections such as DAC (both Unix permissions
> > and ACLs) and SELinux; CAP_SYS_RAWIO is effectively the same as root.
> > 
> > 2) if any user could disrupt the SAN by injecting spurious reservations
> > just by having his laptop's root password, that data centre wouldn't be
> > terribly safe to begin with.
> 
> 3) assume that with this patch user X could disrupt the SAN by injecting
> spurious reservations, e.g. forbidding another user from writing some
> data.  Then they could also destroy those same data even without this
> patch, which is just as disrupting.
> 
> This is because you still need write permission to the device to issue
> reservations.  Read permission will only let you use PERSISTENT RESREVE IN.

I don't think you understand how persistent reservations work.

The first thing I'll say is I agree with Alan.  Unless you can justify
why you want to relax permissions I'm not going to do it.

But secondly, the reason we're so up in arms about SCSI-3 PR is that
there's a feature called reservation by transport ID.  This is used to
reserve multipath devices when one of the paths is down.  Effectively it
allows a PR-OUT command to set a reservation on any LUN with access only
to one of them.  It's definitely a hack in the SCSI standard, but it's
not one that can be controlled by a unix like permission model.  Write
access to *any* LUN allows you to reserve *all* luns.

James


