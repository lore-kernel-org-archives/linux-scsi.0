From: Joe Eykholt <jeykholt-FYB4Gu1CFyUAvxtiuMwx3w@public.gmane.org>
Subject: Re: libfc_lport.c:fc_lport_recv_req() dropping struct
 fc_seq parameter for v2.6.36-rc3..?
Date: Tue, 31 Aug 2010 13:50:50 -0700
Message-ID: <4C7D6B2A.5060609@cisco.com>
References: <1283285663.32007.476.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org>
In-Reply-To: <1283285663.32007.476.camel-Y1+j5t8j3WgjMeEPmliV8E/sVC8ogwMJ@public.gmane.org>
List-Unsubscribe: <http://www.open-fcoe.org/mailman/listinfo/devel>,
	<mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=unsubscribe>
List-Archive: <http://www.open-fcoe.org/pipermail/devel>
List-Post: <mailto:devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>
List-Help: <mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=help>
List-Subscribe: <http://www.open-fcoe.org/mailman/listinfo/devel>,
	<mailto:devel-request-s9riP+hp16TNLxjTenLetw@public.gmane.org?subject=subscribe>
Sender: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
Errors-To: devel-bounces-s9riP+hp16TNLxjTenLetw@public.gmane.org
To: linux-iscsi-target-dev-/JYPxA39Uh5TLH3MbocFFw@public.gmane.org
Cc: openfcoe-devel <devel-s9riP+hp16TNLxjTenLetw@public.gmane.org>, linux-scsi <linux-scsi-u79uwXL29TY76Z2rM5mHXA@public.gmane.org>
List-Id: linux-scsi@vger.kernel.org



On 8/31/10 1:14 PM, Nicholas A. Bellinger wrote:
> Hi Joe and Robert,
> 
> So after jumping to v2.6.36-rc3 for the lio-core-2.6.git/lio-4.0 branch
> recently and fixing some minor breakage around the original struct
> fc4_prov patches I merged from Joe in the spring, mostly having to do
> with drivers/scsi/libfc/libfc_lport.c:fc_lport_recv_req() changes from
> this commit:
> 
> [SCSI] libfc: don't require a local exchange for incomining requests
> http://git.kernel.org/?p=linux/kernel/git/torvalds/linux-2.6.git;a=commitdiff;h=922611569572d3c1aa0ed6491d21583fb3fcca22
> 
> I was able to get libfc + struct fc4_prov compiling after fixing the
> conflicts.  However, I have run into non-trivial breakage in the
> Open-FCoE.org / TCM_FC fabric module itself because of it's dependence
> bit upon having direct access to the passed struct fc_seq.   The code
> currently assigns to struct fc_seq * to struct ft_cmd->seq, and gets
> used in a number of subsequent areas after the struct fc4_prov->recv()
> entry hook at drivers/target/tcm_fc/tfc_cmd.c:ft_recv_cmd() gets called.
> 
> I took a very brief look at trying to resolve the breakage myself, but
> quickly got a bit lost in terms of what TCM_FC actually needs to be
> accessing struct fc_seq directly for.  Would either of you gentlemen
> mind giving me a bit of insight into what you think would be required by
> TCM_FC in order to function with the recent libfc fc_lport_recv_req()
> changes..?

I caused this problem, and anticipated that I would have
to make changes to tcm_fc to accommodate it.  Then I forgot by the
time it made it upstream.

Now incoming requests don't get a sequence assigned unless they ask for
it, so we need to call lport->tt.seq_assign() for the request.
It turns out I forgot that that takes a reference on the sequence, so
I have another patch to add to drop the refcnt.

I can work on this at some point in the next few days if you can wait.

	Joe
