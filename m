From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [RFC][PATCH] allow sleep inside EH hooks
Date: Fri, 27 May 2005 13:04:49 -0400
Message-ID: <1117213489.5035.30.camel@mulgrave>
References: <4296A2C7.4090107@pobox.com>
	 <20050527071109.GB27256@infradead.org> <4296D0D8.6030907@pobox.com>
	 <20050527075924.GA28608@infradead.org> <4296DC0B.9060802@pobox.com>
	 <42974E19.9040007@adaptec.com>  <42974F95.6010603@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:429 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262505AbVE0RFB (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 27 May 2005 13:05:01 -0400
In-Reply-To: <42974F95.6010603@pobox.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: Luben Tuikov <luben_tuikov@adaptec.com>, Christoph Hellwig <hch@infradead.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, 2005-05-27 at 12:49 -0400, Jeff Garzik wrote:
> I'm also curious to see what others think about removing the host_lock 
> acquisition from ->queuecommand() calls.

Personally I don't see the need for it for two reasons:

1) There are certain atomic ops in the mid layer issue that necessitate
we acquire it anyway (serial number generation and state model checking)
2) All queuecommand routines should move to the model of either issuing
or rejecting the command ... if they do that, often there's no need for
the mucking with lock, they remain locked throughout.

On point 2), look at the changes to the aic7xxx driver.  Once its
internal issue queueing was pulled out, it no longer needs to muck with
the host lock in ahc_linux_queue.  If you don't enter this locked, it
would just have to take it at the top and release it before return, as
would most other well written drivers.

James


