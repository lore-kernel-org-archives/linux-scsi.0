Return-Path: <SRS0=JvOq=BQ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DA3DC388D2
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Aug 2020 11:13:34 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 4FC4922D02
	for <linux-scsi@archiver.kernel.org>; Thu,  6 Aug 2020 11:13:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="JV0gvhrd"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729027AbgHFJxa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 6 Aug 2020 05:53:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729280AbgHFJxJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Aug 2020 05:53:09 -0400
Received: from mail-ej1-x643.google.com (mail-ej1-x643.google.com [IPv6:2a00:1450:4864:20::643])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C79EC061574;
        Thu,  6 Aug 2020 02:51:06 -0700 (PDT)
Received: by mail-ej1-x643.google.com with SMTP id c16so29228730ejx.12;
        Thu, 06 Aug 2020 02:51:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+SFOm87lTcNXDMRd0wla+8fRn6E4XWGuxMzSlFg70fQ=;
        b=JV0gvhrdXEN1nZMtSO1lTgMczv1zN2ZavAimjnNwggg521VOBCuR4Gm3K4rDnL9jsH
         DPLHwP0J9pnbg653AVPkCbQ+iQn7Ml0Xi8+vJKzdAWJ4ZxDcWbEchgA8+rGebMzf8jqR
         RZyAS1WRwy7nsSiHXJxTmAPNPu0C9huw1ETHxDfrz4GEJYU/nPXyXX/Yj/6qsbOQFMSW
         i/EOYti7Ioiu6m+6XSCBWuarbwiz7XQKsF+Ug/b1wusCyz94XurRzHemIOGBy8AGJkpi
         JUwn3H9U3mF2B0zBTBc5xezfBXvTA5prm+wbLFOyu4KiaGhbnbc2uwNtPbGRuCwXIP8n
         dR7g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+SFOm87lTcNXDMRd0wla+8fRn6E4XWGuxMzSlFg70fQ=;
        b=Y3YbwfNSO3mu1ZmgkHoPYqA8ZfVU8JnCwn8IqSAJRV9YuzK/v3iEKY8Fb370qbFoas
         +/esXEC12KNn+zKtPdyPQdU3H6FMV99Zyv4jQveEDV/nzMsy2QPd5envynkMDTdV57cY
         Ddd7iuqat+biANzBBlGUvWu/n8ZH8odVLD3gP9LF914CkJystUGZQVHaXaiGAb8JhwC5
         HAAmxW3MttFBzPLKhGxRawiE07Z8VO++1MrVcXYO65VGCVNAv3nkM1amjKgPsYQA0WHM
         sGau5/fv25tiUo6erZyzDTfT43V6hRePWcNmsaMIIBv4KUkYUeIBl5QteHIFDYX1lDeL
         BvEA==
X-Gm-Message-State: AOAM533NAxi6gJWsWdMwjqlPSmJp1KwC0o9UU+QVCXmFsPiCXk2RIMOd
        hsaKSLQGgPIh1RC5d+kfve4=
X-Google-Smtp-Source: ABdhPJzkeJqaDZrozkYDL4pCBHqAj4HJqbt48tTZX+JvVNe0iNt0PBOoEqPKN/U9pjcNtn2dhuTKag==
X-Received: by 2002:a17:906:1104:: with SMTP id h4mr3479158eja.456.1596707465092;
        Thu, 06 Aug 2020 02:51:05 -0700 (PDT)
Received: from ubuntu-laptop ([2a01:598:b906:f0c9:15b9:533b:62ba:b5b3])
        by smtp.googlemail.com with ESMTPSA id dc23sm2910204edb.50.2020.08.06.02.51.00
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 06 Aug 2020 02:51:04 -0700 (PDT)
Message-ID: <871fdbc1719d7a3c469bf857071aa2c6bd71ddaf.camel@gmail.com>
Subject: Re: [PATCH v1] scsi: ufs: no need to send one Abort Task TM in case
 the task in DB was cleared
From:   Bean Huo <huobean@gmail.com>
To:     Can Guo <cang@codeaurora.org>
Cc:     alim.akhtar@samsung.com, avri.altman@wdc.com,
        asutoshd@codeaurora.org, jejb@linux.ibm.com,
        martin.petersen@oracle.com, stanley.chu@mediatek.com,
        beanhuo@micron.com, bvanassche@acm.org, tomas.winkler@intel.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Date:   Thu, 06 Aug 2020 11:50:54 +0200
In-Reply-To: <a68a1bdf74bdf8ada29808537290b35b@codeaurora.org>
References: <20200804123534.29104-1-huobean@gmail.com>
         <a68a1bdf74bdf8ada29808537290b35b@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


