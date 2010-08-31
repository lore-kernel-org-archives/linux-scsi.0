From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: libfc_lport.c:fc_lport_recv_req() dropping struct fc_seq
	parameter for v2.6.36-rc3..?
Date: Tue, 31 Aug 2010 14:00:30 -0700
Message-ID: <1283288430.32007.495.camel@haakon2.linux-iscsi.org>
References: <1283285663.32007.476.camel@haakon2.linux-iscsi.org>
	 <4C7D6B2A.5060609@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp101.sbc.mail.gq1.yahoo.com ([67.195.15.60]:39072 "HELO
	smtp101.sbc.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751911Ab0HaVES (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 31 Aug 2010 17:04:18 -0400
In-Reply-To: <4C7D6B2A.5060609@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Eykholt <jeykholt@cisco.com>
Cc: linux-iscsi-target-dev@googlegroups.com, "Love, Robert W" <robert.w.love@intel.com>, openfcoe-devel <devel@open-fcoe.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Tue, 2010-08-31 at 13:50 -0700, Joe Eykholt wrote:
> 
> On 8/31/10 1:14 PM, Nicholas A. Bellinger wrote:
> > Hi Joe and Robert,
> > 
> > So after jumping to v2.6.36-rc3 for the lio-core-2.6.git/lio-4.0 branch
> > recently and fixing some minor breakage around the original struct
> > fc4_prov patches I merged from Joe in the spring, mostly having to do
> > with drivers/scsi/libfc/libfc_lport.c:fc_lport_recv_req() changes from
> > this commit:
> > 
> > [SCSI] libfc: don't require a local exchange for incomining requests
> > http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=922611569572d3c1aa0ed6491d21583fb3fcca22
> > 
> > I was able to get libfc + struct fc4_prov compiling after fixing the
> > conflicts.  However, I have run into non-trivial breakage in the
> > Open-FCoE.org / TCM_FC fabric module itself because of it's dependence
> > bit upon having direct access to the passed struct fc_seq.   The code
> > currently assigns to struct fc_seq * to struct ft_cmd->seq, and gets
> > used in a number of subsequent areas after the struct fc4_prov->recv()
> > entry hook at drivers/target/tcm_fc/tfc_cmd.c:ft_recv_cmd() gets called.
> > 
> > I took a very brief look at trying to resolve the breakage myself, but
> > quickly got a bit lost in terms of what TCM_FC actually needs to be
> > accessing struct fc_seq directly for.  Would either of you gentlemen
> > mind giving me a bit of insight into what you think would be required by
> > TCM_FC in order to function with the recent libfc fc_lport_recv_req()
> > changes..?
> 
> I caused this problem, and anticipated that I would have
> to make changes to tcm_fc to accommodate it.  Then I forgot by the
> time it made it upstream.

<nod>

> 
> Now incoming requests don't get a sequence assigned unless they ask for
> it, so we need to call lport->tt.seq_assign() for the request.
> It turns out I forgot that that takes a reference on the sequence, so
> I have another patch to add to drop the refcnt.
> 

Ahh, I think I understand a bit more now, thanks for the extra context
here.  Does this mean that lport->tt.seq_assign() will be returning the
struct fc_exch * used by the primary READ/WRITE handlers in tfc_io.c
code..?

> I can work on this at some point in the next few days if you can wait.
> 

Sure, no rush on this item.  I was just curious to understand the bigger
picture of the recent changes you guys have been working on.  8-)

Thanks for your comments Joe!

--nab


