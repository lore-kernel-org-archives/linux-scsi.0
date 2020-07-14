Return-Path: <SRS0=xC/A=AZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ABCAFC433EC
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 07:08:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8B9992076D
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 07:08:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727025AbgGNHIS (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Jul 2020 03:08:18 -0400
Received: from mx2.suse.de ([195.135.220.15]:42754 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725925AbgGNHIR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 14 Jul 2020 03:08:17 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 2DE6BB771;
        Tue, 14 Jul 2020 07:08:18 +0000 (UTC)
Subject: Re: [PATCH v2 21/29] scsi: aic7xxx: aic7xxx_osm: Fix 'amount_xferred'
 set but not used issue
To:     Lee Jones <lee.jones@linaro.org>, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Hannes Reinecke <hare@suse.com>,
        "Daniel M. Eischen" <deischen@iworks.InterWorks.org>,
        Doug Ledford <dledford@redhat.com>
References: <20200713074645.126138-1-lee.jones@linaro.org>
 <20200713074645.126138-22-lee.jones@linaro.org>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <097d4f3f-3d98-4bdc-b31f-5276a8160539@suse.de>
Date:   Tue, 14 Jul 2020 09:08:14 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200713074645.126138-22-lee.jones@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/13/20 9:46 AM, Lee Jones wrote:
> 'amount_xferred' is used, but only in certain circumstances.  Place
> the same stipulations on the defining/allocating of 'amount_xferred'
> as is placed when using it.
> 
> We've been careful not to change any of the ordering semantics here.
> 
> Fixes the following W=1 kernel build warning(s):
> 
>   drivers/scsi/aic7xxx/aic7xxx_osm.c: In function ‘ahc_done’:
>   drivers/scsi/aic7xxx/aic7xxx_osm.c:1725:12: warning: variable ‘amount_xferred’ set but not used [-Wunused-but-set-variable]
>   1725 | uint32_t amount_xferred;
>   | ^~~~~~~~~~~~~~
> 
> Cc: Hannes Reinecke <hare@suse.com>
> Cc: "Daniel M. Eischen" <deischen@iworks.InterWorks.org>
> Cc: Doug Ledford <dledford@redhat.com>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>   drivers/scsi/aic7xxx/aic7xxx_osm.c | 2 ++
>   1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/scsi/aic7xxx/aic7xxx_osm.c b/drivers/scsi/aic7xxx/aic7xxx_osm.c
> index ed437c16de881..e7ccb8b80fc19 100644
> --- a/drivers/scsi/aic7xxx/aic7xxx_osm.c
> +++ b/drivers/scsi/aic7xxx/aic7xxx_osm.c
> @@ -1711,10 +1711,12 @@ ahc_done(struct ahc_softc *ahc, struct scb *scb)
>   	 */
>   	cmd->sense_buffer[0] = 0;
>   	if (ahc_get_transaction_status(scb) == CAM_REQ_INPROG) {
> +#ifdef AHC_REPORT_UNDERFLOWS
>   		uint32_t amount_xferred;
>   
>   		amount_xferred =
>   		    ahc_get_transfer_length(scb) - ahc_get_residual(scb);
> +#endif
>   		if ((scb->flags & SCB_TRANSMISSION_ERROR) != 0) {
>   #ifdef AHC_DEBUG
>   			if ((ahc_debug & AHC_SHOW_MISC) != 0) {
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
