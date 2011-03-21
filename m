From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 3/3] tcm ibmvscsis driver
Date: Mon, 21 Mar 2011 16:50:14 -0700
Message-ID: <1300751414.21880.146.camel@haakon2.linux-iscsi.org>
References: <4D87BC8C.5090104@linux.vnet.ibm.com>
	 <1300741291.21880.17.camel@haakon2.linux-iscsi.org>
	 <4D87C22A.6070301@linux.vnet.ibm.com>
	 <20110322082013O.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:35204 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755109Ab1CUX50 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 21 Mar 2011 19:57:26 -0400
In-Reply-To: <20110322082013O.fujita.tomonori@lab.ntt.co.jp>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: brking@linux.vnet.ibm.com, James.Bottomley@suse.de, linux-scsi <linux-scsi@vger.kernel.org>, Jerome Martin <jxm@risingtidesystems.com>, Marc Fleischmann <mwf@risingtidesystems.com>

On Tue, 2011-03-22 at 08:20 +0900, FUJITA Tomonori wrote:
> On Mon, 21 Mar 2011 16:24:58 -0500
> Brian King <brking@linux.vnet.ibm.com> wrote:
> 
> > > If could send along the original misconfigured configfs layout that is
> > > causing the OOPs in handle_crq(), I would be happy to have a quick look.
> > 
> > Here it is. As you can see, there is no ./target/ibmvscsis directory created. In order
> 
> I suspect something like that. The driver can't crash with any
> configurations though.
> 
> 
> > to get it to work, I did the following. Please let me know if there is a better way
> > to do this...
> 
> As I said long before, this kinda hardware configuration should
> automatically show up when we load the driver module. But the target
> core is broken in this regard.
> 

It's possible to move the I_T nexus creation into VIO context code, but
we still want to be able to define the actual target endpoint definition
from userspace to get the proper VFS reference counting for fabric data
structures containing struct config_group that reference the
config_groups from the rest of the target stack.  We can open that
discussion with jlbec again, but at this point I still do agree with
this original statement that in the end this is going to be unnecessary,
and will end up being ugly and more complex in kernel code to handle
both.

I think what we need to make this easy for ibmvscsis users are simple
userspace items like scanning of existing VIO sysfs layouts to output a
useable set of /sys/kernel/config/target/ibmvscsis ops they can run, and
and the saving to presistent state to /etc/target/, et al.

That said I will get these userspace items added into lio-utils.git code
in the upcoming weeks to support basic scanning and persistent
init.d/target functionality for ibmvscsis.  From there we (RisingTide
Systems) would also like to get ibmvscsis supported into rtsadmin-gpl v2
in order to provide a proper high level shell to users of ibmvscsis.
(mwf and jxm CC'ed)

Best Regards,

--nab


