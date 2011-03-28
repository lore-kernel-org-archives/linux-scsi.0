From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH-v2 00/14] iscsi-target: iSCSI target v4.1.0-rc1 series
	initial merge
Date: Mon, 28 Mar 2011 01:53:55 -0700
Message-ID: <1301302435.23175.148.camel@haakon2.linux-iscsi.org>
References: <1300922917.18039.147.camel@haakon2.linux-iscsi.org>
	 <20110324102939R.fujita.tomonori@lab.ntt.co.jp>
	 <1300949980.18039.222.camel@haakon2.linux-iscsi.org>
	 <20110327190159J.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:48324 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753485Ab1C1JBI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 28 Mar 2011 05:01:08 -0400
In-Reply-To: <20110327190159J.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: linux-scsi@vger.kernel.org, James.Bottomley@suse.de, hch@lst.de, michaelc@cs.wisc.edu, hare@suse.de, bharrosh@panasas.com

On Sun, 2011-03-27 at 19:02 +0900, FUJITA Tomonori wrote:
> On Wed, 23 Mar 2011 23:59:40 -0700
> "Nicholas A. Bellinger" <nab@linux-iscsi.org> wrote:
> 
> > > > But reading the of the configfs layout is not the problem, yes..?
> > > 
> > > I don't think so. The user space doesn't cache the configfs info. So
> > > the rule is pretty simple.
> > 
> > It's more complicated than that.  We have to then start referencing
> > things like struct se_node_acl usage to userspace when locating an
> > explict NodeACL during login.  What happens if the explict NodeACL is
> > removed from configfs context while userspace code is running..?  What
> > happens if the entire TPG is removed during an active userspace login..?
> > It all has to be sychronized with a userspace daemon through a single
> > thread that needs to know about the network portals, TPG layout and
> > explict NodeACls in order to complete a iSCSI login.
> 
> Such can happen even if you do in kernel. During the login process,
> the configuration may change. You can't lock the configuration during
> the login process even if you do all in kernel. We need no
> synchronization at all with the user space approach.
> --

Not sure what you mean here by saying 'You can't lock the configuration
during the login process'.

The PATCH-v2 of iscsi-target code already provides the ability to
add/remove iSCSI network portals <-> iSCSI target portal group
assocations independently of other iSCSI TargetName+TargetPortalGroupTag
endpoints in a real-time M:N configuration via configfs regardless of
individual IPv6/IPv4 network portal or iSCSI login state.

Having to perform a level synchronization with an userspace iSCSI login
daemon for real-time configurable control plane of M:N iSCSI network
portals <-> iSCSI target portal group really does not make any sense
here.  This type of design change only adds extra unnecessary complexity
to existing code for in-kernel iscsi-target who's control plane is
already driven exclusively by userspace using mainline generic
target_core_fabric_configfs.c code.

--nab


