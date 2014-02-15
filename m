From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [LSF/MM TOPIC] atomic block device
Date: Sat, 15 Feb 2014 10:02:15 -0800
Message-ID: <1392487335.2178.5.camel@dabdike.int.hansenpartnership.com>
References: <CAA9_cmf7Y1TL8XqR7dYUn=Pv-En2e0X0FM0zdpkiBkUuNBGKfQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:39161 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753438AbaBOSCR (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 15 Feb 2014 13:02:17 -0500
In-Reply-To: <CAA9_cmf7Y1TL8XqR7dYUn=Pv-En2e0X0FM0zdpkiBkUuNBGKfQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dan Williams <dan.j.williams@intel.com>
Cc: lsf-pc@lists.linux-foundation.org, linux-fsdevel <linux-fsdevel@vger.kernel.org>, jmoyer@redhat.com, david@fromorbit.com, Chris Mason <clm@fb.com>, Jens Axboe <axboe@kernel.dk>, Bryan E Veal <bryan.e.veal@intel.com>, Annie Foong <annie.foong@intel.com>, linux-scsi <linux-scsi@vger.kernel.org>, Christoph Lameter <christoph@lameter.com>

On Sat, 2014-02-15 at 07:04 -0800, Dan Williams wrote:
> In response to Dave's call [1] and highlighting Jeff's attend request
> [2] I'd like to stoke a discussion on an emulation layer for atomic
> block commands.  Specifically, SNIA has laid out their position on the
> command set an atomic block device may support (NVM Programming Model
> [3]) and it is a good conversation piece for this effort.  The goal
> would be to review the proposed operations, identify the capabilities
> that would be readily useful to filesystems / existing use cases, and
> tear down a straw man implementation proposal.
> 
> The SNIA defined capabilities that seem the highest priority to implement are:
> * ATOMIC_MULTIWRITE - dis-contiguous LBA ranges, power fail atomic, no
> ordering constraint relative to other i/o
> 
> * ATOMIC_WRITE - contiguous LBA range, power fail atomic, no ordering
> constraint relative to other i/o
> 
> * EXISTS - not an atomic command, but defined in the NPM.  It is akin
> to SEEK_{DATA|HOLE} to test whether an LBA is mapped or unmapped.  If
> the LBA is mapped additionally specifies whether data is present or
> the LBA is only allocated.
> 
> * SCAR - again not an atomic command, but once we have metadata can
> implement a bad block list, analogous to the bad-block-list support in
> md.
> 
> Initial thought is that this functionality is better implemented as a
> library a block device driver (bio-based or request-based) can call to
> emulate these features.  In the case where the feature is directly
> supported by the underlying hardware device the emulation layer will
> stub out and pass it through.  The argument for not doing this as a
> device-mapper target or stacked block device driver is to ease
> provisioning and make the emulation transparent.  On the other hand,
> the argument for doing this as a virtual block device is that the
> "failed to parse device metadata" is a known failure scenario for
> dm/md, but not sd for example.
> 
> Thoughts?

Actually, this topic has already been suggested by Christoph Lameter ...
he just didn't copy any external mailing lists (bad Christoph, rolled up
newspaper for you).

For those following at home, the SNIA proposal is here:

http://snia.org/sites/default/files/NVMProgrammingModel_v1.pdf

And this was my initial reply:

OK, I'm prepared to look through it, but I should warn you that after
the SNIA HBAAPI cluster fuck I'm not well disposed towards any APIs that
come out of SNIA.  I've read the first 30 pages and they don't inspire
confidence; it's basically going the same way as HBA API.  The failure
there was trying to define universal interfaces for every OS regardless
of the existing interfaces they currently had.  this NVM model seems to
define a lot of existing stuff in block and VFS but slightly
differently.  Why do you think it's a good idea?

I'll further add  what we really need are use cases, not an API
chocolate box.  I think some DB people will be coming to LSF, so we
should really talk use cases with them.

James


