From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [PATCH] reduce stack in qlogicfc.c
Date: Wed, 12 Mar 2003 01:38:26 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030312093826.GA5322@beaverton.ibm.com>
References: <3E6ECFAD.A4363F5E@verizon.net> <20030312072049.GA2428@beaverton.ibm.com> <20030312005220.637494ae.akpm@digeo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20030312005220.637494ae.akpm@digeo.com>
List-Id: linux-scsi@vger.kernel.org
To: Andrew Morton <akpm@digeo.com>
Cc: randy.dunlap@verizon.net, linux-scsi@vger.kernel.org, mjacob@feral.com

Andrew Morton [akpm@digeo.com] wrote:
> Mike Anderson <andmike@us.ibm.com> wrote:
> >
> > Randy.Dunlap [randy.dunlap@verizon.net] wrote:
> > > Can anyone suggest way(s) to have the isp2x00_make_portdb() function
> > > called over and over again until it gets its job done?
> > > Or does anyone even still use this driver?
> > 
> > We have been using the Feral as it covers both Qlogic SCSI and FC cards
> > (both 2200 and 2300 series, the qlogicfc only handles 2200). I believe
> > Andrew Morton is carrying the driver in the mm series of patches.
> > 
> 
> Does it work?   After an initial spurt of not-so-hot testing reports
> everything went quiet and I'd assumed people had given up on it
> for the while.

No we have not given up. It works, but we still have the outstanding
issue that we can overdrive the card do to the combination of can_queue,
device queue_depth and the ring size allocated for the card. A longer
term fix is need for this which Matthew is aware of. In the short term
some adjustments of these values will reduce the number of requeues that
are happening and also keep the SCSI error handler for firing for
timeouts.

-andmike
--
Michael Anderson
andmike@us.ibm.com

