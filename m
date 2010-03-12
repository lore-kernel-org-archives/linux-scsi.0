From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 15503] insmod: error inserting '/lib/aic7xxx.ko': -1 Invalid
 modulkjournald starting
Date: Fri, 12 Mar 2010 06:09:46 GMT
Message-ID: <201003120609.o2C69kAP012924@demeter.kernel.org>
References: <bug-15503-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:58929 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752995Ab0CLGJr (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Mar 2010 01:09:47 -0500
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.3/8.14.3) with ESMTP id o2C69kYY012925
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Fri, 12 Mar 2010 06:09:46 GMT
In-Reply-To: <bug-15503-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=15503





--- Comment #3 from Will L Givens <wlgivens@gmail.com>  2010-03-12 06:09:37 ---
Welp, back again. Tried adding -Wl,--no-relax to the CFLAGS... received the
same error. Then turned around and downgraded build tools a bit, thinking they
might be too new. Rebuilt with gcc-4.3.4 and Binutils-2.17. Got to the very end
and received an error msg that LD didn't recognized the option '--build-id'.

Removed the 'offending' string from the linker options and tried once more, and
received a slightly different error msg:

  IHEX2FW firmware/keyspan/usa28xb.fw
  AS      firmware/keyspan/usa28xb.fw.gen.o
  IHEX2FW firmware/keyspan/usa28x.fw
  AS      firmware/keyspan/usa28x.fw.gen.o
  IHEX2FW firmware/keyspan/usa49w.fw
  AS      firmware/keyspan/usa49w.fw.gen.o
  IHEX2FW firmware/keyspan/usa49wlc.fw
  AS      firmware/keyspan/usa49wlc.fw.gen.o
  LD      firmware/built-in.o
  LD      vmlinux.o
  MODPOST vmlinux.o
WARNING: modpost: Found 1 section mismatch(es).
To see full details build your kernel with:
'make CONFIG_DEBUG_SECTION_MISMATCH=y'
  GEN     .version
  CHK     include/generated/compile.h
  UPD     include/generated/compile.h
  CC      init/version.o
  LD      init/built-in.o
  LD      vmlinux
fs/built-in.o: In function `ep_unregister_pollwait':
(.text+0x3c444): relocation truncated to fit: GPREL16 against `.sbss'
fs/built-in.o: In function `ep_ptable_queue_proc':
(.text+0x3d228): relocation truncated to fit: GPREL16 against `.sbss'
fs/built-in.o: In function `anon_inode_getfile':
(.text+0x3d4d0): relocation truncated to fit: GPREL16 against `.sbss'
fs/built-in.o: In function `anon_inode_getfile':
(.text+0x3d564): relocation truncated to fit: GPREL16 against `.sbss'
fs/built-in.o: In function `anon_inode_getfile':
(.text+0x3d588): relocation truncated to fit: GPREL16 against `.sbss'
fs/built-in.o: In function `anon_inode_getfile':
(.text+0x3d5a4): relocation truncated to fit: GPREL16 against `.sbss'
fs/built-in.o: In function `anon_inode_getfile':
(.text+0x3d608): relocation truncated to fit: GPREL16 against `.sbss'
fs/built-in.o: In function `ctx_rcu_free':
(.text+0x3f64c): relocation truncated to fit: GPREL16 against `.sbss'
fs/built-in.o: In function `ctx_rcu_free':
(.text+0x3f66c): relocation truncated to fit: GPREL16 against symbol `aio_nr'
defined in .sbss section in fs/built-in.o
fs/built-in.o: In function `ctx_rcu_free':
(.text+0x3f694): relocation truncated to fit: GPREL16 against symbol `aio_nr'
defined in .sbss section in fs/built-in.o
fs/built-in.o: In function `really_put_req':
(.text+0x3f718): additional relocation overflows omitted from the output
make: *** [vmlinux] Error 1
[root@jericho linux]#

-- 
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=email
------- You are receiving this mail because: -------
You are watching the assignee of the bug.
