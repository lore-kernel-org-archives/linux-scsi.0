From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [RFC] How to implement linux_block commands in scsi midlayer
Date: Mon, 19 Feb 2007 10:07:46 -0600
Message-ID: <1171901266.3385.15.camel@mulgrave.il.steeleye.com>
References: <87abzcxur6.fsf@denkblock.local>  <45D7D24B.4080802@torque.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:36037 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S932375AbXBSQHv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 19 Feb 2007 11:07:51 -0500
In-Reply-To: <45D7D24B.4080802@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org, Jens Axboe <Jens.Axboe@oracle.com>

On Sat, 2007-02-17 at 23:12 -0500, Douglas Gilbert wrote:
> IOW don't do it!
> 
> Better would be to flag the request for internal use.

This would be my opinion too.  We're trying to move away from
encapsulated commands wherever we can (although we're definitely not
there yet).

The idea is that the block layer would be able to transport native
commands to underlying devices.  However, we were also thinking of
adding control packets that could be interpreted by the processing ULD
(as park essentially is, since it's a state in the disk management
model).  However, realistically, you don't ever send a command to park a
disk ... this won't be beneficial during most times of operation ... you
really want expose the power states and management so the OS can use
them as part of its model ... Tejun already has the beginnings of a
patch to do this.

James


