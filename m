From: "Boaz Harrosh" <openosd@gmail.com>
Subject: Re: [patch 0/4] aha152x.c - Cleanup, need help in testing and auditing
Date: Wed, 18 Jul 2007 15:39:43 +0300
Message-ID: <ec7f7ee70707180539u36b38b78t6c344a9e8a0a1069@mail.gmail.com>
References: <4695F76F.5000305@panasas.com>
	 <20070712135750.2a4a4a54.rdunlap@xenotime.net>
	 <469B38CC.50501@panasas.com>
	 <20070717171607.ffc278eb.rdunlap@xenotime.net>
	 <469DDD74.2060208@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from an-out-0708.google.com ([209.85.132.244]:48440 "EHLO
	an-out-0708.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056AbXGRMjp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Jul 2007 08:39:45 -0400
Received: by an-out-0708.google.com with SMTP id d31so34228and
        for <linux-scsi@vger.kernel.org>; Wed, 18 Jul 2007 05:39:43 -0700 (PDT)
In-Reply-To: <469DDD74.2060208@panasas.com>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: Randy Dunlap <rdunlap@xenotime.net>, James Bottomley <James.Bottomley@steeleye.com>, Christoph Hellwig <hch@lst.de>, "=?ISO-8859-1?Q?\"J=FCrgen_E._Fischer\"?=" <fischer@norbit.de>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, linux-scsi <linux-scsi@vger.kernel.org>

On 7/18/07, Boaz Harrosh <bharrosh@panasas.com> wrote:
> Randy Dunlap wrote:
> > On Mon, 16 Jul 2007 12:22:20 +0300 Boaz Harrosh wrote:
> >
> >> If you could do some testing it is grate. The first 3 patches do not
> >> need scsi-misc specifically. Any post 2.6.20 tree will do. The last patch
> >> could be done together with attached patch on any 2.6.22 tree.
> >> (Apply attached patch anywhere before the last patch (4/4) of the patchset)
> >> Though I do recommend scsi-misc tree.
> >
> > I took 2.6.22, backed out Christoph's aha152x.c patch (using
> > completion for timeouts), added your 5 patches, and then tested.
> > Does that sound OK?
> >
> Yes what you did is perfect
> I was not aware of "Christoph's aha152x.c patch" is that in scsi-misc?
> I'm almost positive I did a git-pull before I sent the patches.
> Sorry about that.
>
> >> Testing:
> >
> > I booted/tested 4 times.  2 Oopsen and 2 of
> > could-never-mount-the-device-due-to-reset-problems.
> > Log is attached.
> >
> >
> > ---
> > ~Randy
> > *** Remember to use Documentation/SubmitChecklist when testing your code ***
>
> Thank you for testing and helping me with this.
>
> I found one thing that should definitely trash the Reset
> and do funny things. But I'm not sure it is it at all.
> If below does not work, could you pleas do a small bisect
> of my patches.
>
> first patch first, than 2nd, 3rd ,accessors thing, and 4th
>
> git-diff
> diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
> index f2f0619..6762cc8 100644
> --- a/drivers/scsi/aha152x.c
> +++ b/drivers/scsi/aha152x.c
> @@ -1151,6 +1151,7 @@ static int aha152x_device_reset(Scsi_Cmnd * SCpnt)
>         struct Scsi_Host *shpnt = SCpnt->device->host;
>         DECLARE_COMPLETION(done);
>         int ret, issued, disconnected;
> +       unsigned short old_cmd_len = SCpnt->cmd_len;
>         unsigned long flags;
>         unsigned long timeleft;
>
> @@ -1171,6 +1172,8 @@ static int aha152x_device_reset(Scsi_Cmnd * SCpnt)
>         disconnected = issued && remove_SC(&DISCONNECTED_SC, SCpnt);
>         DO_UNLOCK(flags);
>
> +       SCpnt->cmd_len         = 0;
> +
>         aha152x_internal_queue(SCpnt, &done, resetting, reset_done);
>
>         timeleft = wait_for_completion_timeout(&done, 100*HZ);
> @@ -1181,6 +1184,8 @@ static int aha152x_device_reset(Scsi_Cmnd * SCpnt)
>                 DO_UNLOCK(flags);
>         }
>
> +       SCpnt->cmd_len         = old_cmd_len;
> +
>         DO_LOCK(flags);
>
>         if(SCpnt->SCp.phase & resetted) {
>
> -

I forgot. If it fails could you also do below on the failing patch.
Get some extra prints ...
Thanks
Boaz

diff --git a/drivers/scsi/aha152x.c b/drivers/scsi/aha152x.c
index f2f0619..ca6f8fc 100644
--- a/drivers/scsi/aha152x.c
+++ b/drivers/scsi/aha152x.c
@@ -278,6 +278,8 @@ static LIST_HEAD(aha152x_host_list);
 #error define AUTOCONF or SETUP0
 #endif

+#define AHA152X_DEBUG
+
 #if defined(AHA152X_DEBUG)
 #define DEBUG_DEFAULT debug_eh
