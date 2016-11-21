From: "Ewan D. Milne" <emilne@redhat.com>
Subject: Re: SG does not ignore dxferp (direct io + mmap)
Date: Mon, 21 Nov 2016 11:25:17 -0500
Message-ID: <1479745517.19792.40.camel@localhost.localdomain>
References: <CAPrnrPAanjswy-aeLF2s_JWCHCudXC6cwWmX8M7NuLMDSR95Mw@mail.gmail.com>
         <408136530.631221.1479686684102.JavaMail.zimbra@redhat.com>
         <CAPrnrPBOrkzz5f5rVE4jBkEEvEQRoeo73y50V6cVNgP3c5yzNg@mail.gmail.com>
         <1479738275.19792.24.camel@localhost.localdomain>
         <CAPrnrPCkXPDWDpbt3HxsTWEoKGt-Atnk2QtJKX4tmG_AeDx8Lw@mail.gmail.com>
         <20161121151552.odbd6rf6dxqvdi2f@linux-x5ow.site>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:4073 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755026AbcKUQZT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 21 Nov 2016 11:25:19 -0500
In-Reply-To: <20161121151552.odbd6rf6dxqvdi2f@linux-x5ow.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: Eyal Ben David <bdeyal@gmail.com>, Laurence Oberman <loberman@redhat.com>, dgilbert@interlog.com, linux-scsi@vger.kernel.org

On Mon, 2016-11-21 at 16:15 +0100, Johannes Thumshirn wrote:
> 
> FWIW:
> jthumshirn@linux-x5ow:~$ sudo ./sg_mmap_read -d /dev/sg0 -l 0 | hexdump 
> 0000000 c033 d08e 00bc 8e7c 8ec0 bed8 7c00 00bf
> 0000010 b906 0200 f3fc 50a4 1c68 cb06 b9fb 0004
> 0000020 bebd 8007 007e 7c00 0f0b 0e85 8301 10c5
> 0000030 f1e2 18cd 5688 5500 46c6 0511 46c6 0010
> 0000040
> jthumshirn@linux-x5ow:~$ sudo ./sg_mmap_read -d /dev/sg0 -l 0 -m | hexdump 
> 0000000 c033 d08e 00bc 8e7c 8ec0 bed8 7c00 00bf
> 0000010 b906 0200 f3fc 50a4 1c68 cb06 b9fb 0004
> 0000020 bebd 8007 007e 7c00 0f0b 0e85 8301 10c5
> 0000030 f1e2 18cd 5688 5500 46c6 0511 46c6 0010
> 0000040
> jthumshirn@linux-x5ow:~$ sudo ./sg_mmap_read -d /dev/sg0 -l 0 -m -b | hexdump 
> 0000000 c033 d08e 00bc 8e7c 8ec0 bed8 7c00 00bf
> 0000010 b906 0200 f3fc 50a4 1c68 cb06 b9fb 0004
> 0000020 bebd 8007 007e 7c00 0f0b 0e85 8301 10c5
> 0000030 f1e2 18cd 5688 5500 46c6 0511 46c6 0010
> 0000040
> jthumshirn@linux-x5ow:~$ uname -r
> 4.8.4-1-default
> 
> root@glass:~ # ~jthumshirn/sg_mmap_read -d /dev/sg0 -l 0 | hexdump
> 0000000 caec 1dfe 3fdc 5b26 5775 eff6 a760 d612
> 0000010 c43c 8551 cfb8 4630 5e61 0750 44f3 c99e
> 0000020 5718 84fd 073f e2f5 0f30 f1fa 1e1a 51e6
> 0000030 3379 217a 7d0f 8040 11cd 261f 3f8b 6de2
> 0000040
> root@glass:~ # ~jthumshirn/sg_mmap_read -d /dev/sg0 -l 0 -m | hexdump
> 0000000 cd00 5f33 8809 ffff 0002 0000 0000 0000
> 0000010 0007 0000 0000 0000 f000 ffff 7fff 0000
> 0000020 0000 0000 0000 0000 6e9d 57ac 0000 0000
> 0000030 0000 0000 0000 0000 0000 0000 0000 0000
> 0000040
> root@glass:~ # ~jthumshirn/sg_mmap_read -d /dev/sg0 -l 0 -m -b | hexdump
> 0000000 4c00 bd7e 8805 ffff 0002 0000 0000 0000
> 0000010 002f 0000 0000 0000 f000 ffff 7fff 0000
> 0000020 0000 0000 0000 0000 6e9d 57ac 0000 0000
> 0000030 0000 0000 0000 0000 0000 0000 0000 0000
> 0000040
> root@glass:~ # uname -r
> 4.4.21-69-default
> root@glass:~ # 
> 
> 
> Buuuut:
> root@glass:~ # ~jthumshirn/sg_mmap_read -d /dev/sg0 -l 0 -| hexdump
> 0000000 46c0 b3b0 8804 ffff 0002 0000 0000 0000
> 0000010 0021 0000 0000 0000 f000 ffff 7fff 0000
> 0000020 0000 0000 0000 0000 6e9d 57ac 0000 0000
> 0000030 626c 3170 6f5f 2070 2020 2020 3d20 3020
> 0000040
> root@glass:~ # ~jthumshirn/sg_mmap_read -d /dev/sg0 -l 0 -| hexdump
> 0000000 0000 0000 0000 0000 0000 0000 0000 0000
> *
> 0000040
> root@glass:~ # ~jthumshirn/sg_mmap_read -d /dev/sg0 -l 0 -| hexdump
> 0000000 0000 0000 0000 0000 0000 0000 0000 0000
> *
> 0000040
> root@glass:~ # ~jthumshirn/sg_mmap_read -d /dev/sg0 -l 0 -| hexdump
> 0000000 73db ffe0 7a7d 1bf6 85cf 39ab a094 7802
> 0000010 959c 5b58 dc6f 1a36 5e7d 0afe d5be 3d41
> 0000020 691e 36ee 458c 14d2 06ed 371b 24dd 1f45
> 0000030 428a 24a0 866a 4a19 4954 e46a afe9 f3df
> 0000040
> glass:~ # 
> 
> Maybe we have a race here.
> 
> for i in $(seq 1 100); do 
> 	sudo ./sg_mmap_read -d /dev/sg0 -l 0 -m -b | hexdump
> done
> on 4.8 works fine.
> 
> On the 4.4 host it has some hickups.
> 
> I'll have a look at it.
> 
> Byte,
> 	Johannes
> 

