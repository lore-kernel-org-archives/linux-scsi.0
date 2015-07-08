From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv2] sd: retry READ CAPACITY for ALUA state transition
Date: Wed, 08 Jul 2015 08:20:27 +0200
Message-ID: <559CC12B.3000002@suse.de>
References: <1436181130-82905-1-git-send-email-hare@suse.de>	 <559A9B23.4020705@sandisk.com> <1436216244.6241.7.camel@HansenPartnership.com> <559B6F24.6020804@suse.de> <559C3B1A.3020002@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:54854 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751068AbbGHGU3 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 8 Jul 2015 02:20:29 -0400
In-Reply-To: <559C3B1A.3020002@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Christoph Hellwig <hch@lst.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 07/07/2015 10:48 PM, Bart Van Assche wrote:
> On 07/06/2015 11:18 PM, Hannes Reinecke wrote:
>> However, to handle the above case correctly we would need to keep
>> track of the entire multipath topology, to figure out which devices
>> belong to that relative target port and might need to be updated
>> (there might be several paths in standby, and we will have sent the
>> RTPG only for one of them).
>> Patches for that are not done yet, so I thought the above patch
>> would be a simple stop-gap measure.
>=20
> Hello Hannes,
>=20
> Are you sure that keeping track of the entire multipath topology
> would be required to implement what I proposed ? In the patch
> "scsi_dh_alua: Use separate alua_port_group structure"
> (http://thread.gmane.org/gmane.linux.scsi/101388/focus=3D101380) I se=
e
> that the new scsi_dh_alua code keeps track of the target port group
> (TPG) ID and relative target port (RTP) ID. As you know this
> information can be queried for each LUN via the Device
> Identification VPD page. How about caching the TPG and RTP IDs per
> LUN such that the scsi_dh_alua code can figure out which LUNs are
> associated with which target ports by iterating over the known LUNs ?
>=20
I did intentionally _not_ store a pointer to the attached LUN in the
alua_port_group structure, as this would induce yet another
potential race condition when devices are being removed.

But meanwhile I've come up with a simpler patch which handles this
rather elegantly (methinks :-), and doesn't require any additional
infrastructure.
I'll be posting it shortly.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=C3=BCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
