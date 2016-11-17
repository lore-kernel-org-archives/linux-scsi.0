From: Paul Menzel <pmenzel@molgen.mpg.de>
Subject: Re: Ordering problems with 3ware controller
Date: Thu, 17 Nov 2016 15:55:11 +0100
Message-ID: <5618e4d9-8add-37eb-a141-c31f98e298ef@molgen.mpg.de>
References: <a41b4bab-edb7-34ab-eb76-7ff4d6e3f677@molgen.mpg.de>
 <yq1bmxpr0wj.fsf@sermon.lab.mkp.net>
 <49d06c24-24a0-e0fa-0cae-af8ea79a38e0@molgen.mpg.de>
 <yq11syjo2py.fsf@sermon.lab.mkp.net>
 <feacce75-237e-c514-eb5a-9d4a83ee5ed7@molgen.mpg.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.molgen.mpg.de ([141.14.17.9]:59535 "EHLO mx1.molgen.mpg.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754823AbcKQRXF (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 17 Nov 2016 12:23:05 -0500
In-Reply-To: <feacce75-237e-c514-eb5a-9d4a83ee5ed7@molgen.mpg.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Donald Buczek <buczek@molgen.mpg.de>, dvteam@molgen.mpg.de, George Spelvin <linux@sciencehorizons.net>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

Dear Linux folks,


On 11/16/16 22:24, Donald Buczek wrote:
> On 10.11.2016 14:59, Martin K. Petersen wrote:
>>>>>>> "Paul" == Paul Menzel <pmenzel@molgen.mpg.de> writes:

>>>> Linux does not provide device discovery ordering guarantees. You need
>>>> to fix your scripts to use UUIDs, filesystem labels, or DM devices to
>>>> get stable naming.
>> Paul> Indeed. But it worked for several years, so that *something* must
>> Paul> have changed that the ordering of the result of `getdents64` is
>> Paul> different now.
>>
>> Could be changes in the PCI or platform code that causes things to be
>> enumerated differently. Whatever it is, it has nothing to do with the
>> 3ware drivers themselves since they have been dormant for a long time.
>>
>
> Right. We further tracked it down. In fact its not a matter of driver
> initialization order but of the way sysfs/kernfs hashes its object names
> and thereby defines the order of names returned by getdents64 calls. In
> fs/kernfs/dir.h the names are inserted into a red-black tree ordered by
> the hashes over their names (and possibly namespace pointer, which in
> our case is zero).
>
> I've walked the rbtrees of the kernfs_node structs from
> /sys/class/scsi_host showing their addresses, the hash values and the
> names in a 4.4.27 system:
>
> root:cu:/home/buczek/autofs/# ./peek-3w
>
> ffff88046d847640 : 11bf1ddd : host0
> ffff88046c56d3e8 : 11bf1e8d : host1
> ffff88046c571c58 : 11bf1f3d : host2
> ffff88046c572550 : 11bf1fed : host3
> ffff88046c577dc0 : 11bf209d : host4
> ffff88046a4bbaf0 : 11bf214d : host5
>
> As can be seen, in 4.4 the hash algorithm happened to produce increasing
> hash values for names like "host0","host1","host2",... In 4.8.6 the hash
> values seem to be more random:
>
> root:gynaekophobie:/home/buczek/autofs/# ./peek-3w
>
> ffff88041df9a7f8 : 074af64b : host0
> ffff88081db40528 : 1009cd9b : host9
> ffff88041d3fba50 : 1c512bfb : host7
> ffff88181d19c000 : 28988a5b : host5
> ffff88041df5a780 : 34dfe8bb : host3
> ffff88041d3f5e10 : 4127471b : host1
> ffff88041ccbd258 : 562d7ccb : host8
> ffff88201cd5f960 : 6274db2b : host6
> ffff88141e2d0ca8 : 6ebc398b : host4
> ffff88041df599d8 : 7b0397eb : host2
>
> The relevant commit is 703b5fa  which includes

The commit message summary is *fs/dcache.c: Save one 32-bit multiply in 
dcache lookup*.

>  static inline unsigned long end_name_hash(unsigned long hash)
>  {
> -       return (unsigned int)hash;
> +       return __hash_32((unsigned int)hash);
>  }
>
> __hash_32 is a multiplication by 0x61C88647 ( hash.h )
>
> And this exactly is the difference between the hash value of "host0" on
> the 4.4 and the 4.8 system:
>
>   DB<2> x sprintf '%x',0x11bf1ddd*0x61C88647
> 0  '6c750ef074af64b'
>
> The bug, of course, is in the userspace tool tw_cli which wrongly
> assumes that the names would be returned in the "right" order by getdents.

Nice analysis.

Unfortunately, I don’t find the discussion of the patch on the Linux 
kernel mailing list.

Searching for the summary only brings up *screen rotation flipped in 
4.8-rc* [1].

> As a dirty workaround, I've created a new wrapper, which uses ptrace to
> pause the program on return from SYS_getdents64 and sorts the values
> returned from the system call in the memory of the target process. >

> I append the source of the wrapper.


Kind regards,

Paul


[1] https://lkml.org/lkml/2016/8/30/739
     "screen rotation flipped in 4.8-rc"
