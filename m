From: Kai Makisara <Kai.Makisara@metla.fi>
Subject: Re: Possible explanation for SCSI benchmark problems in 2.5
Date: Mon, 30 Sep 2002 09:15:19 +0300 (EET DST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.OSF.4.44.0209300903070.2332-100000@abies.metla.fi>
References: <200209300340.g8U3eob03613@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <200209300340.g8U3eob03613@localhost.localdomain>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: andmike@us.ibm.com, linux-scsi@vger.kernel.org, Andrew Morton <akpm@digeo.com>, Jens Axboe <axboe@suse.de>

On Sun, 29 Sep 2002, James Bottomley wrote:

> andmike@us.ibm.com said:
> > I thought this was previously discussed on this thread. http://
> > marc.theaimsgroup.com/?l=linux-kernel&m=103064539622958&w=2
>
> I remember the thread (well now that my memory's been refreshed).
>
> > and I believe the comment from Jens was that this could be killed off
> > in 2.5 if someone did a check for safety on all the devices.
>
> I'm not really an expert in st, which is where it looks like the problems are.
>  On cursory reading of the code, I think the st driver does dio only if all
> pages are below the HIGHMEM zone, otherwise it does intermediate buffering.
> Thus, the st driver will never put anything in the highmem zone in the queue
> and Andrew Morton's version should be fine.
>
St does direct i/o if all pages are directly addressable by the SCSI
adapter (based on the mask). The pages may be in the HIGHMEM zone but
Andrew Morton's change is safe. In fact, st already uses the logic enabled
by the change. (As far as I was able to follow the code, the SCSI requests
sent by st never actually use any code affected by Andrew's change.)

	Kai

