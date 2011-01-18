From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH v4 1/3] scsi: Detailed I/O errors
Date: Tue, 18 Jan 2011 12:33:55 +0100
Message-ID: <4D357AA3.5070509@interlog.com>
References: <cover.1295340405.git.hare@suse.de> <b6ba7efc491aec18cd501f73e2e6bbebc2e0727a.1295340405.git.hare@suse.de>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:38689 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751056Ab1ARLd6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 18 Jan 2011 06:33:58 -0500
In-Reply-To: <b6ba7efc491aec18cd501f73e2e6bbebc2e0727a.1295340405.git.hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: James Bottomley <jbottomley@suse.de>, linux-scsi@vger.kernel.org, jaxboe@fusionio.com, michaelc@cs.wisc.edu, agk@redhat.com, Mike Snitzer <snitzer@redhat.com>

On 11-01-18 10:13 AM, Hannes Reinecke wrote:
> Instead of just passing 'EIO' for any I/O error we should be
> notifying the upper layers with more details about the cause
> of this error.
>
> Update the possible I/O errors to:
>
> - ENOLINK: Link failure between host and target
> - EIO: Retryable I/O error
> - EREMOTEIO: Non-retryable I/O error
> - EBADE: I/O error restricted to the I_T_L nexus
>
> 'Retryable' in this context means that an I/O error _might_ be
> restricted to the I_T_L nexus (vulgo: path), so retrying on another
> nexus / path might succeed.
>
> 'Non-retryable' in general refers to a target failure, so this
> error will always be generated regardless of the I_T_L nexus
> it was send on.
>
> I/O errors restricted to the I_T_L nexus might be retried
> on another nexus / path, but they should _not_ be queued
> if no paths are available.

Hannes,
I don't know if it is applicable to this patch but with
SAS when the uplink from an expander is being stressed
(i.e. it temporarily doesn't have enough bandwidth) then
a sense key of ABORTED COMMAND may be generated. In my
experience retrying such a command succeeds.


BTW might "vulgo" be "ergo" [Latin: therefore]?

Doug Gilbert
