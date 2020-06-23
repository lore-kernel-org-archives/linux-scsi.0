Return-Path: <SRS0=JRJf=AE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D791FC433DF
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Jun 2020 13:36:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B1A1B2070E
	for <linux-scsi@archiver.kernel.org>; Tue, 23 Jun 2020 13:36:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732647AbgFWNgV (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 23 Jun 2020 09:36:21 -0400
Received: from jabberwock.ucw.cz ([46.255.230.98]:59704 "EHLO
        jabberwock.ucw.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732631AbgFWNgV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Jun 2020 09:36:21 -0400
Received: by jabberwock.ucw.cz (Postfix, from userid 1017)
        id 784331C0C0E; Tue, 23 Jun 2020 15:36:19 +0200 (CEST)
Date:   Tue, 23 Jun 2020 15:36:18 +0200
From:   Pavel Machek <pavel@ucw.cz>
To:     Damien Le Moal <Damien.LeMoal@wdc.com>
Cc:     Simon Arlott <simon@octiron.net>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Jonathan Corbet <corbet@lwn.net>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>
Subject: Re: [PATCH] scsi: sd: stop SSD (non-rotational) disks before reboot
Message-ID: <20200623133618.GE2783@bug>
References: <499138c8-b6d5-ef4a-2780-4f750ed337d3@0882a8b5-c6c3-11e9-b005-00805fc181fe>
 <CY4PR04MB37511505492E9EC6A245CFB1E79B0@CY4PR04MB3751.namprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CY4PR04MB37511505492E9EC6A245CFB1E79B0@CY4PR04MB3751.namprd04.prod.outlook.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi!

> > I need to use "reboot=p" on my desktop because one of the PCIe devices
> > does not appear after a warm boot. This results in a very cold boot
> > because the BIOS turns the PSU off and on.
> > 
> > The scsi sd shutdown process does not send a stop command to disks
> > before the reboot happens (stop commands are only sent for a shutdown).
> > 
> > The result is that all of my SSDs experience a sudden power loss on
> > every reboot, which is undesirable behaviour. These events are recorded
> > in the SMART attributes.
> 
> Why is it undesirable for an SSD ? The sequence you are describing is not
> different from doing "shutdown -h now" and then pressing down the power button
> again immediately after power is cut...

Many SSDs are buggy, and will eventually corrupt themselves if you do enough
sudden power loss experiments.

HDDs don't like their power cut, either. You can hear the difference 
between normal power off and power cut...

> > Cc: stable@vger.kernel.org

This needs lot more testing before going to stable.

Thanks,
									Pavel
-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
