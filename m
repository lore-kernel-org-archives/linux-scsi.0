From: Laura Abbott <labbott@redhat.com>
Subject: Userspace regression with 6baca7601bde ("scsi: target: drop unused
 pi_prot_format attribute storage")
Date: Sun, 3 Feb 2019 17:56:00 +0100
Message-ID: <57120b72-2ab9-bfa5-f69c-31aee78d5936@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Language: en-US
Sender: linux-kernel-owner@vger.kernel.org
To: David Disseldorp <ddiss@suse.de>, Christoph Hellwig <hch@lst.de>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-scsi@vger.kernel.org, target-devel@vger.kernel.org, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hi,

Fedora got a bug report of a new permission denied error with 5.0-rc2:

>   File "/usr/lib/python3.7/site-packages/rtslib_fb/utils.py", line 100, in fread
>     with open(path, 'r') as file_fd:
> PermissionError: [Errno 13] Permission denied: '/sys/kernel/config/target/core/fileio_28/xxx/attrib/pi_prot_format'

This looks like an intentional behavior change with

commit 6baca7601bdee2e57f20c45d63eb53b89b33e816
Author: David Disseldorp <ddiss@suse.de>
Date:   Fri Nov 23 18:36:11 2018 +0100

     scsi: target: drop unused pi_prot_format attribute storage
     
     On write, the pi_prot_format configfs attribute invokes the device
     format_prot() callback if present. Read dumps the contents of
     se_dev_attrib.pi_prot_format which is always zero.  Make the configfs
     attribute write-only, and drop the always zero se_dev_attrib.pi_prot_format
     storage.
     
     Signed-off-by: David Disseldorp <ddiss@suse.de>
     Reviewed-by: Christoph Hellwig <hch@lst.de>
     Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>


Unfortunately, existing code that's opening with read permissions is now broken.
Can this be reverted? Full bug at https://bugzilla.redhat.com/show_bug.cgi?id=1667505

Thanks,
Laura
