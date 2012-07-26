From: Aaron Lu <aaron.lu@amd.com>
Subject: Re: [PATCH v3 2/7] scsi: pm: use autosuspend if device supports it
Date: Thu, 26 Jul 2012 20:43:32 +0800
Message-ID: <20120726124326.GA2022@localhost.localdomain>
References: <1343297129-28174-1-git-send-email-aaron.lu@amd.com>
 <1343297129-28174-3-git-send-email-aaron.lu@amd.com>
 <1476441.ovA4GKBza3@linux-lqwf.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-ide-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1476441.ovA4GKBza3@linux-lqwf.site>
Sender: linux-ide-owner@vger.kernel.org
To: Oliver Neukum <oneukum@suse.de>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Alan Stern <stern@rowland.harvard.edu>, Jeff Garzik <jgarzik@pobox.com>, Lin Ming <minggr@gmail.com>, Jeff Wu <jeff.wu@amd.com>, linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, Jul 26, 2012 at 12:44:24PM +0200, Oliver Neukum wrote:
> On Thursday 26 July 2012 18:05:24 Aaron Lu wrote:
> > If the device is using autosuspend, when scsi_autopm_put_device is
> > called for it, use autosuspend runtime pm calls instead of the sync
> > call.
> 
> What is the purpose of this approach?

The purpose is to let scsi layer driver(sd, sr, etc.) use the same pm
api(scsi_autopm_put_device) to put the device to runtime suspended
state.
When the device is ready to be suspended, if it does not make use of
autosuspend, call pm_runtime_put_sync for it; if it makes use of
autosuspend, call the autosuspend runtime pm apis for it.

> You need a very good reason to have an API do two different things
> based on this.

If you see the above reason not good, I'll prepare an updated version
to create a new api to cover the autosuspend case, something like:
void scsi_autopm_put_device_autosuspend(struct scsi_device *sdev)
{
	pm_runtime_mark_last_busy(&sdev->sdev_gendev);
	pm_runtime_put_autosuspend(&sdev->sdev_gendev);
}
Does this look right?

Thanks,
Aaron
