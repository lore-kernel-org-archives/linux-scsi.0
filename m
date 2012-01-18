From: Roland Dreier <roland@purestorage.com>
Subject: Re: [LSF/MM TOPIC] linux servers as a storage server - what's missing?
Date: Wed, 18 Jan 2012 09:00:22 -0800
Message-ID: <CAL1RGDVvSbOjvCFWDSYLm4xRvKftM5OhwEf9pMGrJhjJHxzsaA@mail.gmail.com>
References: <4EF2026F.2090506@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys010aog102.obsmtp.com ([74.125.245.72]:35820 "HELO
	na3sys010aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932214Ab2ARRAw convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 18 Jan 2012 12:00:52 -0500
In-Reply-To: <4EF2026F.2090506@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ric Wheeler <rwheeler@redhat.com>
Cc: linux-fsdevel@vger.kernel.org, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On Wed, Dec 21, 2011 at 7:59 AM, Ric Wheeler <rwheeler@redhat.com> wrot=
e:
> One common thing that I see a lot of these days is an increasing numb=
er of
> platforms that are built on our stack as storage servers. Ranging fro=
m the
> common linux based storage/NAS devices up to various distributed syst=
ems.
> =A0Almost all of them use our common stack - software RAID, LVM, XFS/=
ext4 and
> samba.
>
> At last year's SNIA developers conference, it was clear that Microsof=
t is
> putting a lot of effort into enhancing windows 8 server as a storage =
server
> with both support for a pNFS server and of course SMB. I think that l=
inux
> (+samba) is ahead of the windows based storage appliances today, but =
they
> are putting together a very aggressive list of features.
>
> I think that it would be useful and interesting to take a slot at thi=
s
> year's LSF to see how we are doing in this space. How large do we nee=
d to
> scale for an appliance? =A0What kind of work is needed (support for t=
he copy
> offload system call? better support for out of band notifications lik=
e those
> used in "thinly provisioned" SCSI devices? management API's? Ease of =
use CLI
> work? SMB2.2 support?).
>
> The goal would be to see what technical gaps we have that need more a=
ctive
> development in, not just a wish list :)

I see a technical gap in the robustness of our basic SCSI/block stack. =
 In a
pretty standard low to midrange setup, ie standard server with a couple=
 of SAS
HBAs connected to an external SAS JBOD, it's quite easy to run into pro=
blems
like oopses or other issues that kill the whole system, even from fault=
s that
should affect only part of the system.  For example losing one path to =
the JBOD,
or losing one drive, or having a SCSI reservation conflict can lead to =
the whole
system crashing.

Which is not good for an HA storage server built on redundant hardware.

 - R.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
