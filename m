From: David Howells <dhowells@redhat.com>
Subject: Re: [PATCH] Mark i2o config broken on 64-bit platforms.
Date: Wed, 09 Jul 2008 13:07:47 +0100
Message-ID: <6904.1215605267@redhat.com>
References: <20080709044743.0dd15a3f.akpm@linux-foundation.org> <20080709113547.19235.15424.stgit@warthog.procyon.org.uk>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([66.187.233.31]:43549 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752152AbYGIMID (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Jul 2008 08:08:03 -0400
In-Reply-To: <20080709044743.0dd15a3f.akpm@linux-foundation.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: dhowells@redhat.com, alan@redhat.com, Markus.Lidel@shadowconnect.com, vvs@sw.ru, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

Andrew Morton <akpm@linux-foundation.org> wrote:

> Is it actually known to be broken on 64-bit, or does it happen to work?

It's casting a 32-bit value to a userspace pointer and then passing that to
copy_to/from_user():

				// TODO 64bit fix
				if (copy_from_user
				    (p->virt,
				     (void __user *)(unsigned long)sg[i].
				     addr_bus, sg_size)) {

and:

				// TODO 64bit fix
				if (copy_to_user
				    ((void __user *)sg[j].addr_bus, sg_list[j],
				     sg_size)) {

so someone's obviously aware that it is wrong.  According to vc-annotate it's
been there since before Linus last reset the history, so obviously someone's
aware of it.

Another of these has in fact been cast in the way Linus objects to:

				// TODO 64bit fix
				if (copy_to_user
				    ((void __user *)(u64) sg[j].addr_bus,
				     sg_list[j].virt, sg_size)) {

The problem, I suspect, is that userspace may have addresses that can't be
held in the 32-bit addr_bus value, but the 32-bit value is held in the
i2o_message struct:

	static int i2o_cfg_passthru(unsigned long arg)
	{
	...
		struct i2o_message *msg;
	...
			// TODO 64bit fix
			sg = (struct sg_simple_element *)((&msg->u.head[0]) +
							  sg_offset);
	...
	}

and if these i2o_message structs are actually passed to the hardware, it may
not be possible to actually expand them, and looking at i2o_msg_post(), that
seems to be exactly what happens.

David
