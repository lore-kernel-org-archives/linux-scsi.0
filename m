From: Rogier Wolff <R.E.Wolff@BitWizard.nl>
Subject: Re: aic7xxx sets CDR offline, how to reset?
Date: Wed, 4 Sep 2002 18:25:05 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020904182505.B20614@bitwizard.nl>
References: <dledford@redhat.com> <20020903171321.A12201@redhat.com> <200209032148.g83LmeP09177@localhost.localdomain> <20020904103737.GA9936@win.tue.nl> <1031138593.2788.40.camel@irongate.swansea.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1031138593.2788.40.camel@irongate.swansea.linux.org.uk>
List-Id: linux-scsi@vger.kernel.org
To: Alan Cox <alan@lxorguk.ukuu.org.uk>
Cc: Andries Brouwer <aebr@win.tue.nl>, James Bottomley <James.Bottomley@steeleye.com>, "Justin T. Gibbs" <gibbs@scsiguy.com>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, Sep 04, 2002 at 12:23:13PM +0100, Alan Cox wrote:
> On Wed, 2002-09-04 at 11:37, Andries Brouwer wrote:
> > The scsi error recovery has many bad properties, but one is its slowness.
> > Once it gets triggered on a machine with SCSI disks it is common to
> > have a dead system for several minutes. I have not yet met a situation
> > in which rebooting was not preferable above scsi error recovery,
> > especially since the attempt to recover often fails.
> 
> Well I for one prefer the scsi timeout/abort sequence on a CD getting
> confused badly by a bad block (as at least some of my drives do) to a
> reboot everytime I get bad media

Reboot is bad. Retries are bad. 

Errors should be returned to an upper layer, with an error code: "may
retry", or "will never work". (Like in SMTP)

I will most likely set the "retry count" to 0: Never retry. Almost
never works anyway. And the disk already retried manytimes, so
retrying in software is only "taking time".

We do datarecovery around here. We get bad disks on a dayly basis. We
are currently reading a drive that gets over 10Mb per second while
spitting out bad block reports!

Thing is: those blocks that didn't work first time, may work on our
second retry. However, we need userspace control over that retry. We
prefer to get the 18G worth of data off the disk first, and only then
retry the blocks that happened to be bad first time around.

			Roger.

-- 
** R.E.Wolff@BitWizard.nl ** http://www.BitWizard.nl/ ** +31-15-2137555 **
*-- BitWizard writes Linux device drivers for any device you may have! --*
* The Worlds Ecosystem is a stable system. Stable systems may experience *
* excursions from the stable situation. We are currenly in such an       * 
* excursion: The stable situation does not include humans. ***************
