Return-Path: <SRS0=bR62=4C=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 36459C3B19F
	for <linux-scsi@archiver.kernel.org>; Fri, 14 Feb 2020 14:40:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 05F0724670
	for <linux-scsi@archiver.kernel.org>; Fri, 14 Feb 2020 14:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1581691216;
	bh=mH5i6V3YTMULw6H6EwUEg5VymMpkbQ9unTGmkWMJHw0=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=syOmXIYWZVM5k/YA6bjYdnpRHH+J4qXvu0IOTb0G1QoLDUiqO6THfFEB73tBGjAzr
	 gz30vAPvK/YF+mLwb9uId4h3BtkanHf4ppVSm8REZ/SnL2mi1dVYqpciwisUk0PPj2
	 dyVaWV/1PMj0s2Q2wLk8rVVfA7F2y/qKnEkvy+ac=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729355AbgBNOkP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 14 Feb 2020 09:40:15 -0500
Received: from mail.kernel.org ([198.145.29.99]:38624 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729102AbgBNOkP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 14 Feb 2020 09:40:15 -0500
Received: from redsun51.ssa.fujisawa.hgst.com (unknown [199.255.47.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 23A382187F;
        Fri, 14 Feb 2020 14:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581691214;
        bh=mH5i6V3YTMULw6H6EwUEg5VymMpkbQ9unTGmkWMJHw0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=RSBxjsv7GyGJhd5Tv6ppSe4iLV+As/SfqLKHeujuydizvxrBM+N3DzUBweJfetWPm
         YGerA1vuipxeTZRNMLqQYLyP6xaqElvmx0eYrnzH/brjKtXWHL2ETNESFs5UYX4bga
         yr/ufxeOHFtFFAJak/Lhio4plQw85jwOA9fBDy2E=
Date:   Fri, 14 Feb 2020 23:40:07 +0900
From:   Keith Busch <kbusch@kernel.org>
To:     Hannes Reinecke <hare@suse.de>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Tim Walker <tim.t.walker@seagate.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Ming Lei <ming.lei@redhat.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
Subject: Re: [LSF/MM/BPF TOPIC] NVMe HDD
Message-ID: <20200214144007.GD9819@redsun51.ssa.fujisawa.hgst.com>
References: <CANo=J14resJ4U1nufoiDq+ULd0k-orRCsYah8Dve-y8uCjA62Q@mail.gmail.com>
 <20200211122821.GA29811@ming.t460p>
 <CANo=J14iRK8K3bc1g3rLBp=QTLZQak0DcHkvgZS2f=xO_HFgxQ@mail.gmail.com>
 <BYAPR04MB5816AA843E63FFE2EA1D5D23E71B0@BYAPR04MB5816.namprd04.prod.outlook.com>
 <yq1blq3rxzj.fsf@oracle.com>
 <CANo=J16cDBUDWdV7tdY33UO0UT0t-g7jRfMVTxZpePvLew7Mxg@mail.gmail.com>
 <yq1r1yzqfyb.fsf@oracle.com>
 <2d66bb0b-29ca-6888-79ce-9e3518ee4b61@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2d66bb0b-29ca-6888-79ce-9e3518ee4b61@suse.de>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Feb 14, 2020 at 08:32:57AM +0100, Hannes Reinecke wrote:
> On 2/13/20 5:17 AM, Martin K. Petersen wrote:
> > People often artificially lower the queue depth to avoid timeouts. The
> > default timeout is 30 seconds from an I/O is queued. However, many
> > enterprise applications set the timeout to 3-5 seconds. Which means that
> > with deep queues you'll quickly start seeing timeouts if a drive
> > temporarily is having issues keeping up (media errors, excessive spare
> > track seeks, etc.).
> > 
> > Well-behaved devices will return QF/TSF if they have transient resource
> > starvation or exceed internal QoS limits. QF will cause the SCSI stack
> > to reduce the number of I/Os in flight. This allows the drive to recover
> > from its congested state and reduces the potential of application and
> > filesystem timeouts.
> > 
> This may even be a chance to revisit QoS / queue busy handling.
> NVMe has this SQ head pointer mechanism which was supposed to handle
> this kind of situations, but to my knowledge no-one has been
> implementing it.
> Might be worthwhile revisiting it; guess NVMe HDDs would profit from that.

We don't need that because we don't allocate enough tags to potentially
wrap the tail past the head. If you can allocate a tag, the queue is not
full. And convesely, no tag == queue full.
