From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [Scst-devel] Integration of SCST in the mainstream Linux kernel
Date: Fri, 08 Feb 2008 03:53:59 -0800
Message-ID: <1202471639.1805.149.camel@haakon2.linux-iscsi.org>
References: <393719.81864.qm@web31808.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp121.sbc.mail.sp1.yahoo.com ([69.147.64.94]:25552 "HELO
	smtp121.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752445AbYBHLyi (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Feb 2008 06:54:38 -0500
In-Reply-To: <393719.81864.qm@web31808.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ltuikov@yahoo.com
Cc: Bart Van Assche <bart.vanassche@gmail.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Vladislav Bolkhovitin <vst@vlnb.net>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, scst-devel@lists.sourceforge.net, Andrew Morton <akpm@linux-foundation.org>, Linus Torvalds <torvalds@linux-foundation.org>, Ming Zhang <blackmagic02881@gmail.com>

On Thu, 2008-02-07 at 12:37 -0800, Luben Tuikov wrote:
> Is there an open iSCSI Target implementation which does NOT
> issue commands to sub-target devices via the SCSI mid-layer, but
> bypasses it completely?
> 
>    Luben
> 

Hi Luben,

I am guessing you mean futher down the stack, which I don't know this to
be the case.  Going futher up the layers is the design of v2.9 LIO-SE.
There is a diagram explaining the basic concepts from a 10,000 foot
level.

http://linux-iscsi.org/builds/user/nab/storage-engine-concept.pdf

Note that only traditional iSCSI target is currently implemented in v2.9
LIO-SE codebase in the list of target mode fabrics on left side of the
layout.  The API between the protocol headers that does
encoding/decoding target mode storage packets is probably the least
mature area of the LIO stack (because it has always been iSCSI looking
towards iSER :).  I don't know who has the most mature API between the
storage engine and target storage protocol for doing this between SCST
and STGT, I am guessing SCST because of the difference in age of the
projects.  Could someone be so kind to fill me in on this..?

Also note, the storage engine plugin for doing userspace passthrough on
the right is also currently not implemented.  Userspace passthrough in
this context is an target engine I/O that is enforcing max_sector and
sector_size limitiations, and encodes/decodes target storage protocol
packets all out of view of userspace.  The addressing will be completely
different if we are pointing SE target packets at non SCSI target ports
in userspace.

--nab

> 

