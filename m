From: Lars Marowsky-Bree <lmb@suse.de>
Subject: Re: [RFC] Multi-path IO in 2.5/2.6 ?
Date: Wed, 11 Sep 2002 21:52:32 +0200
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020911195232.GH1212@marowsky-bree.de>
References: <20020911191701.GE1212@marowsky-bree.de> <200209111937.g8BJbfQ02442@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <200209111937.g8BJbfQ02442@localhost.localdomain>
List-Id: linux-scsi@vger.kernel.org
To: linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org

On 2002-09-11T14:37:40,
   James Bottomley <James.Bottomley@steeleye.com> said:

> I think I see driverfs as the solution here.  Topology is deduced by
> examining certain device and HBA parameters.  As long as these parame=
ters
> can be exposed as nodes in the device directory for driverfs, a user =
level
> daemon map the topology and connect the paths at the top.  It should =
even be
> possible to weight the constructed multi-paths.

Perfect, I agree, should've thought of it. As long as this is simple en=
ough
that it can be done in initrd (if / is on a multipath device...).

The required weighting has already been implemented in the LVM1 patch b=
y IBM.
While it appeared overkill to me for "simple" cases, I think it is suit=
ed to
expressing proximity.

> This solution appeals because the kernel doesn't have to dictate poli=
cy,=20

Right.

> I've been think about this separately.  FC in particular needs some t=
ype of
> event notification API (something like "I've just seen this disk" or =
"my
> loop just went down").  I'd like to leverage a mid-layer api into hot=
 plug
> for some of this, but I don't have the details worked out.

This isn't just FC, but also dasd on S/390. Potentially also network bl=
ock
devices, which can notice a link down.

> The probing issue is an interesting one.  At least SCSI has the abili=
ty to=20
> probe with no IO (something like a TEST UNIT READY) and I assume othe=
r block=20
> devices have something similar.  Would it make sense to tie this to a=
 single=20
> well known ioctl so that you can probe any device that supports it wi=
thout=20
> having to send real I/O?

Not sufficient. The test is policy, so the above applies here too ;-)=20

In the case of talking to a dual headed RAID box for example, TEST UNIT=
 READY
might return OK, but the controller might refuse actual IO, or the path=
 may be
somehow damaged in a way which is only detected by doing some "large" I=
O. Now,
this might be total overkill for other scenarios.

I vote for exposing the path via driverfs (which, I think, is already
concensus so the multipath group, topology etc can be used) and allowin=
g
user-space to reenable them after doing whatever probing deemed necessa=
ry.

What are your ideas on the potential timeframe?



Sincerely,
    Lars Marowsky-Br=E9e <lmb@suse.de>

--=20
Immortality is an adequate definition of high availability for me.
	--- Gregory F. Pfister

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
