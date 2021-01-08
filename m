Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1E23BC433DB
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Jan 2021 00:35:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D76B2236FB
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Jan 2021 00:35:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729542AbhAHAfP (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Jan 2021 19:35:15 -0500
Received: from mx2.suse.de ([195.135.220.15]:39618 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727858AbhAHAfP (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 7 Jan 2021 19:35:15 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1610066068; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=n3qtYIMYh6fAVMXomM9BZvVJrKoGdiFkdyRsDUvMs7s=;
        b=Qni8W3FiOLAtjnWjZZNOFj92Z/KIMyzln2kNak4zPutfNdh8ahA7jAXph2HTMKlszNSrP4
        GO+MXQ/EO5egeKDqvHMZPffEdeJzbLjg7FgExltgxVClGgTjUn/lozWB2e7HA5yuEYjP4Y
        ahWJcsN61MSUoBFRrm367Ed5uBKmT8Y=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 3C521AD26;
        Fri,  8 Jan 2021 00:34:28 +0000 (UTC)
Message-ID: <42c087bddc3cc3f83a2c6e3fdd84940dc204ff5a.camel@suse.com>
Subject: Re: [PATCH V3 23/25] smartpqi: correct system hangs when resuming
 from hibernation
From:   Martin Wilck <mwilck@suse.com>
To:     Don Brace <don.brace@microchip.com>, Kevin.Barnett@microchip.com,
        scott.teel@microchip.com, Justin.Lindley@microchip.com,
        scott.benesh@microchip.com, gerry.morong@microchip.com,
        mahesh.rajashekhara@microchip.com, hch@infradead.org,
        jejb@linux.vnet.ibm.com, joseph.szczypek@hpe.com, POSWALD@suse.com
Cc:     linux-scsi@vger.kernel.org
Date:   Fri, 08 Jan 2021 01:34:26 +0100
In-Reply-To: <160763259402.26927.11602719287229380898.stgit@brunhilda>
References: <160763241302.26927.17487238067261230799.stgit@brunhilda>
         <160763259402.26927.11602719287229380898.stgit@brunhilda>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.38.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 2020-12-10 at 14:36 -0600, Don Brace wrote:
> From: Kevin Barnett <kevin.barnett@microchip.com>
> 
> * Correct system hangs when resuming from hibernation after
>   first successful hibernation/resume cycle.
>   * Rare condition involving OFA.
> 
> Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
> Signed-off-by: Kevin Barnett <kevin.barnett@microchip.com>
> Signed-off-by: Don Brace <don.brace@microchip.com>
> ---
>  drivers/scsi/smartpqi/smartpqi_init.c |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/scsi/smartpqi/smartpqi_init.c
> b/drivers/scsi/smartpqi/smartpqi_init.c
> index 40ae82470d8c..5ca265babaa2 100644
> --- a/drivers/scsi/smartpqi/smartpqi_init.c
> +++ b/drivers/scsi/smartpqi/smartpqi_init.c
> @@ -8688,6 +8688,11 @@ static __maybe_unused int pqi_resume(struct
> pci_dev *pci_dev)
>         pci_set_power_state(pci_dev, PCI_D0);
>         pci_restore_state(pci_dev);
>  
> +       pqi_ctrl_unblock_device_reset(ctrl_info);
> +       pqi_ctrl_unblock_requests(ctrl_info);
> +       pqi_scsi_unblock_requests(ctrl_info);
> +       pqi_ctrl_unblock_scan(ctrl_info);
> +
>         return pqi_ctrl_init_resume(ctrl_info);
>  }

Like I said in my comments on 14/25:

pqi_ctrl_unblock_scan() and pqi_ctrl_unblock_device_reset() expand
to mutex_unlock(). Unlocking an already-unlocked mutex is wrong, and
a mutex has to be unlocked by the task that owns the lock. How
can you be sure that these conditions are met here?

Regards
Martin




