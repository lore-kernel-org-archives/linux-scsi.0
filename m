Return-Path: <SRS0=xC/A=AZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 68763C433EB
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 07:07:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 51B012076D
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 07:07:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726851AbgGNHHN (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Jul 2020 03:07:13 -0400
Received: from mx2.suse.de ([195.135.220.15]:42424 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725778AbgGNHHM (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 14 Jul 2020 03:07:12 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 97216AD1E;
        Tue, 14 Jul 2020 07:07:13 +0000 (UTC)
Subject: Re: [PATCH v2 19/29] scsi: aic7xxx: aic7xxx_osm: Remove unused
 variable 'ahc'
To:     Lee Jones <lee.jones@linaro.org>, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Hannes Reinecke <hare@suse.com>,
        "Daniel M. Eischen" <deischen@iworks.InterWorks.org>,
        Doug Ledford <dledford@redhat.com>
References: <20200713074645.126138-1-lee.jones@linaro.org>
 <20200713074645.126138-20-lee.jones@linaro.org>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <94cecb13-2df9-9ee8-0341-9d0165f831d4@suse.de>
Date:   Tue, 14 Jul 2020 09:07:09 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200713074645.126138-20-lee.jones@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/13/20 9:46 AM, Lee Jones wrote:
> Looks as though 'ahc' hasn't been used since 2005.
> 
> Fixes the following W=1 kernel build warning(s):
> 
>   drivers/scsi/aic7xxx/aic7xxx_osm.c: In function ‘ahc_linux_slave_configure’:
>   drivers/scsi/aic7xxx/aic7xxx_osm.c:674:20: warning: variable ‘ahc’ set but not used [-Wunused-but-set-variable]
>   674 | struct ahc_softc *ahc;
>   | ^~~
> 
> Cc: Hannes Reinecke <hare@suse.com>
> Cc: "Daniel M. Eischen" <deischen@iworks.InterWorks.org>
> Cc: Doug Ledford <dledford@redhat.com>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>   drivers/scsi/aic7xxx/aic7xxx_osm.c | 4 ----
>   1 file changed, 4 deletions(-)
> 
> diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/aic7xxx_osm.c
> index 32bfe20d79cc1..cc4c7b1781466 100644
> --- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
> +++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
> @@ -666,10 +666,6 @@ ahc_linux_slave_alloc(struct scsi_device *sdev)
>   static int
>   ahc_linux_slave_configure(struct scsi_device *sdev)
>   {
> -	struct	ahc_softc *ahc;
> -
> -	ahc = *((struct ahc_softc **)sdev->host->hostdata);
> -
>   	if (bootverbose)
>   		sdev_printk(KERN_INFO, sdev, "Slave Configure\n");
>   
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
