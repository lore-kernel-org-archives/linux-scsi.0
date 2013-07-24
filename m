From: =?utf-8?B?SsO2cm4=?= Engel <joern@logfs.org>
Subject: Re: [PATCH] mpt2sas: don't handle broadcast primitives
Date: Wed, 24 Jul 2013 15:23:57 -0400
Message-ID: <20130724192357.GC3641@logfs.org>
References: <20130719220659.GF29404@logfs.org>
 <20130719221143.GG29404@logfs.org>
 <CAC9+anJ47nx+KyKvp7MT1Hanh-8YNDmSQwtM542dpeOdCVVoUw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <CAC9+anJ47nx+KyKvp7MT1Hanh-8YNDmSQwtM542dpeOdCVVoUw@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Baruch Even <baruch@ev-en.org>
Cc: Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>, Sreekanth Reddy <Sreekanth.Reddy@lsi.com>, Support <support@lsi.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, DL-MPTFusionLinux@lsi.com, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel@vger.kernel.org, mit@purestorage.com
List-Id: linux-scsi@vger.kernel.org

On Wed, 24 July 2013 23:42:22 +0300, Baruch Even wrote:
> On Sat, Jul 20, 2013 at 1:11 AM, J=C3=B6rn Engel <joern@logfs.org> wr=
ote:
> > On Fri, 19 July 2013 18:06:59 -0400, J=C3=B6rn Engel wrote:
> >>
> >> The handling of broadcast primitives involves
> >> _scsih_block_io_all_device(), which does what the name implies.  I=
 have
> >> observed cases with >60s of blocking io on all devices, caused by =
a
> >> single bad device.  The downsides of this code are obvious, while =
the
> >> upsides are more elusive.
> >
> > And since this patch looks more like an April fools joke: I have
> > gathered a few machine-months of testing, including tortures that
> > specifically stress the removed codepaths.  This is a serious
> > submission and unless someone can show me a _very_ good reason for
> > keeping the deleted code, I would like to get it merged.
>=20
> This would seem to cause an IO pause through the host whenever there
> is a disk removal/insertion or SES (SAS expander) change which seems
> like a bad proposition indeed. The part of the work that this code
> seems to handle is that when such a change happens something needs to
> detect the dead IOs (f.ex. surprise disk removal) but I believe that
> the SAS HBA firmware will do that internally already so I do think
> this code is needless.
>=20
> The only thing I'd like not to lose is the actual notification and
> ability to log the fact that there was a broadcast notification on th=
e
> SAS network.

I agree logging would be nice.  However my attempts to keep logging and
remove the IO pause were unsuccessful.  Apparently something inside
_scsih_sas_broadcast_primitive_event() is required to get future
events.  If someone from LSI with data sheets and understanding of the
firmware can do a better patch, I would be happy.

J=C3=B6rn

--
The story so far:
In the beginning the Universe was created.  This has made a lot
of people very angry and been widely regarded as a bad move.
-- Douglas Adams
