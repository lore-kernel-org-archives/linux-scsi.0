From: Tom Yan <tom.ty89@gmail.com>
Subject: Re: [PATCH 2/2] libata-scsi: do not return t10 designator if drive
 has WWN
Date: Thu, 7 Jul 2016 21:18:55 +0800
Message-ID: <CAGnHSEn9q-QBGoiS=L18wq_kJ2eg8i-86KHxUuw6OjkHLrY5MQ@mail.gmail.com>
References: <577d824d.a10c420a.da50c.ffff9544@mx.google.com>
 <577E356E.9050209@suse.de> <CAGnHSEnxFdSKzzhqMKUkFeaOH02M2E8sTo9H28eFRbv48QyUng@mail.gmail.com>
 <577E4EA1.8050603@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <577E4EA1.8050603@suse.de>
Sender: linux-ide-owner@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: Tejun Heo <tj@kernel.org>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Yeah it said "One identification descriptor..." but not "Only one
identification descriptor...". So I suppose it is *alright* to also
return t10 designator in addition to the WWN. It's just redundunt and
unnecessary (and that's why I sent the patch), since we only need one
LU name (either derive from the WWN, or the t10 identification when
WWN is not available):

If the ATA IDENTIFY DEVICE data word 87 bit 8 is set to one indicating
that the ATA device supports the
WORLD WIDE NAME field (i.e., ATA IDENTIFY DEVICE data words 108 to
111), then the SATL shall include a
designation descriptor containing a logical unit name as defined in 10.=
5.4.2.2.

If the ATA IDENTIFY DEVICE data word 87 bit 8 is set to zero,
indicating that the ATA device does not support
the WORLD WIDE NAME field (i.e., ATA IDENTIFY DEVICE data words 108 to
111), then the SATL shall include
an identification descriptor containing a logical unit name as defined
in 10.5.4.2.3.

(sat4r05f.pdf)

On 7 July 2016 at 20:44, Hannes Reinecke <hare@suse.de> wrote:
> On 07/07/2016 02:40 PM, Tom Yan wrote:
>> Well, udev uses its own `ata_id` (which issues IDENTIFY DEVICE throu=
gh
>> ATA PASS-THROUGH) though.
>>
>> Anyway I expected the reasoning you gave and I can't really argue wi=
th
>> you. It's just personally I still prefer a cleaner SATL implementati=
on
>> (considering Linux is open source and can be deemed as some sort of
>> reference), so I gave it a go.
>>
>> Not that SAT requires the DI VPD return only one desingator / LU nam=
e though.
>>
> Really?
>
> sat-r08 has:
>
> One identification descriptor for a logical unit (i.e., a logical uni=
t
> name) shall be included (see clause 10.3.4.2).
> In some environments, one or more additional identification descripto=
rs
> may be included (see clause 10.3.4.3).
>
> Am I misreading something?
>
> Cheers,
>
> Hannes
> --
> Dr. Hannes Reinecke                Teamlead Storage & Networking
> hare@suse.de                                   +49 911 74053 688
> SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=C3=BCrnberg
> GF: F. Imend=C3=B6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
> HRB 21284 (AG N=C3=BCrnberg)
