From: "Benjamin Marzinski" <bmarzins@redhat.com>
Subject: Re: [dm-devel] Notes from the four separate IO track sessions at
 LSF/MM
Date: Fri, 29 Apr 2016 11:45:27 -0500
Message-ID: <20160429164527.GL26117@octiron.msp.redhat.com>
References: <1461800389.2311.70.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:33710 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752511AbcD2Qpa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 29 Apr 2016 12:45:30 -0400
Content-Disposition: inline
In-Reply-To: <1461800389.2311.70.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, linux-block@vger.kernel.org, device-mapper development <dm-devel@redhat.com>, lsf@lists.linux-foundation.org

On Wed, Apr 27, 2016 at 04:39:49PM -0700, James Bottomley wrote:
> Multipath - Mike Snitzer
> ------------------------
> 
> Mike began with a request for feedback, which quickly lead to the
> complaint that recovery time (and how you recover) was one of the
> biggest issues in device mapper multipath (dmmp) for those in the room.
>   This is primarily caused by having to wait for the pending I/O to be
> released by the failing path. Christoph Hellwig said that NVMe would
> soon do path failover internally (without any need for dmmp) and asked
> if people would be interested in a more general implementation of this.
>  Martin Petersen said he would look at implementing this in SCSI as
> well.  The discussion noted that internal path failover only works in
> the case where the transport is the same across all the paths and
> supports some type of path down notification.  In any cases where this
> isn't true (such as failover from fibre channel to iSCSI) you still
> have to use dmmp.  Other benefits of internal path failover are that
> the transport level code is much better qualified to recognise when the
> same device appears over multiple paths, so it should make a lot of the
> configuration seamless.

Given the variety of sensible configurations that I've seen for people's
multipath setups, there will definitely be a chunk of configuration that
will never be seemless. Just in the past few weeks, we've added code to
make it easier to allow people to manually configure devices for
situations where none of our automated heuristics do what the user
needs. Even for the easy cases, like ALUA, we've been adding options to
allow users to do things like specify what they want to happen when they
set the TPGS Pref bit.

Recognizing which paths go together is simple. That part has always been
seemless from the users point of view. Configuring how IO is blanced and
failed over between the paths is where the complexity is.

> The consequence for end users would be that
> now SCSI devices would become handles for end devices rather than
> handles for paths to end devices.

This will have a lot of repercussions with applications that uses scsi
devices.  A significant number of tools expect that a scsi device maps
to a connection between an initiator port and a target port. Listing the
topology of these new scsi devices, and getting the IO stats down the
various paths to them will involve writing new tools, or rewriting
existing one. Things like persistent reservations will work differently
(albeit, probably more intuitively).

I'm not saying that this can't be made to work nicely for a significant
subset of cases (like has been pointed out with the muliple transport
case, this won't work for all cases). I just think that it's not a small
amount of work, and not necessarily the only way to speed up failover.

-Ben

> James
> 
> --
> dm-devel mailing list
> dm-devel@redhat.com
> https://www.redhat.com/mailman/listinfo/dm-devel
