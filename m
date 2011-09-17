From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH 1/5] target: Fix race between multiple invocations of target_qf_do_work()
Date: Sat, 17 Sep 2011 12:23:36 -0700
Message-ID: <CA+55aFx+NAovTWxDdPtC4U+v6eUUGfAX_Gt2LNutF6+42BE-gQ@mail.gmail.com>
References: <1316169506-4441-1-git-send-email-nab@linux-iscsi.org> <1316169506-4441-2-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ww0-f44.google.com ([74.125.82.44]:47246 "EHLO
	mail-ww0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753708Ab1IQTX5 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sat, 17 Sep 2011 15:23:57 -0400
In-Reply-To: <1316169506-4441-2-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Roland Dreier <roland@purestorage.com>, Tejun Heo <tj@kernel.org>

On Fri, Sep 16, 2011 at 3:38 AM, Nicholas A. Bellinger
<nab@linux-iscsi.org> wrote:
> From: Roland Dreier <roland@purestorage.com>
>
> When work is scheduled with schedule_work(), the work can end up
> running on multiple CPUs at the same time -- this happens if
> the work is already running on one CPU and schedule_work() is called
> on another CPU. =A0This leads to list corruption with target_qf_do_wo=
rk(),
> which is roughly doing:
>
> =A0 =A0 =A0 =A0spin_lock(...);
> =A0 =A0 =A0 =A0list_for_each_entry_safe(...) {
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0list_del(...);
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0spin_unlock(...);
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0// do stuff
>
> =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0spin_lock(...);
> =A0 =A0 =A0 =A0}
>
> With multiple CPUs running this code, one CPU can end up deleting the
> list entry that the other CPU is about to work on.
>
> Fix this by splicing the list entries onto a local list and then
> operating on that in the work function.

Umm. It sounds like what you really want is just a single-threaded work=
queue.

Wouldn't it be better to do the alloc_workqueue with WQ_UNBOUND, and a
max limit of a single thread? There's a helper function for it:
alloc_ordered_workqueue().

I dunno. Maybe there's a reason why you actually do want threaded
workqueues, but your description makes it sound like this would be
better resolved by simply using an ordered on.

                      Linus
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
