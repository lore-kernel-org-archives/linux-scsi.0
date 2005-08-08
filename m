From: Guennadi Liakhovetski <g.liakhovetski@gmx.de>
Subject: Re: atomic_kmap for PIO (was Re: Fw: Kernel panic with dc395x in
 2.6.12.2)
Date: Mon, 8 Aug 2005 21:31:37 +0200 (CEST)
Message-ID: <Pine.LNX.4.60.0508082108280.7840@poirot.grange>
References: <20050709175725.75f291bf.rdunlap@xenotime.net> <42E17451.6090706@drzeus.cx>
 <20050722153651.28d5db51.rdunlap@xenotime.net> <42E17772.3020903@drzeus.cx>
 <20050723100945.7d43d063.rdunlap@xenotime.net> <42E2933C.4050808@drzeus.cx>
 <20050723152714.4212ba52.rdunlap@xenotime.net> <42E2ECF1.8070501@drzeus.cx>
 <20050723184014.49629f9e.rdunlap@xenotime.net> <42E39462.3040007@drzeus.cx>
 <20050724100153.3e891484.rdunlap@xenotime.net> <42E565FE.4070708@drzeus.cx>
 <20050725203133.3cfa650d.rdunlap@xenotime.net> <42E6A5C3.6070501@drzeus.cx>
 <20050726202058.133382c1.rdunlap@xenotime.net> <42E964CC.5060600@drzeus.cx>
 <20050728201339.216ab3b8.rdunlap@xenotime.net> <42F37893.30006@drzeus.cx>
 <Pine.LNX.4.60.0508070003520.10832@poirot.grange> <42F5FCBF.7080902@drzeus.cx>
 <Pine.LNX.4.60.0508072214240.7539@poirot.gra! nge> <42F68C6A.1070603@cs.wisc.edu>
 <Pine.LNX.4.60.0508080112330.29811
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.gmx.de ([213.165.64.20]:30157 "HELO mail.gmx.net")
	by vger.kernel.org with SMTP id S932202AbVHHTcR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Aug 2005 15:32:17 -0400
In-Reply-To: <42F69F0A.4060108@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>
Cc: Pierre Ossman <drzeus-list@drzeus.cx>, "Randy.Dunlap" <rdunlap@xenotime.net>, oliver@neukum.name, linux-scsi@vger.kernel.org, Jens Axboe <axboe@suse.de>, James Bottomley <James.Bottomley@SteelEye.com>, Jamie Lenehan <lenehan@twibble.org>

On Sun, 7 Aug 2005, Mike Christie wrote:

> Well, iscsi too, but there is the scatterwalk code which the crypto api
> uses today and looks similar to what ide, libata, and scsi need.

Ok, I see what you mean now. Well, my impression is that one could, 
certainly, merge the 2 APIs, but this would incur overhead for both usage 
patterns: crypto traverses the list page / segment at a time, I think, 
some other block users (IDE?) would need the same; whereas the code I am 
proposing is optimised for the case when one needs just to map a few bytes 
from the sg-list, access them, and unmap.

Have I got it right? Other opinions? Perhaps, a lib/scattergather.c with 
these both APIs, and, possibly, others?

Thanks
Guennadi
---
Guennadi Liakhovetski
