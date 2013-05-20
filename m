From: James Smart <James.Smart@emulex.com>
Subject: Re: [PATCH 0/5] scsi: Allow fast io fail without waiting through
 timeout
Date: Mon, 20 May 2013 11:53:58 -0400
Message-ID: <519A4716.7000001@emulex.com>
References: <1369034103-31644-1-git-send-email-renmx@cn.fujitsu.com>
Reply-To: <James.Smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.ext.emulex.com ([138.239.224.99]:12387 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757069Ab3ETPyC (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 20 May 2013 11:54:02 -0400
In-Reply-To: <1369034103-31644-1-git-send-email-renmx@cn.fujitsu.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ren Mingxin <renmx@cn.fujitsu.com>
Cc: James.Bottomley@HansenPartnership.com, Nagalakshmi.Nandigama@lsi.com, Sreekanth.Reddy@lsi.com, michaelc@cs.wisc.edu, robert.w.love@intel.com, dgilbert@interlog.com, hare@suse.de, bprakash@broadcom.com, agk@redhat.com, neilb@suse.de, gregkh@linuxfoundation.org, axboe@kernel.dk, tj@kernel.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Ren,

Based on the discussion recently held at LSF 2013, we are reworking the 
error recovery path to address all the issues you are mentioning.   That 
work contradicts these patches. So for now, these should be held off.

-- james s



On 5/20/2013 3:14 AM, Ren Mingxin wrote:
> When there is a scsi command timed-out or failed, the scsi eh
> tries a thorugh recovery, which is necessary for non-redundant
> systems. However, the thorugh recovery usually takes much time,
> which is not acceptable for misson critical systems. To improve
> this latency, if we are working on a redundant system, we should
> avoid the scsi eh for its long time failing recovery, and quick
> failover to another path.
>
> This set of patches is trying to implement above.
>
> NOTE: the userland tools need to eusure the environment
> restriction, which will be implemented later.
>
> Thanks,
> Ren
>
> Ren Mingxin (5):
>    scsi: rename return code FAST_IO_FAIL to FAST_IO
>    FC transport: Add interface to specify fast io level for timed-out cmds
>    SAS transport: Add interface to specify fast io level for timed-out cmds
>    lpfc: Allow fast timed-out io recovery
>    mptfusion: Allow fast timed-out io recovery
>
>   drivers/message/fusion/mptscsih.c   |   29 ++++++++-
>   drivers/scsi/lpfc/lpfc_scsi.c       |   34 ++++++++++
>   drivers/scsi/scsi_error.c           |   18 ++---
>   drivers/scsi/scsi_sas_internal.h    |    4 -
>   drivers/scsi/scsi_transport_fc.c    |  112 ++++++++++++++++++++++++++++++++++--
>   drivers/scsi/scsi_transport_iscsi.c |    6 -
>   drivers/scsi/scsi_transport_sas.c   |  103 ++++++++++++++++++++++++++++++++-
>   include/scsi/scsi.h                 |    2
>   include/scsi/scsi_transport_fc.h    |   11 +++
>   include/scsi/scsi_transport_sas.h   |    8 ++
>   10 files changed, 303 insertions(+), 24 deletions(-)
>
>

