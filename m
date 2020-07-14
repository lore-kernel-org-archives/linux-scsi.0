Return-Path: <SRS0=xC/A=AZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D6C70C433E4
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 07:07:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B6BF9221FD
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 07:07:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726775AbgGNHHn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Jul 2020 03:07:43 -0400
Received: from mx2.suse.de ([195.135.220.15]:42586 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725925AbgGNHHn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 14 Jul 2020 03:07:43 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 9B451B145;
        Tue, 14 Jul 2020 07:07:43 +0000 (UTC)
Subject: Re: [PATCH v2 20/29] scsi: aic7xxx: aic7xxx_osm: Remove unused
 variable 'targ'
To:     Lee Jones <lee.jones@linaro.org>, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Hannes Reinecke <hare@suse.com>,
        "Daniel M. Eischen" <deischen@iworks.InterWorks.org>,
        Doug Ledford <dledford@redhat.com>
References: <20200713074645.126138-1-lee.jones@linaro.org>
 <20200713074645.126138-21-lee.jones@linaro.org>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <2c38b2b2-d6b4-8a3e-3dd5-8bd511d8396a@suse.de>
Date:   Tue, 14 Jul 2020 09:07:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200713074645.126138-21-lee.jones@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/13/20 9:46 AM, Lee Jones wrote:
> Looks like checking the 'targ' was removed in 2005.
> 
> Fixes the following W=1 kernel build warning(s):
> 
>   drivers/scsi/aic7xxx/aic7xxx_osm.c: In function ‘ahc_send_async’:
>   drivers/scsi/aic7xxx/aic7xxx_osm.c:1604:28: warning: variable ‘targ’ set but not used [-Wunused-but-set-variable]
>   1604 | struct ahc_linux_target *targ;
>   | ^~~~
> 
> Cc: Hannes Reinecke <hare@suse.com>
> Cc: "Daniel M. Eischen" <deischen@iworks.InterWorks.org>
> Cc: Doug Ledford <dledford@redhat.com>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>   drivers/scsi/aic7xxx/aic7xxx_osm.c | 2 --
>   1 file changed, 2 deletions(-)
> 
> diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/aic7xxx_osm.c
> index cc4c7b1781466..ed437c16de881 100644
> --- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
> +++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
> @@ -1592,7 +1592,6 @@ ahc_send_async(struct ahc_softc *ahc, char channel,
>   	case AC_TRANSFER_NEG:
>   	{
>   		struct	scsi_target *starget;
> -		struct	ahc_linux_target *targ;
>   		struct	ahc_initiator_tinfo *tinfo;
>   		struct	ahc_tmode_tstate *tstate;
>   		int	target_offset;
> @@ -1626,7 +1625,6 @@ ahc_send_async(struct ahc_softc *ahc, char channel,
>   		starget = ahc->platform_data->starget[target_offset];
>   		if (starget == NULL)
>   			break;
> -		targ = scsi_transport_target_data(starget);
>   
>   		target_ppr_options =
>   			(spi_dt(starget) ? MSG_EXT_PPR_DT_REQ : 0)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
