From: Sumit Saxena <sumit.saxena@avagotech.com>
Subject: RE: [PATCH v3 6/18] megaraid_sas : Use Block layer tag support for
 internal command indexing
Date: Mon, 11 May 2015 15:27:19 +0530
Message-ID: <5e1ce6ee219828a9d0d000be4836f973@mail.gmail.com>
References: <201504231103.t3NB3e1u029800@palmhbs0.lsi.com> <20150511091805.GG28820@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qc0-f172.google.com ([209.85.216.172]:33469 "EHLO
	mail-qc0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753355AbbEKJ5V (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 11 May 2015 05:57:21 -0400
Received: by qcvo8 with SMTP id o8so42236337qcv.0
        for <linux-scsi@vger.kernel.org>; Mon, 11 May 2015 02:57:20 -0700 (PDT)
In-Reply-To: <20150511091805.GG28820@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, thenzl@redhat.com, martin.petersen@oracle.com, jbottomley@parallels.com, Kashyap Desai <kashyap.desai@avagotech.com>

>-----Original Message-----
>From: Christoph Hellwig [mailto:hch@infradead.org]
>Sent: Monday, May 11, 2015 2:48 PM
>To: Sumit.Saxena@avagotech.com
>Cc: linux-scsi@vger.kernel.org; thenzl@redhat.com;
>martin.petersen@oracle.com; hch@infradead.org;
>jbottomley@parallels.com; kashyap.desai@avagotech.com
>Subject: Re: [PATCH v3 6/18] megaraid_sas : Use Block layer tag support
for
>internal command indexing
>
>> @@ -1668,6 +1655,10 @@ static int megasas_slave_configure(struct
>scsi_device *sdev)
>>  	blk_queue_rq_timeout(sdev->request_queue,
>>  		MEGASAS_DEFAULT_CMD_TIMEOUT * HZ);
>>
>> +	sdev_printk(KERN_INFO, sdev, "qdepth(%d), tagged(%d), "
>> +		"scsi_level(%d), cmd_que(%d)\n", sdev->queue_depth,
>> +		sdev->tagged_supported, sdev->scsi_level,
>> +		(sdev->inquiry[7] & 2) >> 1);
>
>This noisy printk a) doesn't belong into this patch, and b) shouldn't be
a added
>at all.

Yes, it's not needed. I will remove this printk. If I resend only this
patch, then subsequent patches will be affected and needs to be recreated.
If you are Ok, then I can send a patch to remove this printk rebased on
top of this series.
Please let me know your response.
