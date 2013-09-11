From: Ren Mingxin <renmx@cn.fujitsu.com>
Subject: Re: [PATCH 2/3] scsi: improved eh timeout handler
Date: Wed, 11 Sep 2013 17:16:25 +0800
Message-ID: <523034E9.7030508@cn.fujitsu.com>
References: <1378123118-111972-1-git-send-email-hare@suse.de> <1378123118-111972-3-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cn.fujitsu.com ([222.73.24.84]:39773 "EHLO song.cn.fujitsu.com"
	rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org with ESMTP
	id S1753198Ab3IKJLN (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 Sep 2013 05:11:13 -0400
In-Reply-To: <1378123118-111972-3-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>, Joern Engel <joern@logfs.org>, James Smart <james.smart@emulex.com>, Bart Van Assche <bvanassche@acm.org>, Roland Dreier <roland@purestorage.com>

Hi, Hannes:

On 09/02/2013 07:58 PM, Hannes Reinecke wrote:
> If abort succeeds the command is either retried or terminated,
> depending on the number of allowed retries. However, 'eh_eflags'
> records the abort, so if the retry would fail again the
> command is pushed onto the error handler without trying to
> abort it (again); it'll be cleared up from SCSI EH.

I'm still thinking about the aborting 'scsi_eh_abort_cmds()' in SCSI
EH - does it make sense to abort in SCSI EH since we've tried to
abort via your scsi_abort_command()? Though the aborting in SCSI EH
will handle commands which havn't been aborted in scsi_abort_command
since EH has been engaged.

Thanks,
Ren
