From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH-v2 00/14] iscsi-target: iSCSI target v4.1.0-rc1 series
	initial merge
Date: Thu, 24 Mar 2011 07:46:14 +0900
Message-ID: <20110324074600L.fujita.tomonori@lab.ntt.co.jp>
References: <1300875726.21880.542.camel@haakon2.linux-iscsi.org>
	<20110323200722G.fujita.tomonori@lab.ntt.co.jp>
	<1300916254.18039.87.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:40511 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932943Ab1CWWqq (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 23 Mar 2011 18:46:46 -0400
In-Reply-To: <1300916254.18039.87.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nab@linux-iscsi.org
Cc: fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org, James.Bottomley@suse.de, hch@lst.de, michaelc@cs.wisc.edu, hare@suse.de, bharrosh@panasas.com

On Wed, 23 Mar 2011 14:37:34 -0700
"Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:

> > Removing several thousand lines from kernel isn't benefit?
> > 
> > 
> 
> No, not when it adds complexity without benefit for the default case and
> introduces unnecessary userspace C code.
> 
> At this point in lio-utils.git for target v4 code, we require zero C
> userspace code for the default operation of iscsi-target, and I want to
> keep it this way.  

Hmm, you prefer 'zero C userspace code'? On the other hand, you insist
that requiring user Python userspace code to set up ibmvscsis is a
better approach even when the kernel space can set up everything for
ibmvscsis?

I can't understand your logic.

And iSCSI setup usually needs userspace code such as iSNS
anyway. You'll add iSNS to kernel too.


> Maintaining backwards compatibility with interpreted script code for the
> fabric control plane makes life so much eaiser than any kernel <-> user
> C API that I have ever encountered.

I think that the target can use open-iscsi's kernel <-> user
interface. All the userspace code needs is passing negotiated iSCSI
parameters. Once a nexus establishes, the user space will never do
anything for it. So no complicity like open-iscsi.


> > In other words, what the approach to do the pre-nexus operations like
> > IET (or SCST) can't do?
> 
> Because it does not makes sense for the default case, and adds
> unnecessary complexity to the iscsi-target login process.

Well, I don't think so.


> Using mainline libcrypto for CHAP works as expected and allows us to
> provide one-way and mutual authentication for iSCSI discovery and
> explict initiator NodeACLs via configfs attributes without any userspace
> C dependcies.

The user space daemon can read configfs easily to do the same thing.
