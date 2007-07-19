From: Cornelia Huck <cornelia.huck@de.ibm.com>
Subject: Re: [patch 1/3] ps3: Disk Storage Driver
Date: Thu, 19 Jul 2007 14:00:38 +0200
Message-ID: <20070719140038.606abd44@gondolin.boeblingen.de.ibm.com>
References: <20070716161539.075822000@pademelon.sonytel.be>
	<20070716162206.392129000@pademelon.sonytel.be>
	<20070718163637.3f0e0164.akpm@linux-foundation.org>
	<Pine.LNX.4.62.0707191039430.8661@pademelon.sonytel.be>
	<20070719112602.5e3cb21a@gondolin.boeblingen.de.ibm.com>
	<Pine.LNX.4.62.0707191132150.8661@pademelon.sonytel.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate8.uk.ibm.com ([195.212.29.141]:53238 "EHLO
	mtagate8.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757384AbXGSMAe (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Jul 2007 08:00:34 -0400
In-Reply-To: <Pine.LNX.4.62.0707191132150.8661@pademelon.sonytel.be>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Andy Whitcroft <apw@shadowen.org>, Jens Axboe <axboe@kernel.dk>, "James E.J. Bottomley" <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org, Linux Kernel Development <linux-kernel@vger.kernel.org>, Linux/PPC Development <linuxppc-dev@ozlabs.org>, Paul Mackerras <paulus@samba.org>, Jens Axboe <jens.axboe@oracle.com>

On Thu, 19 Jul 2007 11:36:31 +0200 (CEST),
Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com> wrote:

> We have a probe thread that checks for new storage devices and adds them to the
> bus with ps3_system_bus_device_register(), which calls device_register().
> 
> I guess the actual bus probe() routine gets called through the notifier call
> chain? That's where I got lost...

No, ->probe() is called from device_register() directly. If you just
have one probe thread, you should have enough serialization.

(Unless you're doing something interesting from the bus_notifier, which
is called via the notifier chain before ->probe()...)
