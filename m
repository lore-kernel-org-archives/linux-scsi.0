From: "Dr. Greg Wettstein" <greg@wind.enjellic.com>
Subject: Re: [Scst-devel] OSS target - VMware SCSI reservation bug conformity.
Date: Fri, 4 Apr 2014 09:23:20 -0500
Message-ID: <201404041423.s34ENKdl021748@wind.enjellic.com>
References: <nab@linux-iscsi.org>
Reply-To: greg@enjellic.com
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wind.enjellic.com ([76.10.64.91]:48075 "EHLO wind.enjellic.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753195AbaDDOYU (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 4 Apr 2014 10:24:20 -0400
In-Reply-To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
       "Re: [Scst-devel] OSS target - VMware SCSI reservation bug conformity." (Apr  3,  1:21pm)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>, scst-devel@lists.sourceforge.net, linux-scsi@vger.kernel.org

On Apr 3,  1:21pm, "Nicholas A. Bellinger" wrote:
} Subject: Re: [Scst-devel] OSS target - VMware SCSI reservation bug conform

Hi Nicholas, thanks for weighing in on this issue.

> > I had the following reasons for raising the issue:
> > 
> > 	1.) Does anyone in the open-source storage eco-system,
> > 	    ie. SCST/LIO whatever, have any confirmation that this
> > 	    is a known issue.
> > 

> FYI guys, AFAICT this bug is specific to targets that don't support
> VAAI AtomicTestandSet (COMPARE_AND_WRITE), and need to use the
> legacy SCSI-2 reservations instead.

Which, at this point in time, is probably a significant percentage of
the SAN's, both commercial and open-source based, which are feeding
storage to ESXi initiators.

> When AtomicTestandSet is available, ESX will avoid using
> reservations to lock the whole LUN and obtain exclusive access to
> individual VMFS extent on a per node basis instead.

With subsequent performance advantages as well.

ATS is obviously the path forward for multiple reasons.  Unfortunately
I have heard from multiple sources that vendors have already written
their VAAI implementations to be conformant with how ESXi works rather
then the letter of the standard.  Which potentially places us back
into the situation we are with SCSI reservations.

Obviously Dell/EqualLogix addresses this issue or a similar problem
with their 6.0.6H2 firmware and VMware is urging people to upgrade.
That may be a EqualLogix controller error fix in which case it isn't
relevant to those of in this community.

If, on the other hand, there is something which can be done on the
target side to remediate the condition it is to the obvious advantage
of both LIO and SCST to know what that might be.  The question isn't
about advertised feature sets the question is the reality of how any
of this technology works in the field.

The case we are looking at is a perfect example.  The ESXi initiators
retried I/O's several hundred times in the last year, I looked up
everyone one of them in the logs.  Reality isn't standards compliance
but what happens when systems are running at 380 megabytes/second
throughput and something wonky happens and triggers an edge case.

Anyone who knows storage knows that storage managers/architects are
legendary for running firmware or code releases that 'work'.  Better
the devil you know then the devil you don't.  I suspect that will be a
constraint for a long time with respect to rushing into ATS/VAAI
version 1.0 implementations.

Quite frankly the other reality is that if someone does know how to
fix this on the target side they probably are not going to talk about
it, competitive advantage and all that.....

> --nab

Have a good weekend.

Greg

}-- End of excerpt from "Nicholas A. Bellinger"

As always,
Dr. G.W. Wettstein, Ph.D.   Enjellic Systems Development, LLC.
4206 N. 19th Ave.           Specializing in information infra-structure
Fargo, ND  58102            development.
PH: 701-281-1686
FAX: 701-281-3949           EMAIL: greg@enjellic.com
------------------------------------------------------------------------------
"A computer without Windows is like a fish without a bicycle."
                                -- Chris Woods
