From: Greg Dickie <greg@max-t.com>
Subject: Re: megaraid_sas waiting for command and then offline
Date: Tue, 12 Dec 2006 07:30:49 -0500
Message-ID: <1165926657.4991.132.camel@edinburgh.max-t.internal>
References: <457E1C59.80208@metacarta.com> <457E3D0D.7070707@imvu.com>
	 <457E43BE.9040806@metacarta.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from h216-18-124-229.gtcust.grouptelecom.net ([216.18.124.229]:52280
	"EHLO mail.max-t.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751259AbWLLMbY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Dec 2006 07:31:24 -0500
In-Reply-To: <457E43BE.9040806@metacarta.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joseph Malicki <jmalicki@metacarta.com>
Cc: "Brett G. Durrett" <brett@imvu.com>, linux-scsi@vger.kernel.org, linux-poweredge@dell.com, "David N. Welton" <d.welton@webster.it>, Sumant Patro <Sumant.Patro@lsil.com>, "Marc A. Meadows" <mam+megaraid@metacarta.com>, "Keith R. Baker" <krbaker+megaraid@metacarta.com>

We've never had lockups like this but we did notice that the
megaraid_sas modules defaults to a much higher commands per lun setting
than the hardware seems to be able to handle. IIRC the default is 128
and we lowered it to 16 for the 5i and 32 for the 5E.

HTH,
Greg


On Tue, 2006-12-12 at 00:53 -0500, Joseph Malicki wrote:
> Hi Brett!
> 
> Thanks for the response, hopefully we can gather enough data points to 
> help solve the problem.
> 
> The new PERC 5/i integrated firmware dated 11/21/2006 is at:
> http://support.dell.com/support/downloads/format.aspx?c=us&l=en&s=gen&SystemID=PWE_2950&os=LIN4&osl=en&deviceid=9182&typecnt=2&libid=46&releaseid=R139225&vercnt=3
> PERC 5/E adapter: 
> http://support.dell.com/support/downloads/format.aspx?c=us&l=en&s=gen&SystemID=PWE_2950&os=LIN4&osl=en&deviceid=9181&typecnt=2&libid=46&releaseid=R139227&vercnt=2
> 
> The release notes describe very similar symptoms, but I am not ready to 
> believe it yet as I can't reliably reproduce the problem well enough to 
> be confident of a fix, though it sounds like you might be able to.    
> Unfortunately we're using Debian at the moment, but if I can reproduce I 
> can run on RHEL in a heartbeat to duplicate it for support (for now I'm 
> trying to minimize variables).
> 
> Also, which driver version are you running?  I noticed you were using 
> some patches from Sumant Patro@LSI - is your driver identical to the one 
> in 2.6.19?  If not, what does it look like?
> 
> Have you noticed any correlations with patrol reads at the times of the 
> failures? You can tell by running MegaCli -FwTermLog -Dsply -aALL
> 
> What hardware are you running (CPUs, RAM, disk configuration)?
> 
> Have you noticed any correlation with heavy network I/O (as well as disk 
> I/O)?  Some of our systems may have experienced this when running more 
> network load than typical.
> 
> 
> Thanks!
> Joe
> 
> Brett G. Durrett wrote:
> >
> > I am still seeing this and we have between 2 and 5 failures per week 
> > (across almost 20 machines).  I am seeing it on ext3 (we migrated all 
> > of the machines from XFS) and with ReadAhead disabled.
> >
> > You mention a firmware update but I don't see any new PERC 5 firmware 
> > packages on Dell's site... can you give me a pointer to the firmware 
> > update?
> >
> > Also, has anybody had this problem on RHE?  Dell does not support 
> > Linux unless it is RHE... I would be surprised is somehow RHE did not 
> > have this problem.
> >
> > B-
> >
> >
> >
> > Joe Malicki wrote:
> >>>  I have the same or a similar issue running 2.6.17 SMP x86_64 - the
> >>> megaraid_sas driver hangs waiting for commands and then the filesystem
> >>> unmounts, leaving the machine in an unusable state until there is a 
> >>> hard
> >>> reboot (the machine is responsive but any access, shell or 
> >>> otherwise, is
> >>> impossible without the filesystem). While I do not have much debugging
> >>> information available, this happens to me about once every 6-7 days in
> >>> my pool of seven machines, so I can probably get debugging info. Since
> >>> the disk is offline and I can't get remote console, I don't have any
> >>> details except something similar to Dave Lloyd's post, below.
> >>>     
> >>
> >
> 
> _______________________________________________
> Linux-PowerEdge mailing list
> Linux-PowerEdge@dell.com
> http://lists.us.dell.com/mailman/listinfo/linux-poweredge
> Please read the FAQ at http://lists.us.dell.com/faq
-- 
Greg Dickie
just a guy
Maximum Throughput

