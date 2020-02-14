Return-Path: <SRS0=bR62=4C=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4DE49C352A3
	for <linux-scsi@archiver.kernel.org>; Fri, 14 Feb 2020 00:41:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1C825222C2
	for <linux-scsi@archiver.kernel.org>; Fri, 14 Feb 2020 00:41:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="gfskYaqA"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728034AbgBNAlL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 13 Feb 2020 19:41:11 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:37692 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727665AbgBNAlL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 13 Feb 2020 19:41:11 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581640870;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FDMIxAbE8ieq5ylrZWE99LrHP924RmkuGOvqIWIn6sQ=;
        b=gfskYaqAL3arJ23aD+yGqmBUaa/lMEhSLj3rxc6mVfsXevO7VuAXh82T31y+T76uvyGiLJ
        UnwK4MwD93zMJoDmmyq5DTtClWsJDjlINafZ7QKJJQxLwWwlR2cIc7QbSQQhLE699Ys1az
        bxTPRAZahmS8HPVKaIKyJOA/lxlodRw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-361-f0p-8FSRMHGRhhX31onxaw-1; Thu, 13 Feb 2020 19:41:08 -0500
X-MC-Unique: f0p-8FSRMHGRhhX31onxaw-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 32B1C8017CC;
        Fri, 14 Feb 2020 00:41:07 +0000 (UTC)
Received: from ming.t460p (ovpn-8-16.pek2.redhat.com [10.72.8.16])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 4997860BF4;
        Fri, 14 Feb 2020 00:41:00 +0000 (UTC)
Date:   Fri, 14 Feb 2020 08:40:56 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Keith Busch <kbusch@kernel.org>
Cc:     "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        Tim Walker <tim.t.walker@seagate.com>,
        linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: [LSF/MM/BPF TOPIC] NVMe HDD
Message-ID: <20200214004056.GC4907@ming.t460p>
References: <CANo=J14resJ4U1nufoiDq+ULd0k-orRCsYah8Dve-y8uCjA62Q@mail.gmail.com>
 <20200211122821.GA29811@ming.t460p>
 <CANo=J14iRK8K3bc1g3rLBp=QTLZQak0DcHkvgZS2f=xO_HFgxQ@mail.gmail.com>
 <BYAPR04MB5816AA843E63FFE2EA1D5D23E71B0@BYAPR04MB5816.namprd04.prod.outlook.com>
 <20200212220328.GB25314@ming.t460p>
 <BYAPR04MB581622DDD1B8B56CEFF3C23AE71A0@BYAPR04MB5816.namprd04.prod.outlook.com>
 <20200213075348.GA9144@ming.t460p>
 <BYAPR04MB58160C04182D5FE3A15842BBE71A0@BYAPR04MB5816.namprd04.prod.outlook.com>
 <20200213083413.GC9144@ming.t460p>
 <20200213163038.GB7634@redsun51.ssa.fujisawa.hgst.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200213163038.GB7634@redsun51.ssa.fujisawa.hgst.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Feb 14, 2020 at 01:30:38AM +0900, Keith Busch wrote:
> On Thu, Feb 13, 2020 at 04:34:13PM +0800, Ming Lei wrote:
> > On Thu, Feb 13, 2020 at 08:24:36AM +0000, Damien Le Moal wrote:
> > > Got it. And since queue full will mean no more tags, submission will block
> > > on get_request() and there will be no chance in the elevator to merge
> > > anything (aside from opportunistic merging in plugs), isn't it ?
> > > So I guess NVMe HDDs will need some tuning in this area.
> > 
> > scheduler queue depth is usually 2 times of hw queue depth, so requests
> > ar usually enough for merging.
> > 
> > For NVMe, there isn't ns queue depth, such as scsi's device queue depth,
> > meantime the hw queue depth is big enough, so no chance to trigger merge.
> 
> Most NVMe devices contain a single namespace anyway, so the shared tag
> queue depth is effectively the ns queue depth, and an NVMe HDD should
> advertise queue count and depth capabilities orders of magnitude lower
> than what we're used to with nvme SSDs. That should get merging and
> BLK_STS_DEV_RESOURCE handling to occur as desired, right?

Right.

The advertised queue depth might serve two purposes:

1) reflect the namespace's actual queueing capability, so block layer's merging
is possible

2) avoid timeout caused by too many in-flight IO


Thanks,
Ming

