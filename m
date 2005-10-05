From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] 3ware: use scsi_scan_target()
Date: Wed, 05 Oct 2005 15:34:59 -0400
Message-ID: <43442AE3.6030000@pobox.com>
References: <4341D38A.40509@pobox.com> <20051005162850.GA17710@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:6363 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S1030335AbVJETfH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Oct 2005 15:35:07 -0400
In-Reply-To: <20051005162850.GA17710@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, linuxraid@amcc.com

Christoph Hellwig wrote:
> On Mon, Oct 03, 2005 at 08:57:46PM -0400, Jeff Garzik wrote:
> 
>>This change updates the 3ware raid drivers to use scsi_scan_target(), 
>>rather than scsi_scan_host().  This is especially nice for 3w-xxxx, 
>>which does not support LUNs.  The device scan is a bit quicker and more 
>>direct, even if it is a tiny bit more code in the driver.
> 
> 
> if it doesn't support luns scsi_add_device sounds like the better
> interface to use.

That applies to 3w-xxxx, certainly.

I don't see a strong argument for scsi_add_device() over 
scsi_scan_target(), though.  scsi_scan_target() directly supports the 
generic struct device/class_device stuff, and supports both wildcard LUN 
scans as well as no-LUN targets.  My vague preference would be to use 
scsi_scan_target() unless there is a strong reason not to...


> How does 3x-9xxx support luns?  From reading the
> code it doesn't seem to support passthru and faking up LUNs for logical
> volumes sounds odd.

[other emails appear to have addressed this]

	Jeff


