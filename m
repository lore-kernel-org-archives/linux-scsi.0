From: Maurizio Lombardi <mlombard@redhat.com>
Subject: Possible use after free in scsi_put_command()?
Date: Tue, 24 Jun 2014 17:07:12 +0200
Message-ID: <53A99420.3080503@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:48452 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754389AbaFXPHR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Jun 2014 11:07:17 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: hare@suse.de
Cc: linux-scsi@vger.kernel.org

Hi Hannes,

I've a question regarding the asynchronous scsi abort handler,
look at the scsi_put_command() function:

void scsi_put_command(struct scsi_cmnd *cmd)
{
        unsigned long flags;
	[...]
        cancel_delayed_work(&cmd->abort_work);
        __scsi_put_command(cmd->device->host, cmd);
}

cancel_delayed_work() may return while the abort handler is still running,
the problem is that __scsi_put_command() frees the cmd pointer that
is still used by the abort handler.

Is it correct? Isn't safer to use cancel_delayed_work_sync() here?

Thanks,
Maurizio Lombardi

