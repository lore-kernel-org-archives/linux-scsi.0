From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: Fallback sequence in scsi_transport_spi
Date: Mon, 25 Jul 2005 08:19:32 -0400
Message-ID: <1122293972.5084.4.camel@mulgrave>
References: <42E4A327.90005@suse.de>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from stat16.steeleye.com ([209.192.50.48]:61825 "EHLO
	hancock.sc.steeleye.com") by vger.kernel.org with ESMTP
	id S261181AbVGYMTk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Jul 2005 08:19:40 -0400
In-Reply-To: <42E4A327.90005@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: SCSI Mailing List <linux-scsi@vger.kernel.org>

On Mon, 2005-07-25 at 10:30 +0200, Hannes Reinecke wrote:
> it appears that the fallback sequence in
> scsi_transport_spi.c:spi_dv_retrain()
> is somewhat incorrect.
> 
> According to SPI-3 (spi3r14, actually), the flags DT, IU, and QAS can be
> set in the following order of precedence (Table 55, p 155):
> - DT
> - IU
> - QAS

Actually, this is superceded by spi4 and 5.  QAS is now optional for any
transfer agreement.

> However, the fallback routine in spi_dv_retrain first unsets IU, _then_
> QAS, and ignoring DT entirely. This smells a bit fishy.
> Any reasons for this?

DT is theoretically a more stable transfer mechanism in the face of line
noise than ST, so if the drive supports it, it makes some sense to back
down the periods still retaining DT if possible.  DT also mandates data
group transfers if IU isn't mandated, so it's a safer protocol at
detecting errors as well.

James


