From: Jeff Garzik <jeff@garzik.org>
Subject: Re: [patch] scsi: use lock per host instead of per device for shared
 queue tag host
Date: Thu, 25 Jan 2007 20:21:01 -0500
Message-ID: <45B9577D.9000302@garzik.org>
References: <B70A50D07063384EB9BCE3330D18414F02F5B011@nonameb.ptu.promise.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from srv5.dvmed.net ([207.36.208.214]:41553 "EHLO mail.dvmed.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1030559AbXAZBVM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 25 Jan 2007 20:21:12 -0500
In-Reply-To: <B70A50D07063384EB9BCE3330D18414F02F5B011@nonameb.ptu.promise.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ed Lin <ed.lin@promise.com>
Cc: Jens Axboe <jens.axboe@oracle.com>, David Somayajulu <david.somayajulu@qlogic.com>, Michael Reed <mdr@sgi.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>, "james.Bottomley" <james.Bottomley@SteelEye.com>, Promise_Linux <Promise_Linux@promise.com>

Ed Lin wrote:
> There may possibly be some other errors. So we need a lock here.
> I think the simple but reliable way to do it is just to replace
> queue lock with a host lock. James pointed out that there may be
> performance slow down when many devices are accessed at the
> same time. But I think the major part is still on the hardware,
> and a host lock is the price these kind of controllers must pay.


I agree.

Further, a host lock is (a) common across many controllers, to protect 
host-wide resources and (b) only limits us when the controller is 
CPU-limited, a very rare scenario.

	Jeff


