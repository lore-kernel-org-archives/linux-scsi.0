From: "Bryn M. Reeves" <bmr@redhat.com>
Subject: Re: [PATCH] st: implement sysfs based tape statistics v2
Date: Thu, 5 Feb 2015 18:50:40 +0000
Message-ID: <20150205185040.GB9303@localhost.localdomain>
References: <DDB9C85B850785449757F9914A034FCB3BF288C6@G9W0766.americas.hpqcorp.net>
 <CAAzz28jJBpu_Uh7b7qOVWk10dS6Q3Ogm087UEW7H9fiTWWGhQQ@mail.gmail.com>
 <5B997489-2D5C-4F85-BAB8-317E62F694E5@kolumbus.fi>
 <995891679.6002631.1423158020737.JavaMail.zimbra@redhat.com>
 <E267A9CB-6A91-4DD6-9BEE-D0DC6C048B07@kolumbus.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:55280 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751191AbbBESvG (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 5 Feb 2015 13:51:06 -0500
Content-Disposition: inline
In-Reply-To: <E267A9CB-6A91-4DD6-9BEE-D0DC6C048B07@kolumbus.fi>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: =?iso-8859-1?Q?=22Kai_M=E4kisara_=28Kolumbus=29=22?= <kai.makisara@kolumbus.fi>
Cc: Laurence Oberman <loberman@redhat.com>, Laurence Oberman <oberman.l@gmail.com>, Shane M Seymour <shane.seymour@hp.com>, linux-scsi@vger.kernel.org, "James E.J. Bottomley (JBottomley@parallels.com)" <JBottomley@parallels.com>, jeffm@suse.com

On Thu, Feb 05, 2015 at 07:46:32PM +0200, "Kai M=C3=A4kisara (Kolumbus)=
" wrote:
> > On 5.2.2015, at 19.40, Laurence Oberman <loberman@redhat.com> wrote=
:
> > From: "Kai M=C3=A4kisara (Kolumbus)" <kai.makisara@kolumbus.fi>
> > I still think that the tape statistics should be exported like the =
statistics of =E2=80=9Creal=E2=80=9D block devices, i.e., one sysfs fil=
e exporting on a single line the statistics that temporally belong toge=
ther. James rejected this approach. I am leaving the decision about thi=
s code to him. I will neither ack nor nak this code.
> >=20
> > I missed the earlier conversations with James, I will go search for=
 them.
> > Do you mean add them so they are similar to the /proc/diskstats

http://comments.gmane.org/gmane.linux.scsi/80497

On Fri, Feb 22 2013 James Bottomley wrote:
>>>> I'm afraid we can't do it the way you're proposing.  files in sysf=
s must
>>>> conform to the one value per file rule (so we avoid the ABI nastin=
ess
>>>> that plagues /proc).  You can create a stat directory with a bunch=
 of
>>>> files, but not a single file that gives all values.

Documentation/filesystems/sysfs.txt does not agree:

  "Attributes should be ASCII text files, preferably with only one valu=
e
  per file. It is noted that it may not be efficient to contain only on=
e
  value per file, so it is socially acceptable to express an array of
  values of the same type."

There's also ample precedent for this: sysfs disk and partition stats,
SELinux cache and hash table stats (which have a pretty yucky 2d int
array with column headers and a name: val format respectively).

There's also a bunch of multivariate name=3Dvalue format stats files in
the cgroups sysfs tree.

> Not exactly. I mean the data exported in sysfs, for example:
>=20
> > cat /sys/block/sda/sda1/stat
>   159740     9006  5941506    64461   124724    55907 12772208  35986=
77        0   299875  3663235

I'd prefer to consume tape stats in this format too; it follows the
principle of least surprise since it's shared with every other IO stats
source (including device-mapper statistics) and it simplifies handling
the counters in user space.

Regards,
Bryn.

--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
