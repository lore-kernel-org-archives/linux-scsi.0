Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-17.9 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,
	INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9455C4708F
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Jun 2021 13:30:17 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C40BB61378
	for <linux-scsi@archiver.kernel.org>; Tue,  1 Jun 2021 13:30:17 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233993AbhFANb6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 1 Jun 2021 09:31:58 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:53808 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233925AbhFANb5 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 1 Jun 2021 09:31:57 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id B9C221FD2D;
        Tue,  1 Jun 2021 13:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1622554215; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jcmBfXlWWK69clJ4NA13DhcgJNKS1bs6nphTJvphM14=;
        b=ynLKbEruLgRwew2ruaNshiyipc79w7CuJyb9SY4G72/5yxRrfhVHGoeo/ntagGtemAJEg6
        IPa2I7qIjdvVNThsBmrwByzmiCSHX80bRet9F6da8HweQzvZrjDQcKE8G8VSaJJix+jcfn
        v3iaE8CtGnYoB4z0hVbSFyZ4zeLaT2A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1622554215;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jcmBfXlWWK69clJ4NA13DhcgJNKS1bs6nphTJvphM14=;
        b=wdkRV+nja7t8iUp+oHktTHkNaMPx0TkAeHeaRCYVGxyTu/rNk5Zw+tmEa7x7Q17lQE9OKe
        I5PsLcd865lW/oDQ==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id 9C242118DD;
        Tue,  1 Jun 2021 13:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1622554215; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jcmBfXlWWK69clJ4NA13DhcgJNKS1bs6nphTJvphM14=;
        b=ynLKbEruLgRwew2ruaNshiyipc79w7CuJyb9SY4G72/5yxRrfhVHGoeo/ntagGtemAJEg6
        IPa2I7qIjdvVNThsBmrwByzmiCSHX80bRet9F6da8HweQzvZrjDQcKE8G8VSaJJix+jcfn
        v3iaE8CtGnYoB4z0hVbSFyZ4zeLaT2A=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1622554215;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jcmBfXlWWK69clJ4NA13DhcgJNKS1bs6nphTJvphM14=;
        b=wdkRV+nja7t8iUp+oHktTHkNaMPx0TkAeHeaRCYVGxyTu/rNk5Zw+tmEa7x7Q17lQE9OKe
        I5PsLcd865lW/oDQ==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id NNOlJWc2tmCjCAAALh3uQQ
        (envelope-from <hare@suse.de>); Tue, 01 Jun 2021 13:30:15 +0000
Subject: Re: [PATCH v6 04/24] mpi3mr: add support of queue command processing
To:     Kashyap Desai <kashyap.desai@broadcom.com>,
        linux-scsi@vger.kernel.org
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        steve.hagan@broadcom.com, peter.rivera@broadcom.com,
        mpi3mr-linuxdrv.pdl@broadcom.com, sathya.prakash@broadcom.com
References: <20210520152545.2710479-1-kashyap.desai@broadcom.com>
 <20210520152545.2710479-5-kashyap.desai@broadcom.com>
From:   Hannes Reinecke <hare@suse.de>
Organization: SUSE Linux GmbH
Message-ID: <6e6c8e2c-17bc-d7e4-8ce2-ff2e45472352@suse.de>
Date:   Tue, 1 Jun 2021 15:30:15 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210520152545.2710479-5-kashyap.desai@broadcom.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 5/20/21 5:25 PM, Kashyap Desai wrote:
> Send Port Enable Request to FW for Device Discovery.
> As part of port enable completion driver calls scan_start and
> scan_finished hooks.
> scsi layer reference like sdev, starget etc is added but actual
> device discovery will be supported once driver add complete event
> process handling (It is added in subsequent patches)
> 
> This patch provides interface which is used to interact with FW
> via operational queue pairs.
> 
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> Reviewed-by: Tomas Henzl <thenzl@redhat.com>
> Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
> 
> Cc: sathya.prakash@broadcom.com
> Cc: hare@suse.de
> ---
>  drivers/scsi/mpi3mr/mpi3mr.h    |  51 +++
>  drivers/scsi/mpi3mr/mpi3mr_fw.c | 244 ++++++++++++
>  drivers/scsi/mpi3mr/mpi3mr_os.c | 634 +++++++++++++++++++++++++++++++-
>  3 files changed, 927 insertions(+), 2 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		        Kernel Storage Architect
hare@suse.de			               +49 911 74053 688
SUSE Software Solutions Germany GmbH, 90409 Nürnberg
GF: F. Imendörffer, HRB 36809 (AG Nürnberg)
