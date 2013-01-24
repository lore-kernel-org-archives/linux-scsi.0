From: Bart Van Assche <bart.vanassche@gmail.com>
Subject: Re: [PATCH RFC 0/9] [SCSI] Enhanced sense and Unit Attention handling
Date: Wed, 23 Jan 2013 17:19:17 -0700
Message-ID: <CAO+b5-oKyPoSdKJPcyaf4FkDUNH25Cwwz=_C4WiwvpfauNqStQ@mail.gmail.com>
References: <1358526434-1173-1-git-send-email-emilne@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ob0-f175.google.com ([209.85.214.175]:64906 "EHLO
	mail-ob0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752008Ab3AXATS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Jan 2013 19:19:18 -0500
Received: by mail-ob0-f175.google.com with SMTP id uz6so453816obc.20
        for <linux-scsi@vger.kernel.org>; Wed, 23 Jan 2013 16:19:17 -0800 (PST)
In-Reply-To: <1358526434-1173-1-git-send-email-emilne@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Ewan D. Milne" <emilne@redhat.com>
Cc: linux-scsi@vger.kernel.org

On Fri, Jan 18, 2013 at 9:27 AM, Ewan D. Milne <emilne@redhat.com> wrote:
> This patch set adds changes to the SCSI mid-layer, sysfs and scsi_debug
> to provide enhanced support for Unit Attention conditions, as well as
> detection of reported sense data overflow conditions and some changes
> to sense data processing.  It also adds a uevent when the reported
> capacity changes on an sd device.
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

Does this patch series add a function that allows SCSI LLDs to report
AEN data to the SCSI core ? What if a SCSI target reports a LUN
inventory change via AER to e.g. the iSCSI initiator and that
initiator ignores the AEN data ? Will that result in AEN data being
ignored and no automatic LUN rescanning ?

Bart.
