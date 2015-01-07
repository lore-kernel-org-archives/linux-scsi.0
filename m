From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [target:nvme_of 3/3]
 drivers/target/nvme_of/nvme_of_configfs.c:25:31: sparse: symbol
 'nvme_of_fabric_configfs' was not declared. Should it be static?
Date: Wed, 07 Jan 2015 13:33:51 -0800
Message-ID: <1420666431.12144.71.camel@haakon3.risingtidesystems.com>
References: <201501070334.EgwC5iey%fengguang.wu@intel.com>
	 <1420584282.6927.62.camel@haakon3.risingtidesystems.com>
	 <54ACF516.4080602@dev.mellanox.co.il>
	 <1420654943.12144.38.camel@haakon3.risingtidesystems.com>
	 <8F6AF977-2BD7-46FF-A38D-108AF3C05809@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:55165 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755138AbbAGVdw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 7 Jan 2015 16:33:52 -0500
In-Reply-To: <8F6AF977-2BD7-46FF-A38D-108AF3C05809@dev.mellanox.co.il>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>, "Patil, Kiran" <kiran.patil@intel.com>, "Minturn, Dave B" <dave.b.minturn@intel.com>

On Wed, 2015-01-07 at 22:26 +0200, Sagi Grimberg wrote:
> >> On Wed, 2015-01-07 at 10:57 +0200, Sagi Grimberg wrote:
> >>> On 1/7/2015 12:44 AM, Nicholas A. Bellinger wrote:

<SNIP>

> >> Hey Nic,
> >> 
> >> Hope all is well.
> >> 
> >> So this skeleton is interesting to me. As this is a fabric module I
> >> assume this would be the NVMEoFabrics target mode driver for upstream 
> >> which would be able to talk to NVMEoFabrics initiator (which by
> >> the way makes LIO something more than a SCSI target - will this be 
> >> accepted?).
> > 
> > That is currently the plan.
> > 
> > It's still unclear how this will work wrt to existing target code, but
> > given the amount of logic that NVMe is borrowing from SCSI on the
> > command set side (PR, ALUA, VAAI, DIF), I'm sure there is an opportunity
> > for code sharing between NVMe and SCSI based fabrics.
> 
> Right, but I assume there will be a different method to provision this
> stuff given that the target exposes NVME SQs.
> 

Yeah, it's not clear how this is going to work yet, but I'd expect a new
backend driver will be required for exposing NVMe hardware queues into
target -> fabric driver code.

> > 
> >> I'm currently participating in nvmexpress working group defining the
> >> standard of protocol, specifically in the context of RDMA (naturally).
> > 
> > Glad to hear that your involved.  ;)
> 
> Should say passively involved, at the moment I'm just following this
> stuff.
> 
> > 
> >> I'm interested in taking an active role in this project, It is
> >> important to build this layered from day one - separating the fabric 
> >> logic (RDMA or FCoE) from the core layer.
> >> 
> >> Moreover, I know that Mellanox has some plans on accelerating this
> >> area in future devices and we are currently looking into ways to
> >> do that. I want to see that the SW will be able to support that.
> >> 
> >> So, Thoughts?
> > 
> > FYI, Kiran and Dave (CC'ed) from Intel will be driving upstream NVME-OF
> > target development.
> > 
> > I'll be primarily focused on figuring out how NVMe and SCSI can play
> > nicely in target-core, and helping out on the NVMe-OF side where
> > necessary.
> 
> Is there something open that I can start playing around with? What is
> the status here? I imagine that the initiator is developed as well...
> 

I don't believe any public code is available yet, and considering the
draft spec is only available to members of the NVMe consortium, it's
likely going to be a while before that happens.

However, Dave mentioned off-list that sharing early code amongst NVMe
consortium members should not be an issue.

--nab 

