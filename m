From: Tom Yan <tom.ty89@gmail.com>
Subject: Re: [PATCH 1/2] libata-scsi: do not call blk_queue_max_hw_sectors()
Date: Tue, 9 Aug 2016 19:02:23 +0800
Message-ID: <CAGnHSE=KEAUQw9NBDHhkoc-r_BxwSHRKTwtmKoQGVM5Uw+fh9Q@mail.gmail.com>
References: <1dc8fff2418744a7c4bf824f789017228ac15624.1470738284.git.tom.ty89@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qk0-f194.google.com ([209.85.220.194]:33756 "EHLO
	mail-qk0-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752272AbcHILCY (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Aug 2016 07:02:24 -0400
In-Reply-To: <1dc8fff2418744a7c4bf824f789017228ac15624.1470738284.git.tom.ty89@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tejun Heo <tj@kernel.org>
Cc: linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, linux-block@vger.kernel.org, Tom Yan <tom.ty89@gmail.com>

Withdrawn. blk_queue_max_hw_sectors() is not called in hosts.c but in
scsi_lib.c. However, it does not check the dev->max_sectors set in
libata-core.c. So everything of this patch is wrong. Will rewrite and
resend the second patch.

On 9 August 2016 at 18:31,  <tom.ty89@gmail.com> wrote:
> From: Tom Yan <tom.ty89@gmail.com>
>
> We should just let the scsi driver (hosts.c) call the function. It
> has better heuristic anyway (i.e. use SCSI_DEFAULT_MAX_SECTORS as
> fallback when max_sectors is not set).
>
> diff --git a/drivers/ata/libata-scsi.c b/drivers/ata/libata-scsi.c
> index 2bdb5da..495d916 100644
> --- a/drivers/ata/libata-scsi.c
> +++ b/drivers/ata/libata-scsi.c
> @@ -1204,9 +1204,6 @@ static int ata_scsi_dev_config(struct scsi_device *sdev,
>         if (!ata_id_has_unload(dev->id))
>                 dev->flags |= ATA_DFLAG_NO_UNLOAD;
>
> -       /* configure max sectors */
> -       blk_queue_max_hw_sectors(q, dev->max_sectors);
> -
>         if (dev->class == ATA_DEV_ATAPI) {
>                 void *buf;
>
> --
> 2.9.2
>
