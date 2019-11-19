Return-Path: <SRS0=81Lx=ZL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC095C432C3
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Nov 2019 08:31:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id BE719206F4
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Nov 2019 08:31:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725936AbfKSIbp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Nov 2019 03:31:45 -0500
Received: from mx2.suse.de ([195.135.220.15]:49818 "EHLO mx1.suse.de"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1725798AbfKSIbp (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 19 Nov 2019 03:31:45 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx1.suse.de (Postfix) with ESMTP id DEF9CB21C;
        Tue, 19 Nov 2019 08:31:42 +0000 (UTC)
Message-ID: <a024f34f2f366955d3fe73d9bbcdffefaad6bfa6.camel@suse.de>
Subject: Re: [PATCH 40/52] scsi: Kill DRIVER_SENSE
From:   Martin Wilck <mwilck@suse.de>
To:     Hannes Reinecke <hare@suse.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>,
        Bart van Assche <bvanassche@acm.org>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
Date:   Tue, 19 Nov 2019 09:32:20 +0100
In-Reply-To: <20191104090151.129140-41-hare@suse.de>
References: <20191104090151.129140-1-hare@suse.de>
         <20191104090151.129140-41-hare@suse.de>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.34.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 2019-11-04 at 10:01 +0100, Hannes Reinecke wrote:
> Replace the check for DRIVER_SENSE with a check for
> SAM_STAT_CHECK_CONDITION and audit all callsites to
> ensure the SAM status is set correctly.
> For backwards compability move the DRIVER_SENSE definition
> to sg.h, and update the sg driver to set the DRIVER_SENSE
> driver_status whenever SAM_STAT_CHECK_CONDITION is present.
> 
> Signed-off-by: Hannes Reinecke <hare@suse.de>
> ---
>  drivers/ata/libata-scsi.c                   | 13 ++++-----
>  drivers/scsi/NCR5380.c                      |  2 +-
>  drivers/scsi/aic7xxx/aic79xx_osm.c          | 19 +++++-------
>  drivers/scsi/aic7xxx/aic7xxx_osm.c          |  1 -
>  drivers/scsi/arcmsr/arcmsr_hba.c            |  1 -
>  drivers/scsi/ch.c                           |  3 +-
>  drivers/scsi/constants.c                    |  2 +-
>  drivers/scsi/cxlflash/superpipe.c           | 45 ++++++++++++++-----
> ----------
>  drivers/scsi/dc395x.c                       |  2 +-
>  drivers/scsi/esp_scsi.c                     |  3 +-
>  drivers/scsi/megaraid.c                     | 14 ++++-----
>  drivers/scsi/megaraid/megaraid_mbox.c       | 14 ++++-----
>  drivers/scsi/megaraid/megaraid_sas_base.c   |  2 --
>  drivers/scsi/megaraid/megaraid_sas_fusion.c |  1 -
>  drivers/scsi/mpt3sas/mpt3sas_scsih.c        |  3 +-
>  drivers/scsi/mvumi.c                        |  1 -
>  drivers/scsi/scsi.c                         |  7 -----
>  drivers/scsi/scsi_debug.c                   |  4 +--
>  drivers/scsi/scsi_ioctl.c                   |  2 +-
>  drivers/scsi/scsi_lib.c                     | 13 ++++-----
>  drivers/scsi/scsi_scan.c                    |  2 +-
>  drivers/scsi/scsi_transport_spi.c           |  2 +-
>  drivers/scsi/sd.c                           | 33 +++++++++++------
> ----
>  drivers/scsi/sg.c                           |  9 +++---
>  drivers/scsi/stex.c                         |  4 +--
>  drivers/scsi/sym53c8xx_2/sym_glue.c         |  6 ++--
>  drivers/scsi/ufs/ufshcd.c                   |  2 +-
>  drivers/scsi/virtio_scsi.c                  |  3 +-
>  drivers/scsi/vmw_pvscsi.c                   |  3 --
>  drivers/target/loopback/tcm_loop.c          |  1 -
>  drivers/usb/storage/cypress_atacb.c         |  4 +--
>  drivers/xen/xen-scsiback.c                  |  2 +-
>  include/scsi/scsi.h                         |  1 -
>  include/scsi/sg.h                           |  5 ++--
>  include/trace/events/scsi.h                 |  3 +-
>  35 files changed, 94 insertions(+), 138 deletions(-)
> 
>  	}
> diff --git a/drivers/scsi/aic7xxx/aic79xx_osm.c
> b/drivers/scsi/aic7xxx/aic79xx_osm.c
> index 72c67e89b911..0d83184d069c 100644
> --- a/drivers/scsi/aic7xxx/aic79xx_osm.c
> +++ b/drivers/scsi/aic7xxx/aic79xx_osm.c
> @@ -1940,7 +1940,7 @@ ahd_linux_handle_scsi_status(struct ahd_softc
> *ahd,
>  			memcpy(cmd->sense_buffer,
>  			       ahd_get_sense_buf(ahd, scb)
>  			       + sense_offset, sense_size);
> -			cmd->result |= (DRIVER_SENSE << 24);
> +			cmd->result |= SAM_STAT_CHECK_CONDITION;

Perhaps you should consider using set_status_byte() here, too?

Regards,
Martin



