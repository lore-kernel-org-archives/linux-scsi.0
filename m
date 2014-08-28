From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Debugging scsi abort handling ?
Date: Thu, 28 Aug 2014 07:08:41 -0700
Message-ID: <1409234921.2475.1.camel@jarvis.lan>
References: <53F8AAA8.8040407@redhat.com> <53FAE3CA.6060603@redhat.com>
	 <53FAF80D.2070209@redhat.com> <53FB0FE3.80603@acm.org>
	 <53FB1ACD.1040208@redhat.com> <53FF1AD8.9020800@suse.de>
	 <53FF1DE9.5040605@redhat.com> <53FF1FE8.9060108@redhat.com>
	 <53FF2199.4030300@redhat.com> <53FF2283.9000502@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:33664 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751273AbaH1OIm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Aug 2014 10:08:42 -0400
In-Reply-To: <53FF2283.9000502@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hans de Goede <hdegoede@redhat.com>
Cc: Paolo Bonzini <pbonzini@redhat.com>, Hannes Reinecke <hare@suse.de>, Bart Van Assche <bvanassche@acm.org>, SCSI development list <linux-scsi@vger.kernel.org>

On Thu, 2014-08-28 at 14:37 +0200, Hans de Goede wrote:
> Hi,
> 
> On 08/28/2014 02:33 PM, Paolo Bonzini wrote:
> > Il 28/08/2014 14:26, Hans de Goede ha scritto:
> >>>> Then, blk_complete_request will do nothing because its call to
> >>>> blk_mark_rq_complete returns true.
> >>>>
> >>>> All this, of course, as long as ->scsi_done is called _before_ eh_abort
> >>>> returns.
> >> What about calling scsi_done after eh_abort if eh_abort returned FAILED?
> > 
> > I invoke the fifth amendment. :)
> 
> Although I appreciate the tongue in cheek answer, this was sort of a serious
> question, as at the moment this may happen with the uas driver.

The answer is no.  It's part of the internal mid layer functions you
don't need to know about.  You just call the command done functions and
try not to care what actual function they point to.

James


