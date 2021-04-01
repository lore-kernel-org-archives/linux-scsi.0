Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 79838C433ED
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Apr 2021 06:30:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 55F26610A5
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Apr 2021 06:30:28 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233333AbhDAG35 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Apr 2021 02:29:57 -0400
Received: from mx2.suse.de ([195.135.220.15]:36648 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233024AbhDAG3k (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 1 Apr 2021 02:29:40 -0400
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id DAF9CAF2A;
        Thu,  1 Apr 2021 06:29:38 +0000 (UTC)
Subject: Re: [PATCH] scsi_dh_alua: remove check for ASC 24h when
 ILLEGAL_REQUEST returned on RTPG w/extended header
To:     "Ewan D. Milne" <emilne@redhat.com>, linux-scsi@vger.kernel.org
References: <20210331201154.20348-1-emilne@redhat.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <4f241afd-33be-dd0d-c748-6bafddcd2235@suse.de>
Date:   Thu, 1 Apr 2021 08:29:38 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210331201154.20348-1-emilne@redhat.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 3/31/21 10:11 PM, Ewan D. Milne wrote:
> Some arrays return ILLEGAL_REQUEST with ASC 00h if they don't support the
> extended header, so remove the check for INVALID FIELD IN CDB.
> 
> Signed-off-by: Ewan D. Milne <emilne@redhat.com>
> ---
>  drivers/scsi/device_handler/scsi_dh_alua.c | 5 +++--
>  1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
> index e42390333c6e..c4c2f23cf79f 100644
> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
> @@ -587,10 +587,11 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
>  		 * even though it shouldn't according to T10.
>  		 * The retry without rtpg_ext_hdr_req set
>  		 * handles this.
> +		 * Note:  some arrays return a sense key of ILLEGAL_REQUEST
> +		 * with ASC 00h if they don't support the extended header.
>  		 */
>  		if (!(pg->flags & ALUA_RTPG_EXT_HDR_UNSUPP) &&
> -		    sense_hdr.sense_key == ILLEGAL_REQUEST &&
> -		    sense_hdr.asc == 0x24 && sense_hdr.ascq == 0) {
> +		    sense_hdr.sense_key == ILLEGAL_REQUEST) {
>  			pg->flags |= ALUA_RTPG_EXT_HDR_UNSUPP;
>  			goto retry;
>  		}
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
