From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: export bsg.h header to user-mode
Date: Thu, 15 Jan 2009 14:06:55 +0200
Message-ID: <496F26DF.9050303@panasas.com>
References: <496E11D6.20705@panasas.com>	<20090115172127T.fujita.tomonori@lab.ntt.co.jp>	<496EFA69.3050007@panasas.com> <20090115202155G.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([66.104.249.162]:16721 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1756496AbZAOMHB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 15 Jan 2009 07:07:01 -0500
In-Reply-To: <20090115202155G.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: jens.axboe@oracle.com, akpm@linux-foundation.org, osd-dev@open-osd.org, linux-scsi@vger.kernel.org, dougg@torque.net, stable@kernel.org

FUJITA Tomonori wrote:
> On Thu, 15 Jan 2009 10:57:13 +0200
> Boaz Harrosh <bharrosh@panasas.com> wrote:
> 
>> I've tested and linux/bsg.h is perfect for user-mode consumption. It
>> has a few kernel declarations protected by ifdef __KERNEL__ and exactly
>> what you have above. I did not change anything
>>
>>> We don't install any files in include/scsi/* to userspace.
>>>
>>> fujita@viola:~/git/linux-2.6$ cat include/Kbuild
>>> # Top-level Makefile calls into asm-$(ARCH)
>>> # List only non-arch directories below
>>>
>>> header-y += asm-generic/
>>> header-y += linux/
>>> header-y += sound/
>>> header-y += mtd/
>>> header-y += rdma/
>>> header-y += video/
>>> header-y += drm/
>>>
>> But that's fine then since bsg.h is in <linux/bsg.h>
>> not <scsi/bsg.h> what is the problem?
> 
> Oops, somehow I placed bsg.h in include/scsi. Ignore the above my
> comments.
> 
> 
>> OK But you just explained how to do it patch below ...
>>
>>> I guess that SCSI header files for userspace
>>> (/usr/include/scsi/scsi.h, sg.h, etc) come from glibc (but I'm not
>>> sure). They are different from those in kernel.
>>>
>>>
>>>> Meanwhile I will manually copy it to /usr/include/linux/bsg.h and see
>>>> if I need to fix any thing so it can be compiled from user-mode.
>>>>
>>>> Also do you have a small libbsg or something to make it easier for
>>>> use by application? should we maintain such a package?
>>>>
>>>> Pete from the OSC osd project has his set of headers and library
>>>> which I used now. Should I clean it up and send it? Or should I just 
>>>> keep it as part of the osd project for now? what are the sas and fc
>>>> guys using?
>>> Doug copies bsg.h to his smp_utils. I do the same thing for my own bsg
>>> programs. We need glibc (or someone) to install bsg.h properly.
>> That is not acceptable for me since I will need to provide an open-osd-devel
>> package to distros and I might need bsg.h, which I cannot supply with my
>> package, what if someone else will need it too then we have a conflict.
>>
>> I'm sending a patch, please ACK?
>> Thanks
>> Boaz
> 
> As I wrote in the previous mail, exporting some of bsg stuff for
> userspace is necessary, I think. But I have no idea about the correct
> way to do it.
> 
> Seems the header files in /usr/include/linux/ are different from in
> kernel source code (pointless __KERNEL__ stuff are stripped):
> 
> fujita@viola:~$ diff git/linux-2.6/include/linux/xattr.h /usr/include/linux/xattr.h
> 16,19d15
> < #ifdef  __KERNEL__
> <
> < #include <linux/types.h>
> <
> 36,37d31
> < struct inode;
> < struct dentry;
> 49,53c43,45
> < ssize_t xattr_getsecurity(struct inode *, const char *, void *, size_t);
> < ssize_t vfs_getxattr(struct dentry *, const char *, void *, size_t);
> < ssize_t vfs_listxattr(struct dentry *d, char *list, size_t size);
> < int vfs_setxattr(struct dentry *, const char *, const void *, size_t, int);
> < int vfs_removexattr(struct dentry *, const char *);
> ---
>> ssize_t vfs_getxattr(struct dentry *, char *, void *, size_t);
>> int vfs_setxattr(struct dentry *, char *, void *, size_t, int);
>> int vfs_removexattr(struct dentry *, char *);
> 60,61d51
> < #endif  /*  __KERNEL__  */
> <
> 
> Your patch does the right thing?
> 

Yes I just checked, the Kernel build system strips out the #ifdef __KERNEL__ sections
for the exported headers. (Do "make headers_check" you can see at usr/include/linux/)

> 
>> ---
>> From: Boaz Harrosh <bharrosh@panasas.com>
>> Date: Thu, 15 Jan 2009 10:43:17 +0200
>> Subject: [PATCH] include/linux: Add bsg.h to the Kernel exported headers
>>
>> bsg.h in current form is perfectly suitable for user-mode
>> consumption. It is needed together with scsi/sg.h for applications
>> that want to interface with the bsg driver.
>>
>> Currently the few projects that use it would copy it over into
>> the projects. But that is not acceptable for projects that need
>> to provide a libxxx-devel package for distros.
>>
>> Signed-off-by: Boaz Harrosh <bharrosh@panasas.com>

TOMO Please ACK here so Jens can push it through his tree.
Also I think we want to:
CC: stable@kernel.org

for 2.6.27.x and 2.6.28.x Because these where shipped with bsg
and there is no reason why not have it, lets say in Fedora10
or ubuntu 8.10.

>> ---
>>  include/linux/Kbuild |    1 +
>>  1 files changed, 1 insertions(+), 0 deletions(-)
>>
>> diff --git a/include/linux/Kbuild b/include/linux/Kbuild
>> index 12e9a29..2124c06 100644
>> --- a/include/linux/Kbuild
>> +++ b/include/linux/Kbuild


Thanks
Boaz
