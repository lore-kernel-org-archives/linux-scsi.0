From: Krzysztof Oledzki <olel@ans.pl>
Subject: Re: + mpt-fusion-dont-oops-if-numphys==0.patch added to -mm tree
Date: Wed, 20 Feb 2008 04:06:22 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0802200400001.6490@bizon.gios.gov.pl>
References: <200802192335.m1JNZ7MV005426@imap1.linux-foundation.org>
 <1203475151.3103.40.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-187430788-261756978-1203476782=:6490"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bizon.gios.gov.pl ([212.244.124.8]:40322 "EHLO
	bizon.gios.gov.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750773AbYBTDHJ (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Feb 2008 22:07:09 -0500
In-Reply-To: <1203475151.3103.40.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: akpm@linux-foundation.org, linux-scsi <linux-scsi@vger.kernel.org>, mm-commits@vger.kernel.org, Eric.Moore@lsi.com, fujita.tomonori@lab.ntt.co.jp, ole@ans.pl, sathya.prakash@lsi.com, max@rfc2324.org

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-261756978-1203476782=:6490
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Tue, 19 Feb 2008, James Bottomley wrote:

>
> On Tue, 2008-02-19 at 15:34 -0800, akpm@linux-foundation.org wrote:
>> Subject: mpt fusion: don't oops if NumPhys=3D=3D0
>> From: Krzysztof Oledzki <olel@ans.pl>
>>
>> Don't oops if NumPhys=3D=3D0, instead return -ENODEV.
>> This patch fixes http://bugzilla.kernel.org/show_bug.cgi?id=3D9909
>>
>> Signed-off-by: Krzysztof Piotr Oledzki <ole@ans.pl>
>> Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
>> Cc: James Bottomley <James.Bottomley@HansenPartnership.com>
>> Cc: Eric Moore <Eric.Moore@lsi.com>
>> Cc: Sathya Prakash <sathya.prakash@lsi.com>
>> Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
>> ---
>>
>>  drivers/message/fusion/mptsas.c |    5 +++++
>>  1 file changed, 5 insertions(+)
>>
>> diff -puN drivers/message/fusion/mptsas.c~mpt-fusion-dont-oops-if-numphy=
s=3D=3D0 drivers/message/fusion/mptsas.c
>> --- a/drivers/message/fusion/mptsas.c~mpt-fusion-dont-oops-if-numphys=3D=
=3D0
>> +++ a/drivers/message/fusion/mptsas.c
>> @@ -1701,6 +1701,11 @@ mptsas_sas_expander_pg0(MPT_ADAPTER *ioc
>>  =09if (error)
>>  =09=09goto out_free_consistent;
>>
>> +=09if (!buffer->NumPhys) {
>> +=09=09error =3D -ENODEV;
>> +=09=09goto out_free_consistent;
>> +=09}
>> +
>>  =09/* save config data */
>>  =09port_info->num_phys =3D buffer->NumPhys;
>>  =09port_info->phy_info =3D kcalloc(port_info->num_phys,
>> _
>
> This is a bit odd ... It looks like a work around for a fusion firmware
> problem.

Workaround or not, the driver should not oops by allocating 0 size memory=
=20
block and dereferencing it. It used to work in <2.6.23 but not now.

> What's the topology this thing is connected to?

It is a Dell-1950III server with two 400GB SAS disks (RAID1) installed in=
=20
a dwo disk SAS backplane.

Best regrds,

 =09=09=09Krzysztof Ol=EAdzki
---187430788-261756978-1203476782=:6490--
