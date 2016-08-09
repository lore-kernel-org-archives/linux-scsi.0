From: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Subject: RE: [PATCH 02/28] be2iscsi: Replace _bh with _irqsave/irqrestore
Date: Tue, 9 Aug 2016 13:59:35 +0530
Message-ID: <2c0a32a2af7f12150da2818d0b0ec4d6@mail.gmail.com>
References: <1469092085-14311-1-git-send-email-jitendra.bhivare@broadcom.com>
	<1469092085-14311-3-git-send-email-jitendra.bhivare@broadcom.com>
	<57A4DD34.4080000@redhat.com> <yq1popivjjk.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ua0-f182.google.com ([209.85.217.182]:33080 "EHLO
	mail-ua0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751414AbcHII3i (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Aug 2016 04:29:38 -0400
Received: by mail-ua0-f182.google.com with SMTP id 74so9103612uau.0
        for <linux-scsi@vger.kernel.org>; Tue, 09 Aug 2016 01:29:37 -0700 (PDT)
In-Reply-To: <yq1popivjjk.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Christie <mchristi@redhat.com>
Cc: linux-scsi@vger.kernel.org

> -----Original Message-----
> From: Martin K. Petersen [mailto:martin.petersen@oracle.com]
> Sent: Tuesday, August 09, 2016 6:35 AM
> To: Mike Christie
> Cc: Jitendra Bhivare; linux-scsi@vger.kernel.org
> Subject: Re: [PATCH 02/28] be2iscsi: Replace _bh with
_irqsave/irqrestore
>
> >>>>> "Mike" == Mike Christie <mchristi@redhat.com> writes:
>
> >> In beiscsi_alloc_pdu, _bh versions of spin_lock are being used for
> >> protecting SGLs and WRBs. _bh versions are needed as the function
> >> gets invoked in process context and BLOCK_IOPOLL softirq.
> >>
> >> In spin_unlock_bh, after releasing the lock and enabling BH,
> >> do_softirq is called which executes till last SOFTIRQ.
> >>
> >> beiscsi_alloc_pdu is called under session lock. Through block layer,
> >> iSCSI stack in some cases send IOs with interrupts disabled. In such
> >> paths,
>
>
> Mike> What path is this? Is this with mq enabled or disabled?
>
> Jitendra?
>
> --
> Martin K. Petersen	Oracle Linux Engineering
[JB] Sorry for the delayed response, there was some issue with my mail
client.
There are paths block layer where IRQs are disabled with request_queue
queue_lock.
- blk_timeout_work : this triggers NOP-OUT thru' iscsi_eh_cmd_timed_out.
- blk_execute_rq_nowait
