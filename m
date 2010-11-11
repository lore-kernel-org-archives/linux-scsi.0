From: Michal Ludvig <mludvig@logix.net.nz>
Subject: Re: scsi_wait_scan doesn't wait for sym53c8xx
Date: Fri, 12 Nov 2010 11:24:26 +1300
Message-ID: <4CDC6D1A.4080701@logix.net.nz>
References: <4CBC106F.1090103@logix.net.nz>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from maxipes.logix.cz ([93.89.80.122]:53652 "EHLO maxipes.logix.cz"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757051Ab0KKWX5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Nov 2010 17:23:57 -0500
In-Reply-To: <4CBC106F.1090103@logix.net.nz>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org, Matthew Wilcox <matthew@wil.cx>
Cc: Ivan Jager <aij+debian@mrph.org>

  Hi there,

I've got another independent report confirming the same problem as 
described below [oh, sorry for top-posting. I included the original 
email for reference].

This time it's from Ivan Jager (Cc'ed) using sym53c8xx on SPARC and he's 
experiencing the same problem as I did on PARISC. Here is his report: 
http://lists.debian.org/debian-sparc/2010/11/msg00002.html

It all boils down to scsi_wait_scan.ko not waiting for sym53c8xx.ko to 
do its work. Verified on 2.6.32, 2.6.35 and 2.6.36. It may or may not be 
relevant that both SPARC and PARISC are 64bit big-endian architectures.

This is a lspci -v output from my parisc system:
20:01.0 SCSI storage controller: LSI Logic / Symbios Logic 53c1010 
66MHz  Ultra3 SCSI Adapter (rev 01)
         Subsystem: LSI Logic / Symbios Logic 
LSI53C1000/1000R/1010R/1010-66 PCI to Ultra160 SCSI
             Controller
         Flags: bus master, 66MHz, medium devsel, latency 192, IRQ 69
         I/O ports at 12100 [size=256]
         Memory at ffffffff90015000 (64-bit, non-prefetchable) [size=1K]
         Memory at ffffffff90012000 (64-bit, non-prefetchable) [size=8K]
         Capabilities: [40] Power Management version 2
         Kernel driver in use: sym53c8xx

And this is Ivan's sparc system:
0002:00:02.0 SCSI storage controller: LSI Logic / Symbios Logic 53c1010 
66MHz Ultra3 SCSI Adapter (rev 01)
      Subsystem: LSI Logic / Symbios Logic 
LSI53C1000/1000R/1010R/1010-66 PCI to Ultra160 SCSI
            Controller
      Flags: bus master, 66MHz, medium devsel, latency 64, IRQ 27
      I/O ports at 0900 [size=256]
      Memory at 00100000 (64-bit, non-prefetchable) [size=8K]
      Memory at 00102000 (64-bit, non-prefetchable) [size=8K]
      [virtual] Memory at fffff83100000000 (32-bit, non-prefetchable) 
[size=1]
      [virtual] Expansion ROM at fffff83100000000 [disabled] [size=1]
      Capabilities: [40] Power Management version 2
      Kernel driver in use: sym53c8xx

Same controller, same driver, same problem - scsi_wait_scan doesn't wait.

Can somebody have a look at it please?

I've got a spare parisc box where I can test any patches if that helps.

Cheers,

Michal

