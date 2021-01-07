Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 718B2C433DB
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jan 2021 16:44:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3D2B723437
	for <linux-scsi@archiver.kernel.org>; Thu,  7 Jan 2021 16:44:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726669AbhAGQo0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Jan 2021 11:44:26 -0500
Received: from mx2.suse.de ([195.135.220.15]:34908 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726441AbhAGQoZ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 7 Jan 2021 11:44:25 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1610037818; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=81mz4i+qXVRUsgUse3TZ8UbKpk+zuNqwV/MC4/2JEQs=;
        b=rV3f5QAs85PdLpVU+EIkCRUcS0kAam4iQ3umfqEOAyGn0DYkpqkNTz7SLCnKWZYZRmLd6h
        zzMVuBDvmgaAjdXjoVOWimqEAFdAYNklXBHTPyu8y8M13dhyKcfSxHdSdP4e5Nd6/fmPL4
        NJQJNljkujkYm4L7J7ZoX3wIcxDuhsY=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 92C39AD26;
        Thu,  7 Jan 2021 16:43:38 +0000 (UTC)
Message-ID: <66c49950d7fc38163a567fc9b2a8d1c925cdd411.camel@suse.com>
Subject: Re: [PATCH V3 01/25] smartpqi: add support for product id
From:   Martin Wilck <mwilck@suse.com>
To:     Don Brace <don.brace@microchip.com>, Kevin.Barnett@microchip.com,
        scott.teel@microchip.com, Justin.Lindley@microchip.com,
        scott.benesh@microchip.com, gerry.morong@microchip.com,
        mahesh.rajashekhara@microchip.com, hch@infradead.org,
        jejb@linux.vnet.ibm.com, joseph.szczypek@hpe.com, POSWALD@suse.com
Cc:     linux-scsi@vger.kernel.org
Date:   Thu, 07 Jan 2021 17:43:37 +0100
In-Reply-To: <160763246606.26927.4516545707455278972.stgit@brunhilda>
References: <160763241302.26927.17487238067261230799.stgit@brunhilda>
         <160763246606.26927.4516545707455278972.stgit@brunhilda>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.38.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 2020-12-10 at 14:34 -0600, Don Brace wrote:
> From: Kevin Barnett <kevin.barnett@microchip.com>
> 
> Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
> Reviewed-by: Scott Teel <scott.teel@microchip.com>
> Signed-off-by: Kevin Barnett <kevin.barnett@microchip.com>
> Signed-off-by: Don Brace <don.brace@microchip.com>
> ---
>  drivers/scsi/smartpqi/smartpqi.h      |   11 ++++++++++-
>  drivers/scsi/smartpqi/smartpqi_init.c |   11 +++++++++--
>  drivers/scsi/smartpqi/smartpqi_sis.c  |    5 +++++
>  drivers/scsi/smartpqi/smartpqi_sis.h  |    1 +
>  4 files changed, 25 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/scsi/smartpqi/smartpqi.h
> b/drivers/scsi/smartpqi/smartpqi.h
> index 3e54590e6e92..7d3f956e949f 100644
> 
> [...]
> 
> --- a/drivers/scsi/smartpqi/smartpqi_init.c
> +++ b/drivers/scsi/smartpqi/smartpqi_init.c
> @@ -6259,8 +6259,8 @@ static DEVICE_ATTR(model, 0444, pqi_model_show,
> NULL);
>  static DEVICE_ATTR(serial_number, 0444, pqi_serial_number_show,
> NULL);
>  static DEVICE_ATTR(vendor, 0444, pqi_vendor_show, NULL);
>  static DEVICE_ATTR(rescan, 0200, NULL, pqi_host_rescan_store);
> -static DEVICE_ATTR(lockup_action, 0644,
> -       pqi_lockup_action_show, pqi_lockup_action_store);
> +static DEVICE_ATTR(lockup_action, 0644, pqi_lockup_action_show,
> +       pqi_lockup_action_store);

Nitpick: could you please avoid mixing real code changes with unrelated
whitespace edits? The same applies to several patches of this series.

Other than that:

Reviewed-by: Martin Wilck <mwilck@suse.com>



