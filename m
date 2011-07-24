From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 08/13] iscsi-target: Add CHAP Authentication support	using
 libcrypto
Date: Sat, 23 Jul 2011 22:08:08 -0500
Message-ID: <4E2B8C98.2060601@cs.wisc.edu>
References: <1311410747-29947-1-git-send-email-nab@linux-iscsi.org>	 <1311410747-29947-9-git-send-email-nab@linux-iscsi.org>	 <1311439173.23720.14.camel@mulgrave>	 <CA+55aFzkEUbnoDg0KwXDRQMeCFeO5s6_4dWHTY59=hj3QHWL0w@mail.gmail.com>	 <1311445075.17423.13.camel@mulgrave> <1311455867.31450.287.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:36425 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751617Ab1GXDId (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 23 Jul 2011 23:08:33 -0400
In-Reply-To: <1311455867.31450.287.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-iscsi-target-dev@googlegroups.com
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, James Bottomley <James.Bottomley@HansenPartnership.com>, Linus Torvalds <torvalds@linux-foundation.org>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Andy Grover <agrover@redhat.com>, Hannes Reinecke <hare@suse.de>, Roland Dreier <roland@purestorage.com>, Andrew Morton <akpm@linux-foundation.org>

On 07/23/2011 04:17 PM, Nicholas A. Bellinger wrote:
> 
> And, we have also seen historically how painful the split has been with
> open-iscsi, which in the end took much longer to get stable (and is
> still harder to debug) than if a proper login split was used to begin
> with.

Here is my 2 cents from working on open-iscsi.

The split did not really have much to do with the initial stability in
the data paths. It was more due to it getting merged with very little
real world testing.

There were stability issues with the interface because no one ever tried
creating a hw iscsi driver for it before it got merged, because software
iscsi does a host per session and hw drivers ended up doing a host per
port or some pci resource, and then boot support.

Most bugs fixed were due to skb handling, locking/atomic issues,
spec/rfc issues - not interface issues. But many large changes had to be
done to make the initial code support hw iscsi.

I agree open-iscsi is more difficult to debug than initiators that were
mostly in kernel like iscsi_sfnet. For open-iscsi the userspace part is
a single process, many operations cannot block, it has a ulgy state
model. And how it did its split does make things more difficult, because
it breaks up every operation into a different userspace to kernel call
(create a session is a call, create a conn is a call, pass a setting is
a call, bind a conn to a session is call, start the conn is a call,
etc). For software iscsi if open-iscsi just logged in to the target,
then passed everything to the kernel in one call then it would have been
a lot easier to debug. If Tomo's design does not have those issues then
it seems like it would not be that bad for software iscsi.

I think where doing a kernel/userspace split is going to be more
difficult is with supporting hw iscsi targets. With software iscsi you
can just pass down a socket and the settings more or less. With hw
iscsi, you want to be able to send the login related packets through the
iscsi port using the iscsi engine or hw/fw might be doing the actual
login process. But, if you are putting discovery (isns, sendtargets,
dhcp iscsi/isns options, slp, etc) in userspace then you have to solve
those issues for discovery so you can use the same interfaces for both.
