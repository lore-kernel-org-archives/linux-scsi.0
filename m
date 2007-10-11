From: Rob Landley <rob@landley.net>
Subject: Re: Scsi on sparc build break in 2.6.23.
Date: Thu, 11 Oct 2007 08:17:22 -0500
Message-ID: <200710110817.22344.rob@landley.net>
References: <200710110552.49129.rob@landley.net> <20071011110555.GV16424@stusta.de>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_iJiDHa8xrR1VwBb"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from static-71-162-243-5.phlapa.fios.verizon.net ([71.162.243.5]:39955
	"EHLO grelber.thyrsus.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751983AbXJKNR2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Oct 2007 09:17:28 -0400
In-Reply-To: <20071011110555.GV16424@stusta.de>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Adrian Bunk <bunk@kernel.org>
Cc: linux-scsi@vger.kernel.org, sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org

--Boundary-00=_iJiDHa8xrR1VwBb
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

On Thursday 11 October 2007 6:05:55 am Adrian Bunk wrote:
> On Thu, Oct 11, 2007 at 05:52:48AM -0500, Rob Landley wrote:
> > CONFIG_SCSI_SUNESP=y breaks the build in 2.6.23:
> >
> >   LD      vmlinux
> > `scsi_esp_unregister' referenced in section `__ksymtab' of
> > drivers/built-in.o: defined in discarded section `.exit.text' of
> > drivers/built-in.o
> > make: *** [vmlinux] Error 1
> >
> > Do you need my full .config to reproduce this?
>
> Please always attach the .config when reporting errors.
> The few bytes don't matter and it often saves some time.
>
> I have an idea regarding what might be going wrong in this case,
> but it would cost me additional time to look at it because you didn't
> send your .config.

*shrug*  That's why I asked.

The reason I hesitated is I use miniconfig files rather than big .config 
files, and some people get confused by that.  Drop the attached 
miniconfig-linux in the kernel source directory and go:
  make ARCH=sparc allnoconfig KCONFIG_ALLCONFIG=miniconfig-linux

That expands it to a big .config file, and from there "make ARCH=sparc 
CROSS_COMPILE=sparc-" to reproduce the problem.  Assuming you have a sparc 
cross-compiler lying around.

Disable CONFIG_SCSI_SUNESP and it builds to the end, (and the result boots but 
won't mount the root filesystem, which is sort of expected).

Rob
-- 
"One of my most productive days was throwing away 1000 lines of code."
  - Ken Thompson.

--Boundary-00=_iJiDHa8xrR1VwBb
Content-Type: text/plain;
  charset="utf-8";
  name="miniconfig-linux"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="miniconfig-linux"

CONFIG_EXPERIMENTAL=y
CONFIG_SWAP=y
CONFIG_SYSVIPC=y
CONFIG_IKCONFIG=y
CONFIG_IKCONFIG_PROC=y
CONFIG_EMBEDDED=y
CONFIG_UID16=y
CONFIG_SYSCTL_SYSCALL=y
CONFIG_PRINTK=y
CONFIG_BUG=y
CONFIG_ELF_CORE=y
CONFIG_BASE_FULL=y
CONFIG_FUTEX=y
CONFIG_EPOLL=y
CONFIG_SHMEM=y
CONFIG_SLAB=y
CONFIG_VM_EVENT_COUNTERS=y
CONFIG_MODULES=y
CONFIG_MODULE_UNLOAD=y
CONFIG_MODULE_FORCE_UNLOAD=y
CONFIG_KMOD=y
CONFIG_BLOCK=y
CONFIG_IOSCHED_AS=y
CONFIG_IOSCHED_DEADLINE=y
CONFIG_BINFMT_ELF=y
CONFIG_NET=y
CONFIG_PACKET=y
CONFIG_UNIX=y
CONFIG_INET=y
CONFIG_IP_MULTICAST=y
CONFIG_IP_ADVANCED_ROUTER=y
CONFIG_IP_PNP=y
CONFIG_INET_DIAG=y
CONFIG_NETFILTER=y
CONFIG_VLAN_8021Q=y
CONFIG_STANDALONE=y
CONFIG_PREVENT_FIRMWARE_BUILD=y
CONFIG_BLK_DEV=y
CONFIG_BLK_DEV_RAM=y
CONFIG_BLK_DEV_RAM_COUNT=4
CONFIG_BLK_DEV_INITRD=y
CONFIG_SCSI=y
CONFIG_SCSI_LOWLEVEL=y
CONFIG_SCSI_PROC_FS=y
CONFIG_BLK_DEV_SD=y
CONFIG_BLK_DEV_SR=y
CONFIG_SCSI_SUNESP=y
CONFIG_NETDEVICES=y
CONFIG_DUMMY=y
CONFIG_NET_ETHERNET=y
CONFIG_MII=y
CONFIG_SUNLANCE=y
CONFIG_INPUT=y
CONFIG_INPUT_KEYBOARD=y
CONFIG_KEYBOARD_ATKBD=y
CONFIG_INPUT_MOUSE=y
CONFIG_MOUSE_PS2=y
CONFIG_SERIAL_SUNZILOG=y
CONFIG_SERIAL_SUNZILOG_CONSOLE=y
CONFIG_UNIX98_PTYS=y
CONFIG_HWMON=y
CONFIG_FIRMWARE_EDID=y
CONFIG_UNIX98_PTY_COUNT=64
CONFIG_EXT2_FS=y
CONFIG_EXT2_FS_XATTR=y
CONFIG_EXT3_FS=y
CONFIG_EXT3_FS_XATTR=y
CONFIG_INOTIFY=y
CONFIG_INOTIFY_USER=y
CONFIG_DNOTIFY=y
CONFIG_ISO9660_FS=y
CONFIG_PROC_FS=y
CONFIG_PROC_KCORE=y
CONFIG_PROC_SYSCTL=y
CONFIG_SYSFS=y
CONFIG_TMPFS=y
CONFIG_NLS=y
CONFIG_NLS_DEFAULT="ascii"
CONFIG_NLS_CODEPAGE_437=y
CONFIG_NLS_CODEPAGE_850=y
CONFIG_NLS_ASCII=y
CONFIG_NLS_ISO8859_1=y
CONFIG_PRINTK_TIME=y
CONFIG_ENABLE_MUST_CHECK=y
CONFIG_MAGIC_SYSRQ=y
CONFIG_DEBUG_KERNEL=y
CONFIG_LOG_BUF_SHIFT=15
CONFIG_DETECT_SOFTLOCKUP=y
CONFIG_DEBUG_SLAB=y
CONFIG_DEBUG_SPINLOCK=y
CONFIG_DEBUG_SPINLOCK_SLEEP=y
CONFIG_DEBUG_KOBJECT=y
CONFIG_DEBUG_BUGVERBOSE=y
CONFIG_DEBUG_INFO=y
CONFIG_UNWIND_INFO=y
CONFIG_FORCED_INLINING=y
CONFIG_SECURITY=y
CONFIG_SECURITY_CAPABILITIES=y
CONFIG_SQUASHFS=y

--Boundary-00=_iJiDHa8xrR1VwBb--
