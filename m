From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: Bugs on Linux 2.6.18-rc2 sg code?
Date: Sat, 19 Aug 2006 14:23:23 -0600
Message-ID: <20060819202323.GT4340@parisc-linux.org>
References: <8202f4270608101843r7df002d2l40e03eca3271b050@mail.gmail.com> <44E6388D.1000206@torque.net> <44E68F76.4010702@torque.net> <20060819172024.GS4340@parisc-linux.org> <44E74C21.8040108@torque.net> <20060819104109.588604bd.akpm@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:38050 "EHLO
	palinux.external.hp.com") by vger.kernel.org with ESMTP
	id S1422777AbWHSUXY (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 19 Aug 2006 16:23:24 -0400
Content-Disposition: inline
In-Reply-To: <20060819104109.588604bd.akpm@osdl.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@osdl.org>
Cc: dougg@torque.net, Fajun Chen <fajunchen@gmail.com>, linux-scsi@vger.kernel.org

On Sat, Aug 19, 2006 at 10:41:09AM -0700, Andrew Morton wrote:
> ow, GFP_ATOMIC is bad.  Can we avoid that?

I believe all the GFP_ATOMIC calls in sg.c can be downgraded to
GFP_KERNEL.

sg_add_sfp is only called from sg_open(), so the GFP_ATOMIC there can
be downgraded to GFP_KERNEL.

There's one in sg_common_write that can be downgraded.  It's called
from sg_write and sg_ioctl (via sg_new_write).  No locks are held at
those points.

st_map_user_pages uses GFP_ATOMIC.  It's only called from
sg_build_direct, which is only called from sg_start_req, which is only
called from sg_new_write, which is safe per above.

sg_page_malloc uses GFP_ATOMIC.  It's only called from sg_build_indirect.
sg_build_indirect is called from sg_start_req (previously shown safe),
and sg_build_reserve.  sg_build_reserve is safe as it's only called from
sg_ioctl and sg_add_sfp (previously shown safe).

sg_build_sgat is called from sg_build_direct and sg_build_indirect,
both of which have previously been shown safe.

Please check my reasoning, but I'm pretty confident that none of these
paths are called with any locks held.
