From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH RFC 0/4] use scatter lists for all block pc requests	and
 simplify hw handlers
Date: Wed, 08 Jun 2005 13:00:45 +1000
Message-ID: <42A65F5D.6060805@torque.net>
References: <1117847972.23638.62.camel@mina> <20050607180716.GA8172@suse.de> <1118173118.4791.17.camel@mulgrave>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zorg.st.net.au ([203.16.233.9]:56220 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S262078AbVFHDAZ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Jun 2005 23:00:25 -0400
In-Reply-To: <1118173118.4791.17.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Jens Axboe <axboe@suse.de>, Mike Christie <michaelc@cs.wisc.edu>, linux-scsi <linux-scsi@vger.kernel.org>, Kai.Makisara@kolumbus.fi

James Bottomley wrote:
> On Tue, 2005-06-07 at 20:07 +0200, Jens Axboe wrote:
> 
>>I've slowly been doing the same thing in other places in the kernel and
>>this bit has been talked about between James and I for at least a year
>>or two.
> 
> 
> Yes, it's long been a dream of mine to eliminate at least struct
> scsi_request and just use block struct request for everything in the
> SCSI layer.
> 
> The most pleasing aspect of this will be getting rid of the dma mapping
> duplications in st and sg.

James,
A "char_uld" library that st, sg, ch and the proposed OSD
ULDs could tap into, would cut the duplication. As you can
see, Kai and I have shared implementations in this area but
had no mechanism for sharing the actual code.

An idea I had was to flag what mechanism inserted a
command onto a request queue and when a blk_pc_request()
follows a blk_pc_request() then use FIFO order for
the second one.

Doug Gilbert
