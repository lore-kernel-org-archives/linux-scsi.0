From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: PATCH [5/15] qla2xxx:  SG tablesize update
Date: 14 Mar 2004 10:55:30 -0500
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1079279732.2108.40.camel@mulgrave>
References: <20040314082444.GA3416@linux.local.home>
	<1079275768.2022.1.camel@mulgrave> <20040314145142.GL6955@suse.de>
	<1079276396.2022.8.camel@mulgrave> <20040314151809.GG19737@krispykreme>
	<1079278279.2022.34.camel@mulgrave>  <20040314154713.GH19737@krispykreme>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:24979 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S263378AbUCNPzo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 14 Mar 2004 10:55:44 -0500
In-Reply-To: <20040314154713.GH19737@krispykreme>
List-Id: linux-scsi@vger.kernel.org
To: Anton Blanchard <anton@samba.org>
Cc: Jens Axboe <axboe@suse.de>, Andrew Vasquez <andrew.vasquez@qlogic.com>, SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sun, 2004-03-14 at 10:47, Anton Blanchard wrote:
> Lets ignore the pci_map_sg problem and assume the qlogic driver did the 
> right thing. Whats to stop the upper layers from continually trying to 
> queue things when we run out of request slots? If its just sg_tablesize 
> then we are stuck with the current compromise (ie set it to something
> reasonably low).

Because on this type of failure, the driver will return
SCSI_MLQUEUE_HOST_BUSY from its queuecommand routine.  This will tell
the mid layer not to try any more commands for the entire host until an
outstanding one returns (thus hopefully freeing up enough resources).

James


