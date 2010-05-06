From: "Moger, Babu" <Babu.Moger@lsi.com>
Subject: RE: [PATCH 0/2] dm: Add no_abort_q feature flag to dm-mpath
Date: Thu, 6 May 2010 08:38:32 -0600
Message-ID: <E463DF2B2E584B4A82673F53D62C2EF498E061F6@cosmail01.lsi.com>
References: <1272945691-31649-1-git-send-email-andmike@linux.vnet.ibm.com>
 <E463DF2B2E584B4A82673F53D62C2EF498E060CB@cosmail01.lsi.com>
 <20100506013917.GA9298@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aog102.obsmtp.com ([74.125.149.69]:45251 "EHLO
	na3sys009aog102.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752837Ab0EFOiv convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 6 May 2010 10:38:51 -0400
In-Reply-To: <20100506013917.GA9298@linux.vnet.ibm.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@linux.vnet.ibm.com>
Cc: "dm-devel@redhat.com" <dm-devel@redhat.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

> -----Original Message-----
> From: Mike Anderson [mailto:andmike@linux.vnet.ibm.com]
> Sent: Wednesday, May 05, 2010 8:39 PM
> To: Moger, Babu
> Cc: dm-devel@redhat.com; linux-scsi@vger.kernel.org
> Subject: Re: [PATCH 0/2] dm: Add no_abort_q feature flag to dm-mpath
> 
> Moger, Babu <Babu.Moger@lsi.com> wrote:
> > > -----Original Message-----
> > > From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-
> > > owner@vger.kernel.org] On Behalf Of Mike Anderson
> > > Sent: Monday, May 03, 2010 11:01 PM
> > > To: dm-devel@redhat.com
> > > Cc: linux-scsi@vger.kernel.org
> > > Subject: [PATCH 0/2] dm: Add no_abort_q feature flag to dm-mpath
> > >
> > > This patch series contains two patches.
> > >
> > > 1.) The first patch adds a feature flags bit field to the multipath
> > > structure for selected features.
> > >
> > > 2.) The second patch allows a user to set a feature flag for a dm-
> mpath
> > > device of "no_abort_q" to indicate that deactivate_path should not
> call
> > > blk_abort_queue. I tried to select a short feature name to feature
> > > output
> > > listed with multipath -l would not be too long "features='2
> > > queue_if_no_path
> > > no_abort_q'
> >
> > Mike,
> >  In what special circumstances you recommend to use this feature? It
> would be great if you could add that explanation in your patch
> descriptions.
> 
> Yes I will update the descriptions.
> 
> To answer your question in general it would be circumstance where the
> block_abort_queue during failover is leading to longer recovery instead
> of
> shorter. This could be because of aborting / transport / device
> interactions (the work by others in the iSCSI and FC transports have
> made
> things better here).
> 
> While there are case where abort makes a big difference (being able to
> failover in less than max_retries * IO timeout value). The latency
> numbers
> for simple RDAC initiator failover show only small improvements on my
> configurations (others may have better data). A assumption would be
> that
> there could be combinations of transports and devices out there where
> this
> might not give the fastest failover so the user may want control.
> 
> On a historically note the call to block_abort_queue came in somewhat
> sideways by me linked to the timeout movement from SCSI to blk so it
> could
> have integrated better. I should have had a way to disable / enable it
> then and I am trying to provide that now so that the user has some
> control.

Thanks for the details.

