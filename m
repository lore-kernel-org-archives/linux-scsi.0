From: Aboo Valappil <aboo@aboo.org>
Subject: Re: About sg_tablesize in 2.6 kernel
Date: Mon, 02 Oct 2006 12:33:47 +1000
Message-ID: <45207A8B.1000101@aboo.org>
References: <451FA502.1070207@aboo.org> <1159728217.2891.401.camel@laptopd505.fenrus.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ppp245-155.static.internode.on.net ([59.167.245.155]:57505 "EHLO
	localhost.localdomain") by vger.kernel.org with ESMTP
	id S932601AbWJBCdy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 1 Oct 2006 22:33:54 -0400
In-Reply-To: <1159728217.2891.401.camel@laptopd505.fenrus.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arjan van de Ven <arjan@fenrus.demon.nl>
Cc: linux-scsi@vger.kernel.org

Thanks Arjan for clearing it about SG. I think i am fine with the 
page_address() for now.

I managed to finish my virtual scsi device driver. Everything seems to 
be working fine (Reading, writing , etc). But i can not mount a file 
system created on it. From my verification, the driver seems to be doing 
its job. I verified the read and write to the disk by partitioning the 
device, using dd, etc. Seems to work fine. But i can not mount the file 
system created on it.

(I am sorry if i am taking too much of your time and posting wrong 
questions in the mailing list. Please guide me on this, this is the only 
mailing list which responded to my question. I am not a professional 
kernel developer and this is not my full time job but rather just a hobby).

I attached the outputs below, can some one advice what could be wrong here?
I partitioned the drive as follows. Please not that it shows one head, 8 
sectors. I am not sure where it is getting this info. (I do not see any 
SCSI commands issued to the driver for MODE_SENSE for disk geometry page).

[root@localhost scsitap]# fdisk -l /dev/sdb

Disk /dev/sdb: 104 MB, 104858112 bytes
1 heads, 8 sectors/track, 25600 cylinders
Units = cylinders of 8 * 512 = 4096 bytes

   Device Boot      Start         End      Blocks   Id  System
/dev/sdb1               2       21975       87896   83  Linux


[root@localhost scsitap]# mkfs  /dev/sdb1
mke2fs 1.37 (21-Mar-2005)
Filesystem label=
OS type: Linux
Block size=1024 (log=0)
Fragment size=1024 (log=0)
22000 inodes, 87896 blocks
4394 blocks (5.00%) reserved for the super user
First data block=1
Maximum filesystem blocks=67371008
11 block groups
8192 blocks per group, 8192 fragments per group
2000 inodes per group
Superblock backups stored on blocks:
        8193, 24577, 40961, 57345, 73729

Writing inode tables: done
Writing superblocks and filesystem accounting information: done

This filesystem will be automatically checked every 39 mounts or
180 days, whichever comes first.  Use tune2fs -c or -i to override.

[root@localhost scsitap]# mount -o ro /dev/sdb1 /mnt
mount: wrong fs type, bad option, bad superblock on /dev/sdb1,
       missing codepage or other error
       In some cases useful info is found in syslog - try
       dmesg | tail  or so

EXT2-fs error (device sdb1): ext2_check_descriptors: Block bitmap for 
group 0 not in group (block 0)!
EXT2-fs: group descriptors corrupted!

Aboo



Arjan van de Ven wrote:
> [note: you forgot to put in a link to your sourcecode, which greatly
> reduces our ability to give you good answers; please fix this]
>   
>> 1. In 2.6 kernel, even if I set the sg_tablesize to SG_NONE, the 
>> mid-layer is still queuing commands with use_sg=1. There is no way to 
>> disable this SG at all?
>>     
>
> in 2.6 everything is now going via the ONE sg codepath yes. The dual
> code path stuff was just incredibly fragile and a bad idea.
>
>
>
>   
>> address=page_address(sg[i].page) + sg[i].offset;
>>
>> Is this the right way? I am assuming that sg[i].page will be mapped in 
>> to kernel address space as this address is created by SCSI mid-layer. Is 
>> that right? Or do I have to use kmap? I tried replacing page_address 
>> with kmap/kunmap. But as soon as call kunmap to unmap, the kernal 
>> panics! Any thoughts?
>>     
>
> kmap doesn't take struct page as argument.
>
>  but.... if you show us the real code we can give you better
> suggestions.
>
>   
>> 3. Do I have to disable bottom halves before calling scsi_done()? It 
>> seems that the kernel panics when I call scsi_done if I use spin_lock 
>> instead of spin_lock_bh(). This is one of my spin_locks created for 
>> protecting a data structure.
>>     
>
> you don't need any locks before calling the done method.
>
>   

