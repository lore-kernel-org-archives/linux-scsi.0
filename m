From: Aaron Lu <aaron.lu@intel.com>
Subject: Re: [PATCH v2 1/4] scsi: introduce sync_before_stop flag
Date: Tue, 18 Sep 2012 15:47:49 +0800
Message-ID: <20120918074748.GA1696@mint-spring.sh.intel.com>
References: <1347951631-1592-1-git-send-email-aaron.lu@intel.com>
 <1347951631-1592-2-git-send-email-aaron.lu@intel.com>
 <1676757.rqQnA7IDdg@linux-lqwf.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1676757.rqQnA7IDdg@linux-lqwf.site>
Sender: linux-ide-owner@vger.kernel.org
To: Oliver Neukum <oneukum@suse.de>
Cc: Alan Stern <stern@rowland.harvard.edu>, Jeff Garzik <jgarzik@pobox.com>, James Bottomley <James.Bottomley@hansenpartnership.com>, Aaron Lu <aaron.lwe@gmail.com>, Jack Wang <jack_wang@usish.com>, Shane Huang <shane.huang@amd.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Tue, Sep 18, 2012 at 09:30:11AM +0200, Oliver Neukum wrote:
> On Tuesday 18 September 2012 15:00:28 Aaron Lu wrote:
> > When scsi device received stop command, it will take care of its
> > internal cache before enters stopped power condition. This command is
> > translated to standby immediate in libata-scsi, but standby doesn't
> > imply flush cache for ATA device, so to issue stop command to ATA
> > device, an additional flush cache has to be issued.
> 
> Why not just set WCE?

This flag is used for devices whose WCE bit is set.

This flag means, when we are to issue a scsi stop command, we need to
issue an additional sync cache command first.

For scsi device, per the spec, there is no such need as the device will
take care of its internal cache when going to stop power condition.

But for ata device, the stop command is translated to standby immediate,
and we have to flush the internal cache before enter standby.

-Aaron
