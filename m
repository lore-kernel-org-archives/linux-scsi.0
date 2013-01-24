From: Ewan Milne <emilne@redhat.com>
Subject: Re: [PATCH RFC 0/9] [SCSI] Enhanced sense and Unit Attention
 handling
Date: Thu, 24 Jan 2013 17:00:34 -0500
Message-ID: <1359064834.4420.405.camel@localhost.localdomain>
References: <1358526434-1173-1-git-send-email-emilne@redhat.com>
	 <CAO+b5-oKyPoSdKJPcyaf4FkDUNH25Cwwz=_C4WiwvpfauNqStQ@mail.gmail.com>
	 <51011D2E.305@suse.de>
	 <CAO+b5-ptjPEbCrKEpdCEZBCh5Xs7ycXQA5V+iohAL4TSfbUzFg@mail.gmail.com>
	 <51014A7B.2060806@suse.de> <51014C84.4000906@cs.wisc.edu>
	 <51015016.5050309@suse.de>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:38420 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755492Ab3AXWB1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Jan 2013 17:01:27 -0500
In-Reply-To: <51015016.5050309@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: linux-scsi@vger.kernel.org

On Thu, 2013-01-24 at 16:15 +0100, Hannes Reinecke wrote:
> On 01/24/2013 04:00 PM, Mike Christie wrote:
> > On 01/24/2013 07:51 AM, Hannes Reinecke wrote:
> >> On 01/24/2013 03:38 PM, Bart Van Assche wrote:
> >>> On Thu, Jan 24, 2013 at 4:38 AM, Hannes Reinecke <hare@suse.de> wrote:
> >>>> As for AEN, does iSCSI _do_ AEN? I thought it got removed ...
> >>>>
> >>>> If it does, though, it should schedule an event on its own whenever
> >>>> an AER
> >>>> is received. The same goes for LLDDs with vendor-specific AENs;
> >>>> thinking of
> >>>> megaraid_sas here ...
> >>>
> >>> Let me ask this another way. SAN users expect that the LUN list at the
> >>> initiator side gets updated automatically after a SAN configuration
> >>> change. How should a SAN system communicate to a SCSI initiator that
> >>> the LUN list has been changed ? Some FC SAN systems send a LIP after a
> >>> configuration change to force the initiator to rescan LUNs.
> >>
> >> And thereby disrupting traffic on _ALL_ LUNs on the loop.
> >> Really cool idea.
> >> I know; the one vendor which does _not_ talk to us.
> >>
> >>> But how to inform the initiator about a LUN change for other SCSI
> >>> protocols ?
> >>> I'm not sure that it is even possible to report such a change via sense
> >>> data in case a SAN user first removes all LUNs and after that change
> >>> adds one or more LUNs.
> >>>
> >> The official way is indeed via UAs; most storage arrays (Hello, NetApp!)
> >> provide a default LUN0 which is always visible.
> >> Up to the point that some even refuse to add 'normal' disk LUNs to LUN0.
> >> Or have the ominous 'Well-known Address' LUN to handle these kind of
> >> issues.
> >>
> >> Obviously, one needs to send commands to it to even _get_ an UA back.
> >>
> >
> > In SAM5 there is that QUERY ASYNCHRONOUS EVENT TMF. Could we send that
> > periodically to lun0/well-knwon-lun if the transport supports it (iscsi
> > will in
> > http://tools.ietf.org/html/draft-ietf-storm-iscsi-sam-06#section-6).
> > Whatever daemon in userspace handles these other events, could send it
> > (we just need to add a interface) or we could add kernel code.
> >
> Oh, cool.
> Polling a device to figure out if we should poll it :-)
> 
> We'd be better off sending TEST UNIT READY to it; then we should
> be getting UAs regardless on the SAM version in use on the target.

I believe that multipath is already sending periodic commands to devices
through the different paths, to determine up-to-date path status.
So, in at least some cases, we wouldn't have to do anything else.

> 
> (Especially as some target lie about the supported version, so
> they might be supporting SAM-5 without telling us ...)
> 
> > This should not hold up Ewan's patches though.
> >
> Correct.
> 
> AEN handling discussion is a different story and should be build
> on top of Ewans patches.
> 
> Cheers,
> 
> Hannes


