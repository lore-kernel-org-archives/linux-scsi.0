From: Bart Van Assche <bvanassche@acm.org>
Subject: Re: Possible use after free in scsi_put_command()?
Date: Wed, 25 Jun 2014 08:52:12 +0200
Message-ID: <53AA719C.6030204@acm.org>
References: <53A99420.3080503@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from albert.telenet-ops.be ([195.130.137.90]:35936 "EHLO
	albert.telenet-ops.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751415AbaFYGwW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 25 Jun 2014 02:52:22 -0400
In-Reply-To: <53A99420.3080503@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Maurizio Lombardi <mlombard@redhat.com>, hare@suse.de
Cc: linux-scsi@vger.kernel.org

On 06/24/14 17:07, Maurizio Lombardi wrote:
> I've a question regarding the asynchronous scsi abort handler,
> look at the scsi_put_command() function:
> 
> void scsi_put_command(struct scsi_cmnd *cmd)
> {
>         unsigned long flags;
> 	[...]
>         cancel_delayed_work(&cmd->abort_work);
>         __scsi_put_command(cmd->device->host, cmd);
> }
> 
> cancel_delayed_work() may return while the abort handler is still running,
> the problem is that __scsi_put_command() frees the cmd pointer that
> is still used by the abort handler.
> 
> Is it correct? Isn't safer to use cancel_delayed_work_sync() here?

Hello Maurizio,

I agree that that cancel_delayed_work() call is confusing. Hence
"[PATCH] Remove two cancel_delayed_work() calls from the mid-layer"
(http://thread.gmane.org/gmane.linux.scsi/91027). Had you already
noticed that patch ?

Best regards,

Bart.

