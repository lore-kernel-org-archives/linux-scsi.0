From: Jens Axboe <jens.axboe@oracle.com>
Subject: Re: [patch 3/3] Enable Aggressive Link Power management for AHCI
	controllers.
Date: Fri, 22 Jun 2007 21:00:00 +0200
Message-ID: <20070622190000.GK30033@kernel.dk>
References: <20070611184146.448266229@intel.com> <20070620142342.404856fe.kristen.c.accardi@intel.com> <20070621130831.GN18863@kernel.dk> <20070622101509.16d0e93d.kristen.c.accardi@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20070622101509.16d0e93d.kristen.c.accardi@intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: jeff@garzik.org, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, htejun@gmail.com, arjan@linux.intel.com
List-Id: linux-scsi@vger.kernel.org

On Fri, Jun 22 2007, Kristen Carlson Accardi wrote:
> On Thu, 21 Jun 2007 15:08:32 +0200
> Jens Axboe <jens.axboe@oracle.com> wrote:
> 
> > On Wed, Jun 20 2007, Kristen Carlson Accardi wrote:
> > > Enable Aggressive Link Power management for AHCI controllers.
> > > 
> > > This patch will set the correct bits to turn on Aggressive
> > > Link Power Management (ALPM) for the ahci driver.  This
> > > will cause the controller and disk to negotiate a lower
> > > power state for the link when there is no activity (see
> > > the AHCI 1.x spec for details).  This feature is mutually
> > > exclusive with Hot Plug, so when ALPM is enabled, Hot Plug
> > > is disabled.  ALPM will be enabled by default, but it is
> > > settable via the scsi host syfs interface.  Possible 
> > > settings for this feature are:
> > > 
> > > Setting		Effect
> > > ----------------------------------------------------------
> > > min_power	ALPM is enabled, and link set to enter 
> > > 		lowest power state (SLUMBER) when idle
> > > 		Hot plug not allowed.
> > > 
> > > max_performance	ALPM is disabled, Hot Plug is allowed
> > > 
> > > medium_power	ALPM is enabled, and link set to enter
> > > 		second lowest power state (PARTIAL) when
> > > 		idle.  Hot plug not allowed.
> > > 
> > > Signed-off-by:  Kristen Carlson Accardi <kristen.c.accardi@intel.com>
> > 
> > A suggestion (it comes with a patch!) - default to max_power/almp off,
> > not min_power. For two reasons:
> > 
> > - There's such a big performance difference between the two, you really
> >   want max_power when booting.
> > 
> > - It's a lot better to default to no change, than default to enabling
> >   something new.
> 
> Sounds reasonable to me.  Distros/users can decide if they want to have
> scripts that enable this after boot to run at min_power. 

Exactly, it needs to be handled by some power management daemon anyway
and be integrated with power savings in general. You could use io load
to determine when to enable/disable alpm, for instance.

> Acked-by: Kristen Carlson Accardi <kristen.c.accardi@intel.com>

Will you integrate it into the next posting?

-- 
Jens Axboe

