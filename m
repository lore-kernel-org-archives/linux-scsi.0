From: Doug Ledford <dledford@redhat.com>
Subject: Re: aic7xxx_biosparam
Date: Sun, 17 Nov 2002 21:47:54 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021118024754.GC4608@redhat.com>
References: <20021118002742.GO3280@redhat.com> <20021118004341.GA1943@win.tue.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20021118004341.GA1943@win.tue.nl>
List-Id: linux-scsi@vger.kernel.org
To: Andries Brouwer <aebr@win.tue.nl>
Cc: Linux Scsi Mailing List <linux-scsi@vger.kernel.org>

On Mon, Nov 18, 2002 at 01:43:41AM +0100, Andries Brouwer wrote:
> 
> Yes. But note: the number of cylinders (i) is totally immaterial,
> (ii) is returned in a short, the only place where it is used.
> Thus, computing values larger than 65535 is undesired, they will
> be truncated later.

That is a bit of information I was looking for.  I figured it would get 
truncated somewhere (or worse, wrap), and I wanted to know where that 
might be.

> That is why you can replace this strange
> 
> > +    while( capacity >= (cylinders * sectors * heads))
> > +      cylinders++;
> > +    cylinders--;
> 
> by a test like:
> 
> 	if (capacity > 65535 * sectors * heads)
> 		cylinders = 65535;
> 	else
> 		cylinders = ((unsigned int) capacity) / (sectors * heads);

Thanks, I'll do that.

-- 
  Doug Ledford <dledford@redhat.com>     919-754-3700 x44233
         Red Hat, Inc. 
         1801 Varsity Dr.
         Raleigh, NC 27606
  
