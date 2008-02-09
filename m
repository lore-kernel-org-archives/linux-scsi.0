From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: Integration of SCST in the mainstream Linux kernel
Date: Fri, 08 Feb 2008 16:00:27 -0800
Message-ID: <1202515227.1805.167.camel@haakon2.linux-iscsi.org>
References: <393719.81864.qm@web31808.mail.mud.yahoo.com>
	 <1202471639.1805.149.camel@haakon2.linux-iscsi.org>
	 <47AC6A6A.90905@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp111.sbc.mail.mud.yahoo.com ([68.142.198.210]:41809 "HELO
	smtp111.sbc.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756322AbYBIABP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Feb 2008 19:01:15 -0500
In-Reply-To: <47AC6A6A.90905@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: ltuikov@yahoo.com, Bart Van Assche <bart.vanassche@gmail.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, scst-devel@lists.sourceforge.net, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Ming Zhang <blackmagic02881@gmail.com>

On Fri, 2008-02-08 at 17:42 +0300, Vladislav Bolkhovitin wrote:
> Nicholas A. Bellinger wrote:
> > On Thu, 2008-02-07 at 12:37 -0800, Luben Tuikov wrote:
> > 
> >>Is there an open iSCSI Target implementation which does NOT
> >>issue commands to sub-target devices via the SCSI mid-layer, but
> >>bypasses it completely?
> >>
> >>   Luben
> >>
> > 
> > 
> > Hi Luben,
> > 
> > I am guessing you mean futher down the stack, which I don't know this to
> > be the case.  Going futher up the layers is the design of v2.9 LIO-SE.
> > There is a diagram explaining the basic concepts from a 10,000 foot
> > level.
> > 
> > http://linux-iscsi.org/builds/user/nab/storage-engine-concept.pdf
> > 
> > Note that only traditional iSCSI target is currently implemented in v2.9
> > LIO-SE codebase in the list of target mode fabrics on left side of the
> > layout.  The API between the protocol headers that does
> > encoding/decoding target mode storage packets is probably the least
> > mature area of the LIO stack (because it has always been iSCSI looking
> > towards iSER :).  I don't know who has the most mature API between the
> > storage engine and target storage protocol for doing this between SCST
> > and STGT, I am guessing SCST because of the difference in age of the
> > projects.  Could someone be so kind to fill me in on this..?
> 
> SCST uses scsi_execute_async_fifo() function to submit commands to SCSI 
> devices in the pass-through mode. This function is slightly modified 
> version of scsi_execute_async(), which submits requests in FIFO order 
> instead of LIFO as scsi_execute_async() does (so with 
> scsi_execute_async() they are executed in the reverse order). 
> Scsi_execute_async_fifo() added as a separate patch to the kernel.

The LIO-SE PSCSI Plugin also depends on scsi_execute_async() for builds
on >= 2.6.18.  Note in the core LIO storage engine code (would be
iscsi_target_transport.c), there is no subsystem dependence logic.  The
LIO-SE API is what allows the SE plugins to remain simple and small:

-rw-r--r-- 1 root root 35008 2008-02-02 03:25 iscsi_target_pscsi.c
-rw-r--r-- 1 root root  7537 2008-02-02 17:27 iscsi_target_pscsi.h
-rw-r--r-- 1 root root 18269 2008-02-04 02:23 iscsi_target_iblock.c
-rw-r--r-- 1 root root  6834 2008-02-04 02:25 iscsi_target_iblock.h
-rw-r--r-- 1 root root 30611 2008-02-02 03:25 iscsi_target_file.c
-rw-r--r-- 1 root root  7833 2008-02-02 17:27 iscsi_target_file.h
-rw-r--r-- 1 root root 35154 2008-02-02 04:01 iscsi_target_rd.c
-rw-r--r-- 1 root root  9900 2008-02-02 17:27 iscsi_target_rd.h

It also means that the core LIO-SE code does not have to change when the
subsystem APIs change.  This has been important in the past for the
project, but for upstream code, probably would not make a huge
difference.

--nab

