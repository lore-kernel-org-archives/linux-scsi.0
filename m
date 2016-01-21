From: Laurence Oberman <loberman@redhat.com>
Subject: Re: What partition should the MTMKPART argument specify? Was: Re:
 st driver doesn't seem to grok LTO partitioning
Date: Thu, 21 Jan 2016 17:06:03 -0500 (EST)
Message-ID: <1281192568.8282297.1453413963788.JavaMail.zimbra@redhat.com>
References: <20151218170644.24167419@harpe.intellique.com> <688812570.3359420.1452030904683.JavaMail.zimbra@redhat.com> <20160106161049.34f29973@harpe.intellique.com> <1993563395.3556606.1452093814452.JavaMail.zimbra@redhat.com> <20160106170720.61db9e86@harpe.intellique.com> <1371374871.6203837.1452802373256.JavaMail.zimbra@redhat.com> <DDB9C85B850785449757F9914A034FCB4450CE9B@G9W0766.americas.hpqcorp.net> <0840949A-970D-43FB-A691-E2F8AC2A0804@kolumbus.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx3-phx2.redhat.com ([209.132.183.24]:45794 "EHLO
	mx3-phx2.redhat.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237AbcAUWGQ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 21 Jan 2016 17:06:16 -0500
In-Reply-To: <0840949A-970D-43FB-A691-E2F8AC2A0804@kolumbus.fi>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai =?utf-8?Q?M=C3=A4kisara_=28Kolumbus=29?= <kai.makisara@kolumbus.fi>
Cc: Shane M Seymour <shane.seymour@hpe.com>, Emmanuel Florac <eflorac@intellique.com>, Laurence Oberman <oberman.l@gmail.com>, linux-scsi@vger.kernel.org

Given what we see at customers I am leaning towards the SCSI level <=3D=
2 to ensure the older LTO5's are supported.
The newer ones should be backwards compatible.
I may have an older LTO5 showing up that wont need a F/W update to work=
, and will be able to add a "tested by" once I get it.

But lets see what the others have to say

Laurence Oberman
Principal Software Maintenance Engineer
Red Hat Global Support Services

----- Original Message -----
=46rom: "Kai M=C3=A4kisara (Kolumbus)" <kai.makisara@kolumbus.fi>
To: "Shane M Seymour" <shane.seymour@hpe.com>
Cc: "Laurence Oberman" <loberman@redhat.com>, "Emmanuel Florac" <eflora=
c@intellique.com>, "Laurence Oberman" <oberman.l@gmail.com>, linux-scsi=
@vger.kernel.org
Sent: Thursday, January 21, 2016 3:58:46 PM
Subject: What partition should the MTMKPART argument specify? Was: Re: =
st driver doesn't seem to grok LTO partitioning


> On 15.1.2016, at 2.21, Seymour, Shane M <shane.seymour@hpe.com> wrote=
:
>=20
> Unfortunately I'm unable to lay my hands on an LTO 5 tape drive so I'=
m not able to test that it works either. If it helps at all I can test =
in the negative and make sure that for an LTO 3 drive it fails graceful=
ly but that's about it at the moment.

Thanks for all testers and those who attempted to test. The latest patc=
h applies the standard quite strictly and I think it should work with m=
ost drives. The implementation can be fixed later if problems are found=
=2E

However, before making the final patch, we should decide which partitio=
n the specified size should apply to. For the SCSI level <=3D2 it appli=
es to partition 1. For other drives we may have some freedom to =E2=80=9C=
tune=E2=80=9D the definition. The size should apply to the partition th=
e users expect it to apply.=20

The current documentation says "the argument gives in megabytes the siz=
e of partition 1 that is physically the first partition of the tape=E2=80=
=9D. The documentation I have found for current drives (HP and IBM LTO,=
 IBM 3592, Storagetek T1000) all number the partitions sequentially fro=
m the start of the tape. The access time for any partition is probably =
about the same when wrapwise partitioning is used. It does matter with =
linear partitioning. Unfortunately, the standards leave the numbering t=
o the implementor.

Partitioning with two partitions is used for storing index in a small p=
artition and use the rest of the tape for data. In this case, it is pro=
bably natural to specify the size of the index. The LTFS definition sup=
ports index in any partition. The open source code I have seen seem to =
default to index in partition 0.

The HP and IBM LTO default partitioning (FDP=3D1) specifies two wraps (=
minimum) to partition 1 and the rest to 0.

There seem to be lot of arguments supporting both possible choices. Sho=
uld we use the existing definition (1) or change it for the drives supp=
orting SCSI level >=3D 3 (or supporting FORMAT MEDIUM)? The definition =
can=E2=80=99t be changed later. This is why we should make a good decis=
ion.

Opinions?

Thanks,
Kai

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
