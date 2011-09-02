From: Ben Hutchings <bhutchings@solarflare.com>
Subject: Re: [patch net-next-2.6 v2] net: consolidate and fix
 ethtool_ops->get_settings calling
Date: Fri, 02 Sep 2011 19:46:01 +0100
Message-ID: <1314989161.3419.5.camel@bwh-desktop>
References: <1314905304-16485-1-git-send-email-jpirko@redhat.com>
	 <20110902122630.GC1991@minipsycho>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exchange.solarflare.com ([216.237.3.220]:16978 "EHLO
	exchange.solarflare.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754314Ab1IBSqI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 2 Sep 2011 14:46:08 -0400
In-Reply-To: <20110902122630.GC1991@minipsycho>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jiri Pirko <jpirko@redhat.com>
Cc: netdev@vger.kernel.org, ralf@linux-mips.org, fubar@us.ibm.com, andy@greyhouse.net, kaber@trash.net, bprakash@broadcom.com, JBottomley@parallels.com, robert.w.love@intel.com, davem@davemloft.net, shemminger@linux-foundation.org, decot@google.com, mirq-linux@rere.qmqm.pl, alexander.h.duyck@intel.com, amit.salecha@qlogic.com, eric.dumazet@gmail.com, therbert@google.com, paulmck@linux.vnet.ibm.com, laijs@cn.fujitsu.com, xiaosuo@gmail.com, greearb@candelatech.com, loke.chetan@gmail.com, linux-mips@linux-mips.org, linux-scsi@vger.kernel.org, devel@open-fcoe.org, bridge@lists.linux-foundation.org

On Fri, 2011-09-02 at 14:26 +0200, Jiri Pirko wrote:
> This patch does several things:
> - introduces __ethtool_get_settings which is called from ethtool code and
>   from dev_ethtool_get_settings() as well.
> - dev_ethtool_get_settings() becomes rtnl wrapper for
>   __ethtool_get_settings()
[...]

I don't like this locking change.  Most other dev_*() functions require
the caller to hold RTNL, and it will break any OOT module calling
dev_ethtool_get_settings() without producing any warning at compile
time.  Why not put an ASSERT_RTNL() in it instead?

The rest of this looks fine.

Ben. 

-- 
Ben Hutchings, Staff Engineer, Solarflare
Not speaking for my employer; that's the marketing department's job.
They asked us to note that Solarflare product names are trademarked.

