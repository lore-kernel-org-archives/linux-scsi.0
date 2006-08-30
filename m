From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH] aic94xx: Increase can_queue and cmds_per_lun
Date: Wed, 30 Aug 2006 13:19:43 -0400
Message-ID: <1156958383.7701.2.camel@mulgrave.il.steeleye.com>
References: <44F3CF6E.1070000@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:2242 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1751172AbWH3RTp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 30 Aug 2006 13:19:45 -0400
In-Reply-To: <44F3CF6E.1070000@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Darrick J. Wong" <djwong@us.ibm.com>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, Alexis Bruemmer <alexisb@us.ibm.com>, Mike Anderson <andmike@us.ibm.com>, Konrad Rzeszutek <konrad@darnok.org>

On Mon, 2006-08-28 at 22:23 -0700, Darrick J. Wong wrote:
> -	.cmd_per_lun		= 1,
> +	.cmd_per_lun		= 2,

This is an old piece of code.  Today we use 1 for the cmd_per_lun of
non-TCQ devices.

> +	aic94xx_sht.can_queue = asd_ha->hw_prof.max_scbs - ASD_FREE_SCBS;

This is unnecessary unless you alter it before host alloc (which is
where it takes the shost values from the template).

Also, I think if you look at the rest of the driver, it's careful to
account for the need for required scbs in its internal queueing
algorithms, so the ASD_FREE_SCBS should be unnecessary.

> +	shost->can_queue = aic94xx_sht.can_queue;

James


