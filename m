From: Chris Webb <chris@arachsys.com>
Subject: Re: oops during scsi scanning disk setup
Date: Fri, 21 Aug 2009 10:23:26 +0100
Message-ID: <20090821092326.GF32115@arachsys.com>
References: <20090820180549.GD7542@arachsys.com> <1250807161.4302.167.camel@mulgrave.site> <20090821081621.GB32115@arachsys.com> <20090821083356.GC32115@arachsys.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from alpha.arachsys.com ([91.203.57.7]:54408 "EHLO
	alpha.arachsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755111AbZHUJ1i (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Aug 2009 05:27:38 -0400
Content-Disposition: inline
In-Reply-To: <20090821083356.GC32115@arachsys.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: linux-scsi@vger.kernel.org

Chris Webb <chris@arachsys.com> writes:

> Reading through the disassembled code and comparing by hand against
> disk_part_iter_next(), I think that might be line 144 of block/genhd.c,
> where the ptbl->len dereference happens.

Sorry to follow up a third time, but I can now confirm this. I slipped -g into
CFLAGS in the kernel Makefile and rebuilt genhd.o and then the entire vmlinux.

  # objdump -S genhd.o
  [...]
  0000000000000da3 <disk_part_iter_next>:
   *
   * CONTEXT:
   * Don't care.
   */
  struct hd_struct *disk_part_iter_next(struct disk_part_iter *piter)
  {
       da3:       55                      push   %rbp
       da4:       48 89 e5                mov    %rsp,%rbp
       da7:       41 55                   push   %r13
       da9:       41 54                   push   %r12
       dab:       53                      push   %rbx
       dac:       48 89 fb                mov    %rdi,%rbx
       daf:       48 83 ec 08             sub    $0x8,%rsp
          struct disk_part_tbl *ptbl;
          int inc, end;

          /* put the last partition */
          disk_put_part(piter->part);
       db3:       48 8b 7f 08             mov    0x8(%rdi),%rdi
  [...]
       e01:       48 be ff ff ff ff 08    mov    $0x8ffffffff,%rsi
       e08:       00 00 00 
       e0b:       48 b9 00 00 00 00 08    mov    $0x800000000,%rcx
       e12:       00 00 00 
       e15:       eb 50                   jmp    e67 <disk_part_iter_next+0xc4>
                          end = -1;
                  else
                          end = 0;
         } else {
                  inc = 1;
                  end = ptbl->len;
       e17:       8b 42 10                mov    0x10(%rdx),%eax
       e1a:       41 bd 01 00 00 00       mov    $0x1,%r13d
       e20:       eb db                   jmp    dfd <disk_part_iter_next+0x5a>
  [...]

  # addr2line -e vmlinux 0xffffffff803f0d77
  /tmp/linux-2.6.30.4-p.tmp/block/genhd.c:144

Cheers,

Chris,
