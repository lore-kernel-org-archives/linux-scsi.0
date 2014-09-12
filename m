From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [PATCH 14/14] sd: Honor block layer integrity handling flags
Date: Fri, 12 Sep 2014 16:20:19 +0300
Message-ID: <5412F313.4030005@dev.mellanox.co.il>
References: <1409254292-2540-1-git-send-email-martin.petersen@oracle.com>	<1409254292-2540-15-git-send-email-martin.petersen@oracle.com>	<540390FF.2040703@dev.mellanox.co.il>	<yq1bnqn9fzg.fsf@sermon.lab.mkp.net>	<54114AA3.2090806@dev.mellanox.co.il> <yq1k3594o4p.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f174.google.com ([209.85.212.174]:48656 "EHLO
	mail-wi0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754674AbaILNU1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Sep 2014 09:20:27 -0400
Received: by mail-wi0-f174.google.com with SMTP id n3so625042wiv.1
        for <linux-scsi@vger.kernel.org>; Fri, 12 Sep 2014 06:20:25 -0700 (PDT)
In-Reply-To: <yq1k3594o4p.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, axboe@fb.com, hch@lst.de, sagig@mellanox.com

On 9/12/2014 4:35 AM, Martin K. Petersen wrote:
>>>>>> "Sagi" == Sagi Grimberg <sagig@dev.mellanox.co.il> writes:
>
> Sagi,
>
> Sagi> That's still a dependence on prot_type (type 0...). Notice that
> Sagi> you set SCSI_PROT_REF_INCREMENT in every op index (except
> Sagi> SCSI_PROT_NORMAL) so my point is that it's strange to see this
> Sagi> association.
>
> I still don't understand your point. The mask table indicates which
> flags are valid for a given protection operation. They are explicitly
> DIX flags and have nothing to do with the target protection type.
>

I see,
It's just confusing to see flags such as REF_INCREMENT/GUARD_CHECK/REF_CHECK
associated with a set of prot operations, but I guess it's just me.
Do you really need the mask anyway? seems like just an extra precaution
against wrong flagging.

It's just nit-picking - I do not see anything wrong with the patchset.
We can drop this if you want...

> Sagi> P.S.  Now drivers can stop understanding prot_type to set DIF
> Sagi> operations...  so once drivers stop referencing it we can remove
> Sagi> it from scsi_cmnd.
>
> Yes. Second part of this installment removes this and a few other things
> and converts qla2xxx, lpfc, mptNsas, etc. to the new interface.
>

Nice, I posted "RDMA signature feature update" preparing iSER DIF code 
to complement this change - all that is left now is a straight-forward
conversion.
