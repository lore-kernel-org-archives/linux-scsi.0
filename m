Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5701FC433E0
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Jan 2021 00:30:58 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1196223435
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Jan 2021 00:30:58 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727935AbhAHAa5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Jan 2021 19:30:57 -0500
Received: from mx2.suse.de ([195.135.220.15]:38680 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727235AbhAHAa5 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 7 Jan 2021 19:30:57 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1610065810; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=BS3L9WXRXQeyymo+Pzg3AoWdQiyUgv541kZSdTk0kv0=;
        b=Z2mCAwOrR2osTDEkWtwUGssf0uik14Ygdmmh0lqH6pXJgSb9+WyvbRDbtj6bqhaPysRs86
        ZXwyCuFOToLJXVhsvhWjMjOeJZlSc9TGTmKG0RLcK1sZOc5IXdeydsOQByt4dsTvfmuZsz
        5iL87mO06LohiTT/RcgpVw1IkSyJPS8=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 8C101ABC4;
        Fri,  8 Jan 2021 00:30:10 +0000 (UTC)
Message-ID: <ff8339afa9f17cf65648f2a9a6ba8b8460f4020e.camel@suse.com>
Subject: Re: [PATCH V3 22/25] smartpqi: update enclosure identifier in sysf
From:   Martin Wilck <mwilck@suse.com>
To:     Don Brace <don.brace@microchip.com>, Kevin.Barnett@microchip.com,
        scott.teel@microchip.com, Justin.Lindley@microchip.com,
        scott.benesh@microchip.com, gerry.morong@microchip.com,
        mahesh.rajashekhara@microchip.com, hch@infradead.org,
        jejb@linux.vnet.ibm.com, joseph.szczypek@hpe.com, POSWALD@suse.com
Cc:     linux-scsi@vger.kernel.org
Date:   Fri, 08 Jan 2021 01:30:09 +0100
In-Reply-To: <160763258826.26927.5141004289781904133.stgit@brunhilda>
References: <160763241302.26927.17487238067261230799.stgit@brunhilda>
         <160763258826.26927.5141004289781904133.stgit@brunhilda>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.38.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 2020-12-10 at 14:36 -0600, Don Brace wrote:
> From: Murthy Bhat <Murthy.Bhat@microchip.com>
> 
> * Update enclosure identifier field corresponding to
>   physical devices in lsscsi/sysfs.
> 
> Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
> Reviewed-by: Scott Teel <scott.teel@microchip.com>
> Reviewed-by: Kevin Barnett <kevin.barnett@microchip.com>
> Signed-off-by: Murthy Bhat <Murthy.Bhat@microchip.com>
> Signed-off-by: Don Brace <don.brace@microchip.com>
> ---
>  drivers/scsi/smartpqi/smartpqi_init.c |    1 -
>  1 file changed, 1 deletion(-)
> 
> diff --git a/drivers/scsi/smartpqi/smartpqi_init.c
> b/drivers/scsi/smartpqi/smartpqi_init.c
> index 1c51a59f1da6..40ae82470d8c 100644
> --- a/drivers/scsi/smartpqi/smartpqi_init.c
> +++ b/drivers/scsi/smartpqi/smartpqi_init.c
> @@ -1841,7 +1841,6 @@ static void pqi_dev_info(struct pqi_ctrl_info
> *ctrl_info,
>  static void pqi_scsi_update_device(struct pqi_scsi_dev
> *existing_device,
>         struct pqi_scsi_dev *new_device)
>  {
> -       existing_device->devtype = new_device->devtype;
>         existing_device->device_type = new_device->device_type;
>         existing_device->bus = new_device->bus;
>         if (new_device->target_lun_valid) {
> 

I don't get this. Why was it wrong to update the devtype field?



