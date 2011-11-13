From: "Bill Boas" <bboas-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Subject: RE: srp_transport: Fix atttribute registration race
Date: Sat, 12 Nov 2011 22:18:04 -0600
Message-ID: <045e01cca1bb$3dee1070$b9ca3150$@systemfabricworks.com>
References: <201110211857.23622.bvanassche@acm.org> <1320053608.8283.29.camel@dabdike> <CAO+b5-oxshsL7Dm7vhv4zC8m0P4dG3iNzxU9sdbi5cBkAnTpMQ@mail.gmail.com>
Reply-To: <bboas-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <CAO+b5-oxshsL7Dm7vhv4zC8m0P4dG3iNzxU9sdbi5cBkAnTpMQ-JsoAwUIsXosN+BqQ9rBEUg@public.gmane.org>
Content-Language: en-us
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: 'Bart Van Assche' <bvanassche-HInyCGIudOg@public.gmane.org>, 'James Bottomley' <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>, 'David Dillow' <dillowda-1Heg1YXhbW8@public.gmane.org>
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, 'Fujita Tomonori' <fujita.tomonori-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, 'Brian King' <brking-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, 'Roland Dreier' <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

Bart, James, Dave,

At SC we are running a video streaming demo across a 7000 mile fiber
distance using IB extension boxes from Bay Microsystems at 40 Gbps. The
video streaming app uses SRP to transmit the streams across this long
distance link. Performance is not all what we would have hoped. We thin=
k
that because SRP uses RC mode between initiator and target that it is t=
he RC
behavior over this distance that is impacting performance. Are any of y=
ou
aware of an SRP implementation that uses UC mode.

We appreciate your respones in advance,

Bill
Bill Boas
Tel: 01-510-375-8840
Email: bboas-klaOcWyJdxkshyMvu7JE4pqQE7yCjDx5@public.gmane.org


=20
-----Original Message-----
=46rom: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
[mailto:linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org] On Behalf Of Bart Van Assche
Sent: Tuesday, November 01, 2011 1:48 PM
To: James Bottomley
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org; Fujita Tomo=
nori;
Brian King; David Dillow; Roland Dreier
Subject: Re: srp_transport: Fix atttribute registration race

On Mon, Oct 31, 2011 at 10:33 AM, James Bottomley
<James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org> wrote:
> On Fri, 2011-10-21 at 18:57 +0200, Bart Van Assche wrote:
> > Register transport attributes after the attribute array has been se=
t=20
> > up instead of before. The current code is racy because there is no=20
> > guarantee that the CPU examining the attribute container will see=20
> > all values written to the container.
>
> I don't agree with this change log. =A0As far as the kernel is=20
> concerned, nothing happens until that function returns because the=20
> only way to use anything is to get a match to succeed, and they all=20
> check for
> ->transportt which will be NULL.
>
> I can accept that it's best practise to initialise something before=20
> registering it, because the reverse excites everyone's bogosity=20
> sensors, it's just not a bug in this case.

It's very well possible that I have missed something, but it's not clea=
r to
me what's wrong with the patch description ? At least with ib_srp devic=
e
registration happens from another context than module initialization so=
 it
can potentially run on another CPU. I don't see any kind of memory barr=
ier
after the initialization of the SRP transport attribute array. So at le=
ast
in theory and on an architecture with a sufficiently weak memory model =
(e.g.
the POWER
architecture) there is no guarantee that these store operations will be
observed before an SRP device gets registered. Even more, there is no
guarantee that the CPU on which device registration happens will observ=
e
these store operations in the same order as these were performed on the=
 CPU
that ran srp_attach_transport().

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n the
body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org More majordomo info at
http://vger.kernel.org/majordomo-info.html

--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
