From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH-FOR-38] target: Fix t_transport_aborted handling in
 LUN_RESET + active I/O shutdown
Date: Mon, 28 Feb 2011 11:29:35 -0600
Message-ID: <1298914175.2487.42.camel@mulgrave.site>
References: <1298595500-1558-1-git-send-email-nab@linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:47397 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753202Ab1B1R3i (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 28 Feb 2011 12:29:38 -0500
In-Reply-To: <1298595500-1558-1-git-send-email-nab@linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Linus Torvalds <torvalds@linux-foundation.org>

On Thu, 2011-02-24 at 16:58 -0800, Nicholas A. Bellinger wrote:
> 			atomic_set(&task->task_stop, 0);
> +		} else {
> +			if (atomic_read(&task->task_execute_queue) != 0)
> +				transport_remove_task_from_execute_queue(task, dev);

You've done this twice in this patch; just for future reference, it's
better written as

} else if (atomic_read(&task->task_execute_queue) != 0) {
	transport_remove_task_from_execute_queue(task, dev);
}

Which avoids the double indentation.

James