Sure enough.

>From a freshly checked-out and built 4.4, i.e.:

commit afd2ff9b7e1b367172f18ba7f693dfb62bdcb2dc
Author: Linus Torvalds <torvalds@linux-foundation.org>
Date:   Sun Jan 10 15:01:32 2016 -0800

    Linux 4.4

---

# ./sg_mmap_read -d /dev/sg0 -l 0 | od -x
0000000 63eb 1090 d08e 00bc b8b0 0000 d88e c08e
0000020 befb 7c00 00bf b906 0200 a4f3 21ea 0006
0000040 be00 07be 0438 0b75 c683 8110 fefe 7507
0000060 ebf3 b416 b002 bb01 7c00 80b2 748a 8b01
0000100
# ./sg_mmap_read -d /dev/sg0 -l 0 -m | od -x
0000000 63eb 1090 d08e 00bc b8b0 0000 d88e c08e
0000020 befb 7c00 00bf b906 0200 a4f3 21ea 0006
0000040 be00 07be 0438 0b75 c683 8110 fefe 7507
0000060 ebf3 b416 b002 bb01 7c00 80b2 748a 8b01
0000100
# ./sg_mmap_read -d /dev/sg0 -l 0 -m -b | od -x
0000000 6300 1090 d08e 00bc b8b0 0000 d88e c08e    <===== WRONG
0000020 befb 7c00 00bf b906 0200 a4f3 21ea 0006
0000040 be00 07be 0438 0b75 c683 8110 fefe 7507
0000060 ebf3 b416 b002 bb01 7c00 80b2 748a 8b01
0000100

-Ewan



