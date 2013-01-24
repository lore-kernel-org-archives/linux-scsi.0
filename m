From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH RFC 0/9] [SCSI] Enhanced sense and Unit Attention handling
Date: Thu, 24 Jan 2013 07:01:47 -0700
Message-ID: <51013ECB.4020709@cs.wisc.edu>
References: <1358526434-1173-1-git-send-email-emilne@redhat.com> <CAO+b5-oKyPoSdKJPcyaf4FkDUNH25Cwwz=_C4WiwvpfauNqStQ@mail.gmail.com> <51011D2E.305@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:35024 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750780Ab3AXOCh (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 24 Jan 2013 09:02:37 -0500
In-Reply-To: <51011D2E.305@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Bart Van Assche <bart.vanassche@gmail.com>, "Ewan D. Milne" <emilne@redhat.com>, linux-scsi@vger.kernel.org

On 01/24/2013 04:38 AM, Hannes Reinecke wrote:
> On 01/24/2013 01:19 AM, Bart Van Assche wrote:
>> On Fri, Jan 18, 2013 at 9:27 AM, Ewan D. Milne <emilne@redhat.com> wrote:
>>> This patch set adds changes to the SCSI mid-layer, sysfs and scsi_debug
>>> to provide enhanced support for Unit Attention conditions, as well as
>>> detection of reported sense data overflow conditions and some changes
>>> to sense data processing.  It also adds a uevent when the reported
>>> capacity changes on an sd device.
>>>
>>> There was some discussion about this a couple of years ago on the
>>> linux-scsi
>>> mailing list:  http://marc.info/?l=linux-scsi&m=129702506514742&w=2
>>> Although one approach is to send all SCSI sense data to a userspace
>>> daemon
>>> for processing, this patch set does not take that approach due to the
>>> difficulty in reliably delivering all of the data.  An interesting UA
>>> condition might not be delivered due to a flood of media errors, for
>>> example.
>>>
>>> The mechanism used is to flag when certain UA ASC/ASCQ codes are
>>> received
>>> that report asynchronous changes to the storage device configuration.
>>> An appropriate uevent is then generated for the scsi_device or
>>> scsi_target
>>> object.  An aggregation mechanism is used to avoid generating uevents at
>>> too high a rate, and to coalesce multiple UAs reported by LUNs on the
>>> same target for a REPORTED LUNS DATA HAS CHANGED sense code.
>>
>> Does this patch series add a function that allows SCSI LLDs to report
>> AEN data to the SCSI core ? What if a SCSI target reports a LUN
>> inventory change via AER to e.g. the iSCSI initiator and that
>> initiator ignores the AEN data ? Will that result in AEN data being
>> ignored and no automatic LUN rescanning ?
>>
> Well, first and foremost we _don't_ have automatic LUN rescanning.
> This patchset just puts in the infrastructure that userspace can know
> _when_ a LUN rescan might be in order.
> 
> As for AEN, does iSCSI _do_ AEN? I thought it got removed ...

The AEN is sent to userspace right now.

> 
> If it does, though, it should schedule an event on its own whenever an
> AER is received. The same goes for LLDDs with vendor-specific AENs;
> thinking of megaraid_sas here ...
> 

Yeah. It would be nicer if there was a wrapper around this code:

+#ifdef CONFIG_SCSI_ENHANCED_UA
+			struct scsi_target *starget = scsi_target(sdev);
+			if (atomic_xchg(&starget->lun_change_reported, 1) == 0)
+				schedule_delayed_work(&starget->ua_dwork, 2*HZ);
+			scmd_printk(KERN_WARNING, scmd,
+				    "Reported LUNs data has changed");
+#else

so drivers do not have to have to duplicate and know that low level of
details.
