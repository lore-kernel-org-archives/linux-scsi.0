From: Shivasharan Srikanteshwara
        <shivasharan.srikanteshwara@broadcom.com>
Subject: RE: [PATCH v2 11/15] megaraid_sas: Set device queue_depth same as HBA
 can_queue value in scsi-mq mode
Date: Mon, 24 Jul 2017 16:59:28 +0530
Message-ID: <5bfb3bbc3e6d9b3a5c9afb749c075a40@mail.gmail.com>
References: <1499256029-16319-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <1499256029-16319-12-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <20170711135828.GA12013@lst.de> <3adb43de25a7531af4d083cd1af8c5b5@mail.gmail.com>
 <1fb5bf7342826f0cf84841930c7c4b11@mail.gmail.com> <20170720074736.GB22218@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f181.google.com ([209.85.220.181]:34231 "EHLO
        mail-qk0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751837AbdGXL3a (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 24 Jul 2017 07:29:30 -0400
Received: by mail-qk0-f181.google.com with SMTP id t2so53515313qkc.1
        for <linux-scsi@vger.kernel.org>; Mon, 24 Jul 2017 04:29:30 -0700 (PDT)
In-Reply-To: <20170720074736.GB22218@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org, martin.petersen@oracle.com, thenzl@redhat.com, jejb@linux.vnet.ibm.com, Sumit Saxena <sumit.saxena@broadcom.com>, hare@suse.com, Kashyap Desai <kashyap.desai@broadcom.com>

> -----Original Message-----
> From: Christoph Hellwig [mailto:hch@lst.de]
> Sent: Thursday, July 20, 2017 1:18 PM
> To: Shivasharan Srikanteshwara
> Cc: Christoph Hellwig; linux-scsi@vger.kernel.org;
martin.petersen@oracle.com;
> thenzl@redhat.com; jejb@linux.vnet.ibm.com; Sumit Saxena; hare@suse.com;
> Kashyap Desai
> Subject: Re: [PATCH v2 11/15] megaraid_sas: Set device queue_depth same
as
> HBA can_queue value in scsi-mq mode
>
> I still don't understand why you don't want to do the same for the
non-mq path.

Hi Christoph,

Sorry for delay in response.

MQ case -
If there is any block layer requeue happens, we see performance drop. So
we avoid re-queue increasing Device QD = HBA QD. Performance drop due to
block layer re-queue is more in case of HDD (sequential IO converted into
random IO).

Non-MQ case.
If we increase Device QD = HBA QD for no-mq case, we see performance drop
for certain profiles.
For example SATA SSD, previous driver in non-mq set Device QD=32. In this
case, if we have more outstanding IO per device (more than 32), block
layer attempts soft merge and eventually end user experience higher
performance due to block layer attempting soft merge.  Same is not correct
in MQ case, as IO scheduler in MQ adds overhead if at all there is any
throttling or staging due to device QD.

Below is example of single SATA SSD, Sequential Read, BS=4K, IO depth =
256

MQ enable, Device QD = 32 achieves 137K IOPS
MQ enable, Device QD = 916 (HBA QD) achieves 145K IOPS

MQ disable, Device QD = 32 achieves 237K IOPS
MQ disable, Device QD = 916 (HBA QD) achieves 145K IOPS

Ideally we want to keep same QD settings in non-MQ mode, but trying to
avoid as we may face some regression from end user as explained.

Thanks,
Shivasharan
