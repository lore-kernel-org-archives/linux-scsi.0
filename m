Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 42654C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 12 May 2022 09:50:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352064AbiELJuR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 May 2022 05:50:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1351921AbiELJuQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 May 2022 05:50:16 -0400
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5988423BC0
        for <linux-scsi@vger.kernel.org>; Thu, 12 May 2022 02:50:16 -0700 (PDT)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 17D5821CA1;
        Thu, 12 May 2022 09:50:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1652349015; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CDTfrcH2J+wpT6MHPwD//tRDQVCkGoq4f5SeJFs/ebg=;
        b=EQ6PJN0JB4lx/LOM+wyJrv3VNbMB2ixHb5o5wDyzk7j20QsqjLnys+VMIC4lEnHgbw8bqm
        D/E7rV6u/Gbwd37OBM9EcM42VoIT/xEM/tbWY5nkOkYTnn/imnWH8w+7YvHQhQiVdXj8VD
        6DS9QUJ467R0XQLCoIj/4nZdi4TB+uE=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1652349015;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=CDTfrcH2J+wpT6MHPwD//tRDQVCkGoq4f5SeJFs/ebg=;
        b=gV1ttrP49dNjOkI3ZocFd6KebCCRjVzz33zT2vw4BqKqgVmXM1SQhqtiiClsXHigxW6clX
        4yekcQSOeDVpc4AQ==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id EF0E313A84;
        Thu, 12 May 2022 09:50:14 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id xVSiOVbYfGIGPwAAMHmgww
        (envelope-from <hare@suse.de>); Thu, 12 May 2022 09:50:14 +0000
Message-ID: <1f999706-58f9-5521-aaa2-cd88c33669eb@suse.de>
Date:   Thu, 12 May 2022 11:50:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH 1/4] nvme-fc: Add new routine nvme_fc_io_getuuid
Content-Language: en-US
To:     James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org
Cc:     linux-nvme@lists.infradead.org,
        Muneendra <muneendra.kumar@broadcom.com>
References: <20220510200028.37399-1-jsmart2021@gmail.com>
 <20220510200028.37399-2-jsmart2021@gmail.com>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20220510200028.37399-2-jsmart2021@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/10/22 22:00, James Smart wrote:
> From: Muneendra <muneendra.kumar@broadcom.com>
> 
> Add nvme_fc_io_getuuid() to the nvme-fc transport.
> The routine is invoked by the fc LLDD on a per-io request basis.
> The routine translates from the fc-specific request structure to
> the bio and the cgroup structure in order to obtain the fc appid
> stored in the cgroup structure. If a value is not set or a bio
> is not found, a NULL appid (aka uuid) will be returned to the LLDD.
> 
> Signed-off-by: Muneendra <muneendra.kumar@broadcom.com>
> Signed-off-by: James Smart <jsmart2021@gmail.com>
> ---
>   drivers/nvme/host/fc.c         | 16 ++++++++++++++++
>   include/linux/nvme-fc-driver.h | 14 ++++++++++++++
>   2 files changed, 30 insertions(+)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		           Kernel Storage Architect
hare@suse.de			                  +49 911 74053 688
SUSE Software Solutions Germany GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), GF: Felix Imendörffer
