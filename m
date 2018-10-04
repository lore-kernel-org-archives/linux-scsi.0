From: Nathan Chancellor <natechancellor@gmail.com>
Subject: -Wswitch Clang warnings in drivers/scsi
Date: Thu, 4 Oct 2018 11:30:47 -0700
Message-ID: <20181004183047.GA1885@flashbox>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
To: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hi SCSI folks,

In an effort to get the kernel building warning free with Clang, we've
come across an interesting occurrence in a few scsi drivers:

drivers/scsi/hpsa.c:6533:7: warning: overflow converting case value to switch condition type (2148024833 to 18446744071562609153) [-Wswitch]
        case CCISS_GETPCIINFO:
             ^
./include/uapi/linux/cciss_ioctl.h:65:26: note: expanded from macro 'CCISS_GETPCIINFO'
#define CCISS_GETPCIINFO _IOR(CCISS_IOC_MAGIC, 1, cciss_pci_info_struct)
                         ^
./include/uapi/asm-generic/ioctl.h:86:28: note: expanded from macro '_IOR'
#define _IOR(type,nr,size)      _IOC(_IOC_READ,(type),(nr),(_IOC_TYPECHECK(size)))
                                ^
./include/uapi/asm-generic/ioctl.h:70:2: note: expanded from macro '_IOC'
        (((dir)  << _IOC_DIRSHIFT) | \
        ^

I see this warning in drivers/scsi/hpsa.c and drivers/scsi/smartpqi/smartpqi_init.c
on an arm64 allyesconfig build and it has also been reported in a couple of files in
drivers/scsi/cxlflash.

As the warning states, there is an overflow because the switch statement's value is of
type int but the switch value is greater than INT_MAX. I did a brief sweep of the tree
and it seems that all uses of _IOC in switch statement values either are small enough
to fit into size int or the value is of size unsigned int.

I am unsure of the implications of using a smaller _IOC value or converting all ioctls
to expect a cmd of type unsigned int (especially since that has userspace implications)
but I didn't see any negative ioctl commands. Some clarity and insight would be
appreciated.

Thank you for your time,
Nathan
