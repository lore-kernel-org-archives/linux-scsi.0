Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D5317C48BC2
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Jun 2021 21:33:59 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id AE099613B0
	for <linux-scsi@archiver.kernel.org>; Wed, 23 Jun 2021 21:33:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbhFWVgQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 23 Jun 2021 17:36:16 -0400
Received: from mail-pg1-f177.google.com ([209.85.215.177]:38549 "EHLO
        mail-pg1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229726AbhFWVgP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 23 Jun 2021 17:36:15 -0400
Received: by mail-pg1-f177.google.com with SMTP id h4so2894793pgp.5;
        Wed, 23 Jun 2021 14:33:58 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=BhLMHeFA8LBF5iUv2hekNzgxO12U7tFqzW+X3BFXijI=;
        b=KEN2cg8DRz1BEop6nlevaml8+LBVTUG4/O08+t25E7CmM96aLfhDegHGQhjB5o3u8B
         qFxby/IrsL0o5qDb2i+5hgguXfDvRqdUSZU7X7ds0lh50feeygU4iIrGo5JyfXwxHa/E
         G8QGkTnOq9pbb/u2KVM81qAaKzOkkTSMs0o8bL7qWZ4GcPt/dRPj5ATPaA6m7yQdh2WF
         0yvHqehiv8apT9dNTQGRdoKFF8qOoLrwnGQze7AQMB8r1TtRkaqNheuMQvvmatJDVr2Q
         7Xrua17Wwf+ajrcSQb4dmOayhGIJAXcfcHnec5JHUyPyniaRhD9Zz7O1amL/+c1Y6uew
         wGmg==
X-Gm-Message-State: AOAM533gdqJw6ey/ptZ+GG9i3tYne3DJ/53igX9huB4dr/0pyPceDcbF
        PLwpQpm/LVgzvF/QModORNJCgnU+1OQ=
X-Google-Smtp-Source: ABdhPJzKDm+5yz++kgjBwdOzkZPanJgqzSXKDvwMhrD4IyVuHaEzCosKOIK2czaxKlWFZOgESznVHA==
X-Received: by 2002:a65:4244:: with SMTP id d4mr1406508pgq.83.1624484037280;
        Wed, 23 Jun 2021 14:33:57 -0700 (PDT)
Received: from [192.168.3.217] (c-73-241-217-19.hsd1.ca.comcast.net. [73.241.217.19])
        by smtp.gmail.com with ESMTPSA id y2sm691418pfa.195.2021.06.23.14.33.55
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Jun 2021 14:33:56 -0700 (PDT)
Subject: Re: [PATCH v4 09/10] scsi: ufs: Update the fast abort path in
 ufshcd_abort() for PM requests
To:     Can Guo <cang@codeaurora.org>, asutoshd@codeaurora.org,
        nguyenb@codeaurora.org, hongwus@codeaurora.org,
        ziqichen@codeaurora.org, linux-scsi@vger.kernel.org,
        kernel-team@android.com
Cc:     Alim Akhtar <alim.akhtar@samsung.com>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Bean Huo <beanhuo@micron.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
References: <1624433711-9339-1-git-send-email-cang@codeaurora.org>
 <1624433711-9339-11-git-send-email-cang@codeaurora.org>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <b28d71a7-3839-2c07-2630-6196ea10951f@acm.org>
Date:   Wed, 23 Jun 2021 14:33:54 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <1624433711-9339-11-git-send-email-cang@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 6/23/21 12:35 AM, Can Guo wrote:
> @@ -2737,7 +2737,7 @@ static int ufshcd_queuecommand(struct Scsi_Host *host, struct scsi_cmnd *cmd)
>  		 * err handler blocked for too long. So, just fail the scsi cmd
>  		 * sent from PM ops, err handler can recover PM error anyways.
>  		 */
> -		if (hba->wlu_pm_op_in_progress) {
> +		if (cmd->request->rq_flags & RQF_PM) {
>  			hba->force_reset = true;
>  			set_host_byte(cmd, DID_BAD_TARGET);
>  			cmd->scsi_done(cmd);

I'm still concerned that the above code may trigger data corruption. I
prefer that the above code is removed instead of being modified.

Thanks,

Bart.
