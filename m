From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH scsi-misc-2.6 07/08] scsi: remove bogus
	{get|put}_device() calls
Date: Tue, 22 Mar 2005 22:15:55 -0600
Message-ID: <1111551355.5520.100.camel@mulgrave>
References: <20050323021335.960F95F8@htj.dyndns.org>
	 <20050323021335.0D9E25EE@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Received: from stat16.steeleye.com ([209.192.50.48]:15591 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262760AbVCWEP7 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 22 Mar 2005 23:15:59 -0500
In-Reply-To: <20050323021335.0D9E25EE@htj.dyndns.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: Jens Axboe <axboe@suse.de>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>

On Wed, 2005-03-23 at 11:14 +0900, Tejun Heo wrote:
> 	So, basically, SCSI high-level object (scsi_disk) and
> 	mid-level object (scsi_device) are reference counted by users,
> 	not the requests they submit.  Reference count cannot go zero
> 	with active users and users cannot access the object once the
> 	reference count reaches zero.

Actually, no.  Unfortunately we still have some fire and forget APIs, so
the contention that we always have an open refcounted descriptor isn't
always true.

James


