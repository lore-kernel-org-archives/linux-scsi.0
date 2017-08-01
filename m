From: Shivasharan Srikanteshwara
        <shivasharan.srikanteshwara@broadcom.com>
Subject: RE: [PATCH v2 11/15] megaraid_sas: Set device queue_depth same as HBA
 can_queue value in scsi-mq mode
Date: Tue, 1 Aug 2017 18:53:30 +0530
Message-ID: <30f27c86aeb5299bb2c990be5ef693ef@mail.gmail.com>
References: <1499256029-16319-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1499256029-16319-12-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <20170711135828.GA12013@lst.de> <3adb43de25a7531af4d083cd1af8c5b5@mail.gmail.com>
 <1fb5bf7342826f0cf84841930c7c4b11@mail.gmail.com> <20170720074736.GB22218@lst.de>
 5bfb3bbc3e6d9b3a5c9afb749c075a40@mail.gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qt0-f182.google.com ([209.85.216.182]:37690 "EHLO
        mail-qt0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751769AbdHANXc (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Aug 2017 09:23:32 -0400
Received: by mail-qt0-f182.google.com with SMTP id 16so8766894qtz.4
        for <linux-scsi@vger.kernel.org>; Tue, 01 Aug 2017 06:23:32 -0700 (PDT)
In-Reply-To: 5bfb3bbc3e6d9b3a5c9afb749c075a40@mail.gmail.com
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org, martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, Sumit Saxena <sumit.saxena@broadcom.com>, hare@suse.com, Kashyap Desai <kashyap.desai@broadcom.com>

> -----Original Message-----
> From: Shivasharan Srikanteshwara
> [mailto:shivasharan.srikanteshwara@broadcom.com]
> Sent: Monday, July 24, 2017 4:59 PM
> To: 'Christoph Hellwig'
> Cc: 'linux-scsi@vger.kernel.org'; 'martin.petersen@oracle.com';
> 'thenzl@redhat.com'; 'jejb@linux.vnet.ibm.com'; Sumit Saxena;
> 'hare@suse.com'; Kashyap Desai
> Subject: RE: [PATCH v2 11/15] megaraid_sas: Set device queue_depth same
as
> HBA can_queue value in scsi-mq mode
>
> > -----Original Message-----
> > From: Christoph Hellwig [mailto:hch@lst.de]
> > Sent: Thursday, July 20, 2017 1:18 PM
> > To: Shivasharan Srikanteshwara
> > Cc: Christoph Hellwig; linux-scsi@vger.kernel.org;
> > martin.petersen@oracle.com; thenzl@redhat.com;
> > jejb@linux.vnet.ibm.com; Sumit Saxena; hare@suse.com; Kashyap Desai
> > Subject: Re: [PATCH v2 11/15] megaraid_sas: Set device queue_depth
> > same as HBA can_queue value in scsi-mq mode
> >
> > I still don't understand why you don't want to do the same for the
non-mq
> path.
>
> Hi Christoph,
>
> Sorry for delay in response.
>
> MQ case -
> If there is any block layer requeue happens, we see performance drop. So
we
> avoid re-queue increasing Device QD = HBA QD. Performance drop due to
block
> layer re-queue is more in case of HDD (sequential IO converted into
random IO).
>
> Non-MQ case.
> If we increase Device QD = HBA QD for no-mq case, we see performance
drop
> for certain profiles.
> For example SATA SSD, previous driver in non-mq set Device QD=32. In
this case,
> if we have more outstanding IO per device (more than 32), block layer
attempts
> soft merge and eventually end user experience higher performance due to
block
> layer attempting soft merge.  Same is not correct in MQ case, as IO
scheduler in
> MQ adds overhead if at all there is any throttling or staging due to
device QD.
>
> Below is example of single SATA SSD, Sequential Read, BS=4K, IO depth =
256
>
> MQ enable, Device QD = 32 achieves 137K IOPS MQ enable, Device QD = 916
> (HBA QD) achieves 145K IOPS
>
> MQ disable, Device QD = 32 achieves 237K IOPS MQ disable, Device QD =
916
> (HBA QD) achieves 145K IOPS
>
> Ideally we want to keep same QD settings in non-MQ mode, but trying to
avoid
> as we may face some regression from end user as explained.
>
> Thanks,
> Shivasharan

Hi Christoph,
Can you please let us know your thoughts on this?
We understand that the settings should ideally be uniform across non-mq
and mq cases.
But based on the test results above, for non-mq case we are seeing some
difference in performance for certain IO profiles when compared to earlier
releases after increasing queue depth. Same is not the case when mq is
enabled.

Based on these results, we would like to keep this patch as is for this
phase.
We will run the further tests on this and will update for the next phase.

Thanks,
Shivasharan
