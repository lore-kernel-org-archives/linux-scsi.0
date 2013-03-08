From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [RFC 01/11] iscsi-target: Add iscsit_transport API template
Date: Fri, 08 Mar 2013 13:26:16 -0800
Message-ID: <1362777976.7905.326.camel@haakon2.linux-iscsi.org>
References: <1362707116-31406-1-git-send-email-nab@linux-iscsi.org>
	 <1362707116-31406-2-git-send-email-nab@linux-iscsi.org>
	 <CAG4TOxM=PDYXCAMNdRx629aAP+XF7oZmykg0k4b+a688PzzayA@mail.gmail.com>
	 <CAJZOPZLnVLXqcvmjhxuhDghkuAHdf5RmxNSM2gy8LqgCqvh8HQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:40284 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756158Ab3CHV0T (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 8 Mar 2013 16:26:19 -0500
In-Reply-To: <CAJZOPZLnVLXqcvmjhxuhDghkuAHdf5RmxNSM2gy8LqgCqvh8HQ@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Or Gerlitz <or.gerlitz@gmail.com>
Cc: Roland Dreier <roland@kernel.org>, target-devel <target-devel@vger.kernel.org>, linux-rdma <linux-rdma@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, Or Gerlitz <ogerlitz@mellanox.com>, Alexander Nezhinsky <alexandern@mellanox.com>

On Fri, 2013-03-08 at 14:36 +0200, Or Gerlitz wrote:
> On Fri, Mar 8, 2013 at 6:14 AM, Roland Dreier <roland@kernel.org> wrote:
> > Nicholas A. Bellinger <nab@linux-iscsi.org> wrote:
> > > +EXPORT_SYMBOL(iscsit_get_transport);
> 
> > It's not clear to me why this needs to be exported.  Who would use it
> > outside the core iscsi target module?
> 
> Yep, as Nic noted, we're adding here an iscsi transport concept e.g in
> the same manner Mike did libiscsi back in 2005/6 when the iser
> initiator was pushed. This allows for multiple iscsi flavours to use a
> common code  for common functionality. In the initiator area initially
> there were iscsi tcp and iser, later few iscsi HW offloads were merged
> too. Same story here. I think that the point is whether or not these
> APIs are needed, since once we agree on that, we need an header file
> and exporting of functions. As libiscsi.h resided under include/ it
> makes sense to me for this include to be located there too.

So my main concern with putting iscsit_transport definitions into
include/target/iscsi/ is the number of dependencies required from
iscsi_target_core.h.

Currently with iscsi_cmd embedded into isert_cmd, this will require most
existing iscsi_target_core.h definitions to be pushed out into
include/target/iscsi/.  This also includes some namespace conflicts
between libiscsi.h and iscsi_target_core.h, but those can be solved
easily enough.

I'm still leaning towards just keeping iscsi_transport.h definitions
local to drivers/target/iscsi, if there is really not going to be other
drivers aside from ib_isert that end up using it.  If there was interest
in traditional iscsi-target HW offloads using this interface then the
story would be different, but every HW offload that I've seen thus far
using LIO is based on out-of-tree NIC code to start.

--nab







 

> 
> Or.
> 
> Or.
> --
> To unsubscribe from this list: send the line "unsubscribe target-devel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


