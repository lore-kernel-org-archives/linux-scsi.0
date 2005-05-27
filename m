From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] qla2xxx: fix bad locking during eh_abort
Date: Fri, 27 May 2005 16:06:11 -0400
Message-ID: <1117224371.7379.21.camel@mulgrave>
References: <20050526231938.GA31205@plap.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:10415 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262568AbVE0UG0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 May 2005 16:06:26 -0400
In-Reply-To: <20050526231938.GA31205@plap.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Andrew Vasquez <andrew.vasquez@qlogic.com>
Cc: Linux-SCSI Mailing List <linux-scsi@vger.kernel.org>

On Thu, 2005-05-26 at 16:19 -0700, Andrew Vasquez wrote:
> Please apply, this should go in before 2.6.12 is released.

I've got it in the rc-fixes tree for scsi.  However:

> +	spin_unlock(&ha->hardware_lock);

Should be spin_unlock_irq(&ha->hardware_lock); shouldn't it?  Otherwise
we could sleep with interrupts disabled and the kernel now squeaks about
that.

James


