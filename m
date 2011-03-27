From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH-v2 00/14] iscsi-target: iSCSI target v4.1.0-rc1 series
	initial merge
Date: Sun, 27 Mar 2011 19:02:28 +0900
Message-ID: <20110327190159J.fujita.tomonori@lab.ntt.co.jp>
References: <1300922917.18039.147.camel@haakon2.linux-iscsi.org>
	<20110324102939R.fujita.tomonori@lab.ntt.co.jp>
	<1300949980.18039.222.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:48966 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752983Ab1C0KDA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 27 Mar 2011 06:03:00 -0400
In-Reply-To: <1300949980.18039.222.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nab@linux-iscsi.org
Cc: fujita.tomonori@lab.ntt.co.jp, linux-scsi@vger.kernel.org, James.Bottomley@suse.de, hch@lst.de, michaelc@cs.wisc.edu, hare@suse.de, bharrosh@panasas.com

On Wed, 23 Mar 2011 23:59:40 -0700
"Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:

> > > But reading the of the configfs layout is not the problem, yes..?
> > 
> > I don't think so. The user space doesn't cache the configfs info. So
> > the rule is pretty simple.
> 
> It's more complicated than that.  We have to then start referencing
> things like struct se_node_acl usage to userspace when locating an
> explict NodeACL during login.  What happens if the explict NodeACL is
> removed from configfs context while userspace code is running..?  What
> happens if the entire TPG is removed during an active userspace login..?
> It all has to be sychronized with a userspace daemon through a single
> thread that needs to know about the network portals, TPG layout and
> explict NodeACls in order to complete a iSCSI login.

Such can happen even if you do in kernel. During the login process,
the configuration may change. You can't lock the configuration during
the login process even if you do all in kernel. We need no
synchronization at all with the user space approach.
