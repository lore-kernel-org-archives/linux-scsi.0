From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: SG does not ignore dxferp (direct io + mmap)
Date: Mon, 21 Nov 2016 16:15:52 +0100
Message-ID: <20161121151552.odbd6rf6dxqvdi2f@linux-x5ow.site>
References: <CAPrnrPAanjswy-aeLF2s_JWCHCudXC6cwWmX8M7NuLMDSR95Mw@mail.gmail.com>
 <408136530.631221.1479686684102.JavaMail.zimbra@redhat.com>
 <CAPrnrPBOrkzz5f5rVE4jBkEEvEQRoeo73y50V6cVNgP3c5yzNg@mail.gmail.com>
 <1479738275.19792.24.camel@localhost.localdomain>
 <CAPrnrPCkXPDWDpbt3HxsTWEoKGt-Atnk2QtJKX4tmG_AeDx8Lw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:51920 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754577AbcKUPPz (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 21 Nov 2016 10:15:55 -0500
Content-Disposition: inline
In-Reply-To: <CAPrnrPCkXPDWDpbt3HxsTWEoKGt-Atnk2QtJKX4tmG_AeDx8Lw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eyal Ben David <bdeyal@gmail.com>
Cc: emilne@redhat.com, Laurence Oberman <loberman@redhat.com>, dgilbert@interlog.com, linux-scsi@vger.kernel.org

On Mon, Nov 21, 2016 at 04:55:29PM +0200, Eyal Ben David wrote:
> Thanks for your reply,
> 
> On RHEL system it does not occur.
> 
> So far I have seen the problem on Ubuntu 16.04 and Fedora 22 (both
> with kernel 4.4.x)

FWIW:
jthumshirn@linux-x5ow:~$ sudo ./sg_mmap_read -d /dev/sg0 -l 0 | hexdump 
0000000 c033 d08e 00bc 8e7c 8ec0 bed8 7c00 00bf
0000010 b906 0200 f3fc 50a4 1c68 cb06 b9fb 0004
0000020 bebd 8007 007e 7c00 0f0b 0e85 8301 10c5
0000030 f1e2 18cd 5688 5500 46c6 0511 46c6 0010
0000040
jthumshirn@linux-x5ow:~$ sudo ./sg_mmap_read -d /dev/sg0 -l 0 -m | hexdump 
0000000 c033 d08e 00bc 8e7c 8ec0 bed8 7c00 00bf
0000010 b906 0200 f3fc 50a4 1c68 cb06 b9fb 0004
0000020 bebd 8007 007e 7c00 0f0b 0e85 8301 10c5
0000030 f1e2 18cd 5688 5500 46c6 0511 46c6 0010
0000040
jthumshirn@linux-x5ow:~$ sudo ./sg_mmap_read -d /dev/sg0 -l 0 -m -b | hexdump 
0000000 c033 d08e 00bc 8e7c 8ec0 bed8 7c00 00bf
0000010 b906 0200 f3fc 50a4 1c68 cb06 b9fb 0004
0000020 bebd 8007 007e 7c00 0f0b 0e85 8301 10c5
0000030 f1e2 18cd 5688 5500 46c6 0511 46c6 0010
0000040
jthumshirn@linux-x5ow:~$ uname -r
4.8.4-1-default

root@glass:~ # ~jthumshirn/sg_mmap_read -d /dev/sg0 -l 0 | hexdump
0000000 caec 1dfe 3fdc 5b26 5775 eff6 a760 d612
0000010 c43c 8551 cfb8 4630 5e61 0750 44f3 c99e
0000020 5718 84fd 073f e2f5 0f30 f1fa 1e1a 51e6
0000030 3379 217a 7d0f 8040 11cd 261f 3f8b 6de2
0000040
root@glass:~ # ~jthumshirn/sg_mmap_read -d /dev/sg0 -l 0 -m | hexdump
0000000 cd00 5f33 8809 ffff 0002 0000 0000 0000
0000010 0007 0000 0000 0000 f000 ffff 7fff 0000
0000020 0000 0000 0000 0000 6e9d 57ac 0000 0000
0000030 0000 0000 0000 0000 0000 0000 0000 0000
0000040
root@glass:~ # ~jthumshirn/sg_mmap_read -d /dev/sg0 -l 0 -m -b | hexdump
0000000 4c00 bd7e 8805 ffff 0002 0000 0000 0000
0000010 002f 0000 0000 0000 f000 ffff 7fff 0000
0000020 0000 0000 0000 0000 6e9d 57ac 0000 0000
0000030 0000 0000 0000 0000 0000 0000 0000 0000
0000040
root@glass:~ # uname -r
4.4.21-69-default
root@glass:~ # 


Buuuut:
root@glass:~ # ~jthumshirn/sg_mmap_read -d /dev/sg0 -l 0 -| hexdump
0000000 46c0 b3b0 8804 ffff 0002 0000 0000 0000
0000010 0021 0000 0000 0000 f000 ffff 7fff 0000
0000020 0000 0000 0000 0000 6e9d 57ac 0000 0000
0000030 626c 3170 6f5f 2070 2020 2020 3d20 3020
0000040
root@glass:~ # ~jthumshirn/sg_mmap_read -d /dev/sg0 -l 0 -| hexdump
0000000 0000 0000 0000 0000 0000 0000 0000 0000
*
0000040
root@glass:~ # ~jthumshirn/sg_mmap_read -d /dev/sg0 -l 0 -| hexdump
0000000 0000 0000 0000 0000 0000 0000 0000 0000
*
0000040
root@glass:~ # ~jthumshirn/sg_mmap_read -d /dev/sg0 -l 0 -| hexdump
0000000 73db ffe0 7a7d 1bf6 85cf 39ab a094 7802
0000010 959c 5b58 dc6f 1a36 5e7d 0afe d5be 3d41
0000020 691e 36ee 458c 14d2 06ed 371b 24dd 1f45
0000030 428a 24a0 866a 4a19 4954 e46a afe9 f3df
0000040
glass:~ # 

Maybe we have a race here.

for i in $(seq 1 100); do 
	sudo ./sg_mmap_read -d /dev/sg0 -l 0 -m -b | hexdump
done
on 4.8 works fine.

On the 4.4 host it has some hickups.

I'll have a look at it.

Byte,
	Johannes

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
