From: Andrew Morton <akpm@osdl.org>
Subject: Re: [Bugme-new] [Bug 5244] New: HW RAID1 detected as zero size
 drive
Date: Tue, 13 Sep 2005 16:55:05 -0700
Message-ID: <20050913165505.68855efb.akpm@osdl.org>
References: <200509131942.j8DJg3RH013980@fire-1.osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.osdl.org ([65.172.181.4]:55485 "EHLO smtp.osdl.org")
	by vger.kernel.org with ESMTP id S1751172AbVIMXz4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 13 Sep 2005 19:55:56 -0400
In-Reply-To: <200509131942.j8DJg3RH013980@fire-1.osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Atul Mukker <Atul.Mukker@lsil.com>, Sreenivas Bagalkote <Sreenivas.Bagalkote@lsil.com>, Manoj Jose <Manoj.Jose@lsil.com>
Cc: "bugme-daemon@kernel-bugs.osdl.org" <bugme-daemon@kernel-bugs.osdl.org>


Could whoever maintains the megaraid driver(s) please submit a MANTAINERS
patch?

It broke in 2.6.14-rc1.


bugme-daemon@kernel-bugs.osdl.org wrote:
>
> http://bugzilla.kernel.org/show_bug.cgi?id=5244
> 
>            Summary: HW RAID1 detected as zero size drive
>     Kernel Version: 2.6.14-rc1
>             Status: NEW
>           Severity: blocking
>              Owner: andmike@us.ibm.com
>          Submitter: bwindle-kbt@fint.org
> 
> 
> Most recent kernel where this bug did not occur: 2.6.13
> Distribution: Debian Testing
> Hardware Environment: Dell PowerEDGE 1300, MegaRAID with two SCSI drives in
> RAID1, two CPUs
> Software Environment:
> Linux RTIX-NM-003 2.6.13 #8 SMP Wed Aug 31 16:38:12 EDT 2005 i686 GNU/Linux
> 
> Gnu C                  2.95.4
> Gnu make               3.80
> binutils               2.16.1
> util-linux             2.12p
> mount                  2.12p
> module-init-tools      3.2-pre1
> e2fsprogs              1.37
> reiserfsprogs          line
> reiser4progs           line
> Linux C Library        2.3.5
> Dynamic linker (ldd)   2.3.5
> Procps                 3.2.5
> Net-tools              1.60
> Console-tools          0.2.3
> Sh-utils               5.2.1
> 
> Problem Description:
> 
> When booting with 2.6.14-rc1, my RAID1 array is seen as a 0 megabyte drive. This
> causes the kernel to not be able to mount the filesystem, and thus, a panic.
> 
> 2.6.13:
> megaraid: found 0x8086:0x1960:bus 0:slot 13:func 1
> scsi0:Found MegaRAID controller at 0xf8802000, IRQ:185
> megaraid: [1.06:1p00] detected 1 logical drives.
> megaraid: channel[0] is raid.
> megaraid: channel[1] is raid.
> scsi0 : LSI Logic MegaRAID 1.06 254 commands 16 targs 5 chans 7 luns
> scsi0: scanning scsi channel 0 for logical drives.
>   Vendor: MegaRAID  Model: LD0 RAID1  8568R  Rev: 1.06
>   Type:   Direct-Access                      ANSI SCSI revision: 02
> scsi0: scanning scsi channel 4 [P0] for physical devices.
> scsi0: scanning scsi channel 5 [P1] for physical devices.
> st: Version 20050501, fixed bufsize 32768, s/g segs 256
> SCSI device sda: 17547264 512-byte hdwr sectors (8984 MB)
>                  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> sda: asking for cache data failed
> sda: assuming drive cache: write through
> SCSI device sda: 17547264 512-byte hdwr sectors (8984 MB)
> sda: asking for cache data failed
> sda: assuming drive cache: write through
>  sda: sda1
> Attached scsi disk sda at scsi0, channel 0, id 0, lun 0
> 
> 2.6.14-rc1:
> megaraid: found 0x8086:0x1960:bus 0:slot 13:func 1
> scsi0:Found MegaRAID controller at 0xf8802000, IRQ:185
> megaraid: [1.06:1p00] detected 1 logical drives.
> megaraid: channel[0] is raid.
> megaraid: channel[1] is raid.
> scsi0 : LSI Logic MegaRAID 1.06 254 commands 16 targs 5 chans 7 luns
> scsi0: scanning scsi channel 0 for logical drives.
>   Vendor: MegaRAID  Model: LD0 RAID1  8568R  Rev: 1.06
>   Type:   Direct-Access                      ANSI SCSI revision: 02
> scsi0: scanning scsi channel 4 [P0] for physical devices.
> scsi0: scanning scsi channel 5 [P1] for physical devices.
> st: Version 20050830, fixed bufsize 32768, s/g segs 256
> sda : sector size 0 reported, assuming 512.
> SCSI device sda: 1 512-byte hdwr sectors (0 MB)
>                  ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
> sda: asking for cache data failed
> sda: assuming drive cache: write through
> sda : sector size 0 reported, assuming 512.
> SCSI device sda: 1 512-byte hdwr sectors (0 MB)
> sda: asking for cache data failed
> sda: assuming drive cache: write through
>  sda: sda1
> Attached scsi disk sda at scsi0, channel 0, id 0, lun 0
> 
> ------- You are receiving this mail because: -------
> You are on the CC list for the bug, or are watching someone who is.
