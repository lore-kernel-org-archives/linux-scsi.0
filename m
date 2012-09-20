From: "Rafael J. Wysocki" <rjw@sisk.pl>
Subject: Re: [PATCH v7 0/6] ZPODD patches
Date: Thu, 20 Sep 2012 22:00:51 +0200
Message-ID: <201209202200.51303.rjw@sisk.pl>
References: <1347438597-5903-1-git-send-email-aaron.lu@intel.com> <201209191450.37735.rjw@sisk.pl> <5059D488.6070208@intel.com>
Mime-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <5059D488.6070208@intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: Aaron Lu <aaron.lu@intel.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, Alan Stern <stern@rowland.harvard.edu>, Oliver Neukum <oliver@neukum.org>, Jeff Garzik <jgarzik@pobox.com>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-acpi@vger.kernel.org, linux-pm@vger.kernel.org, Aaron Lu <aaron.lwe@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Wednesday, September 19, 2012, Aaron Lu wrote:
> On 09/19/2012 08:50 PM, Rafael J. Wysocki wrote:
> > On Wednesday, September 19, 2012, James Bottomley wrote:
> >> On Wed, 2012-09-19 at 16:03 +0800, Aaron Lu wrote:
> >>> Hi James,
> >>>
> >>> May I know if this patchset will enter v3.7?
> >>
> >> Sigh, well, I was hoping to persuade the PM people to sort this out
> >> first.
> >>
> >> The first observation is that all this looks to be too specific.  ZPO
> >> may be ACPI specific, but the property it abstracts: whether the
> >> particular device is powered off or not is generic and probably should
> >> be known at the generic PM level.  Nothing actually really cares about
> >> how we power off the device until you get all the way down to the ACPI
> >> controller.
> >>
> >> I think we could do this with a couple of flags sitting inside struct
> >> device itself: one for pm state and capabilities defined at a generic
> >> level and one for device specific pm state.  The latter would be for
> >> things like the door lock information which is very specific to CDs
> >> (although not specific to SCSI CDs).  Alternatively, even if we can't
> >> use these capabilities at the generic pm level, we still need an
> >> internal state set of flags because power state stuff traverses the
> >> stack and struct device is the only universal object in that stack.
> >>
> >> So I definitely think all of the sdev flags should become either generic
> >> or specific flags in device.
> > 
> > Well, the problem is that it is kind of irrelevant to the core whether or
> > not the given device can be powered off.  Moreover, the actual meaning of
> > what "power off" means depends on the platform (it may be an individual device
> > state or a power domain state, for instance).  Also, the set of available
> > low-power states depends on the platform (or the bus type) and generally
> > cannot be universally represented and there are low-power states that
> > aren't "power off" per se, but still require the device state to be
> > restored when putting it back into full power.
> > 
> > We've discussed that for a few times and each time we've ended up agreeing
> > that struct device is not the right place to store this information (for
> > example, PCI stores it in struct pci_dev, USB has its own rules etc.).
> > 
> > I'll have a look at the patchset again and see what can be done about this.
> 
> Thanks Rafael, and if there is any question/problem,
> please kindly let me know.

Well, unfortunately my initial review indicates that the patchset is not
quite ready to go upstream yet.

I'll send comments in replies to the individual patches, but overall I can
say that at this stage of development, when I look at the patches, it should
be clear to me not only what is being changed, but _why_ it is being changed
in the first place and, secondly, why it is being changed in this particular
way.  It's far from that, though.

The first patch in the series doesn't even have a changelog.  How the changelog
of the second patch is related to it's actual contents is more than quite
unclear to me.  Etc.

Thanks,
Rafael
