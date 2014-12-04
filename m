From: "Dr. Greg Wettstein" <greg@wind.enjellic.com>
Subject: Re: [Scst-devel] New qla2x00tgt Driver Question
Date: Thu, 4 Dec 2014 01:42:37 -0600
Message-ID: <201412040742.sB47gbGX032229@wind.enjellic.com>
References: <vst@vlnb.net>
Reply-To: greg@enjellic.com
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wind.enjellic.com ([76.10.64.91]:43699 "EHLO wind.enjellic.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750992AbaLDHmu (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 4 Dec 2014 02:42:50 -0500
In-Reply-To: Vladislav Bolkhovitin <vst@vlnb.net>
       "Re: [Scst-devel] New qla2x00tgt Driver Question" (Dec  3,  8:59pm)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>, greg@enjellic.com, Duane Grigsby <duane.grigsby@qlogic.com>, Marc Smith <marc.smith@mcc.edu>, scst-devel <scst-devel@lists.sourceforge.net>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Dec 3,  8:59pm, Vladislav Bolkhovitin wrote:
} Subject: Re: [Scst-devel] New qla2x00tgt Driver Question

> Dr. Greg Wettstein wrote on 12/03/2014 12:46 PM:
> > Secondly, Vlad, we have been running additional testing for the last
> > two days and we have logs from the SCST core which I am including
> > below which suggests that the SCST core target code excessively stalls
> > or mishandles an ABORT while processing a NEXUS_LOSS_SESS TMF.
> > Regardless of your feelings about the target driver code in the kernel
> > we need to make sure there is not some subtle regression in the core
> > SCST code paths during TMF processing.
>
> I don't see any problem on the SCST core level in the logs.

Fair enough, thanks for taking a look.

I though it was somewhat strange to see deferred ABORT's on I/O being
done to RAM based block devices as there is little or no I/O latency.
In our testing, this regression always occurs on TMF function 6
processing and this was also the case in Marc's report.  The comment
that one of the other posters made that this was secondary to slow
backstorage didn't match the characteristics of our test environment.

I see that Duane has identified and is addressing the existence of an
issue with PLOGI/PRLI handling, which must be generic to the Qlogic
target architecture.  I assume, then, that this TMF regression must be
generic to something getting lost in the shuffle when the target port
is processing the asynchronous events.

> Vlad

Have a good week.

}-- End of excerpt from Vladislav Bolkhovitin

As always,
Dr. G.W. Wettstein, Ph.D.   Enjellic Systems Development, LLC.
4206 N. 19th Ave.           Specializing in information infra-structure
Fargo, ND  58102            development.
PH: 701-281-1686
FAX: 701-281-3949           EMAIL: greg@enjellic.com
------------------------------------------------------------------------------
"Simplicity is prerequisite for reliability."
                                -- Edsger W. Dijkstra
