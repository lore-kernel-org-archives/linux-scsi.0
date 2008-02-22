From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [PATCH] libsas: fix error handling
Date: Fri, 22 Feb 2008 04:19:58 -0800 (PST)
Message-ID: <63979.49270.qm@web31807.mail.mud.yahoo.com>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31807.mail.mud.yahoo.com ([68.142.207.70]:22056 "HELO
	web31807.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1756100AbYBVMUA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 22 Feb 2008 07:20:00 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

--- On Thu, 2/21/08, James Bottomley <James.Bottomley@HansenPartnership.com> wrote:
> Look, Luben; I don't mind you making an arse of
> yourself on the mailing
> lists; that's about par for the course nowadays.

No, you just did in this thread by pretending to be any kind of
authority or have an expertise on how to fix this problem, while in
fact to properly address it, one really needs knowledge of the
protocol, how the HW works and how the sequencer works, and
a protocol trace of this specific problem.  And then fixing the
problem after it's been fully understood is yet another feat.

It's unfortunate that you feel the need to attack me and call
me names.  You need to self-examine yourself and figure out
and fix your hostile attitude.

I've mostly stopped exposing your complete and utter incompetence
in SCSI infrastructure and left the weed grow, but calling me names
on public lists is very unprofessional.

Speaking of "arse", a recent example of one of your "pearls" is this:
http://marc.info/?l=linux-ide&m=120291905515015&w=2
"However, I'm happy to be proven wrong ... anyone on this thread is
 welcome to come up with a userland enclosure infrastructure.  Once it
 does everything the in-kernel one does (which is really about the
 minimal possible set), I'll be glad to erase the in-kernel one."

You introduce unnecessary code, the vendors tell you they don't
agree with you, you respond with "I'm happy to be proven wrong" in spite
of everyone's opinion differing yours.  You clearly decide to do what
you think is right without listening to vendors or people in the
industry.  Also, you completely ignore sg_ses(8).

There are other examples, this one is just more recent.

> However, failing to report serious bugs you knew about in
> your code, and
> have known about for two years, is tantamount to sabotage
> ... especially

In 2005, you decided to take a working code out of a GIT tree,
change it privately, and then submit it to GIT as new. Since of
course GIT history is immutable, there is no way to sync back to the
solution I had for users to inspect, evaluate and compare to your
derived code, since you took it out of GIT and changed it privately
before submitting it back to the kernel (I had a GIT repo with
already integrated working code, synced daily to Linus' kernel).  Then
a lot of people started asking me: "It doesn't work" and "SATA
doesn't work", etc, and I had to explain over and over again
what's happened.  So please do not talk about sabotage.

You changed the code quite a bit, to the point where patches
between what I maintain and what you decided to fork off
and make it your own play-ground were different and patches wouldn't
apply cleanly or at all.

For this thread, I've looked at the "error handling" code of what's
in the kernel for aic94xx and your version of the "libsas" and
frankly, I cannot submit patches to something which completely does
NOT follow the Sequencer Interface Spec for AIC94xx series of chips.
For example, handling of REQ_TASK_ABORT -- its implementation is
quite naive and out of spec, i.e. already broken.  I cannot submit
patches to something that I know is already broken, which had
been changed from a per-spec code version.

You know, people are still asking me to sync up to kernel
x.y.z the SAS/SATL+aic94xx I maintain, because they tell me "have been
running it for 2 years on production hardware [i.e. IBM] and no
problems and I just need to upgrade the kernel".

Will you also attack me for having a SATL as part of my SAS code
which I didn't submit to the kernel?  Do you know how much code
is out there that vendors don't bother to try to integrate because
of your attitude such as this?

> when you've been reading the bug reports on the mailing
> list.  I have to
> wonder how many more such bugs you've left in the code
> for users to
> find.

I didn't "leave" any bugs.  Bugs are just part of the development
cycle.  You should know this.

aic94xx is an old product, most customers have upgraded.
The ones who still have IBM servers with this chip, have had the
need to upgrade their kernels for various other reasons and since the
in-kernel solution has failed them, have requested to run my code.

> > BTW, the problem you're "debugging" may
> require a protocol
> > trace and a sequencer update by Adaptec.
> 
> I think you're fully aware that my test rig consists of
> a couple of SAS
> cards and drives donated by IBM and two expanders donated
> by LSI, plus a bit of equipment scavenged from Intel.

No, I'm not aware of this.  I have absolutely no interest in what your
"test rig" consists of.

Here is a question though: why do you even have SAS HW?  You don't
work for a SAS HW vendor and you don't have expertise in SAS
or SCSI in general.  Do you have hardware for each and every
LLDD that's in the kernel?

> I have no access to sophisticated tools like protocol analyzers.

See above.  You don't need to have access to such things unless
you worked for a vendor, and your job is to make your employer's
customers happy, by looking at traces everyday and fixing bugs.
And this itself isn't an easy matter, you need to talk to the
HW engineers, understand the protocol, understand the hardware,
how it implements the protocol, maybe need to read RTL code, all
things which are really out of your domain.

Now if you don't have access to such things, don't give "expert"
advice, and leave it to the respective vendor to get involved.
They have the equipment and the interest to debug their customers'
problems.  Then those vendors would submit patches for you
to integrate.

>  However, thanks for the advice and help.

Hey, no problem, anything for you James.

    Luben

