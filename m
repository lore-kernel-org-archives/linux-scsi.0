From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: usercopy whitelist woe in scsi_sense_cache
Date: Wed, 4 Apr 2018 16:44:51 -0400
Message-ID: <bdba6af9-4d08-05c4-60d7-9559f2047b5f@interlog.com>
References: <10360653.ov98egbaqx@natalenko.name>
 <CAGXu5jLwyot++C2EXs+032Lz5WdG65GsEJ-Q55rfhSbkG1Nh+A@mail.gmail.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <CAGXu5jLwyot++C2EXs+032Lz5WdG65GsEJ-Q55rfhSbkG1Nh+A@mail.gmail.com>
Content-Language: en-CA
Sender: linux-kernel-owner@vger.kernel.org
To: Kees Cook <keescook@chromium.org>, Oleksandr Natalenko <oleksandr@natalenko.name>
Cc: David Windsor <dave@nullcore.net>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On 2018-04-04 04:21 PM, Kees Cook wrote:
> On Wed, Apr 4, 2018 at 12:07 PM, Oleksandr Natalenko
> <oleksandr@natalenko.name> wrote:
>> With v4.16 I get the following dump while using smartctl:
>> [...]
>> [  261.262135] Bad or missing usercopy whitelist? Kernel memory exposure
>> attempt detected from SLUB object 'scsi_sense_cache' (offset 94, size 22)!
>> [...]
>> [  261.345976] Call Trace:
>> [  261.350620]  __check_object_size+0x130/0x1a0
>> [  261.355775]  sg_io+0x269/0x3f0
>> [  261.360729]  ? path_lookupat+0xaa/0x1f0
>> [  261.364027]  ? current_time+0x18/0x70
>> [  261.366684]  scsi_cmd_ioctl+0x257/0x410
>> [  261.369871]  ? xfs_bmapi_read+0x1c3/0x340 [xfs]
>> [  261.372231]  sd_ioctl+0xbf/0x1a0 [sd_mod]
>> [  261.375456]  blkdev_ioctl+0x8ca/0x990
>> [  261.381156]  ? read_null+0x10/0x10
>> [  261.384984]  block_ioctl+0x39/0x40
>> [  261.388739]  do_vfs_ioctl+0xa4/0x630
>> [  261.392624]  ? vfs_write+0x164/0x1a0
>> [  261.396658]  SyS_ioctl+0x74/0x80
>> [  261.399563]  do_syscall_64+0x74/0x190
>> [  261.402685]  entry_SYSCALL_64_after_hwframe+0x3d/0xa2
> 
> This is:
> 
> sg_io+0x269/0x3f0:
> blk_complete_sghdr_rq at block/scsi_ioctl.c:280
>   (inlined by) sg_io at block/scsi_ioctl.c:376
> 
> which is:
> 
>          if (req->sense_len && hdr->sbp) {
>                  int len = min((unsigned int) hdr->mx_sb_len, req->sense_len);
> 
>                  if (!copy_to_user(hdr->sbp, req->sense, len))
>                          hdr->sb_len_wr = len;
>                  else
>                          ret = -EFAULT;
>          }
> 
>> [...]
>> I can easily reproduce it with a qemu VM and 2 virtual SCSI disks by calling
>> smartctl in a loop and doing some usual background I/O. The warning is
>> triggered within 3 minutes or so (not instantly).
>>
>> Initially, it was produced on my server after a kernel update (because disks
>> are monitored with smartctl via Zabbix).
>>
>> Looks like the thing was introduced with
>> 0afe76e88c57d91ef5697720aed380a339e3df70.
>>
>> Any idea how to deal with this please? If needed, I can provide any additional
>> info, and also I'm happy/ready to test any proposed patches.
> 
> Interesting, and a little confusing. So, what's strange here is that
> the scsi_sense_cache already has a full whitelist:
> 
>                         kmem_cache_create_usercopy("scsi_sense_cache",
>                                 SCSI_SENSE_BUFFERSIZE, 0, SLAB_HWCACHE_ALIGN,
>                                 0, SCSI_SENSE_BUFFERSIZE, NULL);
> 
> Arg 2 is the buffer size, arg 5 is the whitelist offset (0), and the
> whitelist size (same as arg2). In other words, the entire buffer
> should be whitelisted.
> 
> include/scsi/scsi_cmnd.h says:
> 
> #define SCSI_SENSE_BUFFERSIZE  96
> 
> That means scsi_sense_cache should be 96 bytes in size? But a 22 byte
> read starting at offset 94 happened? That seems like a 20 byte read
> beyond the end of the SLUB object? Though if it were reading past the
> actual end of the object, I'd expect the hardened usercopy BUG (rather
> than the WARN) to kick in. Ah, it looks like
> /sys/kernel/slab/scsi_sense_cache/slab_size shows this to be 128 bytes
> of actual allocation, so the 20 bytes doesn't strictly overlap another
> object (hence no BUG):
> 
> /sys/kernel/slab/scsi_sense_cache# grep . object_size usersize slab_size
> object_size:96
> usersize:96
> slab_size:128
> 
> Ah, right, due to SLAB_HWCACHE_ALIGN, the allocation is rounded up to
> the next cache line size, so there's 32 bytes of padding to reach 128.
> 
> James or Martin, is this over-read "expected" behavior? i.e. does the
> sense cache buffer usage ever pull the ugly trick of silently
> expanding its allocation into the space the slab allocator has given
> it? If not, this looks like a real bug.
> 
> What I don't see is how req->sense is _not_ at offset 0 in the
> scsi_sense_cache object...

Looking at the smartctl SCSI code it pulls 32 byte sense buffers.
Can't see 22 anywhere relevant in its code.

There are two types of sense: fixed and descriptor: with fixed you
seldom need more than 18 bytes (but it can only represent 32 bit
LBAs). The other type has a header and 0 or more variable length
descriptors. If decoding of descriptor sense went wrong you might
end up at offset 94. But not with smartctl ....

Doug Gilbert
