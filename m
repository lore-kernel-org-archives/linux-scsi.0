From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: scsi_requeue_command and dropping reference to sdev_gendev
Date: Tue, 24 Jul 2012 09:09:15 +0400
Message-ID: <1343106555.3513.1.camel@dabdike>
References: <CAOxq_8N=t0ramZXQ2O49MbQ2KC3k7D-3Uya93nTo3PY3HhF7Ww@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:42676 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751990Ab2GXFJS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Jul 2012 01:09:18 -0400
In-Reply-To: <CAOxq_8N=t0ramZXQ2O49MbQ2KC3k7D-3Uya93nTo3PY3HhF7Ww@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ani Sinha <ani@aristanetworks.com>
Cc: linux-scsi@vger.kernel.org, Francesco Ruggeri <fruggeri@aristanetworks.com>

On Mon, 2012-07-23 at 21:13 -0700, Ani Sinha wrote:
> Hi :
> 
> I am looking at the latest upstream code and I see a potential issue :
> 
> - scsi_requeue_command() drops reference to scsi_device->sdev_gendev in
> scsi_unprep_request->scsi_put_command()->__scsi_put_command(). This can
> trigger the cleanup routine scsi_device_dev_release_usercontext() that
> will deallocate the sdev->request_queue in blk_put_queue() call. This can
> cause potential problems in scsi_requeue_command() when it calls
> scsi_run_queue().
> 
> Am I missing something here?
> 
> Any suggestion will be greatly appreciated.

commit 940f5d47e2f2e1fa00443921a0abf4822335b54d
Author: Bart Van Assche <bvanassche@acm.org>
Date:   Fri Jun 29 15:34:26 2012 +0000

    [SCSI] Avoid dangling pointer in scsi_requeue_command()

James


