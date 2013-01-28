From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH RFC 0/9] [SCSI] Enhanced sense and Unit Attention
 handling
Date: Tue, 29 Jan 2013 07:26:46 +1100
Message-ID: <1359404806.2408.2.camel@dabdike>
References: <1358526434-1173-1-git-send-email-emilne@redhat.com>
	 <CAO+b5-oKyPoSdKJPcyaf4FkDUNH25Cwwz=_C4WiwvpfauNqStQ@mail.gmail.com>
	 <51011D2E.305@suse.de>
	 <CAO+b5-ptjPEbCrKEpdCEZBCh5Xs7ycXQA5V+iohAL4TSfbUzFg@mail.gmail.com>
	 <5106939E.1010301@tributary.com> <51069CC8.3000103@acm.org>
	 <51069DE0.4010006@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:41135 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752124Ab3A1U0x (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Jan 2013 15:26:53 -0500
In-Reply-To: <51069DE0.4010006@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Bart Van Assche <bvanassche@acm.org>, Jeremy Linton <jlinton@tributary.com>, "Ewan D. Milne" <emilne@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Mon, 2013-01-28 at 16:48 +0100, Hannes Reinecke wrote:
> On 01/28/2013 04:44 PM, Bart Van Assche wrote:
> > On 01/28/13 16:05, Jeremy Linton wrote:
> >> What I think your looking for is RSCN (Registered State Change
> >> notification).
> >> Hook that, and then check the name server. This will tell you when
> >> ports get
> >> added/removed. You can then report luns against lun 0 of all the
> >> known target
> >> ports. This allows you to transparently detect changes.
> >>
> >> Otherwise, you run the risk of trapping UA's in the lower level
> >> portions of
> >> the stack that _REALLY_ need to be propagated to the controlling
> >> driver or
> >> application.
> >
> > Thanks for the feedback. Unfortunately sending an RSCN is only
> > possible when using Fibre Channel as transport layer. I'm looking
> > for a solution that also works with other SCSI transports, e.g.
> > iSCSI and SRP.
> >
> And we're already doing that. Rather, the FC HBAs do exactly this.
> 
> So the proposal would be to export a 'virtual' LUN0 if none is 
> present, so that we always have a device to talk to, right?
> 
> Shouldn't be too hard; we already create a 'virtual' LUN0 during 
> scanning, only we delete it if no LUNs are found.
> So we're already doing this, only we don't tell :-)

I'm not sure I'd like to leave virtual LUN-0 around if we find nothing
because it's going to cause confusion and be nasty in cases where a
physical lun 0 is created later.  However, don't the standards define
this ignored lun: W-LUN that's supposed to be created precisely for this
purpose?  I wouldn't object to creating and exporting one of those if we
have to and the array doesn't supply it.

James


