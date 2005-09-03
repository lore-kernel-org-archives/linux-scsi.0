From: Andreas Herrmann <AHERRMAN@de.ibm.com>
Subject: Re: [PATCH 1/7] zfcp: introduce eh_timed_out handler
Date: Sat, 3 Sep 2005 15:21:47 +0200
Message-ID: <OFEE1779F5.D49C96D2-ONC1257071.004902BE-C1257071.00493413@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate3.de.ibm.com ([195.212.29.152]:62099 "EHLO
	mtagate3.de.ibm.com") by vger.kernel.org with ESMTP
	id S1750920AbVICNVu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 3 Sep 2005 09:21:50 -0400
Received: from d12nrmr1607.megacenter.de.ibm.com (d12nrmr1607.megacenter.de.ibm.com [9.149.167.49])
	by mtagate3.de.ibm.com (8.12.10/8.12.10) with ESMTP id j83DLnTZ156384
	for <linux-scsi@vger.kernel.org>; Sat, 3 Sep 2005 13:21:49 GMT
Received: from d12av02.megacenter.de.ibm.com (d12av02.megacenter.de.ibm.com [9.149.165.228])
	by d12nrmr1607.megacenter.de.ibm.com (8.12.10/NCO/VERS6.7) with ESMTP id j83DLnih180890
	for <linux-scsi@vger.kernel.org>; Sat, 3 Sep 2005 15:21:49 +0200
Received: from d12av02.megacenter.de.ibm.com (loopback [127.0.0.1])
	by d12av02.megacenter.de.ibm.com (8.12.11/8.13.3) with ESMTP id j83DLnqA026367
	for <linux-scsi@vger.kernel.org>; Sat, 3 Sep 2005 15:21:49 +0200
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjan@infradead.org>
Cc: James Bottomley <jejb@steeleye.com>, Linux SCSI <linux-scsi@vger.kernel.org>

On 03.09.2005 14:56 Arjan van de Ven <arjan@infradead.org> wrote:

  > > zfcp: introduce eh_timed_out handler
  > > 
  > > This handler is required to avoid offlined SCSI devices in a 
multipath
  > > setup if scsi commands time out on cable pulls lasting longer than 
30
  > > seconds.

  > hmm why is this needed? doesn't the fc transport class do this for you
  > already? If not.. I think it should since it's not unique to your FC
  > driver but common to all..

Sorry, I am not sure whether fc transport does this already. Problem
may be that zfcp does not fully support the fc transport class at the
moment ... ;-(

Problem was that although multipath was used during error injection
tests (long cable pulls) SCSI devices were offlined. This was due to
error escalation in scsi_error.c (see function scsi_eh_ready_devs)
when commands timed out.

By providing an eh_timed_out handler the timed out requests are
returned as fast as possible to the upper layers. zfcp returns
EH_HANDLED for timed-out commands and scsi_times_out calls scsi_done:

        if (scmd->device->host->hostt->eh_timed_out)
                switch (scmd->device->host->hostt->eh_timed_out(scmd)) {
                case EH_HANDLED:
                        __scsi_done(scmd);
                        return;

Then dm-multipath has to decide what to do with the request.

With this patch and a proper multipath configuration
(e.g. queue_if_no_path option) Linux survived hard stress tests
with different kind of error injects (fimware updates, cable pulls
etc.) without I/O errors at user level.

In any case this patch will complete zfcp's set of eh_handlers.


Regards,

Andreas

