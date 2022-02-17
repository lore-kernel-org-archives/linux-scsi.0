Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 27F9DC433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Feb 2022 07:05:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235877AbiBQHF1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Feb 2022 02:05:27 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53222 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229483AbiBQHF0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Feb 2022 02:05:26 -0500
Received: from smtp-out1.suse.de (smtp-out1.suse.de [195.135.220.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97FFE19C3D
        for <linux-scsi@vger.kernel.org>; Wed, 16 Feb 2022 23:05:12 -0800 (PST)
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 3FBD3218E1;
        Thu, 17 Feb 2022 07:05:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1645081511; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3egtymeWdqKfmqsnSqoq0FpJqROt6n7tR5o/o1TEA9Y=;
        b=XMoyf1ka3GMvh2HHHMPMhHRaPEV1QM1fFwJaZ7iK5vhNohh0VVxbL+lJUFeQYijNhYJab2
        QuNCTwfbJBE3X2Ul/ozbglqu0R/OjQc3y3hofMplN+WWDB7Iold03l80zguJkzypT/Bu+Z
        wMpCVo5sTgs+QkI0+fNqiI+JBgkR+rQ=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1645081511;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=3egtymeWdqKfmqsnSqoq0FpJqROt6n7tR5o/o1TEA9Y=;
        b=1Vn9DsEFTJDQDpwT4zwRdf0QVNG9zdIR/tV5daul+UfJBYwMNGcaqz89BrDjPWpVXgPEN0
        dY+zp5/KHGDE44Bw==
Received: from imap2.suse-dmz.suse.de (imap2.suse-dmz.suse.de [192.168.254.74])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange X25519 server-signature ECDSA (P-521) server-digest SHA512)
        (No client certificate requested)
        by imap2.suse-dmz.suse.de (Postfix) with ESMTPS id 0A81713B78;
        Thu, 17 Feb 2022 07:05:11 +0000 (UTC)
Received: from dovecot-director2.suse.de ([192.168.254.65])
        by imap2.suse-dmz.suse.de with ESMTPSA
        id wE/jAKfzDWJXcgAAMHmgww
        (envelope-from <hare@suse.de>); Thu, 17 Feb 2022 07:05:11 +0000
Message-ID: <35fdeac9-8828-9d89-96cd-67470e771299@suse.de>
Date:   Thu, 17 Feb 2022 08:05:10 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.4.0
Subject: Re: [PATCH v4 28/50] scsi: libfc: Stop using the SCSI pointer
Content-Language: en-US
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Saurav Kashyap <skashyap@marvell.com>,
        Javed Hasan <jhasan@marvell.com>,
        Himanshu Madhani <himanshu.madhani@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
References: <20220216210233.28774-1-bvanassche@acm.org>
 <20220216210233.28774-29-bvanassche@acm.org>
From:   Hannes Reinecke <hare@suse.de>
In-Reply-To: <20220216210233.28774-29-bvanassche@acm.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2/16/22 22:02, Bart Van Assche wrote:
> Move the fc_fcp_pkt pointer, the residual length and the SCSI status into
> the new data structure libfc_cmd_priv. This patch prepares for removal of
> the SCSI pointer from struct scsi_cmnd.
> 
> The user of the libfc data path functions have been identified as follows:
> $ git grep -lw fc_queuecommand | grep -v scsi/libfc/
> drivers/scsi/fcoe/fcoe.c
> 
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: Saurav Kashyap <skashyap@marvell.com>
> Cc: Javed Hasan <jhasan@marvell.com>
> Reviewed-by: Himanshu Madhani <himanshu.madhani@oracle.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> ---
>   drivers/scsi/fcoe/fcoe.c    |  1 +
>   drivers/scsi/libfc/fc_fcp.c | 26 +++++++++++---------------
>   include/scsi/libfc.h        |  9 +++++++++
>   3 files changed, 21 insertions(+), 15 deletions(-)
> 
Reviewed-by: Hannes Reinecke <hare@suse.de>

Cheers,

Hannes
-- 
Dr. Hannes Reinecke                Kernel Storage Architect
hare@suse.de                              +49 911 74053 688
SUSE Software Solutions GmbH, Maxfeldstr. 5, 90409 Nürnberg
HRB 36809 (AG Nürnberg), Geschäftsführer: Felix Imendörffer
