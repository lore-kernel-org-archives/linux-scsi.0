From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH 14/14] sd: Honor block layer integrity handling flags
Date: Thu, 11 Sep 2014 10:09:23 +0300
Message-ID: <54114AA3.2090806@dev.mellanox.co.il>
References: <1409254292-2540-1-git-send-email-martin.petersen@oracle.com>	<1409254292-2540-15-git-send-email-martin.petersen@oracle.com>	<540390FF.2040703@dev.mellanox.co.il> <yq1bnqn9fzg.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-we0-f182.google.com ([74.125.82.182]:47570 "EHLO
	mail-we0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751014AbaIKHJa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Sep 2014 03:09:30 -0400
Received: by mail-we0-f182.google.com with SMTP id k48so4017604wev.13
        for <linux-scsi@vger.kernel.org>; Thu, 11 Sep 2014 00:09:29 -0700 (PDT)
In-Reply-To: <yq1bnqn9fzg.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, axboe@fb.com, hch@lst.de, sagig@mellanox.com

On 9/11/2014 3:07 AM, Martin K. Petersen wrote:
>>>>>> "Sagi" == Sagi Grimberg <sagig@dev.mellanox.co.il> writes:
>
> [Back from vacation]

Hey Martin,

>
>>> + [SCSI_PROT_WRITE_PASS] = SCSI_PROT_TRANSFER_PI |
>>> + SCSI_PROT_GUARD_CHECK |
>>> + SCSI_PROT_REF_CHECK |
>>> + SCSI_PROT_REF_INCREMENT |
>>> + SCSI_PROT_IP_CHECKSUM,
>
> Sagi> A bit strange to me that you put REF_CHECK & REF_INCREMENT flag
> Sagi> depending on the prot_op while it really depends on the prot_type.
>
> It doesn't just depend on the prot_type. You need to be able to tell the
> HBA to increment/test the ref tag even for a Type 0 device.
>

That's still a dependence on prot_type (type 0...). Notice that you
set SCSI_PROT_REF_INCREMENT in every op index (except SCSI_PROT_NORMAL)
so my point is that it's strange to see this association.

P.S.
Now drivers can stop understanding prot_type to set DIF operations...
so once drivers stop referencing it we can remove it from scsi_cmnd.

Sagi.
