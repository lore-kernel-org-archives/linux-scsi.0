From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [set5 PATCH 0/6] scsi, async: asynchronous probing rework / fixes
Date: Thu, 28 Jun 2012 15:22:34 -0700
Message-ID: <CAA9_cmejubhZRXkUc_-FYhgD3B0sjR8p4YO3VkgcxWvisd-RWg@mail.gmail.com>
References: <20120622064657.21538.61711.stgit@dwillia2-linux.jf.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20120622064657.21538.61711.stgit@dwillia2-linux.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
To: JBottomley@parallels.com
Cc: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Jun 21, 2012 at 11:46 PM, Dan Williams <dan.j.williams@intel.co=
m> wrote:
> Set5 of 5 patchsets to update scsi, libsas, and libata in
> support of the isci driver.
>
> Commit 43a8d39d "[SCSI] fix async probe regression" found that
> async_synchronize_full() was missing async work that was scheduled to
> its own domain. =A0This led James to note:
>
> =A0 =A0 =A0"My theory is that this is an init problem: The assumption=
 in a lot of
> =A0 =A0 =A0 our code is that async_synchronize_full() waits for every=
thing ... even
> =A0 =A0 =A0 the domain specific async schedules, which isn't true."
>
> ...and this set aims to make that assumption true, but also with the
> ability to opt-out for "private" async work.
>
> The other async probe fix is in the area of unplug events that occur =
in
> the scsi async scanning interval. =A0Essentially scsi_remove_target()=
 can
> now see semi-initialized scsi_targets that have yet to be added via
> device_add().
>
> If there are no objections I'll put these in -next. =A0But I expect a=
t
> least patch1 and patch2 will need an ack from Arjan before the set sh=
ows
> up in scsi.git.
>
> ---

James,

I caught a couple conflicts with scsi.git/for-next and was able to fix
them up without rebasing on top of your tree.  I'll resend the series
after letting these sit in -next for a while, or I can prepare a tag
for you to pull with the whole pending set.

>
> Dan Williams (6):
> =A0 =A0 =A0async: introduce 'async_domain' type

dropped the include of async.h

> =A0 =A0 =A0async: make async_synchronize_full() flush all work regard=
less of domain
> =A0 =A0 =A0scsi: queue async scan work to an async_schedule domain
> =A0 =A0 =A0scsi: cleanup usages of scsi_complete_async_scans

dropped the changes to scsi_wait_scan.c since that file is deleted in
your for-next branch.

--
Dan
