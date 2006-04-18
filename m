From: Roland Dreier <rdreier@cisco.com>
Subject: Re: [PATCH] srp.h: avoid padding of structs
Date: Tue, 18 Apr 2006 09:33:04 -0700
Message-ID: <adairp6j133.fsf@cisco.com>
References: <20060416193443.GA1806@cheetah> <20060417091752.GA2947@cheetah>
	<adavet6j2cs.fsf_-_@cisco.com>
	<1145377662.8447.2.camel@confield.dd.xiranet.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from test-iport-3.cisco.com ([171.71.176.78]:52544 "EHLO
	test-iport-3.cisco.com") by vger.kernel.org with ESMTP
	id S1750951AbWDRQdG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Apr 2006 12:33:06 -0400
In-Reply-To: <1145377662.8447.2.camel@confield.dd.xiranet.com> (Arne Redlich's message of "Tue, 18 Apr 2006 18:27:42 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: arne.redlich@xiranet.com
Cc: James.Bottomley@HansenPartnership.com, linux-scsi@vger.kernel.org

    Arne> Sure - I wasn't aware that gcc will produce different code
    Arne> even if it doesn't have to insert padding bytes.

Yes, it gets paranoid about alignment.  For example, if you build the
following on ia64:

	struct foo { int a; };
	struct bar { int b; } __attribute__((packed));

	int c(struct foo *x) { return x->a; }
	int d(struct bar *x) { return x->b; }

Then c() compiles to:

      0:       13 40 00 40 10 10       [MBB]       ld4 r8=[r32]
      6:       00 00 00 00 10 80                   nop.b 0x0
      c:       08 00 84 00                         br.ret.sptk.many b0;;

and d() compiles to:

     10:       09 70 00 40 00 21       [MMI]       mov r14=r32
     16:       f0 10 80 00 42 00                   adds r15=2,r32
     1c:       34 00 01 84                         adds r32=3,r32;;
     20:       19 80 04 1c 00 14       [MMB]       ld1 r16=[r14],1
     26:       f0 00 3c 00 20 00                   ld1 r15=[r15]
     2c:       00 00 00 20                         nop.b 0x0;;
     30:       09 70 00 1c 00 10       [MMI]       ld1 r14=[r14]
     36:       80 00 80 00 20 e0                   ld1 r8=[r32]
     3c:       f1 78 bd 53                         shl r15=r15,16;;
     40:       01 00 00 00 01 00       [MII]       nop.m 0x0
     46:       e0 70 dc ee 29 00                   shl r14=r14,8
     4c:       81 38 9d 53                         shl r8=r8,24;;
     50:       0b 70 40 1c 0e 20       [MMI]       or r14=r16,r14;;
     56:       f0 70 3c 1c 40 00                   or r15=r14,r15
     5c:       00 00 04 00                         nop.i 0x0;;
     60:       11 00 00 00 01 00       [MIB]       nop.m 0x0
     66:       80 78 20 1c 40 80                   or r8=r15,r8
     6c:       08 00 84 00                         br.ret.sptk.many b0;;

We should use __attribute__((packed)) only when it's really needed.

 - R.
