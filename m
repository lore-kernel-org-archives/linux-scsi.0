From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH v7 0/6] ZPODD patches
Date: Wed, 19 Sep 2012 13:27:47 +0100
Message-ID: <1348057667.2479.33.camel@dabdike.int.hansenpartnership.com>
References: <1347438597-5903-1-git-send-email-aaron.lu@intel.com>
	 <20120919080328.GA4283@mint-spring.sh.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-acpi-owner@vger.kernel.org>
In-Reply-To: <20120919080328.GA4283@mint-spring.sh.intel.com>
Sender: linux-acpi-owner@vger.kernel.org
To: Aaron Lu <aaron.lu@intel.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Oliver Neukum <oliver@neukum.org>, Jeff Garzik <jgarzik@pobox.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2012-09-19 at 16:03 +0800, Aaron Lu wrote:
> Hi James,
> 
> May I know if this patchset will enter v3.7?

Sigh, well, I was hoping to persuade the PM people to sort this out
first.

The first observation is that all this looks to be too specific.  ZPO
may be ACPI specific, but the property it abstracts: whether the
particular device is powered off or not is generic and probably should
be known at the generic PM level.  Nothing actually really cares about
how we power off the device until you get all the way down to the ACPI
controller.

I think we could do this with a couple of flags sitting inside struct
device itself: one for pm state and capabilities defined at a generic
level and one for device specific pm state.  The latter would be for
things like the door lock information which is very specific to CDs
(although not specific to SCSI CDs).  Alternatively, even if we can't
use these capabilities at the generic pm level, we still need an
internal state set of flags because power state stuff traverses the
stack and struct device is the only universal object in that stack.

So I definitely think all of the sdev flags should become either generic
or specific flags in device.

James


