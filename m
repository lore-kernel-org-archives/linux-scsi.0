From: Oliver Neukum <oneukum@suse.de>
Subject: Re: [PATCH v7 2/6] scsi: sr: support runtime pm
Date: Tue, 25 Sep 2012 16:23:38 +0200
Message-ID: <1627578.tkYE3uqGuq@linux-lqwf.site>
References: <1347438597-5903-1-git-send-email-aaron.lu@intel.com> <201209251347.52407.rjw@sisk.pl> <20120925142020.GA3653@mint-spring.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:37008 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752138Ab2IYOZR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 25 Sep 2012 10:25:17 -0400
In-Reply-To: <20120925142020.GA3653@mint-spring.sh.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Aaron Lu <aaron.lu@intel.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Alan Stern <stern@rowland.harvard.edu>, James Bottomley <James.Bottomley@hansenpartnership.com>, Jeff Garzik <jgarzik@pobox.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>

On Tuesday 25 September 2012 22:20:21 Aaron Lu wrote:
> On Tue, Sep 25, 2012 at 01:47:52PM +0200, Rafael J. Wysocki wrote:
> > On Tuesday, September 25, 2012, Aaron Lu wrote:
> > > I'm thinking of enabling this GPE in sr_suspend once we decided that it
> > > is ready to be powered off, so the time frame between sr_suspend and
> > > when the power is actually removed in libata should be taken care of by
> > > the GPE. If GPE fires, the notification function will request a runtime
> > > resume of the device. Does this sound OK?
> > 
> > Well, depending on the implementation.  sr_suspend() should be rather
> > generic, but the ACPI association (including the GPE thing) is specific to ATA.
> 
> Sorry, but don't quite understand this.
> 
> We have ACPI bindings for scsi devices, isn't that for us to use ACPI
> when needed in scsi?

We don't have ACPI bindings for generic SCSI devices. We have such
bindings for SATA drives. You can put such things only in sr if it applies
to all (maybe most) types of drives.

> BTW, if sr_suspend should be generic, that would suggest I shouldn't
> write any ZPODD related code there, right? Any suggestion where these
> code should go then?

libata. Maybe some generic hooks can be called in sr_suspend().

	Regards
		Oliver

PS: Are you sure sr_suspend() handles DVD-RAMs correctly?

