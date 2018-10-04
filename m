From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: -Wswitch Clang warnings in drivers/scsi
Date: Thu, 04 Oct 2018 11:34:29 -0700
Message-ID: <1538678069.230807.6.camel@acm.org>
References: <20181004183047.GA1885@flashbox>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-7"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20181004183047.GA1885@flashbox>
Sender: linux-kernel-owner@vger.kernel.org
To: Nathan Chancellor <natechancellor@gmail.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 2018-10-04 at 11:30 -0700, Nathan Chancellor wrote:
+AD4 Hi SCSI folks,
+AD4 
+AD4 In an effort to get the kernel building warning free with Clang, we've
+AD4 come across an interesting occurrence in a few scsi drivers:
+AD4 
+AD4 drivers/scsi/hpsa.c:6533:7: warning: overflow converting case value to switch condition type (2148024833 to 18446744071562609153) +AFs--Wswitch+AF0
+AD4         case CCISS+AF8-GETPCIINFO:
+AD4              +AF4
+AD4 ./include/uapi/linux/cciss+AF8-ioctl.h:65:26: note: expanded from macro 'CCISS+AF8-GETPCIINFO'
+AD4 +ACM-define CCISS+AF8-GETPCIINFO +AF8-IOR(CCISS+AF8-IOC+AF8-MAGIC, 1, cciss+AF8-pci+AF8-info+AF8-struct)
+AD4                          +AF4
+AD4 ./include/uapi/asm-generic/ioctl.h:86:28: note: expanded from macro '+AF8-IOR'
+AD4 +ACM-define +AF8-IOR(type,nr,size)      +AF8-IOC(+AF8-IOC+AF8-READ,(type),(nr),(+AF8-IOC+AF8-TYPECHECK(size)))
+AD4                                 +AF4
+AD4 ./include/uapi/asm-generic/ioctl.h:70:2: note: expanded from macro '+AF8-IOC'
+AD4         (((dir)  +ADwAPA +AF8-IOC+AF8-DIRSHIFT) +AHw +AFw
+AD4         +AF4
+AD4 
+AD4 I see this warning in drivers/scsi/hpsa.c and drivers/scsi/smartpqi/smartpqi+AF8-init.c
+AD4 on an arm64 allyesconfig build and it has also been reported in a couple of files in
+AD4 drivers/scsi/cxlflash.
+AD4 
+AD4 As the warning states, there is an overflow because the switch statement's value is of
+AD4 type int but the switch value is greater than INT+AF8-MAX. I did a brief sweep of the tree
+AD4 and it seems that all uses of +AF8-IOC in switch statement values either are small enough
+AD4 to fit into size int or the value is of size unsigned int.
+AD4 
+AD4 I am unsure of the implications of using a smaller +AF8-IOC value or converting all ioctls
+AD4 to expect a cmd of type unsigned int (especially since that has userspace implications)
+AD4 but I didn't see any negative ioctl commands. Some clarity and insight would be
+AD4 appreciated.

Have you verified how gcc compiles these switch statements? Maybe gcc supports
switch / case statements on integral types that are larger than an int?

Bart.