On 10/18/2010 10:16 PM, Michal Ludvig wrote:
>  Hi there,
>
> I'm having a problem with 2.6.36-rc8+ on HP PARISC machine (HP 9000 
> RP3410) where I intend to wait for SCSI enumeration during boot before 
> LVM2 kicks in and attempts to activate the root volume. I modprobe 
> scsi_wait_scan in the initramdisk before lvm2 script is run. However 
> the modprobe doesn't wait. I'm on Debian testing, fwiw.
>
> [...]
> [    2.368000] Freeing unused kernel memory: 252k freed
> Loading, please wait...
> [    3.028000] udev: starting version 160
> [    4.104000] SCSI subsystem initialized
> [    4.592000] sym0: <1010-66> rev 0x1 at pci 0000:20:01.0 irq 69
> [    4.668000] sym0: No NVRAM, ID 7, Fast-80, LVD, parity checking
> [    4.700000] sym0: SCSI BUS has been reset.
> [    4.708000] scsi0 : sym-2.2.3
> [    4.868000] sym1: <1010-66> rev 0x1 at pci 0000:20:01.1 irq 70
> [    4.868000] sym1: No NVRAM, ID 7, Fast-80, LVD, parity checking
> [    4.904000] sym1: SCSI BUS has been reset.
> [    4.908000] scsi1 : sym-2.2.3
> [    5.068000] sym2: <1010-66> rev 0x1 at pci 0000:80:01.0 irq 72
> [    5.072000] sym2: No NVRAM, ID 7, Fast-80, LVD, parity checking
> [    5.108000] sym2: SCSI BUS has been reset.
> [    5.112000] scsi2 : sym-2.2.3
> [    5.276000] sym3: <1010-66> rev 0x1 at pci 0000:80:01.1 irq 73
> [    5.276000] sym3: No NVRAM, ID 7, Fast-80, LVD, parity checking
> [    5.312000] sym3: SCSI BUS has been reset.
> [    5.316000] scsi3 : sym-2.2.3
> Begin: Loading essential drivers ... done.
> Begin: Running /scripts/init-premount ... SCSI: Waiting to settle...
>
> ######### here comes modprobe scsi_wait_scan #########
>
> SCSI: done
> done.
> Begin: Mounting root file system ... Begin: Running /scripts/local-top 
> ... [    6.496000] device-mapper: uevent: version 1.0.3
> [    6.496000] device-mapper: ioctl: 4.18.0-ioctl (2010-06-29) 
> initialised: dm-devel@redhat.com
>   Volume group "lethal" not found
>   Skipping volume group lethal
> Unable to find LVM volume lethal/root
> done.
> Begin: Waiting for root file system ... [    7.728000] scsi 0:0:0:0: 
> Direct-Access     HP 36.4G ST336754LC       HPC2 PQ: 0 ANSI: 3
> [    7.728000] scsi target0:0:0: tagged command queuing enabled, 
> command queue depth 16.
> [    7.728000] scsi target0:0:0: Beginning Domain Validation
> [    7.740000] scsi target0:0:0: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 
> ns, offset 31)
> [    7.748000] scsi target0:0:0: Ending Domain Validation
> [    7.752000] scsi 0:0:1:0: Direct-Access     HP 36.4G 
> MAS3367NC        HPC3 PQ: 0 ANSI: 3
> [    7.752000] scsi target0:0:1: tagged command queuing enabled, 
> command queue depth 16.
> [    7.760000] scsi target0:0:1: Beginning Domain Validation
> [    7.764000] scsi target0:0:1: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 
> ns, offset 31)
> [    7.772000] scsi target0:0:1: Ending Domain Validation
> [   11.864000] sd 0:0:0:0: [sda] 71132960 512-byte logical blocks: 
> (36.4 GB/33.9 GiB)
> [   11.864000] sd 0:0:1:0: [sdb] 71132960 512-byte logical blocks: 
> (36.4 GB/33.9 GiB)
> [   11.868000] sd 0:0:0:0: [sda] Write Protect is off
> [   11.892000] sd 0:0:1:0: [sdb] Write Protect is off
> [   11.900000] sd 0:0:0:0: [sda] Write cache: enabled, read cache: 
> enabled, supports DPO and FUA
> [   11.900000] sd 0:0:1:0: [sdb] Write cache: enabled, read cache: 
> enabled, supports DPO and FUA
> [   11.924000]  sda: unknown partition table
> [   11.940000]  sdb: sdb1 sdb2 sdb3
> [   11.944000] sd 0:0:0:0: [sda] Attached SCSI disk
> [   11.964000] sd 0:0:1:0: [sdb] Attached SCSI disk
> done.
> Gave up waiting for root device.  Common problems:
>  - Boot args (cat /proc/cmdline)
>    - Check rootdelay= (did the system wait long enough?)
>    - Check root= (did the system wait for the right device?)
>  - Missing modules (cat /proc/modules; ls /dev)
> ALERT!  /dev/mapper/lethal-root does not exist.  Dropping to a shell!
>
> Apparently /dev/sda and /dev/sdb were discovered long after 
> scsi_wait_scan was loaded.
>
> Here are the relevant modules:
> [...]
> ext3                  203543  2
> jbd                    63990  1 ext3
> dm_mod                112954  9
> scsi_wait_scan           983  0
> zalon7xx               38131  0
> lasi700                 2427  0
> 53c700                 39777  1 lasi700
> hilkbd                  5901  0
> sd_mod                 49383  3
> crc_t10dif              1564  1 sd_mod
> sym53c8xx             104303  2
> scsi_transport_spi     34731  3 zalon7xx,53c700,sym53c8xx
> scsi_mod              193802  7 
> libata,zalon7xx,lasi700,53c700,sd_mod,sym53c8xx,scsi_transport_spi
>
> When I unset CONFIG_SCSI_SCAN_ASYNC it works just fine and all the 
> disks are found in time for LVM.
>
> Is that a bug in the SCSI driver? Or am I doing something wrong? It's 
> not a recent regression, at least 2.6.35 behaves the same on that 
> machine.
>
> Thanks!
>
> Michal
