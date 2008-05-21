From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 7/7] scsi_dh: attach to hardware handler from dm-mpath
Date: Wed, 21 May 2008 08:18:26 +0200
Message-ID: <4833BEB2.1070305@suse.de>
References: <20080514144338.714F910B5DF@craiglockhart-ipmi.suse.de>	 <1210819801.21974.266.camel@chandra-ubuntu>  <482C0676.9070004@suse.de>	 <1210964001.21974.351.camel@chandra-ubuntu>  <483154B0.7020500@suse.de>	 <1211221247.21974.382.camel@chandra-ubuntu>  <4832C706.5040202@suse.de> <1211309554.21974.427.camel@chandra-ubuntu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.suse.de ([195.135.220.2]:51063 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754143AbYEUGS2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 21 May 2008 02:18:28 -0400
In-Reply-To: <1211309554.21974.427.camel@chandra-ubuntu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: sekharan@us.ibm.com
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, dm-devel <dm-devel@redhat.com>

Chandra Seetharaman wrote:
> Hi Hannes,
>=20
> Now I see why you want this change in dm-multipath. I think I agree w=
ith
> these changes.
>=20
Ah. good.

> But, it brings another question: what does dh_state provide ? Help to
> user to see which hardware handler a device is attached to ?
>=20
And allowing to attach to a different hardware handler.
Not everyone is running multipathing, but might be interested in the
having the device handler nevertheless.

> I thought more about the scsi_dh_detach function (in the context of m=
y
> earlier comment), adding it would require more housekeeping to associ=
ate
> one-to-one mapping between attach and detach. We can leave it the sam=
e
> way as the module will be detached when the device disappear eventual=
ly.
>=20
Why? You can detach with dh_state, too; just do an

echo detach > /sys/block/sdX/device/dh_state

and the hardware handler will detach.
So no additional attribute is required.

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
