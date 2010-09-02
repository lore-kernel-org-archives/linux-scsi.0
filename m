From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [Scst-devel] [ANNOUNCE]: Comparison of features between
	different SCSI targets (SCST, STGT, IET, LIO) updated
Date: Thu, 02 Sep 2010 14:31:18 -0700
Message-ID: <1283463078.5598.169.camel@haakon2.linux-iscsi.org>
References: <4C7FFB85.7000006@vlnb.net>
	 <AANLkTikYgSrW-fSRNBMU2DWYk2x1xQSAqKhoW1Lijj4N@mail.gmail.com>
	 <1283458331.5598.129.camel@haakon2.linux-iscsi.org>
	 <AANLkTinf7OgOodts3dvpg99+PFwKtxM631MsLzrJx4mv@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp103.sbc.mail.re3.yahoo.com ([66.196.96.86]:32789 "HELO
	smtp103.sbc.mail.re3.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1755365Ab0IBVfS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Sep 2010 17:35:18 -0400
In-Reply-To: <AANLkTinf7OgOodts3dvpg99+PFwKtxM631MsLzrJx4mv@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chris Weiss <cweiss@gmail.com>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, scst-devel <scst-devel@lists.sourceforge.net>, iscsitarget-devel@lists.sourceforge.net, stgt@vger.kernel.org, James Bottomley <James.Bottomley@hansenpartnership.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, Mike Christie <michaelc@cs.wisc.edu>, Ross Walker <rswwalker@gmail.com>

On Thu, 2010-09-02 at 15:50 -0500, Chris Weiss wrote:
> On Thu, Sep 2, 2010 at 3:12 PM, Nicholas A. Bellinger
> <nab@linux-iscsi.org> wrote:
> >> as a user following the potential inclusion of a kernel-space target,
> >> iscsi specifically, I would be very interested in seeing what other
> >> pluses the other frameworks have over scst, because if this chart is
> >> accurate, all the other targets have quite a ways to go to catch up.
> >>
> >
> > Actually sorry, anyone who has spent more than 30 minutes looking at the
> > TCM v4 code that has already been posted to linux-scsi on monday knows
> > this list just more handwaving.  I suggest you start doing the same
> > (actually discussion specific source file + line refrences) unless you
> > actually want to trust this hopelessly out-of-date list on blind
> > princaple.
> 
> I'm just an end user, I have no interesting in line-by-line
> comparisons or specs details.  I do, however, have interest in bullet
> points, and the lack of bullet points, that throw up red flags to 3rd
> party support contracts.  So, did the kernel team, or some other
> impartial source, compile a similar but not out of date list, and is
> it available for viewing?

Ok, but please understand that this is a technical list where we discuss
specifics of kernel code, and produce and review patches to reach a
desired goal.

One of the reason that TCM/LIO has been selected over SCST is because
our patch workflow over the recent yeras demonstrates exactly this point
the mainline folks who are following along.  For the new persistent
reservations and ALUA multipath features that have been developed in
recent times, the code was added feature bit by feature bit in a
reviewablle manner, with each patch series going to linux-scsi for
comments.  This allowed the code to benefit in a number of cases where
different people (including Tomo-san, mnc, and others) noticed something
strange in their own testing, and in each case we where able to get the
item resolved. The scoreboard for these features is on the wiki here:

http://linux-iscsi.org/index.php/Persistent_Reservations
http://linux-iscsi.org/index.php/ALUA

In terms of some feature list about who supports what for the mainline
discussion, this is quite pointless at this point.  The best way for
mainline people to know what your stack supports is to actually add
support for said feature in reviewable and digestable pieces that are
presented in much a manner that they are accessable to a larger
audicence.  Just developing code some-where else and posting the entire
thing means the code in question does not benefit by public review
during the development phase.

> 
> > First, understand that Vlad has been asked to produce a problem use case
> > for his CRH=1 (Compatibility Reservation Handling) concerns using the
> > SPC-3 RESERVE/RELEASE methods with the TCM v4 code.  He has been never
> > been able to produce a use case, ever.  Also, just for reference, does
> > SCST's SPC-3 persisent reservation handling actually properly support
> > CRH=1 emulation from spc4r17..?  Last time I checked, it most certainly
> > did *not*.
> 
> I haven't tested this specifically, and I'm not even sure that the use
> case is right, but ESX (the only initiator i actually use) uses
> reservations when expanding vmdk files for size, thin provisioning,
> and snapshots.  If I'm running big expands on 2 separate ESX nodes on
> the same iscsi or FC LUN, can you be sure that I won't have a
> collision without reservations?  And I mean 100% absolute sure.
> 

We have some people happly using ESX with LUN_RESET emulation with CDB
level emulation with TCM/FILEIO , TCM/IBLOCK and with TCM/pSCSI in
passthrough mode.

> > Second, in terms of TM emulation / passthrough support in the TCM v4
> > code, we follow what is implemented in drivers/scsi ML and LLDs,
> > primarly to properly for Linux SCSI Initiators.  I honestly don't have
> > alot of interesting currently in implementing all of the ancient TM
> > emulation that none of the mainline SCSI LLDs in Linux implement today,
> > or plan to do the future.  As for specific TM concerns, I am happy to
> > address then on a case by case basis with the appropiate use case.
> 
> Vmware's ESX uses ABORT extensively with network errors and when the
> targets backend goes belly up, and just plain goes nuts if it doens't
> get the kind of response that completely makes sense to it, typically
> requiring the ESX node to be rebooted to get out of a confused state.
> Maybe this is a failure in ESX's initiator, but ESX is following the
> specs, or at least they claim to be.

Yes, it needs to fall back to LUN_RESET, or reset the iSCSI I_T nexus.
I am happy to add proper TASK_ABORT support into TCM v4 at some point
down the line.  However if you can demonstrate that this is a real issue
to me for your particular setup/version of ESX with LUNs reporting SPC-2
or SPC-3 support, I would be happy to consider bumping this up the
priority list.

> 
> And a question that never got answered in another thread:  how many
> OSS and commercial products are using LIO?  and how many of those are
> certified and supported by other commercial products?  This is
> directly related to impartial testing as well as standards
> implementation, stability, and "plays nice with others".  Or in other
> words, where I can look at an example implementation of LIO that's
> considered by someone who is not you to be production ready?

TCM/LIO v3 has been validated for the highest level of Vsphere 4
compliance (eg: above ESX which only uses SPC-2) with >= SPC-3
compatiable Persistent Reservations and ALUA multipath.

http://linux-iscsi.org/index.php/Ecosystem

The vendors on this list including, but not limited to QNAP, Data
Robotics, and Netgear have all received independent SPC-3 SCSI LUN
verification with VMware using TCM/LIO v3.x directly over the last 12
months.  Which means that here in North America, you can walk into just
about any major electronic store that carries these products, and
purchase TCM/LIO v3.x in shrinkwrap form from multiple vendors on
multiple hardware platforms. In some cases, these products using a
custom set of userspace /sys/kernel/config/target/ scripts code (of
varing degrees of quality) with a propritary web-interface (also of
varing degrees of quality) on top.

Best,

--nab

