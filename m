From: Andries Brouwer <aebr@win.tue.nl>
Subject: Re: aic7xxx_biosparam
Date: Mon, 18 Nov 2002 01:43:41 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20021118004341.GA1943@win.tue.nl>
References: <20021118002742.GO3280@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wsdw14.win.tue.nl (wsdw14.win.tue.nl [131.155.69.207])
	by mailhost.tue.nl (8.12.3/8.12.3) with ESMTP id gAI0hfcA23947996
	for <linux-scsi@vger.kernel.org>; Mon, 18 Nov 2002 01:43:41 +0100 (MET)
Received: (from aebr@localhost)
	by wsdw14.win.tue.nl (8.12.6/8.12.3) id gAI0hfkS001949
	for linux-scsi@vger.kernel.org; Mon, 18 Nov 2002 01:43:41 +0100 (MET)
Content-Disposition: inline
In-Reply-To: <20021118002742.GO3280@redhat.com>
List-Id: linux-scsi@vger.kernel.org
To: Linux Scsi Mailing List <linux-scsi@vger.kernel.org>

On Sun, Nov 17, 2002 at 07:27:42PM -0500, Doug Ledford wrote:

> So, this is the change I made to update it so that it won't puke on large 
> devices.  It seems to be working OK for me, but I didn't check the gcc 
> assembly output to see if it's horrible.  Unless someone tells me I'm 
> smoking crack for making this change, I'll submit it pretty soon (I don't 
> consider myself a partition expert, I'm just trying to make sure that when 
> geometry does get defined on my driver that it at least is something the 
> Adaptec BIOS will accept, and the Adaptec BIOS *only* accepts the two 
> listed head/sector combos).

Yes. But note: the number of cylinders (i) is totally immaterial,
(ii) is returned in a short, the only place where it is used.
Thus, computing values larger than 65535 is undesired, they will
be truncated later.

That is why you can replace this strange

> +    while( capacity >= (cylinders * sectors * heads))
> +      cylinders++;
> +    cylinders--;

by a test like:

	if (capacity > 65535 * sectors * heads)
		cylinders = 65535;
	else
		cylinders = ((unsigned int) capacity) / (sectors * heads);


Andries
