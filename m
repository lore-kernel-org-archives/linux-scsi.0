From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [Bug 7026] CD/DVD burning with USB writer doesn't work
Date: Wed, 06 Dec 2006 11:57:05 -0500
Message-ID: <4576F661.2000802@torque.net>
References: <Pine.LNX.4.44L0.0612051546250.6667-100000@iolanthe.rowland.org>	 <1165355432.2785.20.camel@mulgrave.il.steeleye.com>	 <4575f6c6.RvoLkLFpmxoSf6pC%Joerg.Schilling@fokus.fraunhofer.de>	 <1165359506.2785.37.camel@mulgrave.il.steeleye.com>	 <4575fd53.ja06l7+Yx9/C/OYS%Joerg.Schilling@fokus.fraunhofer.de> <1165421548.2810.17.camel@mulgrave.il.steeleye.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pentafluge.infradead.org ([213.146.154.40]:53972 "EHLO
	pentafluge.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S936527AbWLFQ57 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Dec 2006 11:57:59 -0500
In-Reply-To: <1165421548.2810.17.camel@mulgrave.il.steeleye.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Joerg Schilling <Joerg.Schilling@fokus.fraunhofer.de>, stern@rowland.harvard.edu, schilling@fokus.fraunhofer.de, linux-scsi@vger.kernel.org, dgilbert@interlog.com

James Bottomley wrote:
> On Wed, 2006-12-06 at 00:14 +0100, Joerg Schilling wrote:
>> Well, accept the patch if it works.
> 
> It's not about work/not work: it's about correctness.
> 
>>  And in case that you don't like it, make sure that the _parameter_ is
>> moved to where it belongs: to the low level transport layer.
> 
> It's not a low level property; it's a property of the generic queue,
> namely the maximum request size.  It exists for devices independent of
> SCSI (i.e. you'll want it for IDE and weirder transport attachment CDs
> as well).

Too much smoke and mirrors.

That maximum request size comes from the transport ** and
in many cases is a kludge between maximum, optimal and
defensive. The block paradigm is wrong for a pass through
because it requests transports to guess a "maximum",
trying to head off errors that the block layer isn't
particularly well equipped to handle at run time.

On the other hand a pass through gets layered error reporting.
So if a host (and/or its LLD driver) doesn't like the
size (or shape) of data to be sent/received with a
command, then it can say so (and I don't mean EIO or
ENOMEM). That leaves the ball in the court of the pass
through user. Perhaps in this case sysfs could be
useful. The problem may be transient.


** as always the OS could have run out of resources (e.g. ram)
   but again that is most likely transient.

Doug Gilbert



