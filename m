From: Pengfei Wang <wpengfeinudt@gmail.com>
Subject: Re: Double-Fetch bug in Linux-4.5/drivers/scsi/aacraid/commctrl.c
Date: Fri, 8 Jul 2016 10:24:11 +0100
Message-ID: <31EA5FB1-782B-4862-9038-B8F903CB7050@gmail.com>
References: <CACxtibTF72YUeOnm2Rsx6odjRXybjbbGbx32-CqAu5u6ahndKg@mail.gmail.com> <1461681982.2348.4.camel@HansenPartnership.com> <56AE387A-9CCB-4524-A3FB-1DCA24D816E0@gmail.com> <CACxtibRmuwx0athffBQ9mNdGPoHDah+UU+FF5fGjPqwzbD3R1Q@mail.gmail.com> <423FD6710FB8FB4F8728F93591889F9A15F9B3D4@avsrvexchmbx1.microsemi.net>
Mime-Version: 1.0 (Mac OS X Mail 9.1 \(3096.5\))
Content-Type: text/plain; charset=gb2312
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f196.google.com ([209.85.220.196]:35303 "EHLO
	mail-qk0-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754046AbcGHJYK convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Jul 2016 05:24:10 -0400
Received: by mail-qk0-f196.google.com with SMTP id g190so4237400qkc.2
        for <linux-scsi@vger.kernel.org>; Fri, 08 Jul 2016 02:24:09 -0700 (PDT)
In-Reply-To: <423FD6710FB8FB4F8728F93591889F9A15F9B3D4@avsrvexchmbx1.microsemi.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: David Carroll <david.carroll@microsemi.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Dear David,

Thank you for the quick response, and I think the safest way is check f=
or equal, not only check for not larger than the first checked value, a=
lthough I=A1=AFm not sure whether anything wrong would happen if it is =
smaller. Please let me know if a patch is applied. Thanks!

Bests
Pengfei
> =D4=DA 2016=C4=EA7=D4=C27=C8=D5=A3=AC=CF=C2=CE=E711:43=A3=ACDavid Car=
roll <david.carroll@microsemi.com> =D0=B4=B5=C0=A3=BA
>=20
>> -----Original Message-----
>> From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
>> owner@vger.kernel.org] On Behalf Of Pengfei Wang
>> Sent: Thursday, July 07, 2016 7:00 AM
>> To: linux-scsi@vger.kernel.org
>> Subject: Re: Double-Fetch bug in Linux-4.5/drivers/scsi/aacraid/comm=
ctrl.c
>> Hi,
>>=20
>> Will anyone bother to confirm and fix this problem I reported last t=
ime? From
>> the point of view of security, I think it should be fixed.
>> I have discovered several cases of the same kind and all have been f=
ixed by
>> the maintainers. Thanks!
>>=20
>> Pengfei
>>=20
>=20
> Hi Pengfei,
>=20
> I'm currently working on a patch set for the HBA-1000 card, and I agr=
ee with your assessment. We will check the sizes and return an error if=
 the size is larger than when first checked;
> i.e.
>=20
> 	if (copy_from_user(kfib, arg, size)) {
> 		retval =3D -EFAULT;
> 		goto cleanup;
> 	}
>=20
> 	if (unlikely((le16_to_cpu(kfib->header.Size) + sizeof(struct aac_fib=
hdr)) > size)) {
> 		retval =3D -EINVAL;
> 		goto cleanup;
> 	}
>=20
> Thanks, -Dave
>=20

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
