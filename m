From: Ren Mingxin <renmx@cn.fujitsu.com>
Subject: Re: [PATCHv2 0/7] Limit overall SCSI EH runtime
Date: Mon, 15 Jul 2013 18:33:25 +0800
Message-ID: <51E3CFF5.2070501@cn.fujitsu.com>
References: <1372661455-122384-1-git-send-email-hare@suse.de>  <1373488528.7420.55.camel@localhost.localdomain>  <51DF9A25.5030502@cn.fujitsu.com> <1373635840.7420.139.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:38094 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1754885Ab3GOK30 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 15 Jul 2013 06:29:26 -0400
In-Reply-To: <1373635840.7420.139.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: emilne@redhat.com, Hannes Reinecke <hare@suse.de>
Cc: bmr@redhat.com, James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, Bart van Assche <bvanassche@acm.org>, Joern Engel <joern@logfs.org>

Hi, Ewan:

On 07/12/2013 09:30 PM, Ewan Milne wrote:
> On Fri, 2013-07-12 at 13:54 +0800, Ren Mingxin wrote:
>> I'm wondering how do you test, with a special hardware or self-made
>> module?Would you mind pasting your test method() and result?
> This was tested in a SAN environment with an EMC Symmetrix and
> Brocade FC switches.  The error was injected by the following
> commands:
>
> portcfg rscnsupr<port>  --enable
> portdisable<port>
>
> Where<port>  is the FC port of the Symmetrix target.
>
> Multipath is used and the test records how long I/O from userspace
> takes to complete after the error handling stops and the I/O is
> retried on another path.
>
> What happens is that the target never responds to anything the
> HBA sends, so commands and TMFs just timeout.  The HBA doesn't
> see link down (since it is the target port) and doesn't get an
> RSCN.  When the HBA is finally reset, however, it can't login
> to the target port and so further I/O gets an immediate error.
>
> Unfortunately, not all SAN environments will exhibit the failing
> behavior -- it appears as if in some cases the HBA detects the
> problem regardless of the switch portcfg setting.  But this has
> been verified to solve the problem of seemingly endless EH
> activity in testing at a large customer site.

Thanks in advance for your explanations in detail. I've been able to
reproduce only with this patchset.

> Also, to be clear, we tested with the "Limit overall SCSI EH
> runtime" patchset but not the "New EH command timeout handler".
> I think the changes to issue the abort in the timeout handler
> are a good idea, though, because there really is no need to
> wait for all activity on the host to cease before issuing the
> abort as far as I can see.

Hmm, agree with you. It is much better to issue aborts without
waiting, which can shorten the timeout handling time.

>>> Acked-by: Ewan D. Milne<emilne@redhat.com>
>>>

Hi, Hannes:

I noticed that the dd time had been reduced from 6m+ to 2m+ when the
'eh_deadline' was set as 30s, but the dd time was 6m+(nearly the same
as default - 'eh_deadline' was 0) when the 'eh_deadline' was set as
10s. I havn't been able to dig further, but I guess there is some
restriction when setting this 'eh_deadline' interface. Maybe should
not less than some timeout, otherwise 'eh_deadline' setting will not
work?

Thanks,
Ren
