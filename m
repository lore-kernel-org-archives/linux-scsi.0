From: Jeff Epler <jepler@unpythonic.net>
Subject: kcalloc/kmalloc_array could BUILD_BUG_ON for too-big constant
 arguments (was Re: [PATCH] [RESEND] aic7xxx: replace kmalloc/memset by
 kzalloc)
Date: Fri, 27 Mar 2015 14:48:24 -0500
Message-ID: <20150327194824.GC88629@unpythonic.net>
References: <94D0CD8314A33A4D9D801C0FE68B40295930E577@G4W3296.americas.hpqcorp.net>
 <1427041891-2694-1-git-send-email-michael.opdenacker@free-electrons.com>
 <550FB9BE.5010801@suse.de>
 <5511CD10.6040709@free-electrons.com>
 <1427230622.12126.13.camel@perches.com>
 <94D0CD8314A33A4D9D801C0FE68B40295A8416C5@G9W0745.americas.hpqcorp.net>
 <5514A679.5030005@free-electrons.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5514A679.5030005@free-electrons.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Michael Opdenacker <michael.opdenacker@free-electrons.com>
Cc: "Elliott, Robert (Server Storage)" <Elliott@hp.com>, Joe Perches <joe@perches.com>, Hannes Reinecke <hare@suse.de>, "JBottomley@parallels.com" <JBottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

The following is a sketch of how a macro kcalloc could BUILD_BUG_ON for
overflows of two compile-time operands, or call "kcalloc_variable" for
nonconstant arguments.  Tested on gcc 4.7.2 only, since it's what I had to
hand.  I didn't do any testing beyond checking that fn2 didn't build, and that
fn1/3 had plausible-looking code on x86_64.

typedef unsigned long size_t;
#define SIZE_MAX (~(size_t)0)
typedef int gfp_t;
extern void *kzalloc(size_t n, gfp_t flags);
extern void *kcalloc_variable(size_t n, size_t size, gfp_t flags);
#define BUILD_BUG_ON(condition) ((void)sizeof(char[1 - 2*!!(condition)]))

#define kcalloc(n, size, flags) \
	__builtin_choose_expr(__builtin_constant_p((n) | (size)), \
		( \
			BUILD_BUG_ON((n) > SIZE_MAX / (size)), \
			kzalloc((n) * (size), (flags)) \
		), kcalloc_variable((n), (size), (flags)))


void fn1() { kcalloc(3, 3, 0); }
//void fn2() { kcalloc(2, ~(size_t)0, 0); }// compile-time BUILD_BUG_ON
void fn3(int i) { kcalloc(2, i, 0); }

Jeff
