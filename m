Return-Path: <SRS0=bR62=4C=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 197E8C3F68F
	for <linux-scsi@archiver.kernel.org>; Fri, 14 Feb 2020 00:36:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id DF4642168B
	for <linux-scsi@archiver.kernel.org>; Fri, 14 Feb 2020 00:36:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="Ymj9V5Yn"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727955AbgBNAgA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 13 Feb 2020 19:36:00 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:49717 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727594AbgBNAgA (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 13 Feb 2020 19:36:00 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1581640559;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=0ME/CnINQO2pWAEByneP/dtw6TscGVRMxunDfKVudhs=;
        b=Ymj9V5YniZvqmqK/qiV8iwi6OS+Bf16Nq0lPXWD5STuMpKAVO5fOt4I6FPp+xBtQwRdGyN
        ZRufDO94S890F32w+7vcVLyRoYi2eYVrZznMSTAsGMjyhBU0n2WFUNOBHqCmZvMfBsnQmM
        3UvGb+z0DfK9nNorokWYR955ZUUUvJg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-409-5oZdy6SWOIW8J9jkT1Gj2A-1; Thu, 13 Feb 2020 19:35:57 -0500
X-MC-Unique: 5oZdy6SWOIW8J9jkT1Gj2A-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 979558017CC;
        Fri, 14 Feb 2020 00:35:55 +0000 (UTC)
Received: from ming.t460p (ovpn-8-16.pek2.redhat.com [10.72.8.16])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 2C53E90095;
        Fri, 14 Feb 2020 00:35:49 +0000 (UTC)
Date:   Fri, 14 Feb 2020 08:35:45 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        Tim Walker <tim.t.walker@seagate.com>,
        linux-scsi <linux-scsi@vger.kernel.org>
Subject: Re: [LSF/MM/BPF TOPIC] NVMe HDD
Message-ID: <20200214003545.GB4907@ming.t460p>
References: <CANo=J14resJ4U1nufoiDq+ULd0k-orRCsYah8Dve-y8uCjA62Q@mail.gmail.com>
 <20200211122821.GA29811@ming.t460p>
 <CANo=J14iRK8K3bc1g3rLBp=QTLZQak0DcHkvgZS2f=xO_HFgxQ@mail.gmail.com>
 <BYAPR04MB5816AA843E63FFE2EA1D5D23E71B0@BYAPR04MB5816.namprd04.prod.outlook.com>
 <yq1blq3rxzj.fsf@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq1blq3rxzj.fsf@oracle.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Feb 12, 2020 at 10:02:08PM -0500, Martin K. Petersen wrote:
> 
> Damien,
> 
> > Exposing an HDD through multiple-queues each with a high queue depth
> > is simply asking for troubles. Commands will end up spending so much
> > time sitting in the queues that they will timeout.
> 
> Yep!
> 
> > This can already be observed with the smartpqi SAS HBA which exposes
> > single drives as multiqueue block devices with high queue depth.
> > Exercising these drives heavily leads to thousands of commands being
> > queued and to timeouts. It is fairly easy to trigger this without a
> > manual change to the QD. This is on my to-do list of fixes for some
> > time now (lacking time to do it).
> 
> Controllers that queue internally are very susceptible to application or
> filesystem timeouts when drives are struggling to keep up.
> 
> > NVMe HDDs need to have an interface setup that match their speed, that
> > is, something like a SAS interface: *single* queue pair with a max QD
> > of 256 or less depending on what the drive can take. Their is no
> > TASK_SET_FULL notification on NVMe, so throttling has to come from the
> > max QD of the SQ, which the drive will advertise to the host.
> 
> At the very minimum we'll need low queue depths. But I have my doubts
> whether we can make this work well enough without some kind of TASK SET
> FULL style AER to throttle the I/O.

Looks 32 or sort of works fine for HDD, and 128 is good enough for
SSD.

And this number should drive enough parallelism, meantime timeout can be
avoided most of times if not too small timeout value is set. But SCSI
still allows to adjust the queue depth via sysfs.

Thanks,
Ming

