From: Hannes Reinecke <hare@suse.de>
Subject: Re: How to increase RAID/HBA controller's timeout?
Date: Tue, 4 Oct 2016 10:19:47 +0200
Message-ID: <1a59730f-e489-86ce-b01a-fcb3c85a4b4d@suse.de>
References: <CAOE4rSwrEBPHqXoyHbd2a6PTYp9ZnP=KXB7chOCfj0Q1MJfy2A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:44632 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1752961AbcJDITt (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 4 Oct 2016 04:19:49 -0400
In-Reply-To: <CAOE4rSwrEBPHqXoyHbd2a6PTYp9ZnP=KXB7chOCfj0Q1MJfy2A@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?UTF-8?B?RMSBdmlzIE1vc8SBbnM=?= <davispuh@gmail.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 10/02/2016 07:51 PM, Dāvis Mosāns wrote:
> I've HighPoint RocketRAID 2760A which uses mvsas driver.
> 
> And I need to increase it's timeout because it timeouts too early and
> doesn't allow HDD to finish it's recovery routine for unreadable
> sector (that HDD doesn't support TLER)
> 
> I've increased
> 
> # echo 300 > /sys/block/sdd/device/timeout
> # echo 300 > /sys/block/sdd/device/eh_timeout
> 
> But it didn't gave any effect, it still timeouts in ~8 seconds.
> 
> 
> # hdparm --read-sector 3021567960 /dev/sdd
> /dev/sdd:
> reading sector 3021567960: FAILED: Input/output error
> 
> 
> [17226.257531] /mnt/linux/drivers/scsi/mvsas/mv_sas.c 1771:port 2 slot
> 0 rx_desc 30000 has error info0000000001000000.
> [17226.266698] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
> [17226.266707] sas: ata21: end_device-7:2: cmd error handler
> [17226.266740] sas: ata7: end_device-7:0: dev error handler
> [17226.266750] sas: ata8: end_device-7:1: dev error handler
> [17226.266760] sas: ata21: end_device-7:2: dev error handler
> [17226.266767] sas: ata10: end_device-7:3: dev error handler
> [17226.266772] ata21.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
> [17226.266778] ata21.00: failed command: READ SECTOR(S) EXT
> [17226.266781] sas: ata12: end_device-7:5: dev error handler
> [17226.266787] sas: ata11: end_device-7:4: dev error handler
> [17226.266793] sas: ata13: end_device-7:6: dev error handler
> [17226.266795] sas: ata14: end_device-7:7: dev error handler
> [17226.266813] ata21.00: cmd 24/00:01:d8:77:19/00:00:b4:00:00/e0 tag
> 21 pio 512 in
>                         res 51/40:00:d8:77:19/00:00:b4:00:00/00 Emask
> 0x9 (media error)
> [17226.266820] ata21.00: status: { DRDY ERR }
> [17226.266825] ata21.00: error: { UNC }
> [17226.330498] ata21.00: failed to IDENTIFY (I/O error, err_mask=0x1)
> [17226.330506] ata21.00: revalidation failed (errno=-5)
> [17226.330514] ata21: hard resetting link
> [17226.483739] ata21.00: failed to IDENTIFY (I/O error, err_mask=0x1)
> [17226.483746] ata21.00: revalidation failed (errno=-5)
> [17228.669337] hpet1: lost 331 rtc interrupts
> [17230.689985] hpet1: lost 129 rtc interrupts
> [17231.483422] ata21: hard resetting link
> [17231.637199] ata21.00: failed to IDENTIFY (I/O error, err_mask=0x1)
> [17231.637207] ata21.00: revalidation failed (errno=-5)
> [17231.637212] ata21.00: disabled
> [17231.637252] ata21: EH complete
> [17231.637275] sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 0 tries:
> 
> After this that disk isn't accessible at all until it's physically
> disconnected and reconnected.
> 
Well, this looks more like the ATA error recovery not working properly;
libata-eh is trying to reset the link (that's the 'hard resetting link'
message), but after that the device doesn't respond (that's the 'failed
to IDENTIFY' message).
So it's not so much a wrong timeout, it's a wrong EH implementation.
We would need to check why mvsas hard reset is not working; I've seen a
similar issue on isci, but haven't been able to debug things properly.
So it might even be a generic libsas EH issue, and not related to mvsas
at all.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: J. Hawn, J. Guild, F. Imendörffer, HRB 16746 (AG Nürnberg)
