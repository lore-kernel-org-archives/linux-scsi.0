Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D3760C433E0
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Jan 2021 00:14:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9E0D32368A
	for <linux-scsi@archiver.kernel.org>; Fri,  8 Jan 2021 00:14:31 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729396AbhAHAOb (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 7 Jan 2021 19:14:31 -0500
Received: from mx2.suse.de ([195.135.220.15]:59102 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727300AbhAHAOa (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 7 Jan 2021 19:14:30 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.com; s=susede1;
        t=1610064824; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=OynxbXYiyNvIfXBSuIb/SOeZCMfvwXhLlVSsKQOBQJw=;
        b=cZYKThwAI3EKTArsbPLTChMKTKWf2Wq04KVHwIUsJzXOJjKcE+4XkHdU7/t7gUtnsjZ0b/
        ueYULWH546Hi7O13/DVaseRxC1MYuhYh3X4zxF+oc89v+dOGutaMOSlfM0J0C+GwUW9tkW
        x6T19WODiGyTM9GwHog3BACykJBs8AY=
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 0230FB77E;
        Fri,  8 Jan 2021 00:13:44 +0000 (UTC)
Message-ID: <22b679e6047892a385b9991bfae4d9dda67a3259.camel@suse.com>
Subject: Re: [PATCH V3 11/25] smartpqi: add host level stream detection
 enable
From:   Martin Wilck <mwilck@suse.com>
To:     Don Brace <don.brace@microchip.com>, Kevin.Barnett@microchip.com,
        scott.teel@microchip.com, Justin.Lindley@microchip.com,
        scott.benesh@microchip.com, gerry.morong@microchip.com,
        mahesh.rajashekhara@microchip.com, hch@infradead.org,
        jejb@linux.vnet.ibm.com, joseph.szczypek@hpe.com, POSWALD@suse.com
Cc:     linux-scsi@vger.kernel.org
Date:   Fri, 08 Jan 2021 01:13:43 +0100
In-Reply-To: <160763252438.26927.15696823365021360866.stgit@brunhilda>
References: <160763241302.26927.17487238067261230799.stgit@brunhilda>
         <160763252438.26927.15696823365021360866.stgit@brunhilda>
Content-Type: text/plain; charset="ISO-8859-15"
User-Agent: Evolution 3.38.2 
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, 2020-12-10 at 14:35 -0600, Don Brace wrote:
> * Allow R5/R6 stream detection to be disabled/enabled.
>   using sysfs entry enable_stream_detection.
> 
> Example usage:
> 
> lsscsi
> [2:2:0:0]    storage Adaptec  3258P-32i /e     0010
>  ^
>  |
>  +---- NOTE: here host is host2
> 
> find /sys -name \*enable_stream\*
> /sys/devices/pci0000:36/0000:36:00.0/0000:37:00.0/0000:38:00.0/0000:3
> 9:00.0/host2/scsi_host/host2/enable_stream_detection
> /sys/devices/pci0000:5b/0000:5b:00.0/0000:5c:00.0/host3/scsi_host/hos
> t3/enable_stream_detection
> 
> Current stream detection:
> cat
> /sys/devices/pci0000:36/0000:36:00.0/0000:37:00.0/0000:38:00.0/0000:3
> 9:00.0/host2/scsi_host/host2/enable_stream_detection
> 1
> 
> Turn off stream detection:
> echo 0 >
> /sys/devices/pci0000:36/0000:36:00.0/0000:37:00.0/0000:38:00.0/0000:3
> 9:00.0/host2/scsi_host/host2/enable_stream_detection
> 
> Turn on stream detection:
> echo 1 >
> /sys/devices/pci0000:36/0000:36:00.0/0000:37:00.0/0000:38:00.0/0000:3
> 9:00.0/host2/scsi_host/host2/enable_stream_detection
> 
> Reviewed-by: Scott Benesh <scott.benesh@microchip.com>
> Reviewed-by: Scott Teel <scott.teel@microchip.com>
> Reviewed-by: Kevin Barnett <kevin.barnett@microchip.com>
> Signed-off-by: Don Brace <don.brace@microchip.com>

Nitpick below, but

Reviewed-by: Martin Wilck <mwilck@suse.com>

> ---
>  drivers/scsi/smartpqi/smartpqi_init.c |   32
> ++++++++++++++++++++++++++++++++
>  1 file changed, 32 insertions(+)
> 
> diff --git a/drivers/scsi/smartpqi/smartpqi_init.c
> b/drivers/scsi/smartpqi/smartpqi_init.c
> index 96383d047a88..9a449bbc1898 100644
> --- a/drivers/scsi/smartpqi/smartpqi_init.c
> +++ b/drivers/scsi/smartpqi/smartpqi_init.c
> @@ -6724,6 +6724,34 @@ static ssize_t pqi_lockup_action_store(struct
> device *dev,
>         return -EINVAL;
>  }
>  
> +static ssize_t pqi_host_enable_stream_detection_show(struct device
> *dev,
> +       struct device_attribute *attr, char *buffer)
> +{
> +       struct Scsi_Host *shost = class_to_shost(dev);
> +       struct pqi_ctrl_info *ctrl_info = shost_to_hba(shost);
> +
> +       return scnprintf(buffer, 10, "%hhx\n",
> +                       ctrl_info->enable_stream_detection);

Nitpick: As noted before, %hhx is discouraged.

Regards,
Martin


