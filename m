From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 2/3] scsi: improved eh timeout handler
Date: Thu, 12 Sep 2013 22:49:15 +0200
Message-ID: <523228CB.9030803@suse.de>
References: <1378123118-111972-1-git-send-email-hare@suse.de> <1378123118-111972-3-git-send-email-hare@suse.de> <523034E9.7030508@cn.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:53376 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753895Ab3ILTri (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 12 Sep 2013 15:47:38 -0400
In-Reply-To: <523034E9.7030508@cn.fujitsu.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ren Mingxin <renmx@cn.fujitsu.com>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, Joern Engel <joern@logfs.org>, James Smart <james.smart@emulex.com>, Bart Van Assche <bvanassche@acm.org>, Roland Dreier <roland@purestorage.com>

On 09/11/2013 11:16 AM, Ren Mingxin wrote:
> Hi, Hannes:
>
> On 09/02/2013 07:58 PM, Hannes Reinecke wrote:
>> If abort succeeds the command is either retried or terminated,
>> depending on the number of allowed retries. However, 'eh_eflags'
>> records the abort, so if the retry would fail again the
>> command is pushed onto the error handler without trying to
>> abort it (again); it'll be cleared up from SCSI EH.
>
> I'm still thinking about the aborting 'scsi_eh_abort_cmds()' in SCSI
> EH - does it make sense to abort in SCSI EH since we've tried to
> abort via your scsi_abort_command()? Though the aborting in SCSI EH
> will handle commands which havn't been aborted in scsi_abort_command
> since EH has been engaged.
>
Well, with the original design scsi_abort_command() was optional, and
only enabled for selected HBAs.
And I would rather keep it the original implementation, as there might
be HBAs who don't like inline aborts.

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
