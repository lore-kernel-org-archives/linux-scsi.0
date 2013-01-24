From: Ewan Milne <emilne@redhat.com>
Subject: Re: [PATCH RFC 0/9] [SCSI] Enhanced sense and Unit Attention
 handling
Date: Thu, 24 Jan 2013 09:00:45 -0500
Message-ID: <1359036045.4420.396.camel@localhost.localdomain>
References: <1358526434-1173-1-git-send-email-emilne@redhat.com>
	 <CAO+b5-oKyPoSdKJPcyaf4FkDUNH25Cwwz=_C4WiwvpfauNqStQ@mail.gmail.com>
	 <51011D2E.305@suse.de>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:24810 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750780Ab3AXOBk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Jan 2013 09:01:40 -0500
In-Reply-To: <51011D2E.305@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Bart Van Assche <bart.vanassche@gmail.com>, linux-scsi@vger.kernel.org

On Thu, 2013-01-24 at 12:38 +0100, Hannes Reinecke wrote:
> On 01/24/2013 01:19 AM, Bart Van Assche wrote:
> > On Fri, Jan 18, 2013 at 9:27 AM, Ewan D. Milne <emilne@redhat.com> wrote:
> >> This patch set adds changes to the SCSI mid-layer, sysfs and scsi_debug
> >> to provide enhanced support for Unit Attention conditions, as well as
> >> detection of reported sense data overflow conditions and some changes
> >> to sense data processing.  It also adds a uevent when the reported
> >> capacity changes on an sd device.
> >>
> >> There was some discussion about this a couple of years ago on the linux-scsi
> >> mailing list:  http://marc.info/?l=linux-scsi&m=129702506514742&w=2
> >> Although one approach is to send all SCSI sense data to a userspace daemon
> >> for processing, this patch set does not take that approach due to the
> >> difficulty in reliably delivering all of the data.  An interesting UA
> >> condition might not be delivered due to a flood of media errors, for example.
> >>
> >> The mechanism used is to flag when certain UA ASC/ASCQ codes are received
> >> that report asynchronous changes to the storage device configuration.
> >> An appropriate uevent is then generated for the scsi_device or scsi_target
> >> object.  An aggregation mechanism is used to avoid generating uevents at
> >> too high a rate, and to coalesce multiple UAs reported by LUNs on the
> >> same target for a REPORTED LUNS DATA HAS CHANGED sense code.
> >
> > Does this patch series add a function that allows SCSI LLDs to report
> > AEN data to the SCSI core ? What if a SCSI target reports a LUN
> > inventory change via AER to e.g. the iSCSI initiator and that
> > initiator ignores the AEN data ? Will that result in AEN data being
> > ignored and no automatic LUN rescanning ?
> >
> Well, first and foremost we _don't_ have automatic LUN rescanning.
> This patchset just puts in the infrastructure that userspace can 
> know _when_ a LUN rescan might be in order.
> 
> As for AEN, does iSCSI _do_ AEN? I thought it got removed ...

I think you are right, I think AEN was removed in SAM-3 (sam3r14, if my
sources are correct).

Bart might have a point, though.  I wonder if an iscsi device conforming
to SAM-2 would report a LUN inventory change via AEN, but not as a UA
on a normal SCSI command, in which case the iscsi initiator would have
to handle it.  I'll have to do some research and probably ask some
vendors about that, it could maybe be addressed with a follow-on patch.

> 
> If it does, though, it should schedule an event on its own whenever 
> an AER is received. The same goes for LLDDs with vendor-specific 
> AENs; thinking of megaraid_sas here ...
> 
> Cheers,
> 
> Hannes


