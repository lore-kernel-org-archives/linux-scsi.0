From: Cornelia Huck <cornelia.huck@de.ibm.com>
Subject: Re: [patch 1/3] ps3: Disk Storage Driver
Date: Thu, 19 Jul 2007 11:26:02 +0200
Message-ID: <20070719112602.5e3cb21a@gondolin.boeblingen.de.ibm.com>
References: <20070716161539.075822000@pademelon.sonytel.be>
	<20070716162206.392129000@pademelon.sonytel.be>
	<20070718163637.3f0e0164.akpm@linux-foundation.org>
	<Pine.LNX.4.62.0707191039430.8661@pademelon.sonytel.be>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mtagate1.uk.ibm.com ([195.212.29.134]:52001 "EHLO
	mtagate1.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S937474AbXGSJ0F (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Jul 2007 05:26:05 -0400
In-Reply-To: <Pine.LNX.4.62.0707191039430.8661@pademelon.sonytel.be>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, Andy Whitcroft <apw@shadowen.org>, Jens Axboe <axboe@kernel.dk>, "James E.J. Bottomley" <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, Alessandro Rubini <rubini@vision.unipv.it>, linuxppc-dev@ozlabs.org, Paul Mackerras <paulus@samba.org>, Jens Axboe <jens.axboe@oracle.com>

On Thu, 19 Jul 2007 10:57:53 +0200 (CEST),
Geert Uytterhoeven <Geert.Uytterhoeven@sonycom.com> wrote:

> Were .probe()/.remove() made concurrent again? I thought that idea was dropped
> because it caused too many problems?

Well, for a given device, ->probe()/->remove() are locked by dev->sem,
so that there cannot be two probes/removes for the same device at the
same time. However, if you have multiple hotplug events pending at the
same time, it depends on your bus whether it does some serialization or
whether it allows multiple probes/removes running for different devices.
(Initial probing of a bus and probing of all devices with a new driver
is done serialized again, I think that's what you're referring to.)
