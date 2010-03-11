From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15503] insmod: error inserting '/lib/aic7xxx.ko': -1 Invalid
 modulkjournald starting
Date: Thu, 11 Mar 2010 17:22:29 GMT
Message-ID: <201003111722.o2BHMTni004734@demeter.kernel.org>
References: <bug-15503-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:43347 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933301Ab0CKRWa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 11 Mar 2010 12:22:30 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o2BHMUCV004737
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Thu, 11 Mar 2010 17:22:30 GMT
In-Reply-To: <bug-15503-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=15503





--- Comment #2 from Will L Givens <wlgivens@gmail.com>  2010-03-11 17:22:16 ---
Patched GCC to correct a scratch bug and rebuilt. Also upgraded binutils to
2-20.1... then I started receiving a GPREL 16 error. Went ahead and added
-Wl,--no-relax to my CFLAGS for the ENTIRE build, error still persists.

[root@jericho linux]# tail CONFIG_DEBUG_SECTION_MISMATCH.txt -n 75
  CC      lib/sha1.o
  CC      lib/show_mem.o
  CC      lib/string.o
  CC      lib/vsprintf.o
  AR      lib/lib.a
  CC [M]  lib/crc-ccitt.o
  CC [M]  lib/crc-itu-t.o
  CC [M]  lib/libcrc32c.o
  CC [M]  lib/ts_kmp.o
  CC [M]  lib/ts_bm.o
  CC [M]  lib/ts_fsm.o
  AS      arch/alpha/lib/callback_srm.o
  CC      arch/alpha/lib/checksum.o
  CC      arch/alpha/lib/csum_partial_copy.o
  AS      arch/alpha/lib/ev6-clear_page.o
  AS      arch/alpha/lib/ev6-clear_user.o
  AS      arch/alpha/lib/ev6-copy_page.o
  AS      arch/alpha/lib/ev6-copy_user.o
  AS      arch/alpha/lib/ev6-csum_ipv6_magic.o
  AS      arch/alpha/lib/ev6-memchr.o
  AS      arch/alpha/lib/ev6-memcpy.o
  AS      arch/alpha/lib/ev6-memset.o
  AS      arch/alpha/lib/ev6-strncpy_from_user.o
  AS      arch/alpha/lib/ev6-stxcpy.o
  AS      arch/alpha/lib/ev6-stxncpy.o
  AS      arch/alpha/lib/ev67-strcat.o
  AS      arch/alpha/lib/ev67-strchr.o
  AS      arch/alpha/lib/ev67-strlen.o
  AS      arch/alpha/lib/ev67-strlen_user.o
  AS      arch/alpha/lib/ev67-strncat.o
  AS      arch/alpha/lib/ev67-strrchr.o
  CC      arch/alpha/lib/fls.o
  CC      arch/alpha/lib/fpreg.o
  AS      arch/alpha/lib/memmove.o
  CC      arch/alpha/lib/srm_printk.o
  CC      arch/alpha/lib/srm_puts.o
  AS      arch/alpha/lib/strcpy.o
  AS      arch/alpha/lib/strncpy.o
  CC      arch/alpha/lib/udelay.o
  AR      arch/alpha/lib/lib.a
  LD      vmlinux.o
  MODPOST vmlinux.o
WARNING: vmlinux.o(__ksymtab+0x66e0): Section mismatch in reference from the
variable __ksymtab_pci_register_set_vga_state to the function
.init.text:pci_register_set_vga_state()
The symbol pci_register_set_vga_state is exported and annotated __init
Fix this by removing the __init annotation of pci_register_set_vga_state or
drop the export.

  GEN     .version
  CHK     include/generated/compile.h
  UPD     include/generated/compile.h
  CC      init/version.o
  LD      init/built-in.o
  LD      vmlinux
fs/built-in.o: In function `_d_rehash':
(.text+0x15378): relocation truncated to fit: GPREL16 against `.sbss'
fs/built-in.o: In function `d_move_locked':
(.text+0x16ee4): relocation truncated to fit: GPREL16 against `.sbss'
fs/built-in.o: In function `__d_lookup':
(.text+0x177ec): relocation truncated to fit: GPREL16 against `.sbss'
fs/built-in.o: In function `d_validate':
(.text+0x17bd8): relocation truncated to fit: GPREL16 against `.sbss'
fs/built-in.o: In function `hash':
(.text+0x182cc): relocation truncated to fit: GPREL16 against `.sbss'
fs/built-in.o: In function `hash':
(.text+0x182d0): relocation truncated to fit: GPREL16 against `.sbss'
fs/built-in.o: In function `inode_add_to_lists':
(.text+0x18348): relocation truncated to fit: GPREL16 against `.sbss'
fs/built-in.o: In function `__insert_inode_hash':
(.text+0x18408): relocation truncated to fit: GPREL16 against `.sbss'
fs/built-in.o: In function `insert_inode_locked4':
(.text+0x18c5c): relocation truncated to fit: GPREL16 against `.sbss'
fs/built-in.o: In function `insert_inode_locked':
(.text+0x18d80): relocation truncated to fit: GPREL16 against `.sbss'
fs/built-in.o: In function `ilookup':
(.text+0x19004): additional relocation overflows omitted from the output
make: *** [vmlinux] Error 1
[root@jericho linux]#

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
