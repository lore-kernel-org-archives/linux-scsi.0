From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] QStor SATA/RAID driver for 2.6.9-rc3
Date: 08 Oct 2004 10:47:40 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1097250465.2412.49.camel@mulgrave>
References: <4161A06D.8010601@rtr.ca>	<416547B6.5080505@rtr.ca>	<20041007150709.B12688@i
	nfradead.org>	<4165624C.5060405@rtr.ca>	<416565DB.4050006@pobox.com>	<4165A4
	5D.2090200@rtr.ca>	<4165A766.1040104@pobox.com>	<4165A85D.7080704@rtr.ca>	<4
	165AB1B.8000204@pobox.com>	<4165ACF8.8060208@rtr.ca>
		<20041007221537.A17712@infradead.org>	<1097241583.2412.15.camel@mulgrave>
	<4166AF2F.6070904@rtr.ca> <1097249266.1678.40.camel@mulgrave>
	<4166B48E.3020006@rtr.ca>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:45250 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S270042AbUJHPr4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Oct 2004 11:47:56 -0400
In-Reply-To: <4166B48E.3020006@rtr.ca>
List-Id: linux-scsi@vger.kernel.org
To: Mark Lord <lkml@rtr.ca>
Cc: Christoph Hellwig <hch@infradead.org>, Jeff Garzik <jgarzik@pobox.com>, Mark Lord <lsml@rtr.ca>, Linux Kernel <linux-kernel@vger.kernel.org>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Fri, 2004-10-08 at 10:38, Mark Lord wrote:
> Can deadlock occur here, since qstor.c is already using schedule_work()
> as part of it's internal bottom-half handling for abnormal conditions?
> 
> Eg.  hotplug event -> schedule_work -> mid-layer -> queuecommand
>        --> sleep  :: interrupt -> schedule_work -> deadlock?
> 

Since you wouldn't go straight from schedule_work->mid-layer, I assume
you mean that when the workqueue thread runs the work?

With that assumption, this is legal and won't deadlock.

However, I assume you know you can't sleep in queuecommand since it may
be run from the scsi tasklet?

James


