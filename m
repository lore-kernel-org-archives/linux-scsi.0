From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH] scsi: sd: Implement blacklist option for WRITE SAME w/ UNMAP
Date: Fri, 29 Sep 2017 09:21:48 -0400
Message-ID: <yq1lgkx63o3.fsf@oracle.com>
References: <1506529677.4100.452.camel@localhost.localdomain>
        <20170928013512.1058-1-martin.petersen@oracle.com>
        <1506679376.11960.1.camel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:47662 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751176AbdI2NVy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 29 Sep 2017 09:21:54 -0400
In-Reply-To: <1506679376.11960.1.camel@redhat.com> (Laurence Oberman's message
        of "Fri, 29 Sep 2017 06:02:56 -0400")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Laurence Oberman <loberman@redhat.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org


Laurence,

> I am testing this but its not being picked up so I want to know if I
> have the kernel command line wrong here.
>
> scsi_dev_flags=LIO-ORG:thin2:0x80000000
>
> What am I doing wrong to pass the BLIST flags.

This worked for me:

[root@kvm ~]# echo "Linux:scsi_debug:0x80000000" > /proc/scsi/device_info
[root@kvm ~]# grep Linux /proc/scsi/device_info 
'Linux   ' 'scsi_debug      ' 0x80000000
[root@kvm ~]# modprobe scsi_debug unmap_max_blocks=10 unmap_max_desc=1 write_same_length=20 lbpws=1
[root@kvm ~]# lsblk -D
NAME DISC-ALN DISC-GRAN DISC-MAX DISC-ZERO
sda         0      512B       5K         0

(With the caveat that I tweaked scsi_debug to report the UNMAP
parameters despite lbpu being 0).

-- 
Martin K. Petersen	Oracle Linux Engineering
