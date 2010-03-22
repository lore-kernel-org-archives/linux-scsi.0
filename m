From: Mike Hayward <hayward@loup.net>
Subject: Re: [PATCH] sg: retrofit SG_FLAG_Q_AT_TAIL flag
Date: Mon, 22 Mar 2010 01:39:28 -0600
Message-ID: <201003220739.o2M7dSdS002818@alien.loup.net>
References: <4BA51EB6.5040401@interlog.com> <4BA604D8.9090604@panasas.com> <4BA65DC1.2020102@interlog.com>
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from tenax.loup.net ([209.169.16.66]:56052 "EHLO tenax.loup.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751699Ab0CVItW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Mar 2010 04:49:22 -0400
In-reply-to: <4BA65DC1.2020102@interlog.com> (message from Douglas Gilbert on
	Sun, 21 Mar 2010 13:56:17 -0400)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: bharrosh@panasas.com, James.Bottomley@suse.de, linux-scsi@vger.kernel.org, mh-linux-kernel@loup.net

Hi Doug,

 > Now I decided to check the SG_IO ioctl used directly
 > against block devices and it calls:
 >     blk_execute_rq(q, bd_disk, rq, 0);
 > 
 > The last argument is 'at_head' so it has been queuing
 > at_tail for some time. How is that for compatibility??
 > 
 > That almost suggests there should be a
 >    #define SG_FLAG_Q_AT_HEAD 0x20
 > 
 > added to sg.h to cover all the bases.

I would have to agree that default should be queue at tail and option
should be to queue at head since that presents risk of starvation and
is generally not what is desired, just like normal SCSI queue at head
in the target.

I'll give your patch a spin on live hardware soon.

- Mike
