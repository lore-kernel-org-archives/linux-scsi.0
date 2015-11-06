From: Matthew Vernon <mcv21@cam.ac.uk>
Subject: [BUG] Boot failures with mpt2sas / Intel RMS25JB080
	module
Date: Fri, 6 Nov 2015 18:08:46 +0000
Message-ID: <22076.60590.659266.885478@pick.csi.cam.ac.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <xen-devel-bounces@lists.xen.org>
List-Unsubscribe: <http://lists.xen.org/cgi-bin/mailman/options/xen-devel>,
	<mailto:xen-devel-request@lists.xen.org?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xen.org>
List-Help: <mailto:xen-devel-request@lists.xen.org?subject=help>
List-Subscribe: <http://lists.xen.org/cgi-bin/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xen.org?subject=subscribe>
Sender: xen-devel-bounces@lists.xen.org
Errors-To: xen-devel-bounces@lists.xen.org
To: MPT-FusionLinux.pdl@avagotech.com, linux-scsi@vger.kernel.org
Cc: ian.jackson@eu.citrix.com, xen-devel@lists.xen.org
List-Id: linux-scsi@vger.kernel.org

Hi,

[These lists are in the MAINTAINERS file for mpt2sas; I hope this is
the correct place to report this problem. Xen-devel CCd as this is
failing on trying to boot Xen]

When booting Xen, mpt2sas finds my Intel RMS25JB080, but fails to load
it correctly.

This is a Debian jessie (stable) system, kernel version
3.16.0-4-amd64, Xen version 4.4.1.

Relevant snippet of log output of failed boot:

[   64.095008] mpt2sas0: reply_post_free pool: pci_pool_alloc failed
[   64.535255] mpt2sas0: failure at /build/linux-xkTWug/linux-3.16.7-ckt11/drivers/scsi/mpt2sas/mpt2sas_scsih.c:8234/_scsih_probe()!

...it then fails to find any of my attached drives, so cannot boot,
and I get dumped in the initramfs.

Having googled a bit, I tried pci=realloc=off on the kernel
command-line, as well as swiotlb=26422 ; neither of them changed the
failure mode

Booting bare-metal does work; relevant snippet of log output of
successful (i.e. bare-metal) boot:

[    3.977037] mpt2sas0: diag reset: SUCCESS
[    4.178627] mpt2sas0: Allocated physical memory: size(17390 kB)
[    4.178630] mpt2sas0: Current Controller Queue Depth(7931), Max Controller Queue Depth(8192)
[    4.178631] mpt2sas0: Scatter Gather Elements per IO(128)
[    4.409752] mpt2sas0: LSISAS2308: FWVersion(20.00.02.00), ChipRevision(0x05), BiosVersion(07.39.00.00)
[    4.409755] mpt2sas0: Intel(R) Integrated RAID Module RMS25JB080
[    4.409756] mpt2sas0: Protocol=(Initiator), Capabilities=(Raid,TLR,EEDP,Snapshot Buffer,Diag Trace Buffer,Task Set Full,NCQ)
[    4.409846] mpt2sas0: sending port enable !!
...
[    5.941978] mpt2sas0: host_add: handle(0x0001), sas_addr(0x5001e67c17ff5000), phys(8)
[    5.980601] device-mapper: uevent: version 1.0.3
[    5.980773] device-mapper: ioctl: 4.27.0-ioctl (2013-10-30) initialised: dm-devel@redhat.com
[   11.823480] mpt2sas0: port enable: SUCCESS

(and then it finds the attached disks)

Fuller outputs:

i) bare-metal boot dmesg:
http://www-uxsup.csx.cam.ac.uk/~mcv21/debug/bare_metal_dmesg

ii) output from failed Xen boot (captured over a serial line with
earlyprintk=xen and loglvl=all guest_loglvl=all):
http://www-uxsup.csx.cam.ac.uk/~mcv21/debug/failedboot-output-2

iii) kernel config (stock Debian):
http://www-uxsup.csx.cam.ac.uk/~mcv21/debug/config-3.16.0-4-amd64

iv) lspci -vvv output:
http://www-uxsup.csx.cam.ac.uk/~mcv21/debug/lspcivvv

Regards,

Matthew
