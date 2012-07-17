From: Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH] sd: do not set changed flag on all unit attention conditions
Date: Tue, 17 Jul 2012 23:12:11 +0200
Message-ID: <5005D52B.30809@redhat.com>
References: <1342454772-9018-1-git-send-email-pbonzini@redhat.com> <1342455503.3176.42.camel@dabdike.int.hansenpartnership.com> <50044D56.6000400@redhat.com> <1342511100.3039.9.camel@dabdike.int.hansenpartnership.com> <50052390.7030908@redhat.com> <1342514444.3039.23.camel@dabdike.int.hansenpartnership.com> <5005285E.8060706@redhat.com> <1342516317.3039.35.camel@dabdike.int.hansenpartnership.com> <20120717163612.GA15995@infradead.org> <50059713.7090606@redhat.com> <5005B2AC.6020102@cs.wisc.edu> <5005B39D.6030905@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-we0-f174.google.com ([74.125.82.174]:65234 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752464Ab2GQVMR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Jul 2012 17:12:17 -0400
In-Reply-To: <5005B39D.6030905@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Christoph Hellwig <hch@infradead.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Il 17/07/2012 20:49, Mike Christie ha scritto:
> > Not sure if we are talking about the same thing.
> > 
> > So can virtio-scsi send a UA with asc/ascq that indicates the lun
> > changed size? Other drivers do this. I updated Hannes's patches the
> > other day to support UAs like those in userspace.
> > 
> > I just saw the code in the patch where virtio-scsi gets that event.
> Was not done. I meant I saw that patch where virtio-scsi gets that
> virtio_scsi_event and kicks of a rescan based off of that.

Yes, it sends both (event + UA).  Right now Linux ignores the UA, and I
wanted virtio-scsi to match real hardware as much as possible so I
copied what aacraid does.  The event also has the advantage over UA that
it the revalidate is done immediately, not the next time the unit is
accessed.

Paolo
