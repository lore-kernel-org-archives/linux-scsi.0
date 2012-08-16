From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH] scsi: return TARGET_ERROR when a device has been disconnected
Date: Thu, 16 Aug 2012 16:59:10 +0200
Message-ID: <502D0ABE.1010709@suse.de>
References: <1345099208-31687-1-git-send-email-hare@suse.de> <AF371CF6-F10B-470D-810E-4C1F42057E79@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:56975 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753804Ab2HPO7M (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 16 Aug 2012 10:59:12 -0400
In-Reply-To: <AF371CF6-F10B-470D-810E-4C1F42057E79@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Michael Christie <michaelc@cs.wisc.edu>
Cc: linux-scsi@vger.kernel.org, James Bottomley <jbottomley@parallels.com>

On 08/16/2012 04:53 PM, Michael Christie wrote:
>=20
> On Aug 16, 2012, at 1:40 AM, Hannes Reinecke <hare@suse.de> wrote:
>=20
>> When we receive a sense code of
>> NOT READY, LOGICAL UNIT NOT SUPPORTED
>> the device has been disconnected and any retry on other paths
>> would be pointless. So return TARGET_ERROR here.
>=20
>=20
> What target is this with?

HP EVA.

> What about {ILLEGAL_REQUEST,  LOGICAL UNIT NOT SUPPORTED}?
> Would you want to do the same behavior for that error?
>=20
Yes, presumably.

> I ask because I have seen targets return {ILLEGAL_REQUEST,  LOGICAL U=
NIT NOT SUPPORTED}
> when you only unexport the LUN from a path/port on the target.
> I was wondering if some might do the same for {NOT_READY, LOGICAL
UNIT NOT SUPPORTED}?
> In those cases, we would not want multipath to fail IO.
>=20
That's exactly the use-case. When you unexport a target you're
getting the "LUN NOT SUPPORTED" message. And you'll need to return
the error to the upper layers, as you might want to disconnect the
device (eg do a 'rescan-scsi-bus.sh') and you'll want to finish any
program quickly here.

> In these type of cases should the target be returning something else?
>=20
No, that's okay.
We should be modifying it to encompass both.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
