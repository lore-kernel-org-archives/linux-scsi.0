From: Ewan Milne <emilne@redhat.com>
Subject: Re: [PATCH RFC 0/9] [SCSI] Enhanced sense and Unit Attention
 handling
Date: Thu, 24 Jan 2013 08:53:25 -0500
Message-ID: <1359035605.4420.388.camel@localhost.localdomain>
References: <1358526434-1173-1-git-send-email-emilne@redhat.com>
	 <CAO+b5-oKyPoSdKJPcyaf4FkDUNH25Cwwz=_C4WiwvpfauNqStQ@mail.gmail.com>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55886 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753488Ab3AXNx1 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Jan 2013 08:53:27 -0500
In-Reply-To: <CAO+b5-oKyPoSdKJPcyaf4FkDUNH25Cwwz=_C4WiwvpfauNqStQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@gmail.com>
Cc: linux-scsi@vger.kernel.org

On Wed, 2013-01-23 at 17:19 -0700, Bart Van Assche wrote:
> On Fri, Jan 18, 2013 at 9:27 AM, Ewan D. Milne <emilne@redhat.com> wrote:
> > This patch set adds changes to the SCSI mid-layer, sysfs and scsi_debug
> > to provide enhanced support for Unit Attention conditions, as well as
> > detection of reported sense data overflow conditions and some changes
> > to sense data processing.  It also adds a uevent when the reported
> > capacity changes on an sd device.
> >
> > There was some discussion about this a couple of years ago on the linux-scsi
> > mailing list:  http://marc.info/?l=linux-scsi&m=129702506514742&w=2
> > Although one approach is to send all SCSI sense data to a userspace daemon
> > for processing, this patch set does not take that approach due to the
> > difficulty in reliably delivering all of the data.  An interesting UA
> > condition might not be delivered due to a flood of media errors, for example.
> >
> > The mechanism used is to flag when certain UA ASC/ASCQ codes are received
> > that report asynchronous changes to the storage device configuration.
> > An appropriate uevent is then generated for the scsi_device or scsi_target
> > object.  An aggregation mechanism is used to avoid generating uevents at
> > too high a rate, and to coalesce multiple UAs reported by LUNs on the
> > same target for a REPORTED LUNS DATA HAS CHANGED sense code.
> 
> Does this patch series add a function that allows SCSI LLDs to report
> AEN data to the SCSI core ? What if a SCSI target reports a LUN
> inventory change via AER to e.g. the iSCSI initiator and that
> initiator ignores the AEN data ? Will that result in AEN data being
> ignored and no automatic LUN rescanning ?

Well, what the patch series does is add handling in scsi_check_sense(),
so any sense processing that went through that path would be handled.
I don't think this would apply to AEN, however.  The only AEN handling
that I am aware of was in iscsi-initiator-utils, in userspace, which
did a rescan on the iscsi session when a 3F 0E code was received.

> 
> Bart.


