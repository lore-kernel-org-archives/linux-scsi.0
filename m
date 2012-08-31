From: Alan Stern <stern@rowland.harvard.edu>
Subject: Re: [PATCH v5 0/7] ZPODD patches
Date: Fri, 31 Aug 2012 13:10:59 -0400 (EDT)
Message-ID: <Pine.LNX.4.44L0.1208311308060.1328-100000@iolanthe.rowland.org>
References: <20120831154306.GA1427@localhost.localdomain>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <20120831154306.GA1427@localhost.localdomain>
Sender: linux-acpi-owner@vger.kernel.org
To: Aaron Lu <aaron.lwe@gmail.com>
Cc: Aaron Lu <aaron.lu@intel.com>, James Bottomley <James.Bottomley@HansenPartnership.com>, Jeff Garzik <jgarzik@pobox.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 31 Aug 2012, Aaron Lu wrote:

> > In patch 5/7, your implementation of may_power_off is written in such a
> > way that if the drive is already powered off when userspace clears the
> > flag, the drive is not automatically powered back on.  Maybe this is
> > what you want?
> 
> No, actually I didn't consider this.
> 
> What about I do this when may_power_off is set to 0:
> In its store function, if the device is runtime suspended(which means it
> is in powered off state since may_power_off was 1 before this store call)
> I'll set the flag to 0 and then runtime resume this device.

You might also want to runtime resume the device if may_power_off is
changed from 0 to 1.  Then it will power down when it suspends again
instead of just remaining powered up.

Alan Stern

