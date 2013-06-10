From: Baruch Even <baruch@ev-en.org>
Subject: Re: [PATCH 3/4] scsi: improved eh timeout handler
Date: Mon, 10 Jun 2013 03:12:06 +0300
Message-ID: <CAC9+an+BRiFQXVtyjLYwpJGzT_vabQco7hgbp_MQY06j7st5Aw@mail.gmail.com>
References: <1370511835-50072-1-git-send-email-hare@suse.de> <1370511835-50072-4-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ea0-f178.google.com ([209.85.215.178]:59042 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752452Ab3FJAM1 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 9 Jun 2013 20:12:27 -0400
Received: by mail-ea0-f178.google.com with SMTP id l15so2897426eak.9
        for <linux-scsi@vger.kernel.org>; Sun, 09 Jun 2013 17:12:26 -0700 (PDT)
In-Reply-To: <1370511835-50072-4-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@parallels.com>, linux-scsi <linux-scsi@vger.kernel.org>, Joern Engel <joern@logfs.org>, Ewan Milne <emilne@redhat.com>, James Smart <james.smart@emulex.com>, Ren Mingxin <renmx@cn.fujitsu.com>, Roland Dreier <roland@purestorage.com>, Bryn Reeves <bmr@redhat.com>, Christoph Hellwig <hch@infradead.org>

On Thu, Jun 6, 2013 at 12:43 PM, Hannes Reinecke <hare@suse.de> wrote:
> When a command runs into a timeout we need to send an 'ABORT TASK'
> TMF. This is typically done by the 'eh_abort_handler' LLDD callback.
>
> Conceptually, however, this function is a normal SCSI command, so
> there is no need to enter the error handler.
>
> This patch implements a new scsi_abort_command() function which
> invokes an asynchronous function scsi_eh_abort_handler() to
> abort the commands via 'eh_abort_handler'.
>
> If the 'eh_abort_handler' returns SUCCESS or FAST_IO_FAIL the
> command will be retried if possible. If no retries are allowed
> the command will be returned immediately, as we have to assume
> the TMF succeeded and the command is completed with the LLDD.
> For any other return code from 'eh_abort_handler' the command
> will be pushed onto the existing SCSI EH handler, or aborted
> with DID_TIME_OUT if that fails.
>

Why would you do a retry at this low level? We already have a bad path,
the IO may already be rerouted through another path and continuing with this
IO here may interfere with the multipath handling.


Baruch
