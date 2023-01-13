Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 22ACDC678D4
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Jan 2023 11:52:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234479AbjAMLwl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Jan 2023 06:52:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233098AbjAMLwB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 13 Jan 2023 06:52:01 -0500
Received: from smtp-out2.suse.de (smtp-out2.suse.de [195.135.220.29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 33342E0C4;
        Fri, 13 Jan 2023 03:48:43 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id 79C8C3FF36;
        Fri, 13 Jan 2023 11:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1673610521; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1yuZvD6cQQTOQWwUqV+ovRY5kU0BNkWG0uS0UYaSvlc=;
        b=mW6M5N+2VuOnvKsg/3iYAlEXeWTKHGntONz/D1+vku20zFHxGknMbp9VaK6KulsA89DK2Q
        cXT8n5UCvUWB554fsdsKz8a7cBV3dueavaTGNM4IpfBHc+ROzI62FALBZDMPRy9PDFJsEq
        8nJrLdhRGvpLDclr00Sc1ATOOxWKbKY=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1673610521;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=1yuZvD6cQQTOQWwUqV+ovRY5kU0BNkWG0uS0UYaSvlc=;
        b=4hJ/nAfODCQacBy5oEOiHOvpfgjFUYISB76mPj2U4hRLh48jjir8ca7xD5GBNCfXLFmoAg
        Ldb9z/T6uxCSikBA==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 5F3A81358A;
        Fri, 13 Jan 2023 11:48:41 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id 3sLqFhlFwWMPQAAAMHmgww
        (envelope-from <hare@suse.de>); Fri, 13 Jan 2023 11:48:41 +0000
Message-ID: <5206b43b-30a3-6156-8428-4dc4c6eb4fe8@suse.de>
Date:   Fri, 13 Jan 2023 12:48:41 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.6.1
Subject: Re: [PATCH v2 06/18] scsi: support service action in
 scsi_report_opcode()
To:     Niklas Cassel <niklas.cassel@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Damien Le Moal <damien.lemoal@opensource.wdc.com>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-block@vger.kernel.org
References: <20230112140412.667308-1-niklas.cassel@wdc.com>
 <20230112140412.667308-7-niklas.cassel@wdc.com>
Content-Language: en-US
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20230112140412.667308-7-niklas.cassel@wdc.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 1/12/23 15:03, Niklas Cassel wrote:
> From: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> 
> The REPORT_SUPPORTED_OPERATION_CODES command allows checking for support
> of commands that have the same opcode but different service actions,
> such as READ 32 and WRITE 32. However, the current implementation of
> scsi_report_opcode() only allows checking an operation code without a
> service action differentiation.
> 
> Add the "sa" argument to scsi_report_opcode() to allow passing a service
> action. If a non-zero service action is specified, the reporting
> options field value is set to 3 to have the service action field taken
> into account by the device. If no service action field is specified
> (zero), the reporting options field is set to 1 as before.
> 
> Signed-off-by: Damien Le Moal <damien.lemoal@opensource.wdc.com>
> Signed-off-by: Niklas Cassel <niklas.cassel@wdc.com>
> ---
>   drivers/scsi/scsi.c        | 28 +++++++++++++++++++---------
>   drivers/scsi/sd.c          | 10 +++++-----
>   include/scsi/scsi_device.h |  3 ++-
>   3 files changed, 26 insertions(+), 15 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer

