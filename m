From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] aha1542: queuecommand: change panic() to return
Date: 25 Jan 2004 13:34:11 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1075059252.3909.11.camel@mulgrave>
References: <20040124220006.48dd7746.rddunlap@osdl.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat1.steeleye.com ([65.114.3.130]:61338 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S265230AbUAYTeP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sun, 25 Jan 2004 14:34:15 -0500
In-Reply-To: <20040124220006.48dd7746.rddunlap@osdl.org>
List-Id: linux-scsi@vger.kernel.org
To: "Randy.Dunlap" <rddunlap@osdl.org>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Sun, 2004-01-25 at 00:00, Randy.Dunlap wrote:
>  		cptr = (struct chain *) SCpnt->host_scribble;
>  		if (cptr == NULL)
> -			panic("aha1542.c: unable to allocate DMA memory\n");
> +			return 1;
>  		for (i = 0; i < SCpnt->use_sg; i++) {
>  			if (sgpnt[i].length == 0 || SCpnt->use_sg > 16 ||

This is really not right.  If you look, the driver has already claimed a
cdb for the command, so it will leak scarce resources in this error
path.

Also a better return might be SCSI_MLQUEUE_HOST_BUSY, since this would
be a global resource shortage for all commands.

James


