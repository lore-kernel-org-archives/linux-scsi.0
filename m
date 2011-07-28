From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Handling multiple paths to enclosure devices?
Date: Fri, 29 Jul 2011 00:33:22 +0400
Message-ID: <1311885202.5464.14.camel@mulgrave>
References: <1311872730-4863-1-git-send-email-roland@kernel.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:40856 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755561Ab1G1Ud2 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Jul 2011 16:33:28 -0400
In-Reply-To: <1311872730-4863-1-git-send-email-roland@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Roland Dreier <roland@kernel.org>
Cc: linux-scsi@vger.kernel.org, eric@purestorage.com

On Thu, 2011-07-28 at 10:05 -0700, Roland Dreier wrote:
> Hi,
> 
> I'm seeing an issue with the current design of our enclosure
> handling.  In a system with a bunch of drives in an enclosure, it's
> definitely helpful to have a way to go from sdXX to which slot in the
> enclosure that drive is in, and that's what the symlink
> /sys/block/sdXX/device/enclosure_device:NN provides.
> 
> However, in a system with multiple paths to the enclosure, eg an HBA
> with two external SAS ports, both connected to a SAS expander in a
> JBOD, ie in lame ASCII graphics, something like:
> 
>      +-----+                 /-- drv1
>      |     |       +-----+  /---  .
>      |     |==SAS==|     |-/----  .
>      | HBA |       | exp |------  .
>      |     |==SAS==|     |-\----  .
>      |     |       +-----+  \---  .
>      +-----+                 \-- drvN

So this configuration should form a single wide port and thus not
actually be multiple paths.  However, if you have two HBAs instead of
one (or a non-SAS HBA), I grant it becomes multipath.

> we have two paths to each drive, so each gets two names, sdXX and
> sdYY.  However, in drivers/misc/enclosure.c, the code only allows one
> device in each component and so what happens is that sdXX gets
> discovered, then gets an enclosure_device:NN link, then sdYY is
> discovered, so sdXX's enclosure_device:NN link is removed and one is
> added for sdYY.  And so if I want to figure out which enclosure slot
> sdXX is in, I'm in for a hard time.
> 
> It would be a simple matter of writing code to allow all the block
> devices in a slot to link back to that slot -- we would have to be a
> bit more careful of keeping track of what links exist, but it should
> be doable.
> 
> The wrinkle is that there are also /sys/class/enclosure/ZZZ/NN/device
> symlinks that allow going the other way.  And it's harder to see how
> to express multiple block devices in one enclosure slot.
> 
> Thoughts on how to improve our enclosure handling?

My initial thought is that in a multi-path situation, as above, we get
two enclosures appearing as well (one down each path).  If we
incorporated the idea of topological subtrees into the identity matching
code, we'd end up filling each of the enclosures with the path connected
devices.  That seems to be an easy situation for multi-path drivers to
sort out and one requiring no alteration of the existing enclosure code
(except to do the topological subtree search).

How does that sound?

James


