Return-Path: <SRS0=xC/A=AZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.5 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 18A78C433E6
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 06:49:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id F19BF221F0
	for <linux-scsi@archiver.kernel.org>; Tue, 14 Jul 2020 06:49:16 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726785AbgGNGtJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 14 Jul 2020 02:49:09 -0400
Received: from mx2.suse.de ([195.135.220.15]:55994 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725788AbgGNGtJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 14 Jul 2020 02:49:09 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 0345CACC6;
        Tue, 14 Jul 2020 06:49:10 +0000 (UTC)
Subject: Re: [PATCH v2 02/29] include: scsi: scsi_transport_fc: Match HBA
 Attribute Length with HBAAPI V2.0 definitions
To:     Lee Jones <lee.jones@linaro.org>, jejb@linux.ibm.com,
        martin.petersen@oracle.com
Cc:     linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
References: <20200713074645.126138-1-lee.jones@linaro.org>
 <20200713074645.126138-3-lee.jones@linaro.org>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <52269484-8df0-38f7-2be3-b0a10ff9696d@suse.de>
Date:   Tue, 14 Jul 2020 08:49:05 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <20200713074645.126138-3-lee.jones@linaro.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 7/13/20 9:46 AM, Lee Jones wrote:
> According to 'include/scsi/scsi_transport_fc.h':
> 
>   "Attributes are based on HBAAPI V2.0 definitions"
> 
> ... so it seems sane to match the 'HBA Attribute Length' to them.
> 
> If we don't, the compiler complains that the copied data will be truncated.
> 
> Fixes the following W=1 kernel build warning(s):
> 
>   In file included from include/linux/bitmap.h:9,
>   from include/linux/cpumask.h:12,
>   from include/linux/smp.h:13,
>   from include/linux/percpu.h:7,
>   from include/scsi/libfc.h:13,
>   from drivers/scsi/libfc/fc_elsct.c:17:
>   In function ‘strncpy’,
>   inlined from ‘fc_ct_ms_fill.constprop’ at include/scsi/fc_encode.h:263:3:
>   include/linux/string.h:297:30: warning: ‘__builtin_strncpy’ output may be truncated copying 64 bytes from a string of length  79 [-Wstringop-truncation]
>   297 | #define __underlying_strncpy __builtin_strncpy
>   | ^
>   include/linux/string.h:307:9: note: in expansion of macro ‘__underlying_strncpy’
>   307 | return __underlying_strncpy(p, q, size);
>   | ^~~~~~~~~~~~~~~~~~~~
>   In function ‘strncpy’,
>   inlined from ‘fc_ct_ms_fill.constprop’ at include/scsi/fc_encode.h:275:3:
>   include/linux/string.h:297:30: warning: ‘__builtin_strncpy’ output may be truncated copying 64 bytes from a string of length 79 [-Wstringop-truncation]
>   297 | #define __underlying_strncpy __builtin_strncpy
>   | ^
>   include/linux/string.h:307:9: note: in expansion of macro ‘__underlying_strncpy’
>   307 | return __underlying_strncpy(p, q, size);
>   | ^~~~~~~~~~~~~~~~~~~~
> 
> Signed-off-by: Lee Jones <lee.jones@linaro.org>
> ---
>   include/scsi/fc/fc_ms.h | 4 ++--
>   1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/include/scsi/fc/fc_ms.h b/include/scsi/fc/fc_ms.h
> index 800d53dc94705..9e273fed0a85f 100644
> --- a/include/scsi/fc/fc_ms.h
> +++ b/include/scsi/fc/fc_ms.h
> @@ -63,8 +63,8 @@ enum fc_fdmi_hba_attr_type {
>    * HBA Attribute Length
>    */
>   #define FC_FDMI_HBA_ATTR_NODENAME_LEN		8
> -#define FC_FDMI_HBA_ATTR_MANUFACTURER_LEN	64
> -#define FC_FDMI_HBA_ATTR_SERIALNUMBER_LEN	64
> +#define FC_FDMI_HBA_ATTR_MANUFACTURER_LEN	80
> +#define FC_FDMI_HBA_ATTR_SERIALNUMBER_LEN	80
>   #define FC_FDMI_HBA_ATTR_MODEL_LEN		256
>   #define FC_FDMI_HBA_ATTR_MODELDESCR_LEN		256
>   #define FC_FDMI_HBA_ATTR_HARDWAREVERSION_LEN	256
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke            Teamlead Storage & Networking
hare@suse.de                               +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
