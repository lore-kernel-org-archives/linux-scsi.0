From: =?UTF-8?B?RMSBdmlzIE1vc8SBbnM=?= <davispuh@gmail.com>
Subject: How to increase RAID/HBA controller's timeout?
Date: Sun, 2 Oct 2016 20:51:43 +0300
Message-ID: <CAOE4rSwrEBPHqXoyHbd2a6PTYp9ZnP=KXB7chOCfj0Q1MJfy2A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-it0-f45.google.com ([209.85.214.45]:38384 "EHLO
        mail-it0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751271AbcJBRvp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 2 Oct 2016 13:51:45 -0400
Received: by mail-it0-f45.google.com with SMTP id o19so78932019ito.1
        for <linux-scsi@vger.kernel.org>; Sun, 02 Oct 2016 10:51:44 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

I've HighPoint RocketRAID 2760A which uses mvsas driver.

And I need to increase it's timeout because it timeouts too early and
doesn't allow HDD to finish it's recovery routine for unreadable
sector (that HDD doesn't support TLER)

I've increased

# echo 300 > /sys/block/sdd/device/timeout
# echo 300 > /sys/block/sdd/device/eh_timeout

But it didn't gave any effect, it still timeouts in ~8 seconds.


# hdparm --read-sector 3021567960 /dev/sdd
/dev/sdd:
reading sector 3021567960: FAILED: Input/output error


[17226.257531] /mnt/linux/drivers/scsi/mvsas/mv_sas.c 1771:port 2 slot
0 rx_desc 30000 has error info0000000001000000.
[17226.266698] sas: Enter sas_scsi_recover_host busy: 1 failed: 1
[17226.266707] sas: ata21: end_device-7:2: cmd error handler
[17226.266740] sas: ata7: end_device-7:0: dev error handler
[17226.266750] sas: ata8: end_device-7:1: dev error handler
[17226.266760] sas: ata21: end_device-7:2: dev error handler
[17226.266767] sas: ata10: end_device-7:3: dev error handler
[17226.266772] ata21.00: exception Emask 0x0 SAct 0x0 SErr 0x0 action 0x0
[17226.266778] ata21.00: failed command: READ SECTOR(S) EXT
[17226.266781] sas: ata12: end_device-7:5: dev error handler
[17226.266787] sas: ata11: end_device-7:4: dev error handler
[17226.266793] sas: ata13: end_device-7:6: dev error handler
[17226.266795] sas: ata14: end_device-7:7: dev error handler
[17226.266813] ata21.00: cmd 24/00:01:d8:77:19/00:00:b4:00:00/e0 tag
21 pio 512 in
                        res 51/40:00:d8:77:19/00:00:b4:00:00/00 Emask
0x9 (media error)
[17226.266820] ata21.00: status: { DRDY ERR }
[17226.266825] ata21.00: error: { UNC }
[17226.330498] ata21.00: failed to IDENTIFY (I/O error, err_mask=0x1)
[17226.330506] ata21.00: revalidation failed (errno=-5)
[17226.330514] ata21: hard resetting link
[17226.483739] ata21.00: failed to IDENTIFY (I/O error, err_mask=0x1)
[17226.483746] ata21.00: revalidation failed (errno=-5)
[17228.669337] hpet1: lost 331 rtc interrupts
[17230.689985] hpet1: lost 129 rtc interrupts
[17231.483422] ata21: hard resetting link
[17231.637199] ata21.00: failed to IDENTIFY (I/O error, err_mask=0x1)
[17231.637207] ata21.00: revalidation failed (errno=-5)
[17231.637212] ata21.00: disabled
[17231.637252] ata21: EH complete
[17231.637275] sas: --- Exit sas_scsi_recover_host: busy: 0 failed: 0 tries:

After this that disk isn't accessible at all until it's physically
disconnected and reconnected.


Thanks!
