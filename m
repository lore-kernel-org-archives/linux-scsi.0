Return-Path: <SRS0=msWv=XS=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99C10C04EBF
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Sep 2019 13:02:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 760BC207FD
	for <linux-scsi@archiver.kernel.org>; Mon, 23 Sep 2019 13:02:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394881AbfIWNCl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 23 Sep 2019 09:02:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48586 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2394874AbfIWNCl (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 23 Sep 2019 09:02:41 -0400
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id A8E312BFD2
        for <linux-scsi@vger.kernel.org>; Mon, 23 Sep 2019 13:02:40 +0000 (UTC)
Received: by mail-qt1-f200.google.com with SMTP id r15so17129274qtn.12
        for <linux-scsi@vger.kernel.org>; Mon, 23 Sep 2019 06:02:40 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=wo++7OHZ5TF55fscJSREmBycjATg1Pg/3l6GgeJun4o=;
        b=q+VrbsbGJGoqrmNSk6ViKLUUt6ue5NCKGssr1bEJQiS9tQvSlaF+EwUld1ZlUoJp0O
         SBb7RVojRLbNK9YMhej/ybiyyNS0hNNBE2VW1mDBbR+Lkxl1N1GRO1FvfD85p8fYfHgH
         1Xkff/gU2zGnXtj4XfbiQpxRbGyOEMZDpVwNCcDz9mKUiQnIX/LkrhqqXXHPNlAa82C6
         hOnE4u4ENrE06rZKXKGarr10oCmDG6Y6MpwSBEFzzoDXVkryYFarXgpujAK3RqKbf29u
         g7bJXstND9hbcrv37u2WnI8wa1SuJN/eHqHddzjSdrZSF21RamTGLQLXNRt6p1h2p+7z
         zA+Q==
X-Gm-Message-State: APjAAAVTG5FdyVfgmGssOx8OiKUbKX+zr7ehBzUflOQlxoAYN7BntXTu
        AddNh2+CvVQ3SetpzV29o8MdFjiJyZqqdmSV7hsOsjozsmpl+Z5F1RQJ932a2zjn3rfQ2l4W2kM
        S9IO2TiMNd+GHT2dAVpYZvA==
X-Received: by 2002:a37:bc82:: with SMTP id m124mr17491665qkf.231.1569243759815;
        Mon, 23 Sep 2019 06:02:39 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyCoIQZEyUSbcuwAGSvI1U6fLBGUTE9lc6C4NvHGfzFJ+UWHudrlgTu4Dtm9mkQ93wMFUe+yw==
X-Received: by 2002:a37:bc82:: with SMTP id m124mr17491620qkf.231.1569243759411;
        Mon, 23 Sep 2019 06:02:39 -0700 (PDT)
Received: from rhel7lobe ([2600:6c64:4e80:f1:aa45:cafe:5682:368f])
        by smtp.gmail.com with ESMTPSA id 200sm5125496qkf.65.2019.09.23.06.02.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 23 Sep 2019 06:02:38 -0700 (PDT)
Message-ID: <8e9c537b7eaabd611968d22ec31f7cfb90e72efe.camel@redhat.com>
Subject: Re: [PATCH] scsi: core: Log SCSI command age with errors
From:   Laurence Oberman <loberman@redhat.com>
To:     "Milan P. Gandhi" <mgandhi@redhat.com>,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com
Date:   Mon, 23 Sep 2019 09:02:37 -0400
In-Reply-To: <20190923060122.GA9603@machine1>
References: <20190923060122.GA9603@machine1>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5 (3.28.5-2.el7) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 2019-09-23 at 11:31 +0530, Milan P. Gandhi wrote:
> Couple of users had requested to print the SCSI command age along 
> with command failure errors. This is a small change, but allows 
> users to get more important information about the command that was 
> failed, it would help the users in debugging the command failures:
> 
> Signed-off-by: Milan P. Gandhi <mgandhi@redhat.com>
> ---
> diff --git a/drivers/scsi/scsi_logging.c
> b/drivers/scsi/scsi_logging.c
> index ecc5918e372a..ca2182bc53c6 100644
> --- a/drivers/scsi/scsi_logging.c
> +++ b/drivers/scsi/scsi_logging.c
> @@ -437,6 +437,7 @@ void scsi_print_result(const struct scsi_cmnd
> *cmd, const char *msg,
>  	const char *mlret_string = scsi_mlreturn_string(disposition);
>  	const char *hb_string = scsi_hostbyte_string(cmd->result);
>  	const char *db_string = scsi_driverbyte_string(cmd->result);
> +	unsigned long cmd_age = (jiffies - cmd->jiffies_at_alloc) / HZ;
>  
>  	logbuf = scsi_log_reserve_buffer(&logbuf_len);
>  	if (!logbuf)
> @@ -478,10 +479,15 @@ void scsi_print_result(const struct scsi_cmnd
> *cmd, const char *msg,
>  
>  	if (db_string)
>  		off += scnprintf(logbuf + off, logbuf_len - off,
> -				 "driverbyte=%s", db_string);
> +				 "driverbyte=%s ", db_string);
>  	else
>  		off += scnprintf(logbuf + off, logbuf_len - off,
> -				 "driverbyte=0x%02x", driver_byte(cmd-
> >result));
> +				 "driverbyte=0x%02x ",
> +				 driver_byte(cmd->result));
> +
> +	off += scnprintf(logbuf + off, logbuf_len - off,
> +			 "cmd-age=%lus", cmd_age);
> +
>  out_printk:
>  	dev_printk(KERN_INFO, &cmd->device->sdev_gendev, "%s", logbuf);
>  	scsi_log_release_buffer(logbuf);
> 

This looks to be a useful debug addition to me, and the code looks
correct.
I believe this has also been tested by Milan in our lab.

Reviewed-by: Laurence Oberman <loberman@redhat.com> 

