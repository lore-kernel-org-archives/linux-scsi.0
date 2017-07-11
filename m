From: Kashyap Desai <kashyap.desai@broadcom.com>
Subject: RE: [PATCH v2 11/15] megaraid_sas: Set device queue_depth same as HBA
 can_queue value in scsi-mq mode
Date: Tue, 11 Jul 2017 21:17:31 +0530
Message-ID: <3adb43de25a7531af4d083cd1af8c5b5@mail.gmail.com>
References: <1499256029-16319-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1499256029-16319-12-git-send-email-shivasharan.srikanteshwara@broadcom.com> <20170711135828.GA12013@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pg0-f45.google.com ([74.125.83.45]:36338 "EHLO
        mail-pg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932784AbdGKPrd (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 11 Jul 2017 11:47:33 -0400
Received: by mail-pg0-f45.google.com with SMTP id u62so1633591pgb.3
        for <linux-scsi@vger.kernel.org>; Tue, 11 Jul 2017 08:47:33 -0700 (PDT)
In-Reply-To: <20170711135828.GA12013@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, Shivasharan Srikanteshwara <shivasharan.srikanteshwara@broadcom.com>
Cc: linux-scsi@vger.kernel.org, martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, Sumit Saxena <sumit.saxena@broadcom.com>, hare@suse.com

> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@lst.de]
> Sent: Tuesday, July 11, 2017 7:28 PM
> To: Shivasharan S
> Cc: linux-scsi@vger.kernel.org; martin.petersen@oracle.com;
> thenzl@redhat.com; jejb@linux.vnet.ibm.com;
> kashyap.desai@broadcom.com; sumit.saxena@broadcom.com;
> hare@suse.com; hch@lst.de
> Subject: Re: [PATCH v2 11/15] megaraid_sas: Set device queue_depth same
as
> HBA can_queue value in scsi-mq mode
>
> On Wed, Jul 05, 2017 at 05:00:25AM -0700, Shivasharan S wrote:
> > Currently driver sets default queue_depth for VDs at 256 and JBODs
> > based on interface type, ie., for SAS JBOD QD will be 64, for SATA
JBOD QD
> will be 32.
> > During performance runs with scsi-mq enabled, we are seeing better
> > results by setting QD same as HBA queue_depth.
>
> Please no scsi-mq specifics.  just do this unconditionally.

Chris -  Intent for mq specific check is mainly because of sequential work
load for HDD is having penalty due to mq scheduler issue.
We did this exercise prior to mq-deadline support.

Making generic change for non-mq and mq was good, but we may see some user
may not like to see regression.
E.a In case of, QD = 32 for SATA PD file system creation may be faster
compare to large QD. There may be a soft merger at block layer due to
queue depth throttling. Eventually, FS creation goes fast due to IO
merges, but same will not be true if we change queue depth logic (means,
increase device queue depth to HBA QD.)

We have choice to completely remove this patch and ask users to do sysfs
settings in case of scsi-mq performance issue for HDD sequential work
load.
Having this patch, we want to provide better QD settings as default from
driver.


Thanks, Kashyap
