From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: LUN resizing
Date: 25 Nov 2003 09:43:02 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1069774983.2061.28.camel@mulgrave>
References: <1069708054.26088.127.camel@lt-sv>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nat9.steeleye.com ([65.114.3.137]:59908 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S262750AbTKYPnL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Nov 2003 10:43:11 -0500
In-Reply-To: <1069708054.26088.127.camel@lt-sv>
List-Id: linux-scsi@vger.kernel.org
To: Stefan Voelkel <Stefan.Voelkel@millenux.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Tue, 2003-11-25 at 03:34, Stefan Voelkel wrote:
> I have a Linux box connected to a Fibre SAN. Now I'd like to resize one
> LUN and tell my Linux box what happened. In other words can I _live_
> resize a SCSI disk?
> 
>         [ let's not talk about which filesystems are capable of live
>         resizing :) ]
>         
>       * Is this possible at all, eg does the SCSI Standard include
>         something to enable a device to tell the host about the changed
>         geometry (SENSE DATA, ...) ?

The pull command is READ_CAPACITY.  For pushing this information,
there's nothing really standard, although some type of proprietary AEN
could be adapted.

>       * Is it possible with Linux, eg does the block layer/scsi layer
>         support it? any problems with the partition code?
>       * If there are problems, are they solveable, any plans on working
>         on them or is already someone working on this?

You simply do

echo 1 > /sys/bus/scsi/<device>/rescan

It will re-read the capacity and partition table (as long as the device
is unmounted and none of the partitions open).

James


