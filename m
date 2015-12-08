From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [PATCH 12/20] target/tmr: LUN reset cause cmd premature free.
Date: Mon, 7 Dec 2015 18:48:59 -0800
Message-ID: <20151208024859.GB32255@infradead.org>
References: <1449535747-2850-1-git-send-email-himanshu.madhani@qlogic.com>
 <1449535747-2850-13-git-send-email-himanshu.madhani@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([198.137.202.9]:41581 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932234AbbLHCs7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Dec 2015 21:48:59 -0500
Content-Disposition: inline
In-Reply-To: <1449535747-2850-13-git-send-email-himanshu.madhani@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Himanshu Madhani <himanshu.madhani@qlogic.com>
Cc: target-devel@vger.kernel.org, nab@linux-iscsi.org, giridhar.malavali@qlogic.com, linux-scsi@vger.kernel.org

On Mon, Dec 07, 2015 at 07:48:59PM -0500, Himanshu Madhani wrote:
> From: Quinn Tran <quinn.tran@qlogic.com>
> 
> During LUN/Target reset, the TMR code attempt to intercept
> cmds and try to aborted them.  Current code assume cmds are
> always intercepted at the back end device.  The cleanup code
> would issue a "queue_status() & check_stop_free()" to terminate
> the command.  However, when a cmd is intercepted at the front
> end/Fabric layer, current code introduce premature free or
> cause Fabric to double free.
> 
> When command is intercepted at Fabric layer, it means a
> check_stop_free(cmd_kref--) has been called.  The extra
> check_stop_free in the Lun Reset cleanup code causes early
> free.  When a cmd in the Fabric layer is completed, the normal
> free code adds another another free which introduce a double free.
> 
> To fix the issue:
> - add a new flag/CMD_T_SENT_STATUS to track command that have
>  made it down to fabric layer after back end good/bad completion.
> - if cmd reach Fabric Layer at Lun Reset time, add an extra
>  cmd_kref count to prevent premature free.

This seems lke something solved by Bart's abort rewrite in a much nicer
way.  All this special casing based on magic flags isn't maintainable
in the long run.
