From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 0/8] tcm_loop updates
Date: Tue, 23 Jun 2015 11:05:40 +0200
Message-ID: <55892164.6020907@suse.de>
References: <1434620622-65391-1-git-send-email-hare@suse.de>	 <20150619064855.GB1183@lst.de> <5583C117.4030103@suse.de> <1435048143.7460.50.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:60736 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753257AbbFWJFm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Jun 2015 05:05:42 -0400
In-Reply-To: <1435048143.7460.50.camel@haakon3.risingtidesystems.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Christoph Hellwig <hch@lst.de>, Nic Bellinger <nab@daterainc.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>

On 06/23/2015 10:29 AM, Nicholas A. Bellinger wrote:
> On Fri, 2015-06-19 at 09:13 +0200, Hannes Reinecke wrote:
>> On 06/19/2015 08:48 AM, Christoph Hellwig wrote:
>>> What's the benefit of the SAS transport class writeout?  I honestly
>>> always saw tcm_loop as a simple loopback driver, with the different
>>> transport IDs in the PR code as a gimmick.  Note that vhost and
>>> xen-blkback copies that style and I did plan to consolidate it
>>> in common code.
>>>
>> The benefit is that tcm_loop will show up in the system as a 'real'
>> SAS hba; long-term goal is to simulate SAS multipathing here.
>> I was even planning on adding simlated FC infrastructure, too;
>> with that we could simulate FC multipathing, too, and our QA would
>> be _so_ happy...
>>
>=20
> Sounds like a reasonable use-case to support for loopback testing.
>=20
>> Again, these patches are mainly a collection of patches I've done to
>> test various scenarios, in the hope others might find them useful,
>> too. So I can easily hold off these patches until you've posted your
>> rework.
>>
>=20
> How different do you expect sas, fc, and iscsi transports to be..?
>=20
> Do you think this would this be better served by a simple tcm_loop LL=
D
> specific API for different multipath transports..?
>=20
Actually, I would split off the various transport functions into
separate files (tcm_loop_sas, tcm_loop_fc, etc), but keep a common
tcm_loop module.
We can even make transport classes optional by adding an explicit
'sas.XXX' prefix scanning when creating the device similar to what
we do with the 'fc.XXX' prefix already.
With that we would have a 'sas.XXX', 'fc.XXX', and 'iqn.XXX' WWN
which would attach to the respective transport class, and any other
WWN (which would be the default) would be getting the standard
emulation without any transport class attached.

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
