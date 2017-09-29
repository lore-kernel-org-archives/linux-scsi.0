From: Laurence Oberman <loberman@redhat.com>
Subject: Re: [PATCH] scsi: sd: Implement blacklist option for WRITE SAME w/
 UNMAP
Date: Fri, 29 Sep 2017 10:01:52 -0400
Message-ID: <1506693712.28112.1.camel@redhat.com>
References: <1506529677.4100.452.camel@localhost.localdomain>
         <20170928013512.1058-1-martin.petersen@oracle.com>
         <1506679376.11960.1.camel@redhat.com> <yq1lgkx63o3.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f174.google.com ([209.85.220.174]:53362 "EHLO
        mail-qk0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752157AbdI2OBy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Sep 2017 10:01:54 -0400
Received: by mail-qk0-f174.google.com with SMTP id w63so1239954qkd.10
        for <linux-scsi@vger.kernel.org>; Fri, 29 Sep 2017 07:01:54 -0700 (PDT)
In-Reply-To: <yq1lgkx63o3.fsf@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org

On Fri, 2017-09-29 at 09:21 -0400, Martin K. Petersen wrote:
> Laurence,
> 
> > I am testing this but its not being picked up so I want to know if
> > I
> > have the kernel command line wrong here.
> > 
> > scsi_dev_flags=LIO-ORG:thin2:0x80000000
> > 
> > What am I doing wrong to pass the BLIST flags.
> 
> This worked for me:
> 
> [root@kvm ~]# echo "Linux:scsi_debug:0x80000000" >
> /proc/scsi/device_info
> [root@kvm ~]# grep Linux /proc/scsi/device_info 
> 'Linux   ' 'scsi_debug      ' 0x80000000
> [root@kvm ~]# modprobe scsi_debug unmap_max_blocks=10
> unmap_max_desc=1 write_same_length=20 lbpws=1
> [root@kvm ~]# lsblk -D
> NAME DISC-ALN DISC-GRAN DISC-MAX DISC-ZERO
> sda         0      512B       5K         0
> 
> (With the caveat that I tweaked scsi_debug to report the UNMAP
> parameters despite lbpu being 0).
> 

OK, Thanks, that is working now and I pick up the correct size now.
Its going to be very useful for these corner case array
inconsistencies.

Tested-by: Laurence Oberman <loberman@redhat.com>

Sep 29 09:56:11 localhost kernel: scsi 1:0:0:50: Direct-Access     LIO-
ORG  thin2            4.0  PQ: 0 ANSI: 5
Sep 29 09:56:11 localhost kernel: scsi 1:0:0:50: alua: supports
implicit and explicit TPGS
Sep 29 09:56:11 localhost kernel: scsi 1:0:0:50: alua: device
naa.6001405f7aa27ca453f4381a00f22ea6 port group 0 rel port 2
Sep 29 09:56:11 localhost kernel: sd 1:0:0:50: Attached scsi generic
sg64 type 0
Sep 29 09:56:11 localhost kernel: RHDEBUG: unmap_limit_for_ws set by
kernel flag for case SD_LBP_WS16
Sep 29 09:56:11 localhost kernel: sd 1:0:0:50: [sdbl] 81920000 512-byte 
logical blocks: (41.9 GB/39.1 GiB)
Sep 29 09:56:11 localhost kernel: sd 1:0:0:50: [sdbl] Write Protect is
off
Sep 29 09:56:11 localhost kernel: sd 1:0:0:50: [sdbl] Write cache:
enabled, read cache: enabled, supports DPO and FUA
Sep 29 09:56:11 localhost kernel: sd 1:0:0:50: alua: transition timeout
set to 60 seconds
