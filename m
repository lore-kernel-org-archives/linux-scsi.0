From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [Lsf-pc] [LSF/MM TOPIC] Unifying the LIO and SCST target drivers
Date: Fri, 27 Feb 2015 13:58:35 -0800
Message-ID: <1425074315.30923.74.camel@haakon3.risingtidesystems.com>
References: <54B63F74.2040702@sandisk.com>
	 <20150115090829.GA14154@infradead.org> <54B7E70C.8020304@sandisk.com>
	 <20150119092153.GA8666@infradead.org> <54BCD00D.4080603@sandisk.com>
	 <54E7112F.2080901@sandisk.com>
	 <1424476807.1477.52.camel@haakon3.risingtidesystems.com>
	 <54ED8B38.10904@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <54ED8B38.10904@sandisk.com>
Sender: target-devel-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: Christoph Hellwig <hch@infradead.org>, "Dr. Greg Wettstein" <greg@wind.enjellic.com>, "lsf-pc@lists.linux-foundation.org" <lsf-pc@lists.linux-foundation.org>, target-devel <target-devel@vger.kernel.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Wed, 2015-02-25 at 09:43 +0100, Bart Van Assche wrote:
> On 02/21/15 01:00, Nicholas A. Bellinger wrote:
> > On Fri, 2015-02-20 at 11:49 +0100, Bart Van Assche wrote:
> >> What I proposed myself consists of three steps:
> >> 1. Updating the LIO SRP target driver to a more recent version.
> >> 2. Target driver and LIO core refactoring such that the LIO and
> >>    SCST APIs can be unified.
> >> 3. Adding support in SCST for the unified target driver API.
> >>
> >> This work is taking a little more time than I had expected - I still
> >> have to start with step (3). But I can already show in which direction I
> >> would like to go for steps (1) and (2). The 43 patches I came up with so
> >> far for steps (1) and (2) are available in the lio branch of the
> >> https://github.com/bvanassche/linux git repository. As you can see in
> >> that repository 42 of these 43 patches make sense even without knowing
> >> that something like SCST exists.
> > 
> > Please go ahead and post the series for review with bug fixes at the
> > head of the series, with future improvements following after the fixes.
> > 
> > Doing a brief review from your tree, I can see there are some useful
> > fixes, but also there are some patches that have incorrect assumptions
> > and/or break the existing userspace APIs.
> > 
> > That said, I'm happy to review the full series, and very much appreciate
> > your efforts to improve upstream code.
> > 
> > However, keep in mind that I'll not be merging anything for target-core
> > that adds support for out-of-tree code, nor anything that changes
> > existing target configfs APIs to fit out-of-tree code requirements.
> 
> Let's start with what we agree on and discuss the other topics during
> the LSF/MM summit.
> 

Looking at how your attempting to drive creation + removal of struct
config_group from within kernel code here:

target: Add target port registration API
https://github.com/bvanassche/linux/commit/dbb8bf32db3428ede6ecc688ede1e5e01fc59d88

is the exactly the wrong approach to take.

The creation and deletion of struct config_group must be driven by
user-space, and by user-space only.  No exceptions will be made.

This was already proposed way back during the original LIO configfs
conversion in 2008, and was strongly rejected.  To quote Joel [1]:

  "That's precisely what you don't do with configfs.  It's a
   defined "not to be done" thing.  So there's no preferred way, there's
   no way at all."

What it fundamentally comes down to is that you need to change SCST to
be driven by user-space like LIO does using configfs to properly
reference count kernel data structures, and not try to hack upstream
target-core and target drivers to fit your out-of-tree sysfs design.

And you'll recall Greg already commented on this back in 2010 [2], and
his response to you was:

  "And use configfs for your configuration stuff, that's what it is 
   there for, and if it doesn't somehow work properly for you, please 
   work with the configfs developers to fix that up."

--nab

[1] http://marc.info/?l=linux-scsi&m=122109943422792&w=2
[2] http://marc.info/?l=linux-scsi&m=128985930727238&w=2
