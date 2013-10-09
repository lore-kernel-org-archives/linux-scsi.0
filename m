From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi: Set the minimum valid value of 'eh_deadline' as
 0
Date: Wed, 09 Oct 2013 11:38:51 +0200
Message-ID: <5255242B.8040404@suse.de>
References: <524C48AC.2010901@suse.de> <1381304600-7862-1-git-send-email-renmx@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:38855 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752136Ab3JIIhE (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 9 Oct 2013 04:37:04 -0400
In-Reply-To: <1381304600-7862-1-git-send-email-renmx@cn.fujitsu.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ren Mingxin <renmx@cn.fujitsu.com>
Cc: jbottomley@parallels.com, linux-scsi@vger.kernel.org, emilne@redhat.com, joern@logfs.org, james.smart@emulex.com, bvanassche@acm.org, roland@purestorage.com

On 10/09/2013 09:43 AM, Ren Mingxin wrote:
> The former minimum valid value of 'eh_deadline' is 1s, which means
> the earliest occasion to shorten EH is 1 second later since a
> command is failed or timed out. But if we want to skip EH steps
> ASAP, we have to wait until the first EH step is finished. If the
> duration of the first EH step is long, this waiting time is
> excruciating. So, it is necessary to accept 0 as the minimum valid
> value for 'eh_deadline'.
>
> According to my test, with Hannes' patchset 'New EH command timeout
> handler' as well, the minimum IO time is improved from 73s
> (eh_deadline =3D 1) to 43s(eh_deadline =3D 0) when commands are timed
> out by disabling RSCN and target port.
>
> Another thing: scsi_finish_command() should be invoked if
> scsi_eh_scmd_add() is returned on failure - let EH finish those
> commands.
>
D'accord. Looks like a valid case.
I'll be merging it to my original patchset, seeing that
James _still_ hasn't responded to it, let alone merged it.

Sigh.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
