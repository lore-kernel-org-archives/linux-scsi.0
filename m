From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: BUG in kernel: Wrong Handling of USB =?UTF-8?Q?HDD=E2=80=99s?=
 in scsiglue(slave_configure) and scsi/sd(sd_read_cache_type)
Date: Thu, 29 Sep 2011 13:31:17 -0500
Message-ID: <1317321077.3190.71.camel@dabdike.hansenpartnership.com>
References: <CADDb1s2Qhy1dNmjk+DhU=rf46A4X6kPdQ2rdpwK9zinY4Yv1mw@mail.gmail.com>
	 <CADDb1s3KjMugBGwLmjoPv93hJVBCjkD81o8F0CZxJXXt+-Fk2A@mail.gmail.com>
	 <1317245383.22022.23.camel@dabdike.hansenpartnership.com>
	 <CADDb1s0naC9bKYDuvxMK1R+ey9KB+Sh8e-9KNJXH-EuTNueueQ@mail.gmail.com>
	 <1317320825.3190.70.camel@dabdike.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1317320825.3190.70.camel@dabdike.hansenpartnership.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Amit Sahrawat <amit.sahrawat83@gmail.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org, Christoph Hellwig <hch@infradead.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2011-09-29 at 13:27 -0500, James Bottomley wrote:
> On Thu, 2011-09-29 at 14:49 +0530, Amit Sahrawat wrote:
> > The patch did not work, although it did get pass the earlier condit=
ion
> > which I mentioned- but still Write Cache is not taken into account =
=E2=80=93
> > seems mode sensing in sd_read_cache_type() does not send proper
> > request to the device =E2=80=93 or does not read in proper bytes fo=
r this(as
> > per hdparm command analysis):
> >=20
> > Logs After Connecting:
> > scsi 0:0:0:0: Direct-Access     Seagate  Portable         0130 PQ: =
0 ANSI: 4
> > sd 0:0:0:0: [sda] 488397168 512-byte logical blocks: (250 GB/232 Gi=
B)
> > sd 0:0:0:0: [sda] Write Protect is off
> > sd 0:0:0:0: [sda] No Caching mode page present
>=20
> This line means that a request for page 0x0 didn't turn up the cachin=
g
> mode page in the list of supported pages.
>=20
> What does
>=20
> sg_inq  --page=3D0x0 /dev/sda

Um, lets try that again, this time with the correct information.  What
we're looking for is the list of mode pages, so=20

sg_modes --page=3D0x3f /dev/sda

Should return it.

Thanks,

James
