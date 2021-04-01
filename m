Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06153C433B4
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Apr 2021 04:25:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C95AE6101A
	for <linux-scsi@archiver.kernel.org>; Thu,  1 Apr 2021 04:25:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229539AbhDAEZF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 1 Apr 2021 00:25:05 -0400
Received: from mail-1.ca.inter.net ([208.85.220.69]:38869 "EHLO
        mail-1.ca.inter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbhDAEYg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Apr 2021 00:24:36 -0400
Received: from localhost (offload-3.ca.inter.net [208.85.220.70])
        by mail-1.ca.inter.net (Postfix) with ESMTP id 951DC2EA0CE;
        Thu,  1 Apr 2021 00:24:35 -0400 (EDT)
Received: from mail-1.ca.inter.net ([208.85.220.69])
        by localhost (offload-3.ca.inter.net [208.85.220.70]) (amavisd-new, port 10024)
        with ESMTP id X0FNgQliW7ej; Thu,  1 Apr 2021 00:06:11 -0400 (EDT)
Received: from [192.168.48.23] (host-45-58-219-4.dyn.295.ca [45.58.219.4])
        (using TLSv1 with cipher DHE-RSA-AES128-SHA (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: dgilbert@interlog.com)
        by mail-1.ca.inter.net (Postfix) with ESMTPSA id D164C2EA073;
        Thu,  1 Apr 2021 00:24:34 -0400 (EDT)
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH] scsi_dh_alua: remove check for ASC 24h when
 ILLEGAL_REQUEST returned on RTPG w/extended header
To:     "Ewan D. Milne" <emilne@redhat.com>, linux-scsi@vger.kernel.org
Cc:     hare@suse.de
References: <20210331201154.20348-1-emilne@redhat.com>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <2c505c60-9ba0-9ce6-46a6-e6edea2ada03@interlog.com>
Date:   Thu, 1 Apr 2021 00:24:34 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210331201154.20348-1-emilne@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2021-03-31 4:11 p.m., Ewan D. Milne wrote:
> Some arrays return ILLEGAL_REQUEST with ASC 00h if they don't support the
> extended header, so remove the check for INVALID FIELD IN CDB.

Wow. Referring to the 18 byte sense buffer as an extended header sounds
like it comes from the transition of SCSI-1 to SCSI-2, about 30 years ago.
Those arrays need to be named and shamed.

Doug Gilbert
Hmm, it is April first ...

> Signed-off-by: Ewan D. Milne <emilne@redhat.com>
> ---
>   drivers/scsi/device_handler/scsi_dh_alua.c | 5 +++--
>   1 file changed, 3 insertions(+), 2 deletions(-)
> 
> diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
> index e42390333c6e..c4c2f23cf79f 100644
> --- a/drivers/scsi/device_handler/scsi_dh_alua.c
> +++ b/drivers/scsi/device_handler/scsi_dh_alua.c
> @@ -587,10 +587,11 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
>   		 * even though it shouldn't according to T10.
>   		 * The retry without rtpg_ext_hdr_req set
>   		 * handles this.
> +		 * Note:  some arrays return a sense key of ILLEGAL_REQUEST
> +		 * with ASC 00h if they don't support the extended header.
>   		 */
>   		if (!(pg->flags & ALUA_RTPG_EXT_HDR_UNSUPP) &&
> -		    sense_hdr.sense_key == ILLEGAL_REQUEST &&
> -		    sense_hdr.asc == 0x24 && sense_hdr.ascq == 0) {
> +		    sense_hdr.sense_key == ILLEGAL_REQUEST) {
>   			pg->flags |= ALUA_RTPG_EXT_HDR_UNSUPP;
>   			goto retry;
>   		}
> 

