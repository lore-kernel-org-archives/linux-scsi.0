From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH target-pending] iscsi-target: make sure to wake up
 sleeping login worker
Date: Tue, 23 Jan 2018 23:01:11 -0800
Message-ID: <1516777271.24576.312.camel@haakon3.daterainc.com>
References: <20180119133629.14812-1-fw@strlen.de>
         <1516376785.3606.37.camel@gmail.com> <20180119172629.GD21673@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <netdev-owner@vger.kernel.org>
In-Reply-To: <20180119172629.GD21673@breakpoint.cc>
Sender: netdev-owner@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Cc: Eric Dumazet <eric.dumazet@gmail.com>, target-devel@vger.kernel.org, mchristi@redhat.com, netdev@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Hey Florian & Co,

On Fri, 2018-01-19 at 18:26 +0100, Florian Westphal wrote:
> Eric Dumazet <eric.dumazet@gmail.com> wrote:
> > On Fri, 2018-01-19 at 14:36 +0100, Florian Westphal wrote:
> > > diff --git a/drivers/target/iscsi/iscsi_target_nego.c b/drivers/target/iscsi/iscsi_target_nego.c
> > > index b686e2ce9c0e..3723f8f419aa 100644
> > > --- a/drivers/target/iscsi/iscsi_target_nego.c
> > > +++ b/drivers/target/iscsi/iscsi_target_nego.c
> > > @@ -432,6 +432,9 @@ static void iscsi_target_sk_data_ready(struct sock *sk)
> > >  	if (test_and_set_bit(LOGIN_FLAGS_READ_ACTIVE, &conn->login_flags)) {
> > >  		write_unlock_bh(&sk->sk_callback_lock);
> > >  		pr_debug("Got LOGIN_FLAGS_READ_ACTIVE=1, conn: %p >>>>\n", conn);
> > > +		if (WARN_ON(iscsi_target_sk_data_ready == conn->orig_data_ready))
> > > +			return;
> > 
> > Is this WARN_ON() belonging to this fix ?
> > At least make it WARN_ON_ONCE() or pr_err_once()
> 
> Nicholas, I don't know this code at all so it would be good if you could
> give advice here (omit all together, WARN_ON_ONCE, ...).
> 

This is regular behavior during multi PDU login sequences, and should
not include a WARN_ON.

So with MNC's Tested-by in place, applying to target-pending/for-next
minus the WARN_ON, with a extra 4.14.y stable tag.

Thanks again for taking a look at this.

To your earlier point wrt net.ipv4.tcp_low_latency=1 on 4.13 code not
triggering pre-queue logic.  From groking the original patch to drop
prequeue I agree this should really be the case, but am still at a loss
how MNC is triggering on 4.14+ unless something else has changed to
uncover this iscsi-target bug.

Still curious to verify the root cause, but I haven't been able to
reproduce this in VMs on small scale, and haven't had cycles to
reproduce on HW yet.

That said, since the bug appears to be masked on <= 4.13.y +
tcp_low_latency=1, unless someone can reproduce this on earlier code
with tcp_low_latency=0, I'll leave off the older stable tag for now.
