From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [GIT PULL] target updates for v3.8-rc1
Date: Sat, 15 Dec 2012 17:25:18 -0800
Message-ID: <1355621118.7425.10.camel@haakon2.linux-iscsi.org>
References: <1355529222.31680.143.camel@haakon2.linux-iscsi.org>
	 <CA+55aFzHGQX1KWPcRwiFqK3EifodAfN=NQ=OMQKww2qM57gYsA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:36464 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752123Ab2LPBZ1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 15 Dec 2012 20:25:27 -0500
In-Reply-To: <CA+55aFzHGQX1KWPcRwiFqK3EifodAfN=NQ=OMQKww2qM57gYsA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>, Christoph Hellwig <hch@lst.de>, Roland Dreier <roland@kernel.org>, Sebastian Andrzej Siewior <bigeasy@linutronix.de>

On Sat, 2012-12-15 at 14:28 -0800, Linus Torvalds wrote:
> On Fri, Dec 14, 2012 at 3:53 PM, Nicholas A. Bellinger
> <nab@linux-iscsi.org> wrote:
> >
> > Here are the target updates for v3.8-rc1 merge window code.  Please go
> > ahead and pull from:
> >
> >   git://git.kernel.org/pub/scm/linux/kernel/git/nab/target-pending.git for-next
> >
> > Just a heads up that there is a minor merge conflict that you'll
> > encounter in target_handle_task_attr() code, that sfr has been carrying
> > a fix for recently within -next.  After dropping the HEAD section, the
> > resolution should look like:
> 
> Hmm. This is *not* how I resolved that conflict - that seems to drop the new
> 
>      complete(&cmd->t_transport_stop_comp);
> 
> added by Roland in commit 3ea160b3e8f0 ("target: Fix handling of
> aborted commands").

You are most certainly correct.

> 
> So my conflict resolution looks different.
> 
> Which may be a bug, of course. Nicholas, Roland, please check my end result,
> 

Including the complete() from commit 3ea160b3e8f0 in the exception path
for transport_check_aborted_status() within target_execute_cmd() code
was/is the proper merge resolution.

Thank you for taking care of this.

--nab

