From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 08/13] iscsi-target: Add CHAP Authentication
	support	using libcrypto
Date: Mon, 25 Jul 2011 13:42:58 -0700
Message-ID: <1311626578.17766.79.camel@haakon2.linux-iscsi.org>
References: <1311410747-29947-1-git-send-email-nab@linux-iscsi.org>
	 <1311410747-29947-9-git-send-email-nab@linux-iscsi.org>
	 <1311439173.23720.14.camel@mulgrave>
	 <CA+55aFzkEUbnoDg0KwXDRQMeCFeO5s6_4dWHTY59=hj3QHWL0w@mail.gmail.com>
	 <1311445075.17423.13.camel@mulgrave>
	 <1311455867.31450.287.camel@haakon2.linux-iscsi.org>
	 <1311479558.2702.8.camel@mulgrave>
	 <1311482486.31450.408.camel@haakon2.linux-iscsi.org>
	 <4E2DC486.8080701@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:49118 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752768Ab1GYUwV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Jul 2011 16:52:21 -0400
In-Reply-To: <4E2DC486.8080701@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andy Grover <agrover@redhat.com>
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, Linus Torvalds <torvalds@linux-foundation.org>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Roland Dreier <roland@purestorage.com>, Andrew Morton <akpm@linux-foundation.org>

On Mon, 2011-07-25 at 12:31 -0700, Andy Grover wrote:
> On 07/23/2011 09:41 PM, Nicholas A. Bellinger wrote:
> > While I apperciate Mike's input here, I'll leave the final word to Andy
> > and Christoph who have been primarly driving iscsi-target v4.1
> > development and are the guys who have their fingers deepest in the code.
> 
> I appreciate that, but hch and I have been working on cleaning up the
> main datapath; I personally haven't needed to familiarize myself with
> the auth code at all so far. That said, I happen to think you are
> correct, and am in favor of accepting the code as is, with in-kernel
> auth. I wasn't 100% sure from reading Mike's response but it sounded
> like he was saying he'd be ok with in-kernel auth since it would make
> handling hw iscsi targets easier.
> 

....

> (BTW I think the arguments about backwards compatibility with existing
> rtslib or pre-kernel-acceptance versions are not persuasive and a
> distraction from the real technical discussion. Linux has a very strong
> stable-user-api tenet, but we should commit to support stable APIs that
> are reviewed and accepted in the kernel, and not be limited by
> compatibility with prior out-of-kernel versions.)
> 

What I was trying to say here is we currently have a consistent
userspace library for the two default iscsi-target cases that is
completely driven by python userspace code.  We use rtslib to mask the
possible future changes (and breakage) to the target kernel api
(configfs) to avoid direct breakage with apps using the library, as well
as being able to gracefully add new API functionality using the
modern /var/target/spec/ layout that thus far has been fully native
using /sys/kernel/config/target/ (eg: no external userspace C code)

Yes, we do expect to have to change rtslib as neccessary in order to
support new features including the optional to implement fabric
dependent authentication methods.  How that looks is larely dependent on
the interaction with configfs, and what extra userspace daemons need to
be involved.  What I am very eager to avoid is more userspace dependence
for the default login cases that everyone will be using for v3.1.
 
> > But all that said, there is still one person who has the real final word
> > here, and he's made it clear how he feels about this type of kernel/user
> > split.
> 
> Well that's great and all - I would just emphasize we're all going to be
> working on this code cooperatively for a long time to come. More time
> spent discussing technical issues to where we can all reach a grumbling
> consensus will ultimately bear more fruit than appeals to the Hierarchy.
> 

Yes, but the specific discussion for 'optional to implement' is low on
the priority list now as we don't have iSCSI clients that use it for
v3.1.  So I am very happy to move forward for v3.2 and start adding
these as necessary, and would even consider reviving the old
AuthMethod=SRP code for LIO-Target 2.x if folks are willing to help on
the open-iscsi side to make this happen.

But aside from this particular bit of code, the main concern here has
really been the discussion to move the default non authenticated paths
from the kernel and into single threaded userspace code, when the
current /sys/kernel/config/target/iscsi/ is capable of configuring
10,000+ endpoints individually.  This point I am very firm on from
having to develop a fully dynamic control plane over the years with out
of tree and pre configfs LIO-Target code, and is what I think what makes
the most sense technically moving forward with v4.1 iscsi-target code.

Thanks,

--nab

