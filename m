From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCHv2] Add EVPD page 0x83 entries to sysfs
Date: Tue, 11 Feb 2014 11:52:15 +0100
Message-ID: <52FA00DF.1010300@suse.de>
References: <1392030699-105348-1-git-send-email-hare@suse.de> <52F91535.4010905@tributary.com> <52F92319.6080806@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:41114 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750984AbaBKKwR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Feb 2014 05:52:17 -0500
In-Reply-To: <52F92319.6080806@interlog.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dgilbert@interlog.com
Cc: Jeremy Linton <jlinton@tributary.com>, James Bottomley <jbottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Kai Makisara <kai.makisara@kolumbus.fi>, "Martin K. Petersen" <martin.petersen@oracle.com>

On 02/10/2014 08:06 PM, Douglas Gilbert wrote:
> On 14-02-10 01:06 PM, Jeremy Linton wrote:
>> On 2/10/2014 5:11 AM, Hannes Reinecke wrote:
>>> EVPD page 0x83 is used to uniquely identify the device. So
>>> instead of
>>> having each and every program issue a separate SG_IO call to
>>> retrieve this
>>> information it does make far more sense to display it in sysfs.
>>
>> Tested-by: Jeremy Linton <jlinton@tributary.com>
>>
>>     So, I just ran it in 3.14-rc2. No OOPS, that is good. It even
>> survived
>> probing a SPC-2 device without a page 0x83.
>>
>> I tested it with a fairly narrow set of devices, a couple IBM
>> libraries with
>> LTO/359x and a VTL.
>>
>> I did notice this on an old IBM raid adapter running in the machine
>>
>> cat: ident_lun_scsi_name: Invalid argument
>>
>> (that came from this device)
>> sg_inq --page=3D0x83 --hex /dev/sg2
>> VPD INQUIRY, page code=3D0x83:
>>   00     00 83 00 48 01 03 00 08  50 01 0b 90 00 12 1d 90  =20
>> ...H....P.......
>>   10     61 93 00 08 50 01 0b 90  00 12 1d 8e 61 94 00 04  =20
>> a...P.......a...
>>   20     00 00 00 01 61 a3 00 08  50 01 0b 90 00 12 1d 8d  =20
>> ....a...P.......
>>   30     63 a8 00 18 6e 61 61 2e  35 30 30 31 30 42 39 30  =20
>> c...naa.50010B90
>>   40     30 30 31 32 31 44 38 44  00 00 00 00              =20
>> 00121D8D....
>>
>> And there may be a couple descriptors missing here and there. For
>> example
>> 3592E05 is missing the total port count (I think).
>>
>> VPD INQUIRY, page code=3D0x83:
>>   00     01 83 00 5c 02 01 00 24  49 42 4d 20 20 20 20 20  =20
>> ...\...$IBM
>>   10     30 33 35 39 32 45 30 35  20 20 20 20 20 20 20 20    03592E0=
5
>>   20     30 30 30 30 30 37 38 33  36 33 32 33 01 03 00 08  =20
>> 000007836323....
>>   30     50 05 07 63 02 41 0c 2c  01 13 00 08 50 05 07 63  =20
>> P..c.A.,....P..c
>>   40     02 81 0c 2c 01 14 00 04  00 00 00 02 01 23 00 08  =20
>> ...,.........#..
>>   50     50 05 07 63 02 41 0c 2c  01 24 00 04 00 00 00 01  =20
>> P..c.A.,.$......
>>
>> /sys/class/scsi_tape/nst14/device # ls ident_*
>> ident_lun_naa  ident_lun_t10  ident_port_naa  ident_port_relport=20
>> ident_target_naa
>>
>>
>>
>>
>> This almost seems like a case where exporting the raw 0x83 data
>> may be better...
>=20
> I have seen corrupted "di" VPD pages as well. So the
> order in which you look for designators can be important
> (and whether you stop on the first error or continue).
>=20
> $ sg_vpd -e -p 0x83
> Matching standard VPD pages:
>   di         0x83      Device identification
>   di_asis    0x83      Like 'di' but designators ordered as found
>   di_lu      0x83      Device identification, lu only
>   di_port    0x83      Device identification, target port only
>   di_target  0x83      Device identification, target device only
>=20
> The difference between --page=3Ddi and --page=3Ddi_asis is that the
> first looks for lu, followed by port, followed by target device
> matches. The --page=3Ddi_asis prints out the designators as they
> are found. Finding and decoding anything beyond a corrupted
> designator is hit or miss.
>=20
Yep, true. I'll need to add some boundary checks to the parsing
algorithm.

>> Also, as I stated previously, my personal bias is to include the
>> page 0x80
>> serial number data for tape devices as well. That seems to be the
>> most
>> reliable. Mostly because a lot of the VTLs now just give you the sam=
e
>> wwnn/wwpn in 0x83 for multiple LUNs. Meaning you can't uniquely
>> identify the
>> device over different physical ports.
>=20
> I'm guessing that various companies selling target
> capable chips also provide generic target code for those
> chips. Then it is up to the OEM to customize that generic
> code for their devices. Some do that customization more
> thoroughly than others.
>=20
Indeed. Some have odd ideas what can be put in there.
But nevertheless, the page format is reasonably simple,
so adding boundary checks isn't a problem.

And if vendors do not adhere to the spec that's tough,
but nothing we should code for.

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