> 
> Please check Stanley's recent change to ufshcd_abort, you may
> want to rebase your change on his and do goto cleanup here.
> @Stanley correct me if I am wrong.
> 
> But even if you do a goto cleanup here, we still lost the
> chances to dump host infos/regs like it does in the old code.
> If a cmd was completed but without a notifying intr, this is
> kind of a problem that we/host should look into, because it's
> pasted at least 30 sec since the cmd was sent, so those dumps
> are necessary to debug the problem. How about moving blow prints
> in front of this part?
> 
> Thanks,
> 
> Can Guo.
> 
> >  	}
> > 
> >  	/* Print Transfer Request of aborted task */

Hi Can

Thanks, do you mean that change to like this:


Author: Bean Huo <beanhuo@micron.com>
Date:   Thu Aug 6 11:34:45 2020 +0200

    scsi: ufs: no need to send one Abort Task TM in case the task in 	
  was cleared
    
    If the bit corresponds to a task in the Doorbell register has been
    cleared, no need to poll the status of the task on the device side
    and to send an Abort Task TM.
    This patch also deletes dispensable dev_err() in case of the task
    already completed.
    
    Signed-off-by: Bean Huo <beanhuo@micron.com>

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index 307622284239..f7c91ce9e294 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6425,23 +6425,9 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
                return ufshcd_eh_host_reset_handler(cmd);
 
        ufshcd_hold(hba, false);
-       reg = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
        /* If command is already aborted/completed, return SUCCESS */
-       if (!(test_bit(tag, &hba->outstanding_reqs))) {
-               dev_err(hba->dev,
-                       "%s: cmd at tag %d already completed,
outstanding=0x%lx, doorbell=0x%x\n",
-                       __func__, tag, hba->outstanding_reqs, reg);
+       if (!(test_bit(tag, &hba->outstanding_reqs)))
                goto out;
-       }
-
-       if (!(reg & (1 << tag))) {
-               dev_err(hba->dev,
-               "%s: cmd was completed, but without a notifying intr,
tag = %d",
-               __func__, tag);
-       }
-
-       /* Print Transfer Request of aborted task */
-       dev_err(hba->dev, "%s: Device abort task at tag %d\n",
__func__, tag);
 
        /*
         * Print detailed info about aborted request.
@@ -6462,6 +6448,17 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
        }
        hba->req_abort_count++;
 
+       reg = ufshcd_readl(hba, REG_UTP_TRANSFER_REQ_DOOR_BELL);
+       if (!(reg & (1 << tag))) {
+               dev_err(hba->dev,
+               "%s: cmd was completed, but without a notifying intr,
tag = %d",
+               __func__, tag);
+               goto cleanup;
+       }
+
+       /* Print Transfer Request of aborted task */
+       dev_err(hba->dev, "%s: Device abort task at tag %d\n",
__func__, tag);
+
        /* Skip task abort in case previous aborts failed and report
failure */
        if (lrbp->req_abort_skip) {
                err = -EIO;
@@ -6526,6 +6523,7 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
                goto out;
        }
 
+cleanup:
        scsi_dma_unmap(cmd);
 
        spin_lock_irqsave(host->host_lock, flags);





Author: Stanley Chu <stanley.chu@mediatek.com>
Date:   Thu Aug 6 11:48:00 2020 +0200

    scsi: ufs: Cleanup completed request without interrupt notification
    
    If somehow no interrupt notification is raised for a completed
request
    and its doorbell bit is cleared by host, UFS driver needs to
cleanup
    its outstanding bit in ufshcd_abort(). Otherwise, system may behave
    abnormally by below flow:
    
    After ufshcd_abort() returns, this request will be requeued by SCSI
    layer with its outstanding bit set. Any future completed request
    will trigger ufshcd_transfer_req_compl() to handle all "completed
    outstanding bits". In this time, the "abnormal outstanding bit"
    will be detected and the "requeued request" will be chosen to
execute
    request post-processing flow. This is wrong because this request is
    still "alive".
    
    Signed-off-by: Stanley Chu <stanley.chu@mediatek.com>

diff --git a/drivers/scsi/ufs/ufshcd.c b/drivers/scsi/ufs/ufshcd.c
index f7c91ce9e294..29d5e5e5d0e0 100644
--- a/drivers/scsi/ufs/ufshcd.c
+++ b/drivers/scsi/ufs/ufshcd.c
@@ -6489,7 +6489,7 @@ static int ufshcd_abort(struct scsi_cmnd *cmd)
                        /* command completed already */
                        dev_err(hba->dev, "%s: cmd at tag %d
successfully cleared from DB.\n",
                                __func__, tag);
-                       goto out;
+                       goto cleanup;
                } else {
                        dev_err(hba->dev,
                                "%s: no response from device. tag = %d,
err %d\n",

