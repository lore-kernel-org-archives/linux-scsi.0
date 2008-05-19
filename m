From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 7/7] scsi_dh: attach to hardware handler from dm-mpath
Date: Mon, 19 May 2008 12:21:36 +0200
Message-ID: <483154B0.7020500@suse.de>
References: <20080514144338.714F910B5DF@craiglockhart-ipmi.suse.de>	 <1210819801.21974.266.camel@chandra-ubuntu>  <482C0676.9070004@suse.de> <1210964001.21974.351.camel@chandra-ubuntu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.suse.de ([195.135.220.2]:38357 "EHLO mx1.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754879AbYESKVj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 19 May 2008 06:21:39 -0400
In-Reply-To: <1210964001.21974.351.camel@chandra-ubuntu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: sekharan@us.ibm.com
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi <linux-scsi@vger.kernel.org>, dm-devel <dm-devel@redhat.com>

Hi Chandra,

Chandra Seetharaman wrote:
> On Thu, 2008-05-15 at 11:46 +0200, Hannes Reinecke wrote:
>> Hi Chandra,
>>
>> Chandra Seetharaman wrote:
>>> What is the purpose of this feature ?
>>>
>>> With dh_state functionality, one could associate a handler to a new
>>> device and then if one does "multipath", the hardware handler would=
 be
>>> associated with the multipath device. What are we achieving by this=
 ?
>>>
>> This allows multipath to override the device tables build into
>> the device handler. Reason here is that multipath has a configuratio=
n
>> file which allows the user to override the build-in defaults.
>> And this includes the hardware handler, so we need to make sure that
>> the hardware handler is indeed attached.
>=20
> Hardware handler's existence is currently been verified during parsin=
g
> (by doing a request_module() followed by scsi_dh_handler_exist() in
> parse_hw_handler()).
>=20
Yes, but this only verifies that the _handler_ exist, not that it is
attached to this sdev

> Hardware handler module is attached to the device itself (thru
> try_module_get() in attach), so, the module will exist as long as the
> device exists.
>=20
Not quite. It's only attached automatically if the device map has
an entry for this module.
However, given this patchset we can now easily manually attach any
device to the device handler. Or at least try to do so.
It's then up to the device handler to refuse binding if none of
the necessary pages/information etc. was found.

> Hence, there is no need to attach it again from the multipath layer.
>=20
Yes, you do. The user might have it's own custom configuration file,
covering new/unknown/unhandled/testing devices, which out of necessity
are _not_ hardcoded in the device table of the device handler.
So multipath has to have a way of attaching device handler to those
devices, too.

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
