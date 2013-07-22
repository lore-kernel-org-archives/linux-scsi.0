From: James Bottomley <jbottomley@parallels.com>
Subject: Re: [PATCH v3 0/6] [SCSI] Enhanced sense and Unit Attention handling
Date: Mon, 22 Jul 2013 15:31:34 +0000
Message-ID: <1374507094.2335.21.camel@dabdike>
References: <1371663761-22481-1-git-send-email-emilne@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.parallels.com ([199.115.105.18]:35047 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755908Ab3GVPbg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 22 Jul 2013 11:31:36 -0400
In-Reply-To: <1371663761-22481-1-git-send-email-emilne@redhat.com>
Content-Language: en-US
Content-ID: <3DBAA963FDF2104C82BF3484B1ED9B7F@sw.swsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Ewan D. Milne" <emilne@redhat.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "rwheeler@redhat.com" <rwheeler@redhat.com>, Kirill Korotaev <dev@parallels.com>

On Wed, 2013-06-19 at 13:42 -0400, Ewan D. Milne wrote:
> From: "Ewan D. Milne" <emilne@redhat.com>
> 
> This patch set adds changes to the SCSI mid-layer, sysfs and scsi_debug
> to provide enhanced support for Unit Attention conditions, as well as
> detection of a unit attention queue overflow condition and the ability
> for drivers to report sense data outside of normal command completion.
> 
> There was some discussion about this a couple of years ago on the linux-scsi
> mailing list:  http://marc.info/?l=linux-scsi&m=129702506514742&w=2
> Although one approach is to send all SCSI sense data to a userspace daemon
> for processing, this patch set does not take that approach due to the
> difficulty in reliably delivering all of the data.  An interesting UA
> condition might not be delivered due to a flood of media errors, for example.
> 
> The mechanism used is to flag when certain UA ASC/ASCQ codes are received
> that report asynchronous changes to the storage device configuration.
> An appropriate uevent is then generated for the scsi_device or scsi_target
> object.  An aggregation mechanism is used to avoid generating uevents at
> too high a rate, and to coalesce multiple UAs reported by LUNs on the
> same target for a REPORTED LUNS DATA HAS CHANGED sense code.
> 
> The changes are enabled by a new kernel config option CONFIG_SCSI_ENHANCED_UA.
> If this config option is not used, no new uevents are generated.  There are
> some changes to kernel logging messages if CONFIG_SCSI_ENHANCED_UA is enabled,
> because the existing messages explicitly stated that the kernel did not do
> anything with the information.
> 
> Note that checkpatch is reporting errors on patch 5/6 relating to macros
> in scsi_sysfs.c -- I believe these errors are incorrect and have sent a
> message to the checkpatch maintainer.  The macros were derived from
> existing ones already in the file.
> 
> Changes made since earlier v2 version:
> 
>    - Remove patch 1/8 "Generate uevent on sd capacity change"
>    - Remove patch 8/8 "Streamline detection of FM/EOM/ILI status"
>    - Changed scsi_debug to not generate UA on INQUIRY or REPORT_LUNS
>    - Changed scsi_debug to only report UA queue overflow condition
>      if dsense=1, as descriptor format sense data is needed
> 
> Changes made since earlier RFC version:
> 
>    - Remove patch 1/9 "Detect overflow of sense data buffer"
>      Some scsi_debug changes in this patch were moved to patch 7/8
>    - Corrected Kconfig help text
>    - Change name of "sdev_evt_thread" to "sdev_evt_work"
>    - Change name of "starget_evt_thread" to "starget_evt_work"
>    - Pull code out of scsi_check_sense() that handles UAs into
>      an exported function so that drivers can report conditions
>      received asynchronously
> 
> Thanks to everyone for the comments on this patch series.
> 
> Ewan D. Milne (6):
>   [SCSI] Add a kernel config option for enhanced Unit Attention support
>   [SCSI] Rename scsi_evt_xxx to sdev_evt_xxx and scsi_event to
>     sdev_event
>   [SCSI] Add support for scsi_target events
>   [SCSI] Generate uevents for certain Unit Attention codes
>   [SCSI] Add sysfs support for enhanced Unit Attention handling
>   [SCSI] Add sense and Unit Attention generation to scsi_debug

Ping on this, please.

I have another possible consumer of this infrastructure, when it's
ready, which is the SCSI RAID drivers.  We've been getting complaints
that there's no event we get from them when a RAID system goes from
online -> degraded which should be the sysadmin's cue to go in and
replace the disk (well, this isn't quite true, a lot come with
proprietary monitoring daemons which do this, but they're pretty unique
per controller).

I was thinking we might resurrect the orphaned raid_class.c to do this
and give a universally displayable but rudimentary view of the topology
and health of the device and add an easy hook for RAID events.

James

