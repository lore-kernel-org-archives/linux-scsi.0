From: Bart Van Assche <bvanassche-HInyCGIudOg@public.gmane.org>
Subject: Re: srp_transport: Fix atttribute registration race
Date: Tue, 1 Nov 2011 19:47:48 +0100
Message-ID: <CAO+b5-oxshsL7Dm7vhv4zC8m0P4dG3iNzxU9sdbi5cBkAnTpMQ@mail.gmail.com>
References: <201110211857.23622.bvanassche@acm.org> <1320053608.8283.29.camel@dabdike>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
In-Reply-To: <1320053608.8283.29.camel@dabdike>
Sender: linux-rdma-owner-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
To: James Bottomley <James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org>
Cc: linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, linux-rdma-u79uwXL29TY76Z2rM5mHXA@public.gmane.org, Fujita Tomonori <fujita.tomonori-Zyj7fXuS5i5L9jVzuh4AOg@public.gmane.org>, Brian King <brking-23VcF4HTsmIX0ybBhKVfKdBPR1lH4CV8@public.gmane.org>, David Dillow <dillowda-1Heg1YXhbW8@public.gmane.org>, Roland Dreier <roland-BHEL68pLQRGGvPXPguhicg@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Oct 31, 2011 at 10:33 AM, James Bottomley
<James.Bottomley-JuX6DAaQMKPCXq6kfMZ53/egYHeGw8Jk@public.gmane.org> wrote:
> On Fri, 2011-10-21 at 18:57 +0200, Bart Van Assche wrote:
> > Register transport attributes after the attribute array has been
> > set up instead of before. The current code is racy because there
> > is no guarantee that the CPU examining the attribute container
> > will see all values written to the container.
>
> I don't agree with this change log. =A0As far as the kernel is concer=
ned,
> nothing happens until that function returns because the only way to u=
se
> anything is to get a match to succeed, and they all check for
> ->transportt which will be NULL.
>
> I can accept that it's best practise to initialise something before
> registering it, because the reverse excites everyone's bogosity senso=
rs,
> it's just not a bug in this case.

It's very well possible that I have missed something, but it's not
clear to me what's wrong with the patch description ? At least with
ib_srp device registration happens from another context than module
initialization so it can potentially run on another CPU. I don't see
any kind of memory barrier after the initialization of the SRP
transport attribute array. So at least in theory and on an
architecture with a sufficiently weak memory model (e.g. the POWER
architecture) there is no guarantee that these store operations will
be observed before an SRP device gets registered. Even more, there is
no guarantee that the CPU on which device registration happens will
observe these store operations in the same order as these were
performed on the CPU that ran srp_attach_transport().

Bart.
--
To unsubscribe from this list: send the line "unsubscribe linux-rdma" i=
n
the body of a message to majordomo-u79uwXL29TY76Z2rM5mHXA@public.gmane.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
