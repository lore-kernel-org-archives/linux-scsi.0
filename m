From: Stefan Priebe - Profihost AG <s.priebe@profihost.ag>
Subject: Re: isci regression in 4.11.0-rc2 by scsi: libsas: allow async aborts
Date: Mon, 13 Nov 2017 11:23:48 +0100
Message-ID: <3553f40f-8ca0-2fb4-963e-5d1e9b176635@profihost.ag>
References: <2dcd4012-1255-c28f-22c2-32890b421473@profihost.ag>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cloud1-vm154.de-nserver.de ([178.250.10.56]:39453 "EHLO
        cloud1-vm154.de-nserver.de" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1751705AbdKMKXu (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 13 Nov 2017 05:23:50 -0500
In-Reply-To: <2dcd4012-1255-c28f-22c2-32890b421473@profihost.ag>
Content-Language: de-DE
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: jth@kernel.org, hare@suse.de, martin.petersen@oracle.com, intel-linux-scu@intel.com, linux-scsi <linux-scsi@vger.kernel.org>, artur.paszkiewicz@intel.com

ping - anybody?

Greets,
Stefan

Am 08.11.2017 um 10:33 schrieb Stefan Priebe - Profihost AG:
> Hello,
> 
> after upgrading some servers from 4.9 to a kernel > 4.11 i saw a
> regression where i cannot boot into the os.
> 
> The kernel is crashing in the isci (NOT iscsi) driver in task abort.
> 
> Message:
> Unable to handle kernel NULL pointer dereference at isci_task_abort_task
> 
> git bisect detected the following offending commit:
> 909657615d9b3ce709be4fd95b9a9e8c8c7c2be6 is the first bad commit
> commit 909657615d9b3ce709be4fd95b9a9e8c8c7c2be6
> Author: Christoph Hellwig <hch@lst.de>
> Date: Thu Apr 6 15:36:32 2017 +0200
> 
>     scsi: libsas: allow async aborts
> 
>     We now first try to call ->eh_abort_handler from a work queue, but
> libsas
>     was always failing that for no good reason. Allow async aborts.
> 
>     Reviewed-by: Johannes Thumshirn <jth@kernel.org>
>     Reviewed-by: Hannes Reinecke <hare@suse.de>
>     Signed-off-by: Christoph Hellwig <hch@lst.de>
>     Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
> 
> :040000 040000 b15f1eb57bf74667aefb7a304fa09bf58386eaf2
> 64df540499763db44c7e1b6ec9a55ffa9b2ebedc M drivers
> 
> i can't grab much information except for a photo as the boot process is
> before netconsole or others can jump in.
> 
> The caller of isci_task_abort_task seems to be sas_eh_abort_handler.
> 
> Thanks!
> 
> Greets,
> Stefan
> 
