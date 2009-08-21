From: Chris Webb <chris@arachsys.com>
Subject: Re: oops during scsi scanning disk setup
Date: Fri, 21 Aug 2009 09:16:21 +0100
Message-ID: <20090821081621.GB32115@arachsys.com>
References: <20090820180549.GD7542@arachsys.com> <1250807161.4302.167.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from alpha.arachsys.com ([91.203.57.7]:60869 "EHLO
	alpha.arachsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754636AbZHUIUd (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Aug 2009 04:20:33 -0400
Content-Disposition: inline
In-Reply-To: <1250807161.4302.167.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org

James Bottomley <James.Bottomley@suse.de> writes:

> On Thu, 2009-08-20 at 19:05 +0100, Chris Webb wrote:
> >   15:27:13.014 kernel: IP: [<ffffffff803f0d77>] disk_part_iter_next+0x74/0xfd
> 
> Have to confess, no idea how this happened.  Especially since the system
> must have gone through the disk iterator once before successfully.
> 
> Can you use addr2line or gdb to get where this occurred?

Hi James. I'm having a bit of trouble getting this to work, although I can
disassemble the function fine.

  # addr2line -e vmlinux 0xffffffff803f0d77
  ??:0

  # gdb vmlinux
  GNU gdb 6.8
  Copyright (C) 2008 Free Software Foundation, Inc.
  License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
  This is free software: you are free to change and redistribute it.
  There is NO WARRANTY, to the extent permitted by law.  Type "show copying"
  and "show warranty" for details.
  This GDB was configured as "x86_64-arachsys-linux-gnu"...
  (no debugging symbols found)
  (gdb) info line *0xffffffff803f0d77
  No line number information available for address 0xffffffff803f0d77 <disk_part_iter_next+116>

  (gdb) disas disk_part_iter_next
  Dump of assembler code for function disk_part_iter_next:
  0xffffffff803f0d03 <disk_part_iter_next+0>:     push   %rbp
  0xffffffff803f0d04 <disk_part_iter_next+1>:     mov    %rsp,%rbp
  0xffffffff803f0d07 <disk_part_iter_next+4>:     push   %r13
  0xffffffff803f0d09 <disk_part_iter_next+6>:     push   %r12
  0xffffffff803f0d0b <disk_part_iter_next+8>:     push   %rbx
  0xffffffff803f0d0c <disk_part_iter_next+9>:     mov    %rdi,%rbx
  0xffffffff803f0d0f <disk_part_iter_next+12>:    sub    $0x8,%rsp
  0xffffffff803f0d13 <disk_part_iter_next+16>:    mov    0x8(%rdi),%rdi
  0xffffffff803f0d17 <disk_part_iter_next+20>:    test   %rdi,%rdi
  0xffffffff803f0d1a <disk_part_iter_next+23>:    je     0xffffffff803f0d25 <disk_part_iter_next+34>
  0xffffffff803f0d1c <disk_part_iter_next+25>:    add    $0x10,%rdi
  0xffffffff803f0d20 <disk_part_iter_next+29>:    callq  0xffffffff8047088a <put_device>
  0xffffffff803f0d25 <disk_part_iter_next+34>:    movq   $0x0,0x8(%rbx)
  0xffffffff803f0d2d <disk_part_iter_next+42>:    mov    %gs:0xb4e8,%rax
  0xffffffff803f0d36 <disk_part_iter_next+51>:    incl   -0x1fbc(%rax)
  0xffffffff803f0d3c <disk_part_iter_next+57>:    mov    (%rbx),%rax
  0xffffffff803f0d3f <disk_part_iter_next+60>:    mov    0x14(%rbx),%ecx
  0xffffffff803f0d42 <disk_part_iter_next+63>:    mov    0x30(%rax),%rdx
  0xffffffff803f0d46 <disk_part_iter_next+67>:    test   $0x1,%cl
  0xffffffff803f0d49 <disk_part_iter_next+70>:    je     0xffffffff803f0d77 <disk_part_iter_next+116>
  0xffffffff803f0d4b <disk_part_iter_next+72>:    or     $0xffffffffffffffff,%eax
  0xffffffff803f0d4e <disk_part_iter_next+75>:    and    $0xc,%cl
  0xffffffff803f0d51 <disk_part_iter_next+78>:    mov    $0x0,%ecx
  0xffffffff803f0d56 <disk_part_iter_next+83>:    cmove  %ecx,%eax
  0xffffffff803f0d59 <disk_part_iter_next+86>:    or     $0xffffffffffffffff,%r13d
  0xffffffff803f0d5d <disk_part_iter_next+90>:    lea    0x20(%rdx),%rdi
  0xffffffff803f0d61 <disk_part_iter_next+94>:    mov    $0x8ffffffff,%rsi
  0xffffffff803f0d6b <disk_part_iter_next+104>:   mov    $0x800000000,%rcx
  0xffffffff803f0d75 <disk_part_iter_next+114>:   jmp    0xffffffff803f0dc7 <disk_part_iter_next+196>
  0xffffffff803f0d77 <disk_part_iter_next+116>:   mov    0x10(%rdx),%eax
  0xffffffff803f0d7a <disk_part_iter_next+119>:   mov    $0x1,%r13d
  0xffffffff803f0d80 <disk_part_iter_next+125>:   jmp    0xffffffff803f0d5d <disk_part_iter_next+90>
  0xffffffff803f0d82 <disk_part_iter_next+127>:   movslq %edx,%r8
  0xffffffff803f0d85 <disk_part_iter_next+130>:   lea    (%rdi,%r8,8),%r8
  0xffffffff803f0d89 <disk_part_iter_next+134>:   mov    (%r8),%r12
  0xffffffff803f0d8c <disk_part_iter_next+137>:   test   %r12,%r12
  0xffffffff803f0d8f <disk_part_iter_next+140>:   je     0xffffffff803f0dbf <disk_part_iter_next+188>
  [...]

I'm sure I've seen addr2line and gdb info line work fine like this in the
past, but there definitely doesn't seem to be debugging info present in my
vmlinux now. Am I doing something stupid, or is there something special I
need to do to get debugging symbols turned on? (And if I do this and
recompile in a copy of the tree, will I still get a valid mapping from the
address disk_part_iter_next+116 to a line number for you?)

Best wishes,

Chris.
