From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH target-pending] iscsi-target: make sure to wake up
 sleeping login worker
Date: Fri, 19 Jan 2018 18:26:29 +0100
Message-ID: <20180119172629.GD21673@breakpoint.cc>
References: <20180119133629.14812-1-fw@strlen.de>
 <1516376785.3606.37.camel@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:35010 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1756005AbeASR3H (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 19 Jan 2018 12:29:07 -0500
Content-Disposition: inline
In-Reply-To: <1516376785.3606.37.camel@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Eric Dumazet <eric.dumazet@gmail.com>
Cc: Florian Westphal <fw@strlen.de>, target-devel@vger.kernel.org, mchristi@redhat.com, nab@linux-iscsi.org, netdev@vger.kernel.org, linux-scsi@vger.kernel.org

Eric Dumazet <eric.dumazet@gmail.com> wrote:
> On Fri, 2018-01-19 at 14:36 +0100, Florian Westphal wrote:
> > diff --git a/drivers/target/iscsi/iscsi_target_nego.c b/drivers/target/iscsi/iscsi_target_nego.c
> > index b686e2ce9c0e..3723f8f419aa 100644
> > --- a/drivers/target/iscsi/iscsi_target_nego.c
> > +++ b/drivers/target/iscsi/iscsi_target_nego.c
> > @@ -432,6 +432,9 @@ static void iscsi_target_sk_data_ready(struct sock *sk)
> >  	if (test_and_set_bit(LOGIN_FLAGS_READ_ACTIVE, &conn->login_flags)) {
> >  		write_unlock_bh(&sk->sk_callback_lock);
> >  		pr_debug("Got LOGIN_FLAGS_READ_ACTIVE=1, conn: %p >>>>\n", conn);
> > +		if (WARN_ON(iscsi_target_sk_data_ready == conn->orig_data_ready))
> > +			return;
> 
> Is this WARN_ON() belonging to this fix ?
> At least make it WARN_ON_ONCE() or pr_err_once()

Nicholas, I don't know this code at all so it would be good if you could
give advice here (omit all together, WARN_ON_ONCE, ...).

Thanks!
