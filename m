From: Jitendra Bhivare <jitendra.bhivare@broadcom.com>
Subject: RE: [PATCH 02/28] be2iscsi: Replace _bh with _irqsave/irqrestore
Date: Tue, 27 Sep 2016 15:48:31 +0530
Message-ID: <81c4d1740abeeaa19157383d09606ab6@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vk0-f43.google.com ([209.85.213.43]:36227 "EHLO
        mail-vk0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1754079AbcI0KSf (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 27 Sep 2016 06:18:35 -0400
Received: by mail-vk0-f43.google.com with SMTP id d8so8514715vka.3
        for <linux-scsi@vger.kernel.org>; Tue, 27 Sep 2016 03:18:35 -0700 (PDT)
References: 817c1848a40a874cd5748f414d87665f@mail.gmail.com
In-Reply-To: 817c1848a40a874cd5748f414d87665f@mail.gmail.com
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: cleech@redhat.com, lduncan@suse.com
Cc: linux-scsi@vger.kernel.org, Mike Christie <mchristi@redhat.com>, "Martin K. Petersen" <martin.petersen@oracle.com>

> -----Original Message-----
> From: Jitendra Bhivare [mailto:jitendra.bhivare@broadcom.com]
> Sent: Friday, September 23, 2016 8:38 PM
> To: 'Mike Christie'; 'Martin K. Petersen'
> Cc: 'linux-scsi@vger.kernel.org'
> Subject: RE: [PATCH 02/28] be2iscsi: Replace _bh with _irqsave/irqrestore
>
> Hi Mike,
>
> I could reproduce hard lockup using for-next kernel only in
> iscsi_eh_cmd_timeout path due to spin_lock_irqsave taken in
> blk_timeout_work
> Please refer stack trace below.
>
> The _bh version used for frwd_lock and back_lock does not seem to be
> causing
> any issue similar to seen with be2iscsi after replacing _bh versions in
> be2iscsi.
>
> I am testing it further, to confirm in all possible scenarios... NOPs,
> error
> recovery, resets and reconnects.
> On my setup, I affined all EQ interrupts on a single CPU.
> Along with heavy IO, few of the invocations of fio were pinned to run on
> same
> CPU.
>
> Any call to unlock_bh with another spin_lock already held, invoking
> do_softirq,
> might cause deadlock if bottom half used by driver calls function which
> needs
> that another spin_lock.
> Is there a code which prevents this issue?
>
The only place, I think, libiscsi can have issues is__iscsi_complete_pdu
which should be protected under _bh version for frwd and back locks.
If the function is executed in process context there is a good chance the
base version of spin_lock used for frwd/back locks could cause deadlocks
when lld uses _bh version in alloc_pdu path
(__iscsi_complete_pdu->iscsi_send_nopout... alloc_pdu).

Thanks,

JB
