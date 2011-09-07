From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [PATCH] [SCSI]: libsas failure to revalidate domain for anything but the first expander child.
Date: Wed, 7 Sep 2011 10:03:16 -0700 (PDT)
Message-ID: <1315414996.90012.YahooMailNeo@web31802.mail.mud.yahoo.com>
References: <20110730002509.28735.82590.stgit@localhost6.localdomain6> <FC1F9E38C0703341A1A750524E2525A901853EC8@XYUS-EX22.xyus.xyratex.com> <FC1F9E38C0703341A1A750524E2525A901853F74@XYUS-EX22.xyus.xyratex.com> <1314897501.64142.YahooMailNeo@web31807.mail.mud.yahoo.com> <FC1F9E38C0703341A1A750524E2525A9018540CA@XYUS-EX22.xyus.xyratex.com>
Reply-To: Luben Tuikov <ltuikov@yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from nm30-vm1.bullet.mail.bf1.yahoo.com ([98.139.213.54]:33743 "HELO
	nm30-vm1.bullet.mail.bf1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1754832Ab1IGRDS convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 Sep 2011 13:03:18 -0400
In-Reply-To: <FC1F9E38C0703341A1A750524E2525A9018540CA@XYUS-EX22.xyus.xyratex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mark Salyzyn <mark_salyzyn@us.xyratex.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: Darrick J Wong <djwong@us.ibm.com>, James Bottomley <jbottomley@parallels.com>

>So are you suggesting a larger/different fix, or do you see this minor=
 change as an acceptable means of resolving the specific issue of the r=
evalidation not going beyond the first child expander? At least with th=
is fix it will go to the first expander with a change. It was a code-bu=
g from fumble-fingers, missing a '*', not a request to revamp ;->
>


Neither. I was merely stating a fact, history.

I don't mind this patch.


>I know that by spec it should not stop at the first discovered change,=
 ignoring changes in other children, but that is a much finer corner ca=
se requiring discovery events at a higher frequency than the revalidati=
on period can handle. Not sure if I have the stomach to wait for a rewr=
ite of libsas ... Besides I feel libsas 'mostly works' and for today ju=
st needs a few tweaks (evolution, not revolution).
>

Yes. My original code did handle all this as event management used a cl=
ever technique to handle infinite number of events (of finite number of=
 type of event) in finite amount of memory. Bottomley and his gang (290=
8d778ab3e244900c310974e1fc1c69066e450) ripped that out and added the ut=
terly naive way or processing events as you currently see in libsas. Th=
e result is a buggy, substandard and mediocre implementation.


>Sincerely -- Mark Salyzyn
>
>-----Original Message-----
>From: Luben Tuikov [mailto:ltuikov@yahoo.com]=20
>Sent: Thursday, September 01, 2011 1:18 PM
>To: Mark Salyzyn; linux-scsi@vger.kernel.org
>Cc: Darrick J Wong; James Bottomley
>Subject: Re: [PATCH] [SCSI]: libsas failure to revalidate domain for a=
nything but the first expander child.
>
>----- Original Message -----
>
>> In an enclosure model where there are chaining expanders to a large =
body
>> of storage, it was discovered that libsas, responding to a broadcast
>> event change, would only revalidate the domain of first child expand=
er
>> in the list.
>>=20
>> The issue is that the pointer value to the discovered source device =
was
>> used to break out of the loop, rather than the content of the pointe=
r.
>>=20
>> This still remains non-compliant as the revalidate domain code is
>> supposed to loop through all child expanders, and not stop at the fi=
rst
>> one it finds that reports a change count. However, the design of thi=
s
>> routine does not allow multiple device discoveries and that would be=
 a
>> more complicated set of patches reserved for another day. We are fix=
ing
>> the glaring bug rather than refactoring the code.
>
>Obviously I've tested this both when I was at Adaptec and at Vitesse. =
I'd connect
>7-8 expanders, run iogen with 1000 threads to say 30-40 disks, and the=
n unplug
>the port between a level 1 and 2 expander and the I/O would quiesce, i=
ogen would
>report a subset of the disks missing, and then when the port was reest=
ablished,
>I/O would restart. However I'm not sure that Bottomley tested this sce=
nario after
>changing my code off-line before submitting it into the Linux kernel.
>
>Now a few notes to mention: Your patch patches a function called
>sas_find_bcast_dev(). My original code does NOT have such a function.
>Revalidation is much more subtle and the code looks simpler in my orig=
inal
>version. In my original code there is a lot more recursion, symmetry a=
nd
>code mirroring. Granted, while such code is shorter, and simpler, it i=
s harder
>to figure out what it does, and I feel this is exactly why we see the =
current
>state of libsas to be so explicit, simplistic and introducing bugs. Se=
e this:
>http://marc.info/?l=3Dlinux-scsi&m=3D131480962006471&w=3D2 where I des=
cribed
>the state of libsas recently.
>
>> Please note, as I am *stuck* on Outlook as per company policy, the
>> following inline content will likely not patch clean even emailed as
>> 'Plain Text', the enclosed attached file should do the job. I have=20
>> Cc'd
>> all the folks that originated the files in libsas, as there was no
>> listed MAINTAINERs.
>>=20
>> Checkpatch.pl reports clean. Patch applies cleanly to a WIDE variety=
 of
>> kernels up to latest.
>>=20
>> Sincerely -- Mark Salyzyn
>>=20
>> Cc: Luben Tuikov <tuikov@yahoo.com>
>> Cc: Darrick J Wong <djwong@us.ibm.com>
>> Cc: James Bottomley <jbottomley@parallels.com>
>>=20
>> Signed-off-by: Mark Salyzyn <msalyzyn@us.xyratex.com>
>>=20
>> sas_expander.c |=A0 =A0 2 +-
>> 1 file changed, 1 insertion(+), 1 deletion(-)
>>=20
>> diff -ru scsi-misc-2.6/drivers/scsi/libsas/sas_expander.c
>> scsi-misc-2.6.new/drivers/scsi/libsas/sas_expander.c
>> --- scsi-misc-2.6/drivers/scsi/libsas/sas_expander.c=A0=A0=A0 2011-0=
8-31
>> 08:32:21.000000000 -0400
>> +++ scsi-misc-2.6.new/drivers/scsi/libsas/sas_expander.c
>> 2011-09-01 08:57:55.000000000 -0400
>> @@ -1721,7 +1721,7 @@
>> =A0=A0=A0 list_for_each_entry(ch, &ex->children, siblings) {
>> =A0=A0=A0 =A0=A0=A0 if (ch->dev_type =3D=3D EDGE_DEV || ch->dev_type=
 =3D=3D
>> FANOUT_DEV) {
>> =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 res =3D sas_find_bcast_dev(ch, src_dev=
);
>> -=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 if (src_dev)
>> +=A0=A0=A0 =A0=A0=A0 =A0=A0=A0 if (*src_dev)
>> =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 =A0=A0=A0 return res;
>> =A0=A0=A0 =A0=A0=A0 }
>> =A0=A0=A0 }
>>
>______________________________________________________________________
>This email may contain privileged or confidential information, which s=
hould only be used for the purpose for which it was sent by Xyratex. No=
 further rights or licenses are granted to use such information. If you=
 are not the intended recipient of this message, please notify the send=
er by return and delete it. You may not use, copy, disclose or rely on =
the information contained in it.
>
>Internet email is susceptible to data corruption, interception and una=
uthorised amendment for which Xyratex does not accept liability. While =
we have taken reasonable precautions to ensure that this email is free =
of viruses, Xyratex does not accept liability for the presence of any c=
omputer viruses in this email, nor for any losses caused as a result of=
 viruses.
>
>Xyratex Technology Limited (03134912), Registered in England & Wales, =
Registered Office, Langstone Road, Havant, Hampshire, PO9 1SA.
>
>The Xyratex group of companies also includes, Xyratex Ltd, registered =
in Bermuda, Xyratex International Inc, registered in California, Xyrate=
x (Malaysia) Sdn Bhd registered in Malaysia, Xyratex Technology (Wuxi) =
Co Ltd registered in The People's Republic of China and Xyratex Japan L=
imited registered in Japan.
>______________________________________________________________________
>
>
>
>
>
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
