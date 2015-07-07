From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 0/8] tcm_loop updates
Date: Tue, 07 Jul 2015 07:50:11 +0200
Message-ID: <559B6893.5030604@suse.de>
References: <1434620622-65391-1-git-send-email-hare@suse.de>	 <20150619064855.GB1183@lst.de> <5583C117.4030103@suse.de>	 <1435048143.7460.50.camel@haakon3.risingtidesystems.com>	 <55892164.6020907@suse.de> <1436228703.5138.2.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1436228703.5138.2.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Christoph Hellwig <hch@lst.de>, Nic Bellinger <nab@daterainc.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org, Ewan Milne <emilne@redhat.com>
List-Id: linux-scsi@vger.kernel.org

On 07/07/2015 02:25 AM, Nicholas A. Bellinger wrote:
> On Tue, 2015-06-23 at 11:05 +0200, Hannes Reinecke wrote:
>> On 06/23/2015 10:29 AM, Nicholas A. Bellinger wrote:
>>> On Fri, 2015-06-19 at 09:13 +0200, Hannes Reinecke wrote:
>>>> On 06/19/2015 08:48 AM, Christoph Hellwig wrote:
>>>>> What's the benefit of the SAS transport class writeout?  I honest=
ly
>>>>> always saw tcm_loop as a simple loopback driver, with the differe=
nt
>>>>> transport IDs in the PR code as a gimmick.  Note that vhost and
>>>>> xen-blkback copies that style and I did plan to consolidate it
>>>>> in common code.
>>>>>
>>>> The benefit is that tcm_loop will show up in the system as a 'real=
'
>>>> SAS hba; long-term goal is to simulate SAS multipathing here.
>>>> I was even planning on adding simlated FC infrastructure, too;
>>>> with that we could simulate FC multipathing, too, and our QA would
>>>> be _so_ happy...
>>>>
>>>
>>> Sounds like a reasonable use-case to support for loopback testing.
>>>
>>>> Again, these patches are mainly a collection of patches I've done =
to
>>>> test various scenarios, in the hope others might find them useful,
>>>> too. So I can easily hold off these patches until you've posted yo=
ur
>>>> rework.
>>>>
>>>
>>> How different do you expect sas, fc, and iscsi transports to be..?
>>>
>>> Do you think this would this be better served by a simple tcm_loop =
LLD
>>> specific API for different multipath transports..?
>>>
>> Actually, I would split off the various transport functions into
>> separate files (tcm_loop_sas, tcm_loop_fc, etc), but keep a common
>> tcm_loop module.
>> We can even make transport classes optional by adding an explicit
>> 'sas.XXX' prefix scanning when creating the device similar to what
>> we do with the 'fc.XXX' prefix already.
>> With that we would have a 'sas.XXX', 'fc.XXX', and 'iqn.XXX' WWN
>> which would attach to the respective transport class, and any other
>> WWN (which would be the default) would be getting the standard
>> emulation without any transport class attached.
>=20
> I'm open to merging the tcm_loop patches #1-#6 as-is for the sas
> transport pieces, or wait until you've done a large split based on
> transport class types.
>=20
> It's really your call how the initial merge should look.
>=20
Probably leave out the transport class stuff for now; I kinda like
the idea of having all types of transport classes available for
tcm_loop.
But this is actually not related to the rest of the patchset, so
you can skip those for the time being.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=C3=BCrnberg)
