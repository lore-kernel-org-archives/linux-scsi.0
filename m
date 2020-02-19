Return-Path: <SRS0=YE2i=4H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.6 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82A9FC3524E
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Feb 2020 20:51:01 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4C3F624677
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Feb 2020 20:51:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=default; t=1582145461;
	bh=elJqOZvyfQWvQ8In1AjZnSkYrHkr0otpJwRaZHCgpxo=;
	h=Date:From:To:Cc:Subject:References:In-Reply-To:List-ID:From;
	b=petdKNnzGPJDjhBtfP6wuzCCwsGgwUBcyLGLzSVFsCyGq7oHur+Jc/Lh/ELNEQ9p1
	 ZNzDAy8xfwODKkqS4jNPC8H95eT2QsbIJelcIsh/Gxk18TcH5KvTQ2h/usbp+xEoK7
	 Z65O9RUrLFnbF/pKzpD47t5+tyVwIfbxl4/e5W4o=
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727421AbgBSUvA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Feb 2020 15:51:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:58082 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726645AbgBSUvA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 19 Feb 2020 15:51:00 -0500
Received: from redsun51.ssa.fujisawa.hgst.com (unknown [199.255.47.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9CBC924656;
        Wed, 19 Feb 2020 20:50:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582145459;
        bh=elJqOZvyfQWvQ8In1AjZnSkYrHkr0otpJwRaZHCgpxo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=W9zlWyXKb/CugInFr/h8yZlZWNm/5x9tvD/KWAIHPuEvsrHpTChlurGgY9L8raBoy
         wCVWBwUJFkJs/eldR9pUoyDf7UuLF2zMc5co+/QiWjCncTpyha8w/AdC3seNQvEH0n
         iRIJiEGNGesF863JJJ5xwD3RTPGZ3uzH2UU3i2sE=
Date:   Thu, 20 Feb 2020 05:50:52 +0900
From:   Keith Busch <kbusch@kernel.org>
To:     Tim Walker <tim.t.walker@seagate.com>
Cc:     Damien Le Moal <Damien.LeMoal@wdc.com>,
        Ming Lei <ming.lei@redhat.com>, Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "linux-block@vger.kernel.org" <linux-block@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>
Subject: Re: [LSF/MM/BPF TOPIC] NVMe HDD
Message-ID: <20200219205052.GB28509@redsun51.ssa.fujisawa.hgst.com>
References: <d043a58d-6584-1792-4433-ac2cc39526ca@suse.de>
 <20200214170514.GA10757@redsun51.ssa.fujisawa.hgst.com>
 <CANo=J17Rve2mMLb_yJNFK5m8wt5Wi4c+b=-a5BJ5kW3RaWuQVg@mail.gmail.com>
 <20200218174114.GA17609@redsun51.ssa.fujisawa.hgst.com>
 <20200219013137.GA31488@ming.t460p>
 <BYAPR04MB58165C6B400AE30986F988D5E7100@BYAPR04MB5816.namprd04.prod.outlook.com>
 <20200219021540.GC31488@ming.t460p>
 <BYAPR04MB5816DF16BC3720ABF286671EE7100@BYAPR04MB5816.namprd04.prod.outlook.com>
 <CANo=J15Wvm2R+vuLj6QQ5Vete507cA==5Rw=4vn3Z8npZ=2vww@mail.gmail.com>
 <CANo=J14GM=Uu7qWirtvgzjEKVCzLV0nZLOOPqD9M+nwOKrv7yQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANo=J14GM=Uu7qWirtvgzjEKVCzLV0nZLOOPqD9M+nwOKrv7yQ@mail.gmail.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Feb 19, 2020 at 11:28:46AM -0500, Tim Walker wrote:
> Hi Ming-
> 
> >Will NVMe HDD support multiple NS?
> 
> At this point it doesn't seem like an NVMe HDD could benefit from
> multiple namespaces. However, a multiple actuator HDD can present the
> actuators as independent channels that are capable of independent
> media access. It seems that we would want them on separate namespaces,
> or sets. I'd like to discuss the pros and cons of each, and which
> would be better for system integration.

If NVM Sets are not implemented, the host is not aware of resource
separatation for each namespace.

If you implement NVM Sets, two namespaces in different sets tells the host
that the device has a backend resource partition (logical or physical)
such that processing commands for one namespace will not affect the
processing capabilities of the other. Sets define "noisy neighbor"
domains.

Dual actuators sound like you have independent resources appropriate to
report as NVM Sets, but that may depend on other implementation details.

The NVMe specification does not go far enough, though, since IO queues
are always a shared resource. The host may implement a different IO
queue policy such that they're not shared (you'd need at least one IO
queue per set), but we don't currently do that.
