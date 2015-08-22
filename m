From: Anatol Pomozov <anatol.pomozov@gmail.com>
Subject: IO failures with SMR drives at latest kernel versions
Date: Fri, 21 Aug 2015 22:37:44 -0700
Message-ID: <CAOMFOmVFqOvr7AZQ0hie3LB3ReUcNV3rav5Dk_uf2aHoq-LK4A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vk0-f46.google.com ([209.85.213.46]:32881 "EHLO
	mail-vk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751947AbbHVFoz (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 22 Aug 2015 01:44:55 -0400
Received: by vkd66 with SMTP id 66so39271619vkd.0
        for <linux-scsi@vger.kernel.org>; Fri, 21 Aug 2015 22:44:55 -0700 (PDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Linux SCSI List <linux-scsi@vger.kernel.org>
Cc: hch@lst.de, Tejun Heo <tj@kernel.org>

Hi

I recently got 2 Seagate 8Tb drives. 'dd' over whole disc ran fine.
Then I inserted into my RAID and started rebalancing. I've got
following error almost immediately:



ata5.00: failed command: WRITE FPDMA QUEUED
ata5.00: cmd 61/00:e0:80:e7:75/1d:00:9f:00:00/40 tag 28 ncq 3801088 out
                                       res
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata5.00: status: { DRDY }
ata5.00: failed command: WRITE FPDMA QUEUED
ata5.00: cmd 61/80:e8:80:04:76/1d:00:9f:00:00/40 tag 29 ncq 3866624 out
                                       res
40/00:00:00:00:00/00:00:00:00:00/00 Emask 0x4 (timeout)
ata5.00: status: { DRDY }
ata5: hard resetting link
ata5: SATA link up 3.0 Gbps (SStatus 123 SControl 300)
ata5.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) succeeded
ata5.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK) filtered out
ata5.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE CONFIGURATION OVERLAY)
filtered out
ata5.00: ACPI cmd ef/10:06:00:00:00:00 (SET FEATURES) succeeded
ata5.00: ACPI cmd f5/00:00:00:00:00:00 (SECURITY FREEZE LOCK) filtered out
ata5.00: ACPI cmd b1/c1:00:00:00:00:00 (DEVICE CONFIGURATION OVERLAY)
filtered out
ata5.00: configured for UDMA/133
ata5.00: device reported invalid CHS sector 0
ata5.00: device reported invalid CHS sector 0
ata5.00: device reported invalid CHS sector 0
ata5.00: device reported invalid CHS sector 0
ata5.00: device reported invalid CHS sector 0
ata5.00: device reported invalid CHS sector 0
ata5.00: device reported invalid CHS sector 0
ata5.00: device reported invalid CHS sector 0
ata5.00: device reported invalid CHS sector 0
ata5.00: device reported invalid CHS sector 0
ata5.00: device reported invalid CHS sector 0



Discs are from different batches and I was a bit surprised to see
identical failures at the same time. I was ready send the drives to
RMA but then I discovered this thread
https://bbs.archlinux.org/viewtopic.php?id=199351 A lot of people
report the same problem as mine. It was found that the problem appears
only starting from 3.19, with kernel 3.18 or Windows these drives work
fine. It is recommended to revert this change
9162c6579bf90b3f5ddb7e3a6c6fa946c1b4cbeb "libata: Implement
ATA_DEV_ZAC" that seems fixes the issue.

There is also the same issue reported at kernel.org
https://bugzilla.kernel.org/show_bug.cgi?id=93581


This issue is extremely annoying and makes negative SMR drives user
experience. Had anybody look at this bug?
