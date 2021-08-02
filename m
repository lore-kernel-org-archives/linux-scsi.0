Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B064C4338F
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Aug 2021 13:16:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D7AB360F70
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Aug 2021 13:16:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233764AbhHBNQv (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Aug 2021 09:16:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233691AbhHBNQv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Aug 2021 09:16:51 -0400
Received: from mail-wr1-x429.google.com (mail-wr1-x429.google.com [IPv6:2a00:1450:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89D3AC06175F
        for <linux-scsi@vger.kernel.org>; Mon,  2 Aug 2021 06:16:41 -0700 (PDT)
Received: by mail-wr1-x429.google.com with SMTP id h14so21421565wrx.10
        for <linux-scsi@vger.kernel.org>; Mon, 02 Aug 2021 06:16:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=XB0+sK2y2OhCGvitjXQoX7WS7ISvhgZ+PL1Z1Roq38I=;
        b=mYzTT79zmgzQXAenLJy8HLipMdIujoNx2hGOPinURJ8okWLHAkZ6M+lprpgwy3/wh1
         Vu7RhqO1HVnv1axwVCMl343lN8JUYsU6DZdU92bBuYjaeS7HEIVk9VBcCDBwNWYwZMeg
         tnYH2QSz33FPhFU/BF00PHh4Y1iE6AvbTRo4WR3eNcDG30NY7GmlhBytxaXayBPpxTe9
         w053dz10UjYrFqpowOEMsYBny7A7GMjA16IK8oGsbQuO/Dh+xh6B4xkk1NdhDgOq4a7l
         rPxs2qolnj38ASJzFOaJ69zRAVKVDR5XLTYekfX+Oa90rvcPnLWavFNtzDhHMG06Ojkf
         CIUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=XB0+sK2y2OhCGvitjXQoX7WS7ISvhgZ+PL1Z1Roq38I=;
        b=Kq2wUvcSrTgdAq1cQmTDUhRnndhCmmSLmx/Xk1d6XRgkME8BoSyK/X9PKMlGqwTI7U
         /UADUQ6pTou5NkqDb0m+GOkd55MK4ZXnOZCkZb7Tx8ly28VQiu+cEaFkDw3eGhWvtkwS
         P509f+oE9AmgfdnEVGFjImC4sJxZRu/daVtsFABfDegM1j9ACSRxspJKW9oO7yvoYKeo
         p7W6ohgbl1ferZ6WwzKBh6hBtPFZID9lvDuXd9JbmAW7mC3RBB5tGjpWYuFUr0jY8qEi
         f58Spz3n4VWE3AjsK0Bio2xNJpCgdC3yLDZa+bsCKKpZBUy6Ci+jOcwBLsV/rOlBrCZv
         D5VQ==
X-Gm-Message-State: AOAM531Ed5n/0YmcBwBFLs+kAmNBJtLpiCe8Myoxz9sB4DOZE5BQ/2lc
        2SOGUGIJxkAW4hsmrboEnEY=
X-Google-Smtp-Source: ABdhPJzUDtUwCsgBLGqiS+bFo3v3sASRHoSyy2nR+wuIrjZfHwgvRS9kGNlUnn/IrheaptUOWjwwWw==
X-Received: by 2002:adf:ebd2:: with SMTP id v18mr18143202wrn.248.1627910200238;
        Mon, 02 Aug 2021 06:16:40 -0700 (PDT)
Received: from ubuntu-laptop (ip5f5bfdd7.dynamic.kabel-deutschland.de. [95.91.253.215])
        by smtp.googlemail.com with ESMTPSA id s13sm10355406wmc.47.2021.08.02.06.16.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 06:16:40 -0700 (PDT)
Message-ID: <644b3783c170defc89fb6aa4844b30ccd10a6c01.camel@gmail.com>
Subject: Re: [PATCH v3 15/18] scsi: ufs: Request sense data asynchronously
From:   Bean Huo <huobean@gmail.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bean Huo <beanhuo@micron.com>
Date:   Mon, 02 Aug 2021 15:16:39 +0200
In-Reply-To: <20210722033439.26550-16-bvanassche@acm.org>
References: <20210722033439.26550-1-bvanassche@acm.org>
         <20210722033439.26550-16-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2021-07-21 at 20:34 -0700, Bart Van Assche wrote:
> Clearing a unit attention synchronously from inside the UFS error
> handler
> may trigger the following deadlock:
> - ufshcd_err_handler() calls ufshcd_err_handling_unprepare() and the
> latter
>   function calls ufshcd_clear_ua_wluns().
> - ufshcd_clear_ua_wluns() submits a REQUEST SENSE command and that
> command
>   activates the SCSI error handler.
> - The SCSI error handler calls ufshcd_host_reset_and_restore().
> - ufshcd_host_reset_and_restore() executes the following code:
>   ufshcd_schedule_eh_work(hba);
>   flush_work(&hba->eh_work);
> 
> This sequence results in a deadlock (circular wait). Fix this by
> requesting
> sense data asynchronously.
> 
> Cc: Adrian Hunter <adrian.hunter@intel.com>
> Cc: Stanley Chu <stanley.chu@mediatek.com>
> Cc: Can Guo <cang@codeaurora.org>
> Cc: Asutosh Das <asutoshd@codeaurora.org>
> Cc: Avri Altman <avri.altman@wdc.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Reviewed-by: Bean Huo <beanhuo@micron.com>

