From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: sg driver and Fedora Core 2
Date: Sat, 29 May 2004 13:27:58 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <40B8C81E.3050106@pobox.com>
References: <40B74725.90403@torque.net>	<20040528172535.GD13961@devserv.devel.redhat.com>	<1085846125.2101.29.camel@mulgrave>	<20040529155744.GA32621@devserv.devel.redhat.com>	<1085846840.2103.47.camel@mulgrave> 	<20040529162912.GA5922@devserv.devel.redhat.com> <1085849399.2004.101.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from parcelfarce.linux.theplanet.co.uk ([195.92.249.252]:64467 "EHLO
	www.linux.org.uk") by vger.kernel.org with ESMTP id S264301AbUE2R2M
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 May 2004 13:28:12 -0400
In-Reply-To: <1085849399.2004.101.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: SCSI Mailing List <linux-scsi@vger.kernel.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, Alan Cox <alan@redhat.com>, Douglas Gilbert <dougg@torque.net>, Arjan van de Ven <arjanv@redhat.com>, Jens Axboe <axboe@suse.de>

Really what needs to happen is a generic userland tap attaches to a 
chrdev, issues an ioctl(2) to attach to a request_queue, and then does 
read(2)/write(2)/mmap(2) to communicate with the request_queue.

:)

Call it /dev/bsg, or somesuch.

The SG_IO ioctl won't work for all cases, since some block devices may 
rightly wish to limit (or block) multiple openers on the blkdev itself. 
   OTOH, the SG_IO ioctl does eliminate the userland app needing to 
worry about _any_ target/addressing information, since that is implicit 
in the dentry pointing to the blkdev's inode.

	Jeff



