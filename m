From: Mark Lord <liml@rtr.ca>
Subject: Re: [PATCH] libata: device suspend/resume
Date: Tue, 24 May 2005 12:27:22 -0400
Message-ID: <429355EA.9060100@rtr.ca>
References: <20050523201535.GA24298@havoc.gtf.org> <1116880875.5021.34.camel@mulgrave>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cpu1185.adsl.bellglobal.com ([207.236.110.166]:54796 "EHLO
	mail.rtr.ca") by vger.kernel.org with ESMTP id S262144AbVEXQ1Z
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 May 2005 12:27:25 -0400
In-Reply-To: <1116880875.5021.34.camel@mulgrave>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>, linux-ide@vger.kernel.org

 >> Patch is via Mark Lord,
 >
 >Um, it is? it looks identical to this one from Jens
...

As Jeff said, he got the patch "via" me.
Here are the first few lines from the file I sent to Jeff (below),
just to make it clear I never tried to claim it as my own.

Cheers
--
Mark Lord


From: Hannes Reinecke <hare@suse.de>
Subject: Fix sata atapi error handling
References: 70918

SCSI commands which end up on the error handler need special attention;
we have to make sure that eh_cmd_q is properly emptied or scsi_eh will
try to forever finalize the command.

With this patch eh_cmd_q is explicitely emptied if not done so in the
strategy handler and a proper abort sequence is executed for each
command if required.
We rely on the strategy handler to fill out proper sense information for
us as SATA is 'special' when it comes to command sense gathering.

Signed-off-by: Kurt Garloff <garloff@suse.de>
Signed-off-by: Jens Axboe <axboe@suse.de>
Acked-by: Andreas Gruenbacher <agruen@suse.de>
...

