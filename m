From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [RFC]transient transport error report for LLD timeout
Date: 27 Sep 2004 10:06:41 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1096294008.1714.7.camel@mulgrave>
References: <200409232332.AA03619@fukuchi.jp.fujitsu.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:15780 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S266117AbUI0OGv (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 27 Sep 2004 10:06:51 -0400
In-Reply-To: <200409232332.AA03619@fukuchi.jp.fujitsu.com>
List-Id: linux-scsi@vger.kernel.org
To: Masao Fukuchi <fukuchi.masao@jp.fujitsu.com>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>, Linux Kernel <linux-kernel@vger.kernel.org>

On Thu, 2004-09-23 at 19:32, Masao Fukuchi wrote:
> Therefore, I newly prepared timer in block layer.
> When it detects timeout, it responds to upper(RAID/multipath) layer and
> upper layer begins retry operation using alt-disk/alt-path.
> Resource using in block and SCSI(LLD) layer is freed when it receives 
> response from LLD(SCSI) layer.

I really don't think this is the correct thing to do.  The block layer
has no idea what's actually happened to the command, but it's going to
complete it anyway.  Depending on what goes on above, this may unpin the
user pages that the scsi_cmnd is still using.  Also, the two timers
(scsi command timer and this new block layer timer are critically
coupled.  Tune them wrongly and nasty things will happen).

The right thing to do is to see the no retry flag in error recovery and
complete the command when we see the host has relinquished it.  Then go
on to do transport recovery with a new command.

James


