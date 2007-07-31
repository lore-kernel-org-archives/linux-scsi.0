From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Subject: Re: [patch 2/4] Expose Power Management Policy option to users
Date: Tue, 31 Jul 2007 09:30:14 -0700
Message-ID: <20070731093014.db9e0734.kristen.c.accardi@intel.com>
References: <20070705194909.337398431@intel.com>
	<20070705130518.135e4e3c.kristen.c.accardi@intel.com>
	<46AE12B6.6090408@garzik.org>
	<46AED656.8070407@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <46AED656.8070407@gmail.com>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: Jeff Garzik <jeff@garzik.org>, James.Bottomley@steeleye.com, linux-scsi@vger.kernel.org, akpm@linux-foundation.org, linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org, edwintorok@gmail.com, axboe@kernel.dk
List-Id: linux-scsi@vger.kernel.org

On Tue, 31 Jul 2007 15:27:34 +0900
Tejun Heo <htejun@gmail.com> wrote:

> Jeff Garzik wrote:
> > Any chance the SCSI peeps could ACK this, and then let me include it in
> > the ALPM patchset in the libata tree?
> 
> ATA link PS is pretty complex with HIPM, DIPM and AHCI ALPM.  I'm not
> sure whether this three level knob would be sufficient.  It might be
> good enough if we're gonna develop extensive in-kernel black/white list
> specifying which method works on which combination but my gut tells me
> that it's best left to userland (probably in the form of per-notebook PS
> profile).

I think what you are saying is that you'd like a way to use your HIPM
and DIPM without ALPM on the AHCI driver.  Fine - it's really easy
to add these levels later - if they don't make sense at the sysfs interface
we can add module params to specify the definition of "min_power" as 
being performed via HIPM and DIPM instead of ALPM - although as of yet we
have no evidence what so ever that this method actually adds value over
ALPM.

> 
> Adding to the fun, there are quite a few broken devices out there which
> act weirdly when link PS actions are taken.

OK - this is why I added the blacklist for this feature.

> 
> Also, I generally don't think AHCI ALPM is a good idea.  It doesn't have
> 'cool down' period before entering PS state which unnecessarily hampers
> performance and might increase chance of device malfunction.

"might increase"?  How about some actual examples of where you've shown
this to be a problem?  I can assert that I think ALPM is a good idea,
because I've never had a report of it causing problems.  Windows has 
been using this feature for a very long time - and you have to admit that
they have a pretty large market share.  Nobody is complaining about ALPM
increasing device malfunction, so unless you have proof it seems insane
to nak due to this. 
