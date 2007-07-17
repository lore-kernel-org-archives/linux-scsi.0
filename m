From: Geoff Levand <geoffrey.levand@am.sony.com>
Subject: Re: PS3 Storage Driver O_DIRECT issue
Date: Tue, 17 Jul 2007 09:40:12 -0700
Message-ID: <469CF0EC.9070002@am.sony.com>
References: <20070704132212.726923000@pademelon.sonytel.be>	<20070713122752.GA854@aepfle.de> <Pine.LNX.4.62.0707131532350.18802@pademelon.sonytel.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from outbound-cpk.frontbridge.com ([207.46.163.16]:16029 "EHLO
	outbound5-cpk-R.bigfish.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760392AbXGQQkS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Jul 2007 12:40:18 -0400
In-Reply-To: <Pine.LNX.4.62.0707131532350.18802@pademelon.sonytel.be>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Olaf Hering <olaf@aepfle.de>, Jens Axboe <axboe@kernel.dk>, "James E.J. Bottomley" <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org, Alessandro Rubini <rubini@ipvvis.unipv.it>, linux-kernel@vger.kernel.org, linuxppc-dev@ozlabs.org, Paul Mackerras <paulus@samba.org>

Geert Uytterhoeven wrote:
> On Fri, 13 Jul 2007, Olaf Hering wrote:
>> This driver (or the generic PS3 code) has appearently problems with
>> O_DIRECT. 
>> glibc aborts parted because the malloc metadata get corrupted. While it
>> is reproducible, the place where it crashes changes with every version
>> of the debug attempt.
>> I dont have a handle right now, all I know is that the metadata after a
>> malloc area get overwritten with zeros.
>> 
>> 
>> Can you have a look at this? 
>> parted /dev/ps3da
>> print (a few times)
> 
> I can't seem to reproduce this with parted 1.7.1-5.1 (from Debian
> etch/lenny/sid) and kernel 2.6.22-g77320894.

Hi.

I found this happens on Fedora 7:

[root@ps3-nfs ~]# uname -a
Linux ps3-nfs 2.6.22-ps3-linux-dev-g4d898766-dirty #1 SMP Wed Jul 11 13:29:46 PDT 2007 ppc64 ppc64 ppc64 GNU/Linux
[root@ps3-nfs ~]# parted --version
parted (GNU parted) 1.8.6

Here is the error message from parted:

Command History:
print

Error: SEGV_MAPERR (Address not mapped to object)
Backtrace has 20 calls on stack:
  20: /usr/lib/libparted-1.8.so.6(ped_assert+0xb0) [0xfb7ea50]
  19: parted [0x1000c6dc]
  18: [0x100350]
  17: [(nil)]
  16: /lib/libc.so.6 [0xfdcfe64]
  15: /lib/libc.so.6 [0xfdd0b34]
  14: /lib/libc.so.6(__libc_memalign+0xec) [0xfdd1e1c]
  13: /lib/libc.so.6(posix_memalign+0xbc) [0xfdd207c]
  12: /usr/lib/libparted-1.8.so.6 [0xfb8f42c]
  11: /usr/lib/libparted-1.8.so.6(ped_device_read+0x164) [0xfb7f5f4]
  10: /usr/lib/libparted-1.8.so.6(ped_geometry_read+0x16c) [0xfb89a5c]
  9: /usr/lib/libparted-1.8.so.6 [0xfba739c]
  8: /usr/lib/libparted-1.8.so.6(ped_file_system_probe_specific+0x104) [0xfb80d04]
  7: /usr/lib/libparted-1.8.so.6(ped_file_system_probe+0xec) [0xfb8134c]
  6: /usr/lib/libparted-1.8.so.6 [0xfbbcc38]
  5: /usr/lib/libparted-1.8.so.6 [0xfbbcfb4]
  4: /usr/lib/libparted-1.8.so.6(ped_disk_new+0xc0) [0xfb88bf0]
  3: parted [0x10006e00]
  2: parted(command_run+0x1c) [0x10004d8c]
  1: parted(interactive_mode+0x134) [0x1000e4b4]
Aborted


