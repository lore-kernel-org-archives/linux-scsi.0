From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH] iscsi_ibft: search for broadcom specific ibft sign
Date: Fri, 9 May 2014 09:20:05 -0400
Message-ID: <20140509132005.GB2899@phenom.dumpdata.com>
References: <1399453220-21663-1-git-send-email-vikas.chaudhary@qlogic.com>
 <20140507134757.GC12826@phenom.dumpdata.com>
 <1399489950.2227.63.camel@dabdike.int.hansenpartnership.com>
 <20140507192158.GA17806@phenom.dumpdata.com>
 <536A8E67.7030805@cs.wisc.edu>
 <20140507201524.GA26303@fenchurch.internal.datastacks.com>
 <536A97E6.6000907@cs.wisc.edu>
 <536A9E33.70406@cs.wisc.edu>
 <3FC4AB8B47ECD546BCD4B361A64BEACD8C69A63A@avmb3.qlogic.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:21220 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754928AbaEINWA (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 May 2014 09:22:00 -0400
Content-Disposition: inline
In-Reply-To: <3FC4AB8B47ECD546BCD4B361A64BEACD8C69A63A@avmb3.qlogic.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Peter Jones <pjones@redhat.com>, James Bottomley <jbottomley@parallels.com>, linux-scsi <linux-scsi@vger.kernel.org>, Giridhar Malavali <giridhar.malavali@qlogic.com>, "konrad@kernel.org" <konrad@kernel.org>, Dept-Eng iSCSI Driver <Dept-iSCSIDriver@qlogic.com>

On Fri, May 09, 2014 at 11:50:20AM +0000, Vikas Chaudhary wrote:
> 
> 
> On 08/05/14 2:27 am, "Mike Christie" <michaelc@cs.wisc.edu> wrote:
> 
> >On 05/07/2014 03:30 PM, Mike Christie wrote:
> >> On 05/07/2014 03:15 PM, Peter Jones wrote:
> >>> On Wed, May 07, 2014 at 02:49:59PM -0500, Mike Christie wrote:
> >>>> On 05/07/2014 02:21 PM, Konrad Rzeszutek Wilk wrote:
> >>>>> On Wed, May 07, 2014 at 07:12:31PM +0000, James Bottomley wrote:
> >>>>>> On Wed, 2014-05-07 at 09:47 -0400, Konrad Rzeszutek Wilk wrote:
> >>>>>>> On Wed, May 07, 2014 at 05:00:20AM -0400,
> >>>>>>>vikas.chaudhary@qlogic.com wrote:
> >>>>>>>> From: Vikas Chaudhary <vikas.chaudhary@qlogic.com>
> >>>>>>>>
> >>>>>>>> Broadcom iscsi offload firmware uses a non standard ibft sign of
> >>>>>>>>"BIFT".
> >>>>>>>
> >>>>>>> Why? If it uses the standard iBFT format why does it use
> >>>>>>> a non-standard signature?
> >>>>>>
> >>>>>> This is useful as an academic exercise (and perhaps even a reminder
> >>>>>>to
> >>>>>> broadcom not to do it again) but I don't think we can make it a show
> >>>>>> stopper.  The boards have shipped with the non-standard signature,
> >>>>>>so we
> >>>>>> have to work with them.
> >>>>>
> >>>>> I agree as the train has left, but this got me thinking about these
> >>>>> questions that I hope Qlogic folks could answer:
> >>>>>
> >>>>>  - Mention what else is different - perhaps there are other entries
> >>>>>that
> >>>>>    are a bit different? Or maybe the are some non-standard ones
> >>>>>added on?
> >>>>>
> >>>>>  - How has this been tested? As in had all the fields been tested
> >>>>>(so CHAP
> >>>>>    on/off, extra ports, etc).
> >>>>>
> >>>>
> >>>> This supports the same stuff as was added in the original commit for
> >>>> that string:
> >>>>
> >>>> 140363500ddadad0c09cb512cc0c96a4d3efa053
> >>>>
> >>>> It just was not carried over in the acpi specific table in commit
> >>>> 935a9fee51c945b8942be2d7b4bae069167b4886.
> >>>
> >>> Okay, but that patch leaves the scanning for it pre-ACPI intact.
> >> 
> >> Before 935a9fee51c945b8942be2d7b4bae069167b4886, didn't we check for
> >> BIFT in the ACPI table case?
> >> 
> >> Before that patch, we used to do:
> >> drivers/firmware/iscsi_ibft_find.c:find_ibft_region()
> >> 
> >>         for (i = 0; i < ARRAY_SIZE(ibft_signs) && !ibft_addr; i++)
> >>                 acpi_table_parse(ibft_signs[i].sign, acpi_find_ibft);
> >> 
> >> and BIFT was in that ibft_signs array.
> >> 
> >> I was just saying I thought since we added support for BIFT, we had been
> >> checking for it in the ACPI case.
> >
> >
> >I think I am in the wrong. When I added that support I thought BIFT was
> >supposed to be for both the ACPI and the RAM case, so I had coded it
> >like above. I am not seeing that in the old mails though, so you might
> >be right and they just are now adding support for ACPI. Will just wait
> >for qlogic/broadcom.
> 
> Mike, In your original patch 140363500ddadad0c09cb512cc0c96a4d3efa053 we
> are checking for BIFT, and BIFT was in ibft_signs[] array which is defined
> in iscsi_ibft_find.c.
> Latter when patch 935a9fee51c945b8942be2d7b4bae069167b4886 get added, this
> patch defined new array of ibft_signs[] in iscsi_ibft.c which does not
> have BIFT signature.
> Patch 935a9fee51c945b8942be2d7b4bae069167b4886 added to fix finding IBFT
> ACPI table on UEFI. We are just enhancing this patch.

In a nutsheel this is a fix for a regression that has been there since 3.2
and introduced by 935a9fee51c945b8942be2d7b4bae069167b4886 ("ibft: Fix finding
IBFT ACPI table on UEFI").

Vikas,
Could you resend the patch and include these details in the commit messages:
That this is a fix for said regression and what cards it impacts (or firmwares).

Thank you.

Since this is a regression I can send the patch to Linus right away - but
I really would like to have that information in the git commit message
so that Linus doesn't look funny at me.
