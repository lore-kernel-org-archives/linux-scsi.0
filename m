From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [PATCH 4/5] mvme147: Scsi_Cmnd to struct scsi_cmnd convertion
Date: Tue, 12 Sep 2006 15:23:33 -0500
Message-ID: <1158092613.3461.43.camel@mulgrave.il.steeleye.com>
References: <4506FCEE.1070209@nachtwindheim.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat9.steeleye.com ([209.192.50.41]:47239 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S1030413AbWILUXo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 12 Sep 2006 16:23:44 -0400
In-Reply-To: <4506FCEE.1070209@nachtwindheim.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Henne <henne@nachtwindheim.de>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, 2006-09-12 at 20:31 +0200, Henne wrote:
> Changes obsolete typedef'd Scsi_Cmnd to struct scsi_cmnd.
> Signed-off-by: Henrik Kretzschmar <henne@nachtwindheim.de>

Actually, just a single patch for all the coupled drivers would be
better, please.

> -int wd33c93_queuecommand(Scsi_Cmnd *, void (*done)(Scsi_Cmnd *));
> -int wd33c93_abort(Scsi_Cmnd *);
> -int wd33c93_reset(Scsi_Cmnd *, unsigned int);
> +int wd33c93_queuecommand(struct scsi_cmnd *, void (*done)(struct scsi_cmnd *));
> +int wd33c93_abort(struct scsi_cmnd *);
> +int wd33c93_reset(struct scsi_cmnd *, unsigned int);

These prototypes are all unnecessary and can be pulled out of the
individual header files.  The first two are provided by wd33c93.h and
the last one isn't actually in the body of any file.

wd33c93_info is also unused and can go.

Thanks,

James


