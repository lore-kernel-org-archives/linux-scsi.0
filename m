From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: [PATCH] [SCSI] scsi_debug: fix deadlock on module unload, also
 complete queued commands
Date: Thu, 13 Dec 2012 07:21:17 +1100
Message-ID: <50C8E73D.4070908@interlog.com>
References: <1355331647-6604-1-git-send-email-emilne@redhat.com>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:47792 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754603Ab2LLUV3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 12 Dec 2012 15:21:29 -0500
In-Reply-To: <1355331647-6604-1-git-send-email-emilne@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Ewan D. Milne" <emilne@redhat.com>
Cc: linux-scsi@vger.kernel.org

On 12-12-13 04:00 AM, Ewan D. Milne wrote:
> From: "Ewan D. Milne" <emilne@redhat.com>
>
> The module unload path in scsi_debug was calling del_timer_sync() with the
> queued_arr_lock held.  The timer_intr_handler() function also takes this lock,
> so if it executes as the timer is being removed, the kernel would deadlock.
>
> Also changed to complete all queued commands if scsi_debug is unloaded instead
> of discarding them, because the requests would eventually timeout after the
> module was gone.
>
> Signed-off-by: Ewan D. Milne <emilne@redhat.com>

Acked-by: Douglas Gilbert <dgilbert@interlog.com>


