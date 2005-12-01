From: James.Smart@Emulex.Com
Subject: RE: [PATCH 9/11][REPOST #2]  lpfc 8.1.1 : Add polled-mode support
Date: Thu, 1 Dec 2005 11:58:39 -0500
Message-ID: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7B86@xbl3.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:58353 "EHLO
	emulex.emulex.com") by vger.kernel.org with ESMTP id S932335AbVLAQ6p convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 1 Dec 2005 11:58:45 -0500
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: arjan@infradead.org
Cc: linux-scsi@vger.kernel.org

> > if value is 1 :
> >   Interrupts are left enabled, expecting that the user has tuned the
> >   interrupt coalescing values. When this setting is enabled, the
> > driver
> >   will attempt to service completed i/o whenever new i/o is 
> submitted
> >   to the adapter. If the coalescing values are large, and the i/o
> >   generation rate steady, an interrupt will be avoided by servicing
> >   completed i/o prior to the coalescing thresholds kicking in.
> > However,
> >   if the i/o completion load is high enough or i/o generation slow,
> > the
> >   coalescion values will ensure that completed i/o is serviced in a
> > timely
> >   fashion.
> 
> this sounds nice.. couldn't this be the default? (even if the delays
> aren't set by default).. 

The real issue with changing the default is that the interrupt coalescing
values affect things that generate interrupts other than just FCP i/o, like
discovery.  Tune too high and you might start seeing erroneous ELS errors,
affecting target presentation, recovery after link events, etc.

I've done this kind of tuning in several drivers and the conclusion has
been that you can really only tune the coalescing values if you understand
your environment and application/system needs very very well.

This caveat should have been in the text discussion, and will be added to
the documentation file we will create for lpfc.

-- james s
