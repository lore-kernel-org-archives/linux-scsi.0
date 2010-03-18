From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: Re: [PATCH 2/2] RFC: The be2iscsi driver support for bsg
Date: Fri, 19 Mar 2010 08:10:36 +0900
Message-ID: <20100319081016W.fujita.tomonori@lab.ntt.co.jp>
References: <20100317180647.GA25863@serverengines.com>
	<20100318225808Z.fujita.tomonori@lab.ntt.co.jp>
	<4BA294FC.3030400@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sh.osrg.net ([192.16.179.4]:33933 "EHLO sh.osrg.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750945Ab0CRXKy (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 18 Mar 2010 19:10:54 -0400
In-Reply-To: <4BA294FC.3030400@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: michaelc@cs.wisc.edu
Cc: fujita.tomonori@lab.ntt.co.jp, jayamohank@serverengines.com, linux-scsi@vger.kernel.org, James.Bottomley@suse.de, open-iscsi@googlegroups.com

On Thu, 18 Mar 2010 16:02:52 -0500
Mike Christie <michaelc@cs.wisc.edu> wrote:

> On 03/18/2010 08:58 AM, FUJITA Tomonori wrote:
> >
> > - You invent your hardware specific data structure for the simplest
> >    operation such as setting IP address.
> 
> I think this is what Jay is not trying to do. I think the patch has some 
> extra code like the ISCSI_BSG_HST_VENDOR parts that makes it confusing - 
> it got me too. The ISCSI_BSG_HST_VENDOR code in be2iscsi looks like it 
> is basically disabled (should remove for a formal patch when he sends 
> for merging).
> 
> It looks like there is a common struct iscsi_bsg_common_format that is 
> getting passed around, and then in be2iscsi the driver is using that 
> info to make a be2iscsi specific command. So scsi_transport_iscsi / 
> ISCSI_SET_IP_ADDR / iscsi_bsg_common_format  gets translated by b2iscsi 
> to b2iscsi / OPCODE_COMMON_ISCSI_NTWK_MODIFY_IP_ADDR / be_modify_ip_addr.

Yeah, seems you are right. But looks like this patchset also adds the
vendor specific message support (ISCSI_BSG_HST_VENDOR)?

I still want to know why vendors can't do this via the existing
netlink interface. open-iscsi uses the netlink interface for some pdu
so I guess that having a different channel for management might be a
good idea.
