From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: sg driver and Fedora Core 2
Date: 29 May 2004 12:38:18 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1085852299.2004.206.camel@mulgrave>
References: <40B74725.90403@torque.net>	<20040528172535.GD13961@devserv.devel.redhat.com
	>	<1085846125.2101.29.camel@mulgrave>	<20040529155744.GA32621@devserv.devel.
	redhat.com>	<1085846840.2103.47.camel@mulgrave>
		<20040529162912.GA5922@devserv.devel.redhat.com>
	<1085849399.2004.101.camel@mulgrave>  <40B8C81E.3050106@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:39622 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S264515AbUE2Ris (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 29 May 2004 13:38:48 -0400
In-Reply-To: <40B8C81E.3050106@pobox.com>
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jgarzik@pobox.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Alan Cox <alan@redhat.com>, Douglas Gilbert <dougg@torque.net>, Arjan van de Ven <arjanv@redhat.com>, Jens Axboe <axboe@suse.de>

On Sat, 2004-05-29 at 12:27, Jeff Garzik wrote:
> Really what needs to happen is a generic userland tap attaches to a 
> chrdev, issues an ioctl(2) to attach to a request_queue, and then does 
> read(2)/write(2)/mmap(2) to communicate with the request_queue.
> 
> :)
> 
> Call it /dev/bsg, or somesuch.

Well, this touches on something else I'm thinking about: lazy
attachment.  In multi thousand disc environments, you don't want us
wasting resources allocating a queue and reading a partition table for
all of them; you really only want to do that for the devices you're
actually going to use.  Once we have this, I think dual attachment will
be a dead issue.

> The SG_IO ioctl won't work for all cases, since some block devices may 
> rightly wish to limit (or block) multiple openers on the blkdev itself. 
>    OTOH, the SG_IO ioctl does eliminate the userland app needing to 
> worry about _any_ target/addressing information, since that is implicit 
> in the dentry pointing to the blkdev's inode.

Yes, the mapping issues is the huge problem where users keep shooting
themselves in the foot.

James


