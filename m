From: rct@frus.com (Bob Tracy)
Subject: Re: [BUG] 2.6.23-rc3 can't see sd partitions on Alpha
Date: Fri, 7 Dec 2007 08:55:26 -0600 (CST)
Message-ID: <20071207145526.B561CDBA2@gherkin.frus.com>
References: <20071207022646.373c92f5.akpm@linux-foundation.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S1753496AbXLGOzo@vger.kernel.org>
In-Reply-To: <20071207022646.373c92f5.akpm@linux-foundation.org>
 "from Andrew Morton at Dec 7, 2007 02:26:46 am"
Sender: linux-kernel-owner@vger.kernel.org
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Bob Tracy <rct@frus.com>, mingo@elte.hu, mcree@orcon.net.nz, linux-kernel@vger.kernel.org, rjw@sisk.pl, rth@twiddle.net, ink@jurassic.park.msu.ru, linux-scsi@vger.kernel.org, kay.sievers@vrfy.org, greg@kroah.com
List-Id: linux-scsi@vger.kernel.org

I wrote:
> "git diff 2f1f53bdc6531696934f6ee7bbdfa2ab4f4f62a3 6f37ac793d6ba7b35d338f791974166f67fdd9ba"
> produced a relatively short patch (18,437 bytes).  The list of involved
> files:
> 
> (omitted)
>
> Current state of the source tree is the 6f37ac... version, so I'll start
> backing out the above diffs in related groups and continue until I've got
> a working kernel.  For lack of an obvious target, I'll start with the
> seemingly innocuous change to sysctl_check.c.  I'll report back when I've
> got something.

That was quick :-).  Backing out the sysctl_check.c diff gives me a
working kernel.  Beats the #$%@! out of me how/why, though.

Michael Cree: could you try backing out the diff below from your
2.6.24-rc3 tree and see if things are now working for you?

Here's "uname -a", just to confirm (maybe) I'm running on what I say
works:

Linux smirkin 2.6.24-rc2-g6f37ac79-dirty #2 Fri Dec 7 08:03:12 CST 2007 alpha

Here's the diff I backed out (patch -R).  It's short...

diff --git a/kernel/sysctl_check.c b/kernel/sysctl_check.c
index 5a2f2b2..4abc6d2 100644
--- a/kernel/sysctl_check.c
+++ b/kernel/sysctl_check.c
@@ -738,7 +738,7 @@ static struct trans_ctl_table trans_net_table[] = {
 	{ NET_ROSE,		"rose",		trans_net_rose_table },
 	{ NET_IPV6,		"ipv6",		trans_net_ipv6_table },
 	{ NET_X25,		"x25",		trans_net_x25_table },
-	{ NET_TR,		"tr",		trans_net_tr_table },
+	{ NET_TR,		"token-ring",	trans_net_tr_table },
 	{ NET_DECNET,		"decnet",	trans_net_decnet_table },
 	/*  NET_ECONET not used */
 	{ NET_SCTP,		"sctp",		trans_net_sctp_table },

-- 
------------------------------------------------------------------------
Bob Tracy          |  "They couldn't hit an elephant at this dist- "
rct@frus.com       |   - Last words of Union General John Sedgwick,
                   |  Battle of Spotsylvania Court House, U.S. Civil War
------------------------------------------------------------------------
