From: Roland Dreier <roland@purestorage.com>
Subject: Re: [LSF/MM TOPIC] I_T Nexus loss SCSI error handling
Date: Mon, 4 Feb 2013 16:08:42 -0800
Message-ID: <CAL1RGDX1i6boiYjXEddrQxxZb-Rrbj4YBBD-muhbmJMAY9zH8g@mail.gmail.com>
References: <50FD2416.3070500@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys010aog110.obsmtp.com ([74.125.245.88]:45629 "HELO
	na3sys010aog110.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755590Ab3BEAJF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 4 Feb 2013 19:09:05 -0500
Received: by mail-lb0-f197.google.com with SMTP id gg6so7753822lbb.0
        for <linux-scsi@vger.kernel.org>; Mon, 04 Feb 2013 16:09:02 -0800 (PST)
In-Reply-To: <50FD2416.3070500@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: lsf-pc@lists.linux-foundation.org, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, Jan 21, 2013 at 3:18 AM, Hannes Reinecke <hare@suse.de> wrote:
> The current error handler still uses a 'target reset' (or, rather, bus
> reset) strategy, although the respective TMF  has been obsoleted since
> SAM-3. SAM-5 defines an I_T nexus loss event instead, which so far has only
> been implemented in libsas.
>
> There has been some discussions on the mailing list, but so far there hasn't
> been any conclusion.
>
> So I would like to discuss a possible implementation of a I_T Nexus loss
> strategy and how to keep compability with SAM-2 targets.

Would this handle the case of a SAS fabric with lots of target
devices, where we start to get errors from a single device while IO is
proceeding fine to everything else on the fabric?  It would be really
nice if the Linux stack handled this without escalating to a target
reset and host reset, since that disrupts all the IO that is
proceeding fine (and which won't do much to fix a target drive that
might really be dead).

 - R.
