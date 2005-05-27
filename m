From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] qla2xxx: fix bad locking during eh_abort
Date: Fri, 27 May 2005 16:38:25 -0400
Message-ID: <1117226305.7379.30.camel@mulgrave>
References: <20050526231938.GA31205@plap.qlogic.org>
	 <1117224371.7379.21.camel@mulgrave>
	 <20050527201831.GE16474@plap.qlogic.org>  <42978372.9070607@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:35247 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262581AbVE0Uil (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 May 2005 16:38:41 -0400
In-Reply-To: <42978372.9070607@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Andrew Vasquez <andrew.vasquez@qlogic.com>, Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, 2005-05-27 at 16:30 -0400, Jeff Garzik wrote:
> The ha->hardware_lock is obtained without spin_lock_irq(), so that's 
> correct.

Yes, that was my confusion

But ... I wish you hadn't pointed it out.  Now I look at the driver, the
ha->hardware_lock is taken at interrupt level (in the interrupt
routines).

However, this sequence of code:

	spin_unlock_irq(ha->host->host_lock);
	spin_lock(&ha->hardware_lock);

Enables interrupts then takes this lock.  If we ever get a qla interrupt
before we drop the ha->hardware_lock again, that will be a classic
deadlock.

James


