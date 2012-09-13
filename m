From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH 1/2] scsi: sd: set ready_to_power_off for scsi disk
Date: Thu, 13 Sep 2012 10:26:44 +0100
Message-ID: <1347528404.2720.28.camel@dabdike.int.hansenpartnership.com>
References: <1347522049-1836-1-git-send-email-aaron.lu@intel.com>
	    <1347522049-1836-2-git-send-email-aaron.lu@intel.com>
	   <1347524092.2720.1.camel@dabdike.int.hansenpartnership.com>
	   <50519801.6080502@intel.com>
	  <1347525466.2720.10.camel@dabdike.int.hansenpartnership.com>
	  <50519E08.10800@intel.com>
	 <1347526590.2720.15.camel@dabdike.int.hansenpartnership.com>
	 <5051A25F.7040704@intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <5051A25F.7040704@intel.com>
Sender: linux-ide-owner@vger.kernel.org
To: Aaron Lu <aaron.lu@intel.com>
Cc: Alan Stern <stern@rowland.harvard.edu>, Jeff Garzik <jgarzik@pobox.com>, Aaron Lu <aaron.lwe@gmail.com>, Jack Wang <jack_wang@usish.com>, Shane Huang <shane.huang@amd.com>, Oliver Neukum <oliver@neukum.org>, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, linux-pm@vger.kernel.org, linux-acpi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, 2012-09-13 at 17:07 +0800, Aaron Lu wrote:
> On 09/13/2012 04:56 PM, James Bottomley wrote:
> > So what's the target audience for the feature.  If it isn't laptops or
> > standard desktops, is it the enterprise?
> 
> To make this feature useful for normal laptop user, a better mechanism
> for scsi disk runtime pm is needed. Alan Stern and Lin Ming has been
> working on this, and I'll see if I can make that patch work later.
> 
> So I think this is basically 2 things, one is the runtime suspend of the
> disk, another is when it is runtime suspended, how to remove its power.
> I'm currently doing the latter one, which is simpler, so I want to do it
> first :-)

Well, I don't like the way the interaction of the patches is going.
You're the one proposing powering down the device outside of the
standards defined transitions, so you need to be responsible for the
actions that necessitates, including synchronizing the cache.  The specs
(SPC-4) say that cache management is explicitly unnecessary for the
standard SCSI power states (Active, Idle, Standby and Stopped), so
someone at some point is going to read that and remove the unnecessary
cache sync in the code.  When that happens, you'll start getting data
loss.

James

