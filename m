From: "Ashutosh Naik" <ashutosh.naik@gmail.com>
Subject: Re: Kernel Crash when using the open-iscsi initiator on 2.6.25.6
Date: Wed, 25 Jun 2008 23:05:18 +0530
Message-ID: <81083a450806251035k285e4e3dga052f041c9e2d94d@mail.gmail.com>
References: <81083a450806242236m62754185t3099c06f9f77676@mail.gmail.com>
	 <48627851.9010804@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ti-out-0910.google.com ([209.85.142.188]:51584 "EHLO
	ti-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751774AbYFYRfT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Jun 2008 13:35:19 -0400
Received: by ti-out-0910.google.com with SMTP id b6so1728413tic.23
        for <linux-scsi@vger.kernel.org>; Wed, 25 Jun 2008 10:35:18 -0700 (PDT)
In-Reply-To: <48627851.9010804@cs.wisc.edu>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, open-iscsi@googlegroups.com

On Wed, Jun 25, 2008 at 10:24 PM, Mike Christie <michaelc@cs.wisc.edu> wrote:

>>  connection5:0: ping timeout of 5 secs expired, last rx 4309652882,
>> last ping 4309657882, now 4309662882
>
>
> However, once it happens we should not report it again like is done here.
> There is something weird there. Do you have the iscsid output? Between these
> two reports of pings timing out is there any messages from iscsid about
> reconnecting?

iscsid tried to reconnect but the target died, I think.

>>  connection5:0: detected conn error (1011)
>>  connection5:0: detected conn error (1011)
>>  session5: host reset succeeded
>
>
> And we should not get here. The iscsi driver's scsi command timeout handler
> should prevent the command from firing the scsi eh, because in this case we
> think it is a transport problem.
>
> What version of the iscsi tools are you using? Are they from a distro or
> open-iscsi.org?
>
> Are you running with the iscsi kernel modules from 2.6.25.6, or are you
> using the iscsi modules from the open-iscsi.org website that come with the
> tarball?
>
> Is the kernel a unmodified 2.6.25.6 or does it have some distro patches or
> patches that you have created?

It was an unmodififed 2.6.25.6 kernel, and open-iscsi version 2.0-869.2

>> INFO: task fdisk:5226 blocked for more than 120 seconds.
>
> I think you get this message and what follows, is a result of the above
> problem. While the iscsi initiator is trying to reconnect, IO is queued by
> the scsi layer so fdisk is going to be waiting around until we recover or
> give up.

Yep, but is there any way to close gracefully and avoid the kernel dump?

Thanks
Ashutosh
