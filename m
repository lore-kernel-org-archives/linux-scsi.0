Return-Path: <SRS0=EtEA=ZU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A9851C432C0
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Nov 2019 17:40:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8C313215F1
	for <linux-scsi@archiver.kernel.org>; Thu, 28 Nov 2019 17:40:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726657AbfK1Rj7 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 28 Nov 2019 12:39:59 -0500
Received: from netrider.rowland.org ([192.131.102.5]:41895 "HELO
        netrider.rowland.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with SMTP id S1726446AbfK1Rj7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 28 Nov 2019 12:39:59 -0500
Received: (qmail 21220 invoked by uid 500); 28 Nov 2019 12:39:58 -0500
Received: from localhost (sendmail-bs@127.0.0.1)
  by localhost with SMTP; 28 Nov 2019 12:39:58 -0500
Date:   Thu, 28 Nov 2019 12:39:58 -0500 (EST)
From:   Alan Stern <stern@rowland.harvard.edu>
X-X-Sender: stern@netrider.rowland.org
To:     "Schmid, Carsten" <Carsten_Schmid@mentor.com>
cc:     Andrea Vai <andrea.vai@unipv.it>,
        Finn Thain <fthain@telegraphics.com.au>,
        Ming Lei <ming.lei@redhat.com>,
        Damien Le Moal <Damien.LeMoal@wdc.com>,
        Jens Axboe <axboe@kernel.dk>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        USB list <linux-usb@vger.kernel.org>,
        SCSI development list <linux-scsi@vger.kernel.org>,
        Himanshu Madhani <himanshu.madhani@cavium.com>,
        Hannes Reinecke <hare@suse.com>,
        Omar Sandoval <osandov@fb.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Greg KH <gregkh@linuxfoundation.org>,
        Hans Holmberg <Hans.Holmberg@wdc.com>,
        Kernel development list <linux-kernel@vger.kernel.org>
Subject: Re: AW: AW: Slow I/O on USB media after commit
 f664a3cc17b7d0a2bc3b3ab96181e1029b0ec0e6
In-Reply-To: <fa9566db62474d7aa5473cf7a1f0da8d@SVR-IES-MBX-03.mgc.mentorg.com>
Message-ID: <Pine.LNX.4.44L0.1911281234150.19734-100000@netrider.rowland.org>
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 28 Nov 2019, Schmid, Carsten wrote:

> I have been involved in several benchmarkings of flash devices in the past.
> So what we see here is definitely not a device issue regarding wear leveling.
> 
> I wanted to prevent all of you going into the wrong direction, that's why
> i wanted Andrea to confirm that it's not a matter of the flash device.
> 
> There are so much items involved into benchmarking flash devices.
> But Andrea's observations with factors of 10-30 times slow down
> i have never seen before.
> 
> I assume the only thing that you change between the benchmarks
> is the kernel (and the modules, of course), right, Andrea?
> Then we can rule out cache settings which massively can impact
> benchmarks.
> 
> The only thing that makes sense from my POV is:
> - collect traces with the kernel before mentioned commit (fast)
> - apply patch in doubt
> - again collect traces (slow)
> - compare the traces
> 
> Then we should be able to see the difference(s).

We have already done this.  I forget whether the traces are in the
email history available in the archives or whether they are stored 
somewhere else.

In any case, my analysis of the traces is in the archives.  It seemed 
very clear that the only difference which mattered was the ordering of 
the write commands (sequential vs. non-sequential).  This was obviously 
something which the commit in question would affect, and it also seemed 
likely to cause the device to slow down considerably.

Alan Stern

> Unfortunately i'm not an expert on the SCSI and USB kernel stuff
> involved here. Else i would try to understand what happens and
> give you some hints.
> 
> BR
> Carsten

