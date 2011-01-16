From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] configfs: change depends -> select SYSFS
Date: Sun, 16 Jan 2011 15:45:35 -0800
Message-ID: <AANLkTikWHkfb1-Yh_O=rYEqzgz48rwRggCp6uhr+E86J@mail.gmail.com>
References: <1295125851-25279-1-git-send-email-nab@linux-iscsi.org>
 <20110116141105.59e5b3a2@stein> <1295214807.22813.57.camel@haakon2.linux-iscsi.org>
 <20110117000659.57352da7@stein> <AANLkTik=Pv1KdiBa3RbSoqmDC92F33jyFb0b-Ej_iGRN@mail.gmail.com>
 <20110116231901.GF22723@ZenIV.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:39521 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752138Ab1APXq1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sun, 16 Jan 2011 18:46:27 -0500
In-Reply-To: <20110116231901.GF22723@ZenIV.linux.org.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-kernel <linux-kernel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-fsdevel <linux-fsdevel@vger.kernel.org>, Joel Becker <jlbec@evilplan.org>, Randy Dunlap <randy.dunlap@oracle.com>, James Bottomley <James.Bottomley@suse.de>

On Sun, Jan 16, 2011 at 3:19 PM, Al Viro <viro@zeniv.linux.org.uk> wrote:
>
> How do you eliminate things like "it really depends on having DMA"?
> When we configure e.g. s390 or uml kernel, it's not like we could
> enable a PCI driver and have architecture magically switch to a
> PCI-supporting one, after all...

If it's something that cannot be changed, then it should be "depends on".

Think about it - writing a "hard requirement" as "depends on" is
perfectly sane. It makes semantic sense, and it is useful to filter
out things that you simply CANNOT have, because you've selected a
configuration or an architecture that simply do not _support_ those
features.

But if it's something where it's not about a feature that is needed,
but about a configuration dependency, it's IMNSHO almost always the
wrong thing to have "depends on".

Another way of thinking about this is to think about what features are
the one that a user *cares* about, and wants to enable or disable by
hand.

Just think about that for a moment - isn't _that_ what a kernel config
should be asking about?

And now ask yourself, do you really expect some random user to say "I
want to enable SYSFS and CONFIGFS, because I am going to use ocfs2 on
my system"?

Really?

Or do you expect a high-quality implementation of a configuration
script to allow the user to just say "I want ocfs2", and then figure
out the dependencies and solve them for you?

I'd say that the latter case is OBVIOUSLY the quality implementation,
while the former one is just stupid.

                   Linus
