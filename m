From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 7/7] scsi_dh: attach to hardware handler from dm-mpath
Date: Fri, 23 May 2008 13:40:08 +0200
Message-ID: <20080523114008.GG380@pentland.suse.de>
References: <20080514144338.714F910B5DF@craiglockhart-ipmi.suse.de> <1210819801.21974.266.camel@chandra-ubuntu> <482C0676.9070004@suse.de> <1210964001.21974.351.camel@chandra-ubuntu> <483154B0.7020500@suse.de> <1211221247.21974.382.camel@chandra-ubuntu> <4832C706.5040202@suse.de> <1211309554.21974.427.camel@chandra-ubuntu> <4833BEB2.1070305@suse.de> <1211444095.3956.6.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60172 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750938AbYEWLkL (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 23 May 2008 07:40:11 -0400
Content-Disposition: inline
In-Reply-To: <1211444095.3956.6.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: sekharan@us.ibm.com, linux-scsi <linux-scsi@vger.kernel.org>, dm-devel <dm-devel@redhat.com>

On Thu, May 22, 2008 at 09:14:54AM +0100, James Bottomley wrote:
> On Wed, 2008-05-21 at 08:18 +0200, Hannes Reinecke wrote:
[ .. ]
> > Why? You can detach with dh_state, too; just do an
> >=20
> > echo detach > /sys/block/sdX/device/dh_state
> >=20
> > and the hardware handler will detach.
> > So no additional attribute is required.
>=20
> Actually, if you're going down this route, it makes more sense to hav=
e
> the device handler be a driver ... remember you were the one promisin=
g
> multiple driver binding at the FS/Storage summit ...  that way we can
> use all the generic driver standard interfaces for manual
> binding/unbinding.  Plus we can place the attributes as driver attrib=
ute
> groups.
>=20
Hmm. Actually this very discussion I had with Kay Sievers earlier this
week when we tried to make bsg useable for udev.
The problem here is that we really want the device_handler to kick in
_before_ any of the 'normal' SCSI ULD starts it's probing, as we might
want to suppress I/O on this channel.

If we were to use the normal driver binding for this we'd be called
at the same level with the normal ULDs, making it unpredictable at whic=
h
time we're called.

And it was actually Greg KH which promised the multiple driver binding,
but seems that he's not getting around doing this anytime soon.
Hmm; maybe I can convince Kay on doing it ...
But want we really want to do is _not_ having these 'special' handlers
called at any time during bus probing, but having a fixed order like:

sdev probing
 - (optional) device handler attach
 - bsg attach
 - SCSI ULD probing

We would like to have bsg available before ULD probing, as then we coul=
d
use the bsg device nodes in general in udev (like calling scsi_id on it=
).
It _might_ be possible to handle these cases with multiple driver bindi=
ng,
but seeing that there's no-one currently working on it I'd like to stic=
k
with the current approach.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: Markus Rex, HRB 16746 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
