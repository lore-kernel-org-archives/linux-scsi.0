From: Chris Weiss <cweiss@gmail.com>
Subject: Re: [Scst-devel] [ANNOUNCE]: Comparison of features between different
 SCSI targets (SCST, STGT, IET, LIO) updated
Date: Thu, 2 Sep 2010 15:50:30 -0500
Message-ID: <AANLkTinf7OgOodts3dvpg99+PFwKtxM631MsLzrJx4mv@mail.gmail.com>
References: <4C7FFB85.7000006@vlnb.net> <AANLkTikYgSrW-fSRNBMU2DWYk2x1xQSAqKhoW1Lijj4N@mail.gmail.com>
 <1283458331.5598.129.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1283458331.5598.129.camel@haakon2.linux-iscsi.org>
Sender: linux-kernel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, scst-devel <scst-devel@lists.sourceforge.net>, iscsitarget-devel@lists.sourceforge.net, stgt@vger.kernel.org, James Bottomley <James.Bottomley@hansenpartnership.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Ross Walker <rswwalker@gmail.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, Sep 2, 2010 at 3:12 PM, Nicholas A. Bellinger
<nab@linux-iscsi.org> wrote:
>> as a user following the potential inclusion of a kernel-space target=
,
>> iscsi specifically, I would be very interested in seeing what other
>> pluses the other frameworks have over scst, because if this chart is
>> accurate, all the other targets have quite a ways to go to catch up.
>>
>
> Actually sorry, anyone who has spent more than 30 minutes looking at =
the
> TCM v4 code that has already been posted to linux-scsi on monday know=
s
> this list just more handwaving. =A0I suggest you start doing the same
> (actually discussion specific source file + line refrences) unless yo=
u
> actually want to trust this hopelessly out-of-date list on blind
> princaple.

I'm just an end user, I have no interesting in line-by-line
comparisons or specs details.  I do, however, have interest in bullet
points, and the lack of bullet points, that throw up red flags to 3rd
party support contracts.  So, did the kernel team, or some other
impartial source, compile a similar but not out of date list, and is
it available for viewing?

> First, understand that Vlad has been asked to produce a problem use c=
ase
> for his CRH=3D1 (Compatibility Reservation Handling) concerns using t=
he
> SPC-3 RESERVE/RELEASE methods with the TCM v4 code. =A0He has been ne=
ver
> been able to produce a use case, ever. =A0Also, just for reference, d=
oes
> SCST's SPC-3 persisent reservation handling actually properly support
> CRH=3D1 emulation from spc4r17..? =A0Last time I checked, it most cer=
tainly
> did *not*.

I haven't tested this specifically, and I'm not even sure that the use
case is right, but ESX (the only initiator i actually use) uses
reservations when expanding vmdk files for size, thin provisioning,
and snapshots.  If I'm running big expands on 2 separate ESX nodes on
the same iscsi or FC LUN, can you be sure that I won't have a
collision without reservations?  And I mean 100% absolute sure.

> Second, in terms of TM emulation / passthrough support in the TCM v4
> code, we follow what is implemented in drivers/scsi ML and LLDs,
> primarly to properly for Linux SCSI Initiators. =A0I honestly don't h=
ave
> alot of interesting currently in implementing all of the ancient TM
> emulation that none of the mainline SCSI LLDs in Linux implement toda=
y,
> or plan to do the future. =A0As for specific TM concerns, I am happy =
to
> address then on a case by case basis with the appropiate use case.

Vmware's ESX uses ABORT extensively with network errors and when the
targets backend goes belly up, and just plain goes nuts if it doens't
get the kind of response that completely makes sense to it, typically
requiring the ESX node to be rebooted to get out of a confused state.
Maybe this is a failure in ESX's initiator, but ESX is following the
specs, or at least they claim to be.

And a question that never got answered in another thread:  how many
OSS and commercial products are using LIO?  and how many of those are
certified and supported by other commercial products?  This is
directly related to impartial testing as well as standards
implementation, stability, and "plays nice with others".  Or in other
words, where I can look at an example implementation of LIO that's
considered by someone who is not you to be production ready?
