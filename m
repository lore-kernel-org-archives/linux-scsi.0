From: Douglas Miller <dougmill@linux.vnet.ibm.com>
Subject: Issues with LSI-3008 adapters, mpt3sas driver
Date: Wed, 31 Aug 2016 15:43:52 -0500
Message-ID: <e04c2ab2-f959-9eb6-744b-c5169635c0b5@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:36784 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1753198AbcHaUn7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 31 Aug 2016 16:43:59 -0400
Received: from pps.filterd (m0098393.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u7VKhY33110992
        for <linux-scsi@vger.kernel.org>; Wed, 31 Aug 2016 16:43:58 -0400
Received: from e33.co.us.ibm.com (e33.co.us.ibm.com [32.97.110.151])
        by mx0a-001b2d01.pphosted.com with ESMTP id 255wjawmjs-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Wed, 31 Aug 2016 16:43:58 -0400
Received: from localhost
        by e33.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <dougmill@linux.vnet.ibm.com>;
        Wed, 31 Aug 2016 14:43:57 -0600
Received: from b01cxnp22034.gho.pok.ibm.com (b01cxnp22034.gho.pok.ibm.com [9.57.198.24])
        by d03dlp01.boulder.ibm.com (Postfix) with ESMTP id 5CFC41FF0051
        for <linux-scsi@vger.kernel.org>; Wed, 31 Aug 2016 14:43:36 -0600 (MDT)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, jejb@us.ibm.com

Hi all,

I am seeing an issue while using an LSI-3008-based adapter (mpt3sas 
driver) on a PowerPC system (although I am not yet convinced it is 
architecture dependent). When I create a RAID1 volume, the physical disk 
devices get "hidden" as expected however the various kernel objects are 
out of sync. The corresponding bits in the "sd_index_ida" bitmap gets 
cleared, and the symlink in /sys/dev/block for this major:minor pair 
gets removed, but none of the other major:minor entries in sysfs get 
removed. The next time a new device is added (for example, during 
another RAID volume create or delete), the recently-freed major:minor 
number is picked up from the "sd_index_ida" bitmap but the attempt to 
create sysfs entries fails EEXIST due to an entry by the same name 
already (still) existing. This failure goes unhandled and later the 
kernel panics in sd_probe_async while dereferencing an (apparently) 
invalid backing_dev_info structure (presumably left invalid due to the 
EEXIST error).

A reboot clears this (bitmaps and sysfs) up and the second RAID volume 
(if a create was done) shows up normally. However, even if the panic 
were avoided by better error handling in sd_probe_async there would 
still be the problem of being able to create more than one RAID volume 
without rebooting.

I am wondering if this issue has been seen elsewhere, and also just what 
might be going wrong. For mpt3sas, it appears that the firmware largely 
drives the hiding/exposing of devices but I don't see an issue with the 
ordering of those events. I am wondering if the driver is failing to 
setup the device attributes correctly in order to get the proper sysfs 
handling.

I am seeing this on Ubuntu 16.04, but also see it on the upstream 
kernel. Oddly, it does not happen on RHEL 7.2 (an older kernel).

A possibly-related issue we see is that when a RAID volume is deleted, 
none of the RAID device nodes (/dev as well as /sys/) get removed - 
although they are unusable. Deleting before creating does not produce 
the panic, so I believe the "sd_index_ida" bitmap is not getting updated 
by the delete.


Any help would be appreciated.

Thanks,

Doug

