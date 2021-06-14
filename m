Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37F36C48BE6
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Jun 2021 06:00:04 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 10EE261009
	for <linux-scsi@archiver.kernel.org>; Mon, 14 Jun 2021 06:00:04 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232139AbhFNGCF (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 14 Jun 2021 02:02:05 -0400
Received: from smtp-out2.suse.de ([195.135.220.29]:45022 "EHLO
        smtp-out2.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229811AbhFNGCE (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 14 Jun 2021 02:02:04 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out2.suse.de (Postfix) with ESMTPS id D18761FD32;
        Mon, 14 Jun 2021 06:00:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1623650400; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RHI5AL2mTop6BgJRfI9PCSVPS2DHFk2o/gPDCy0POlo=;
        b=gVIfeXrfmtqx5MMcH2LkNS3tw6THKk8e9fIJvyhfmHLwmD9qca4m5+405pzNehkcYuuITh
        Fp+Suof6YbXP5Z8IkoKb0lOr+BygC+TCdW9a+GuMvRA5F8nqMLDnjEwdKhjEx2SZT5vWsA
        +5IYD/eXEiJgp8/w9VzEwCuWcX0syuo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1623650400;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RHI5AL2mTop6BgJRfI9PCSVPS2DHFk2o/gPDCy0POlo=;
        b=qmsXsW/uTqTEpzCz2eyVTy9TeO6mEdC2kCxNy0LAyAfWCgmPT6zaXrcQoJGRpdp4g7miR/
        +Tnj2xiE6TWT0rAA==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id 8AE8E118DD;
        Mon, 14 Jun 2021 06:00:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1623650400; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RHI5AL2mTop6BgJRfI9PCSVPS2DHFk2o/gPDCy0POlo=;
        b=gVIfeXrfmtqx5MMcH2LkNS3tw6THKk8e9fIJvyhfmHLwmD9qca4m5+405pzNehkcYuuITh
        Fp+Suof6YbXP5Z8IkoKb0lOr+BygC+TCdW9a+GuMvRA5F8nqMLDnjEwdKhjEx2SZT5vWsA
        +5IYD/eXEiJgp8/w9VzEwCuWcX0syuo=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1623650400;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=RHI5AL2mTop6BgJRfI9PCSVPS2DHFk2o/gPDCy0POlo=;
        b=qmsXsW/uTqTEpzCz2eyVTy9TeO6mEdC2kCxNy0LAyAfWCgmPT6zaXrcQoJGRpdp4g7miR/
        +Tnj2xiE6TWT0rAA==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id vA4QIGDwxmBlXAAALh3uQQ
        (envelope-from <hare@suse.de>); Mon, 14 Jun 2021 06:00:00 +0000
Subject: Re: libata: big endian bug in VPD page 89 (ATA Information)
To:     dgilbert@interlog.com, linux-scsi <linux-scsi@vger.kernel.org>,
        linux-ide@vger.kernel.org,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Tony Asleson <tasleson@redhat.com>
References: <f0d1073e-b4a0-c255-41a3-ff52f1553c0f@interlog.com>
From:   Hannes Reinecke <hare@suse.de>
Message-ID: <0f886a0e-4ff7-6c7c-6863-0497d911f445@suse.de>
Date:   Mon, 14 Jun 2021 08:00:00 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <f0d1073e-b4a0-c255-41a3-ff52f1553c0f@interlog.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/14/21 3:28 AM, Douglas Gilbert wrote:
> In drivers/ata/libata-scsi.c in function ata_scsiop_inq_89() there is
> this line, just before the return:
>        memcpy(&rbuf[60], &args->id[0], 512);
> 
> args->id[0] is the first u16 word of an array from the ATA IDENTIFY
> DEVICE response while rbuf is an array of u8 that will become the
> response to a SCSI INQUIRY(VPD=89h). Given the definition of VPD
> page 89h:
>    byte 60+0:  ATA IDENTIFY DEVICE data word 0 bits 7:0
>    byte 60+1:  ATA IDENTIFY DEVICE data word 0 bits 15:8
>    byte 60+2:  ATA IDENTIFY DEVICE data word 1 bits 7:0
>    ........
> 
> then that memcpy is just fine and dandy on a little endian machine.
> On a big endian machine, not so much.
> 
> Would this call after the memcpy fix things?
>     swap_buf_le16((u16 *)(rbuf + 60), ATA_ID_WORDS);
> 
> That function (in libata-core.c) only swaps bytes in 16 bit words
> on big endian machines.
> 
It might. But probably no-one ever ran libata code on big-endian machines.
They are becoming rare these days; I wouldn't know where to look.
So if you had a chance to run it please give it a go.
Truth to be told, I won't be surprised if there would be more issues 
lurking in the libata code.

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
