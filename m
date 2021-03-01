Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-15.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0051CC433DB
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 06:57:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9673364E38
	for <linux-scsi@archiver.kernel.org>; Mon,  1 Mar 2021 06:57:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232183AbhCAG5C (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 1 Mar 2021 01:57:02 -0500
Received: from mx2.suse.de ([195.135.220.15]:48746 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232181AbhCAG46 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 1 Mar 2021 01:56:58 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.221.27])
        by mx2.suse.de (Postfix) with ESMTP id 46276AAC5;
        Mon,  1 Mar 2021 06:56:16 +0000 (UTC)
Subject: Re: [PATCH 09/24] mpi3mr: add support for recovering controller
To:     Kashyap Desai <kashyap.desai@broadcom.com>,
        linux-scsi@vger.kernel.org
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        steve.hagan@broadcom.com, peter.rivera@broadcom.com,
        mpi3mr-linuxdrv.pdl@broadcom.com, sathya.prakash@broadcom.com
References: <20201222101156.98308-1-kashyap.desai@broadcom.com>
 <20201222101156.98308-10-kashyap.desai@broadcom.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <faf6021d-796f-049c-3c95-acd9cff4925f@suse.de>
Date:   Mon, 1 Mar 2021 07:56:15 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.0
MIME-Version: 1.0
In-Reply-To: <20201222101156.98308-10-kashyap.desai@broadcom.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 12/22/20 11:11 AM, Kashyap Desai wrote:
> Added h/w defined process of doing controller reset.
> The driver on detection of firmware fault or any kind of unresponsiveness in
> the controller (Any admin command time outs) results in resetting the controller.
> The primary reset mechanisms used are either soft reset or diag fault reset.
> Reset is performed if the host sets the ResetAction field in the HostDiagnostic
> register to a 001b (Soft Reset) or 007b(diag fault reset).
> The driver after successfully resetting the controller reinitialize the
> controller by going through start of the day controller initialization procedures.
> The pending I/Os during the reset are returned back to SML for retry.
> 
> Signed-off-by: Kashyap Desai <kashyap.desai@broadcom.com>
> Cc: sathya.prakash@broadcom.com
> ---
>   drivers/scsi/mpi3mr/mpi3mr.h    |  22 +-
>   drivers/scsi/mpi3mr/mpi3mr_fw.c | 416 +++++++++++++++++++++++++++++---
>   drivers/scsi/mpi3mr/mpi3mr_os.c |  93 ++++++-
>   3 files changed, 488 insertions(+), 43 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
