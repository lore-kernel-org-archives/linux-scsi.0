From: Baruch Even <baruch@ev-en.org>
Subject: Re: error handler scheduling
Date: Fri, 12 Apr 2013 22:20:22 +0300
Message-ID: <CAC9+anLoi4RW1hgK3XpHj_4e5XkJyUUiOhJL2PDxKLRmyBH-UQ@mail.gmail.com>
References: <51525560.3000008@emulex.com> <5153048B.20905@interlog.com>
 <94D0CD8314A33A4D9D801C0FE68B402950DB0D1D@G9W0745.americas.hpqcorp.net> <5167D71F.5000001@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ea0-f173.google.com ([209.85.215.173]:39624 "EHLO
	mail-ea0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751998Ab3DLTUn (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 12 Apr 2013 15:20:43 -0400
Received: by mail-ea0-f173.google.com with SMTP id k11so1363757eaj.18
        for <linux-scsi@vger.kernel.org>; Fri, 12 Apr 2013 12:20:42 -0700 (PDT)
In-Reply-To: <5167D71F.5000001@cn.fujitsu.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ren Mingxin <renmx@cn.fujitsu.com>
Cc: "Elliott, Robert (Server Storage)" <Elliott@hp.com>, "dgilbert@interlog.com" <dgilbert@interlog.com>, "James.Smart@emulex.com" <James.Smart@emulex.com>, hare@suse.de, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Fri, Apr 12, 2013 at 12:42 PM, Ren Mingxin <renmx@cn.fujitsu.com> wrote:
>
> Please let me summarize what this thread has talked about the scsi
> eh latency:
>
> 1) some scsi cmds' timemout values are inappropriate, we can avoid
>    timeout by:
>    a) sg_format sets the IMMED bit and use TEST UNIT READY or REQUEST
>       SENSE polling to monitor - by Douglas
>    b) cut big cmd into some reasonable-sized ones - by Douglas
>    c) improve timeout values according to device types - by Elliott
> 2) call ->done() on the command after lun reset - by Hannes
>
> And, my question is:
> - could we wake up eh thread ASAP instead of waiting for all cmds
>   complete to fast scheduling?
>
> BTW: my original question is here:
> http://www.spinics.net/lists/linux-scsi/msg65107.html

I don't think you can just do this simple change of not waiting for all commands
to timeout. The problem will start when your abort will fail and
you'll be forced
to do the higher level actions such as target reset, since it will
take out all active
requests you'll want to wait for all active requests to either return
or timeout and
for that time you want to also not send any new commands down the pipe.

Ofcourse, there are situations where you don't care enough about the other
commands and can handle their cancellation with an immediate target reset
or you may even just prefer to not even abort that single command. I've seen and
implemented changes (internal to my employer) to do just that but the changes
to the code are non-trivial.

Baruch
