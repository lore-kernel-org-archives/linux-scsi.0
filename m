Return-Path: <SRS0=mSyi=4B=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6F294C3B18C
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Feb 2020 16:30:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3D76724673
	for <linux-scsi@archiver.kernel.org>; Thu, 13 Feb 2020 16:30:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1581611446;
	bh=nsWJZz/XRgp46cV0agCDAmZPkwPwLp1ic2dkZW13uMI=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=MqCX6lXQCelErkCq37zATsKXUMFXXnrScv+JW2/0rwnAS1EnHTXIK3m2k01Q72ioH
	 4j2CzYhd+slSelHzFKJdjrL4LMqYFc9ulyfPuyZ3caD9+ND9slMi3K8sFiF2gAWTvu
	 skahSaRhveB3GsoJtD6RQ0OZMQxIKh6Q2T5FEDwk=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728055AbgBMQap (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 13 Feb 2020 11:30:45 -0500
Received: from mail.kernel.org ([198.145.29.99]:35554 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727926AbgBMQap (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 13 Feb 2020 11:30:45 -0500
Received: from redsun51.ssa.fujisawa.hgst.com (unknown [199.255.47.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F3DB5217F4;
        Thu, 13 Feb 2020 16:30:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1581611444;
        bh=nsWJZz/XRgp46cV0agCDAmZPkwPwLp1ic2dkZW13uMI=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=0rnNxsBFGlcfGbSG5+CPtnSIx21akwCBsUsO6wdm8O34Z+ufB7LBXP/sU8jM1/IAI
         qPlyr6r7813v+7XU0QhXvqwNLFInRY775lp723vSXcB+xNbXJchlbi7zjiPjNIn0aK
         HTV6p84oCg8+9UkaAdadR9A6sOBb1urepBHIDXvI=
Date:   Fri, 14 Feb 2020 01:30:38 +0900
From:   Keith Busch <kbusch@kernel.org>
To:     Ming Lei <ming.lei@redhat.com>
Cc:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        Tim Walker <tim.t.walker@seagate.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
Subject: Re: [LSF/MM/BPF TOPIC] NVMe HDD
Message-ID: <20200213163038.GB7634@redsun51.ssa.fujisawa.hgst.com>
References: <CANo=J14resJ4U1nufoiDq+ULd0k-orRCsYah8Dve-y8uCjA62Q@mail.gmail.com>
 <20200211122821.GA29811@ming.t460p>
 <CANo=J14iRK8K3bc1g3rLBp=QTLZQak0DcHkvgZS2f=xO_HFgxQ@mail.gmail.com>
 <BYAPR04MB5816AA843E63FFE2EA1D5D23E71B0@BYAPR04MB5816.namprd04.prod.outlook.com>
 <20200212220328.GB25314@ming.t460p>
 <BYAPR04MB581622DDD1B8B56CEFF3C23AE71A0@BYAPR04MB5816.namprd04.prod.outlook.com>
 <20200213075348.GA9144@ming.t460p>
 <BYAPR04MB58160C04182D5FE3A15842BBE71A0@BYAPR04MB5816.namprd04.prod.outlook.com>
 <20200213083413.GC9144@ming.t460p>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200213083413.GC9144@ming.t460p>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Feb 13, 2020 at 04:34:13PM +0800, Ming Lei wrote:
> On Thu, Feb 13, 2020 at 08:24:36AM +0000, Damien Le Moal wrote:
> > Got it. And since queue full will mean no more tags, submission will block
> > on get_request() and there will be no chance in the elevator to merge
> > anything (aside from opportunistic merging in plugs), isn't it ?
> > So I guess NVMe HDDs will need some tuning in this area.
> 
> scheduler queue depth is usually 2 times of hw queue depth, so requests
> ar usually enough for merging.
> 
> For NVMe, there isn't ns queue depth, such as scsi's device queue depth,
> meantime the hw queue depth is big enough, so no chance to trigger merge.

Most NVMe devices contain a single namespace anyway, so the shared tag
queue depth is effectively the ns queue depth, and an NVMe HDD should
advertise queue count and depth capabilities orders of magnitude lower
than what we're used to with nvme SSDs. That should get merging and
BLK_STS_DEV_RESOURCE handling to occur as desired, right?
