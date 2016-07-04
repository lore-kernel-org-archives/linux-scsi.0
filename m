From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 5/6] fcoe: implement FIP VLAN responder
Date: Mon, 4 Jul 2016 13:22:20 +0200
Message-ID: <577A46EC.70306@suse.de>
References: <1467620963-67047-1-git-send-email-hare@suse.de>
 <1467620963-67047-6-git-send-email-hare@suse.de>
 <20160704100547.fy7ima6fwkcs4aha@c203.arch.suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.suse.de ([195.135.220.15]:34927 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752844AbcGDLWW (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 4 Jul 2016 07:22:22 -0400
In-Reply-To: <20160704100547.fy7ima6fwkcs4aha@c203.arch.suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, Hannes Reinecke <hare@suse.de>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Johannes Thumshirn <jth@kernel.org>, Christoph Hellwig <hch@lst.de>, James Bottomley <james.bottomley@hansenpartnership.com>, linux-scsi@vger.kernel.org

On 07/04/2016 12:05 PM, Johannes Thumshirn wrote:
> On Mon, Jul 04, 2016 at 10:29:22AM +0200, Hannes Reinecke wrote:
>> When running in VN2VN mode there is no central instance which
>> would send out any FIP VLAN discovery notifications. So this
>> patch adds a new sysfs attribute 'fip_vlan_responder' which
>> will activate a FIP VLAN discovery responder.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.com>
>> ---
>=20
> [...]
>=20
>> +/**
>> + * fcoe_ctlr_vlan_send() - Send a FIP VLAN Notification
>> + * @fip: The FCoE controller
>> + * @sub: sub-opcode for vlan notification or vn2vn vlan notificatio=
n
>> + * @dest: The destination Ethernet MAC address
>> + * @min_len: minimum size of the Ethernet payload to be sent
>> + */
>> +static void fcoe_ctlr_vlan_send(struct fcoe_ctlr *fip,
>> +			      enum fip_vlan_subcode sub,
>> +			      const u8 *dest)
>> +{
>> +	struct sk_buff *skb;
>> +	struct fip_frame {
>> +		struct ethhdr eth;
>> +		struct fip_header fip;
>> +		struct fip_mac_desc mac;
>> +		struct fip_vlan_desc vlan;
>> +	} __packed * frame;
>=20
> Hmmm this is the 2nd time fip_frame is defined in  fcoe_ctlr.c. I'd p=
refere
> having the type definition somewhere else in this file and then use i=
t in
> fcoe_ctlr_vlan_send() and fcoe_ctlr_vn_send().
>=20
This appears to be the convention in the file; every function which is
sending a frame on the wire defines a local variable 'struct fip_frame'
which contains the actual frame definition.

Might be that the style can be improved, but that should be a separate
patch.

>> +	size_t len;
>> +	size_t dlen;
>> +
>> +	len =3D sizeof(*frame);
>> +	dlen =3D sizeof(frame->mac) + sizeof(frame->vlan);
>> +	len =3D max(len, sizeof(struct ethhdr));
>> +
>> +	skb =3D dev_alloc_skb(len);
>> +	if (!skb)
>> +		return;
>=20
> dev_alloc_skb() uses GFP_ATOMIC so it's actually not unlikely to fail
> so please return -ENOMEM here, just so the caller knows what happened=
=2E
>=20
Again, the calling convention of fcoe_ctlr_send_vlan() insists on using
a void return.
Yes, this should be improved, but again with another patch.

So do I need to send two additional patches for updating the infrastruc=
ture?

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		   Teamlead Storage & Networking
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
