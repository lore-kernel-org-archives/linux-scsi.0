From: James Bottomley <jbottomley@parallels.com>
Subject: Re: [PATCH 0/2] scsi command timeout fixes
Date: Fri, 13 Jun 2014 16:52:52 +0000
Message-ID: <1402678371.2224.35.camel@dabdike.int.hansenpartnership.com>
References: <1402660906-74661-1-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.parallels.com ([199.115.105.18]:45743 "EHLO
	mx2.parallels.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751138AbaFMQw7 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Jun 2014 12:52:59 -0400
In-Reply-To: <1402660906-74661-1-git-send-email-hare@suse.de>
Content-Language: en-US
Content-ID: <67136E4A268965498BD83AAC1C653466@sw.swsoft.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "hare@suse.de" <hare@suse.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "hch@infradead.org" <hch@infradead.org>, "bvanassche@acm.org" <bvanassche@acm.org>, "emilne@redhat.com" <emilne@redhat.com>

On Fri, 2014-06-13 at 14:01 +0200, Hannes Reinecke wrote:
> Hi all,
> 
> I've received reports claiming they're seeing a double command completion
> occasionally when a command timeout happens.
> 
> Delving into it I found this this indeed might happening; reason being
> that the LLDD will only be informed about a timed-out command by
> calling scsi_try_to_abort_command(). Anytime before that the LLDD
> is free to assume the command is valid and might call scsi_done() on it.
> Which then will lead to interesting issues in the error handler.

Actually, I'm afraid, this reasoning isn't correct.

Completions of timed out commands are mediated by the block layer using
the REQ_ATOM_COMPLETE flag.

The reason it's an atomic flag is whoever sets it first owns the
completion.  Before a timeout fires, the timeout and completion actually
race.  If completion occurs first, the timeout may still fire, but it
will get harmlessly ignored if the REQ_ATOM_COMPLETE flag is set (it's
mediated by blk_mark_rq_complete()).

Conversely, after the timeout has fired, the flag is set and any
incoming completion gets ignored (code in blk_complete_request()).  The
atomicity of the flag should guarantee we never see double completions.

However, in between the timeout firing and us doing something with the
command in the error handler, we have to force the LLD to give it up.
This requires that we take actions to ensure that we've really killed
the command within the LLD before we start doing things with the command
in the error handler.  The way we do this is either successful abort,
which ensures the LLD won't complete the command or successful reset
which should kill all commands for the LUN/Target/Device etc.

If you're seeing double completions it's either because we have a bug in
SCSI and are doing something with the command before we know block has
relinquished it.  That's actually why this bug was so serious:

commit d555a2abf3481f81303d835046a5ec2c4fb3ca8e
Author: James Bottomley <JBottomley@Parallels.com>
Date:   Fri Mar 28 10:50:17 2014 -0700

    [SCSI] Fix spurious request sense in error handling

We'd wrongly call request sense on a timed out command and that could
cause double completions.

Assuming SCSI is correct, we can still get double completions if drivers
don't actually kill the queued command on abort or reset ... there was a
nasty bug like this within hpsa for a while.

James

