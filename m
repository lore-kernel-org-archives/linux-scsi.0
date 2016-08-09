From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH 02/28] be2iscsi: Replace _bh with _irqsave/irqrestore
Date: Mon, 08 Aug 2016 21:05:19 -0400
Message-ID: <yq1popivjjk.fsf@sermon.lab.mkp.net>
References: <1469092085-14311-1-git-send-email-jitendra.bhivare@broadcom.com>
	<1469092085-14311-3-git-send-email-jitendra.bhivare@broadcom.com>
	<57A4DD34.4080000@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:37545 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751433AbcHIBF2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Aug 2016 21:05:28 -0400
In-Reply-To: <57A4DD34.4080000@redhat.com> (Mike Christie's message of "Fri, 5
	Aug 2016 13:38:44 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <mchristi@redhat.com>
Cc: Jitendra Bhivare <jitendra.bhivare@broadcom.com>, linux-scsi@vger.kernel.org

>>>>> "Mike" == Mike Christie <mchristi@redhat.com> writes:

>> In beiscsi_alloc_pdu, _bh versions of spin_lock are being used for
>> protecting SGLs and WRBs. _bh versions are needed as the function
>> gets invoked in process context and BLOCK_IOPOLL softirq.
>> 
>> In spin_unlock_bh, after releasing the lock and enabling BH,
>> do_softirq is called which executes till last SOFTIRQ.
>> 
>> beiscsi_alloc_pdu is called under session lock. Through block layer,
>> iSCSI stack in some cases send IOs with interrupts disabled. In such
>> paths,


Mike> What path is this? Is this with mq enabled or disabled?

Jitendra?

-- 
Martin K. Petersen	Oracle Linux Engineering
