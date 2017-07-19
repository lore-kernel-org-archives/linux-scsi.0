From: Shivasharan Srikanteshwara
        <shivasharan.srikanteshwara@broadcom.com>
Subject: RE: [PATCH v2 11/15] megaraid_sas: Set device queue_depth same as HBA
 can_queue value in scsi-mq mode
Date: Wed, 19 Jul 2017 14:12:59 +0530
Message-ID: <1fb5bf7342826f0cf84841930c7c4b11@mail.gmail.com>
References: <1499256029-16319-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1499256029-16319-12-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <20170711135828.GA12013@lst.de> <3adb43de25a7531af4d083cd1af8c5b5@mail.gmail.com>
 13ff9692d698c5b05f32310259506735@mail.gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f171.google.com ([209.85.220.171]:34668 "EHLO
        mail-qk0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752190AbdGSInC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Jul 2017 04:43:02 -0400
Received: by mail-qk0-f171.google.com with SMTP id t2so33814527qkc.1
        for <linux-scsi@vger.kernel.org>; Wed, 19 Jul 2017 01:43:02 -0700 (PDT)
In-Reply-To: 13ff9692d698c5b05f32310259506735@mail.gmail.com
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org, martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, Sumit Saxena <sumit.saxena@broadcom.com>, hare@suse.com, Kashyap Desai <kashyap.desai@broadcom.com>

> -----Original Message-----
> From: Shivasharan Srikanteshwara
> [mailto:shivasharan.srikanteshwara@broadcom.com]
> Sent: Wednesday, July 12, 2017 1:51 PM
> To: Kashyap Desai; 'Christoph Hellwig'
> Cc: 'linux-scsi@vger.kernel.org'; 'martin.petersen@oracle.com';
> 'thenzl@redhat.com'; 'jejb@linux.vnet.ibm.com'; Sumit Saxena;
> 'hare@suse.com'
> Subject: RE: [PATCH v2 11/15] megaraid_sas: Set device queue_depth same as
> HBA can_queue value in scsi-mq mode
>
> > -----Original Message-----
> > From: Kashyap Desai [mailto:kashyap.desai@broadcom.com]
> > Sent: Tuesday, July 11, 2017 9:18 PM
> > To: Christoph Hellwig; Shivasharan Srikanteshwara
> > Cc: linux-scsi@vger.kernel.org; martin.petersen@oracle.com;
> > thenzl@redhat.com; jejb@linux.vnet.ibm.com; Sumit Saxena; hare@suse.com
> > Subject: RE: [PATCH v2 11/15] megaraid_sas: Set device queue_depth same
> > as
> > HBA can_queue value in scsi-mq mode
> >
> > > -----Original Message-----
> > > From: Christoph Hellwig [mailto:hch@lst.de]
> > > Sent: Tuesday, July 11, 2017 7:28 PM
> > > To: Shivasharan S
> > > Cc: linux-scsi@vger.kernel.org; martin.petersen@oracle.com;
> > > thenzl@redhat.com; jejb@linux.vnet.ibm.com;
> > > kashyap.desai@broadcom.com; sumit.saxena@broadcom.com;
> > hare@suse.com;
> > > hch@lst.de
> > > Subject: Re: [PATCH v2 11/15] megaraid_sas: Set device queue_depth
> > > same
> > as
> > > HBA can_queue value in scsi-mq mode
> > >
> > > On Wed, Jul 05, 2017 at 05:00:25AM -0700, Shivasharan S wrote:
> > > > Currently driver sets default queue_depth for VDs at 256 and JBODs
> > > > based on interface type, ie., for SAS JBOD QD will be 64, for SATA
> > JBOD QD
> > > will be 32.
> > > > During performance runs with scsi-mq enabled, we are seeing better
> > > > results by setting QD same as HBA queue_depth.
> > >
> > > Please no scsi-mq specifics.  just do this unconditionally.
> >
> > Chris -  Intent for mq specific check is mainly because of sequential
> > work load
> > for HDD is having penalty due to mq scheduler issue.
> > We did this exercise prior to mq-deadline support.
> >
> > Making generic change for non-mq and mq was good, but we may see some
> > user may not like to see regression.
> > E.a In case of, QD = 32 for SATA PD file system creation may be faster
> compare
> > to large QD. There may be a soft merger at block layer due to queue
> > depth
> > throttling. Eventually, FS creation goes fast due to IO merges, but same
> > will
> not
> > be true if we change queue depth logic (means, increase device queue
> > depth
> to
> > HBA QD.)
> >
> > We have choice to completely remove this patch and ask users to do sysfs
> > settings in case of scsi-mq performance issue for HDD sequential work
> > load.
> > Having this patch, we want to provide better QD settings as default from
> driver.
> >
> >
> > Thanks, Kashyap
>
> Hi Christoph,
> As Kashyap mentioned, the performance issues seen were specific to scsi-mq
> enabled case when running sequential workloads with HDDs.
> Making this generic might result in regressions in some scenarios for
> non-mq.
> That was the idea behind making the change specific to scsi-mq only.
>
> Let us know if you are ok with having this as is or we could remove
> this patch completely and have users manually tune queue depth settings if
> they
> are seeing performance issues with scsi-mq enabled.
>
> Thanks,
> Shivasharan

Hi Christoph,
Can you please let us know your thoughts on this patch?
Are we good to keep the changes as is?

Thanks,
Shivasharan
