From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] libata: device suspend/resume
Date: Tue, 24 May 2005 04:21:02 -0400
Message-ID: <4292E3EE.10006@pobox.com>
References: <20050523201535.GA24298@havoc.gtf.org> <1116880875.5021.34.camel@mulgrave> <20050523204516.GA28058@havoc.gtf.org> <1116886206.5021.42.camel@mulgrave> <20050524062128.GT9855@suse.de> <4292CF5D.90809@pobox.com> <20050524075953.GY9855@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.dvmed.net ([216.237.124.58]:31437 "EHLO mail.dvmed.net")
	by vger.kernel.org with ESMTP id S261448AbVEXIVH (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 May 2005 04:21:07 -0400
In-Reply-To: <20050524075953.GY9855@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jens Axboe <axboe@suse.de>
Cc: James Bottomley <James.Bottomley@SteelEye.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, linux-ide@vger.kernel.org

Jens Axboe wrote:
> On Tue, May 24 2005, Jeff Garzik wrote:
> 
>>The SCSI layer needs to issue the START STOP UNIT command in response to 
>>a suspend event, and libata-scsi will (per SAT spec) translate that into 
>>the ATA standby command.  Merely following the relevant SCSI+SAT+ATA 
>>standards gets us there.
> 
> 
> BTW, you also need to set host/device modes on resume. Where do you
> propose to do that currently, without the LLD hook?

In the START STOP UNIT emulation.  SSU is basically a high level "do PM 
command".



As a tangent, I would like to try and convince you to stop thinking so 
much about hooks, and start thinking about adding new commands at the 
struct request level.  Sending things down the request_queue is much 
nicer because commands can be sent using the normal rq mechanisms. 
Often, commands can be translated directly into ATA or SCSI commands in 
the prep function.

Two commands I have been thinking about, to add alongside READ, WRITE, 
READA, READ_SYNC, etc. are:  SYNC_CACHE and PM_EVENT.

This would be quite useful for DM and md RAID, especially.  It becomes 
trivial to clone a SYNC_CACHE command, and send it to 5 underlying ATA 
and SCSI devices in a RAID array.  If the PM_EVENT or SYNC_CACHE command 
needs special processing, one can easily add code for that without 
needing any hooks -- just call your new code from the request_queue 
function that handles READ/WRITE/READA/...

This applies to the current thread (PM_EVENT), and also fits right into 
your barrier work, too (SYNC_CACHE).

	Jeff


