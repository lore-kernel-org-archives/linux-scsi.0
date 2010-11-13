From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [GIT PULL] SCSI queuecommand API change for 2.6.37-rc1
Date: Fri, 12 Nov 2010 20:42:50 -0800
Message-ID: <AANLkTik_eXv1_ZaqD01CoT6igzjBZtmECD0e+QUkMhxP@mail.gmail.com>
References: <1289606118.3015.539.camel@mulgrave.site> <AANLkTinj2BM2eGo2yyfzs=t+nu79WLW_bGYota9sDZwH@mail.gmail.com>
 <20101113042821.GE18258@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp1.linux-foundation.org ([140.211.169.13]:46557 "EHLO
	smtp1.linux-foundation.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753093Ab0KMEnl (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 12 Nov 2010 23:43:41 -0500
In-Reply-To: <20101113042821.GE18258@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: James Bottomley <James.Bottomley@suse.de>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Jeff Garzik <jeff@garzik.org>, Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

On Fri, Nov 12, 2010 at 8:28 PM, Matthew Wilcox <matthew@wil.cx> wrote:
> Actually, it'd be even better if we took away an argument.
>
> int queuecommand(struct scsi_cmnd *cmd);
>
> Every single driver sets cmd->scsi_done = done;

.. and i that's all they really ever do with it, I guess that that
would indeed be an improvement.

I still do think that passing in shost is actually a good idea, since
you'll normally be needing it for locking and other things anyway
(looking at the libata-scsi.c one, for example, the very first thing
it wants to do is to look up the port from the shost pointer).

Having to inevitably do that silly double dereference
("cmd->device->host") seems bogus. Passing in the host you want to
queue something on seems to be natural, and avoids that nasty chain of
dereferences, so it really should improve the code.

I don't think there are any drivers that don't want that host pointer
pretty much immediately, even if they can elide the locking. But I
admit I only looked at two (qla4xxx driver does the exact same thing:
the very first thing in the queuecommand function is
"to_qla_host(cmd->device->host)", but it wants that hostdata thing
too, so whatever.)

So the shost pointer is certainly a lot more useful than the 'done'
function pointer.  So yeah, I'd switch them around - pass the 'done'
thing indirectly, and the shost directly.

                        Linus
