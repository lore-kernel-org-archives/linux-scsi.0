From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] fix sector_div use in scsicam.c
Date: Sun, 27 Oct 2002 10:21:44 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200210271621.g9RGLik11263@localhost.localdomain>
References: <hch@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id IAA09198
	for <linux-scsi@vger.kernel.org>; Sun, 27 Oct 2002 08:21:48 -0800
In-Reply-To: Message from Christoph Hellwig <hch@lst.de>
   of "Sun, 27 Oct 2002 17:02:58 +0100." <20021027170258.A15779@lst.de>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: linux-scsi@vger.kernel.org

hch@lst.de said:
> sector_div has the same slightly strange calling convention do_div
> has: it's return value is the modulo of the two operators, the
> division result is in the first parameter.  Also optimize one of the
> expensive 64bit division away (okay, okay - it's not exactly an
> fast-path :)) 

Oops, I thought the semantics were the other way around...

> -		ip[2] = sector_div(capacity, ip[0] * ip[1]);
> +		ip[2] = capacity; 

This doesn't look right.  We updated the divisors (ip[0] and ip[1]) in the if 
statement, so surely we have to recalculate the division?

James


