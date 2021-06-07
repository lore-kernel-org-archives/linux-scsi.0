Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-12.3 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,
	MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AA7BDC47082
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Jun 2021 13:02:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8A6206108D
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Jun 2021 13:02:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230343AbhFGNEK (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Jun 2021 09:04:10 -0400
Received: from smtp-out1.suse.de ([195.135.220.28]:45480 "EHLO
        smtp-out1.suse.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230254AbhFGNEK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Jun 2021 09:04:10 -0400
Received: from imap.suse.de (imap-alt.suse-dmz.suse.de [192.168.254.47])
        (using TLSv1.2 with cipher ECDHE-ECDSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by smtp-out1.suse.de (Postfix) with ESMTPS id 980F821A90;
        Mon,  7 Jun 2021 13:02:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1623070938; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7WP7yfB0MIMV5YAUtxqOsOXkEpqWLnan4Liepj3r5Co=;
        b=ndGWEc/PMrrG2XzW9V1JSGzy96TTIGUVkMMHhvqD3eDV87NJdZYlQqYKfjvTZIb1q5xl1J
        idfxVfFH7AE3htm/qdA+nCKi7WqEVRUrPb2aenJmUE/aZMyAQN4JT14sFeF+vI/GNGPRKK
        4yPqenM0QkWy6kU1T3Xy0hUScCCZ11s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1623070938;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7WP7yfB0MIMV5YAUtxqOsOXkEpqWLnan4Liepj3r5Co=;
        b=U2Pv6ftmdBY1o9jgLZtHsx4Q1B9PMzxe642Fnm2loNk5wRQv7/V8ypRnW8zvuK/aA2wtNa
        MePy3LaQPkCov9Cg==
Received: from imap3-int (imap-alt.suse-dmz.suse.de [192.168.254.47])
        by imap.suse.de (Postfix) with ESMTP id 60665118DD;
        Mon,  7 Jun 2021 13:02:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=suse.de; s=susede2_rsa;
        t=1623070938; h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7WP7yfB0MIMV5YAUtxqOsOXkEpqWLnan4Liepj3r5Co=;
        b=ndGWEc/PMrrG2XzW9V1JSGzy96TTIGUVkMMHhvqD3eDV87NJdZYlQqYKfjvTZIb1q5xl1J
        idfxVfFH7AE3htm/qdA+nCKi7WqEVRUrPb2aenJmUE/aZMyAQN4JT14sFeF+vI/GNGPRKK
        4yPqenM0QkWy6kU1T3Xy0hUScCCZ11s=
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=suse.de;
        s=susede2_ed25519; t=1623070938;
        h=from:from:reply-to:date:date:message-id:message-id:to:to:cc:cc:
         mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=7WP7yfB0MIMV5YAUtxqOsOXkEpqWLnan4Liepj3r5Co=;
        b=U2Pv6ftmdBY1o9jgLZtHsx4Q1B9PMzxe642Fnm2loNk5wRQv7/V8ypRnW8zvuK/aA2wtNa
        MePy3LaQPkCov9Cg==
Received: from director2.suse.de ([192.168.254.72])
        by imap3-int with ESMTPSA
        id qPKEFtoYvmADEgAALh3uQQ
        (envelope-from <hare@suse.de>); Mon, 07 Jun 2021 13:02:18 +0000
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     Jiri Slaby <jirislaby@kernel.org>, Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        Johannes Thumshirn <jthumshirn@suse.de>,
        linux-scsi@vger.kernel.org
References: <20191021095322.137969-1-hare@suse.de>
 <20191021095322.137969-14-hare@suse.de>
 <a5551d37-8303-2cbb-f82a-17fea785adad@kernel.org>
 <c48e74e9-4bbb-d892-4976-06bb448f5f6c@suse.de>
 <yq1bl8hn9py.fsf@ca-mkp.ca.oracle.com>
From:   Hannes Reinecke <hare@suse.de>
Organization: SUSE Linux GmbH
Subject: Re: [PATCH 13/24] scsi: Kill DRIVER_SENSE
Message-ID: <e2c75feb-cd87-1681-a5ee-6aed7ee82e11@suse.de>
Date:   Mon, 7 Jun 2021 15:02:18 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <yq1bl8hn9py.fsf@ca-mkp.ca.oracle.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/7/21 2:30 PM, Martin K. Petersen wrote:
> 
> Hannes,
> 
>>> Any ideas?
> 
>>> Can you enable SCSI logging via
>>
>> scsi.scsi_logging_level=216
>>
>> on the kernel commandline and send me the output?
> 
> You now effectively set SAM_STAT_CHECK_CONDITION if the scsi_cmnd has a
> sense buffer.
> 
> The original code only set DRIVER_SENSE if the adapter response actually
> contained sense information:
> 
> @@ -161,8 +161,7 @@ static void virtscsi_complete_cmd(struct virtio_scsi *vscsi, void *buf)
>                        min_t(u32,
>                              virtio32_to_cpu(vscsi->vdev, resp->sense_len),
>                              VIRTIO_SCSI_SENSE_SIZE));
> -               if (resp->sense_len)
> -                       set_driver_byte(sc, DRIVER_SENSE);
> +               set_status_byte(sc, SAM_STAT_CHECK_CONDITION);
>         }
> 
Oh, I know. But we're checking for a valid sense code during scanning:

			if (scsi_status_is_check_condition(result) &&
			    scsi_sense_valid(&sshdr)) {

so if that makes a difference it would mean that the virtio driver has
some stale sense data which then gets copied over.
Anyway.
Can you test with this patch?

diff --git a/drivers/scsi/virtio_scsi.c b/drivers/scsi/virtio_scsi.c
index fd69a03d6137..0cb1182fd734 100644
--- a/drivers/scsi/virtio_scsi.c
+++ b/drivers/scsi/virtio_scsi.c
@@ -161,7 +161,8 @@ static void virtscsi_complete_cmd(struct virtio_scsi
*vscsi, void *buf)
                       min_t(u32,
                             virtio32_to_cpu(vscsi->vdev, resp->sense_len),
                             VIRTIO_SCSI_SENSE_SIZE));
-               set_status_byte(sc, SAM_STAT_CHECK_CONDITION);
+               if (resp->sense_len)
+                       set_status_byte(sc, SAM_STAT_CHECK_CONDITION);
        }

        sc->scsi_done(sc);

Cheers,

Hannes
-- 
Dr. Hannes Reinecke		        Kernel Storage Architect
hare@suse.de			               +49 911 74053 688
SUSE Software Solutions Germany GmbH, 90409 Nürnberg
GF: F. Imendörffer, HRB 36809 (AG Nürnberg)
