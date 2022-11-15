Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CE9F9C4332F
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Nov 2022 14:13:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229695AbiKOONc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Nov 2022 09:13:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229661AbiKOON2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Nov 2022 09:13:28 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7436A1A0
        for <linux-scsi@vger.kernel.org>; Tue, 15 Nov 2022 06:13:23 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id v124-20020a1cac82000000b003cf7a4ea2caso13208186wme.5
        for <linux-scsi@vger.kernel.org>; Tue, 15 Nov 2022 06:13:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qb3ZO23+V/G7s5F7gxfKLWfGdRmSsftDA4cPHDXJcw0=;
        b=RmnuhAelNKP6h1Ki20lAzhOt+lLPwwqc2lE6HCjYt3UjluETXN/kLvwMQp9vQtBNCb
         mlugKN0ii/8rxpzr/+61zKaDbBBa97DPShynGzgCuYndTmXzwAf3DjYgiBhIAoWmPay8
         BlLcl6yok1ht324ahfsawIcOI3ewOkuPGUqS4almBxSEU3ogyd1VNGn6c1b8LRN5tiXT
         xFGh+GVdIlZ4iBdMV3myEUsS5bTyOHw2ZY0geWhUbSkLkob8w7D8C92VwHoAysAMZ6mP
         /Y30Kl61/7gT9i+y4DPnWAOTbMayyg0Ao82CC8i2j7DI8GUVz1ZCzhFCPDK1XCIbOIXa
         TW6A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qb3ZO23+V/G7s5F7gxfKLWfGdRmSsftDA4cPHDXJcw0=;
        b=Nem7IfBnxpnBGLGDXPX7y2z3IGotOXOscTFMPfOguMTuIM/Sh7ULgwdyUM5dE/VrUP
         nztRkc+2Zm9znwVuCyJSENavWhDtHe4U8XBq19YhgGqLNXxg2RP85lgejdsCyiYQE/ST
         998gJqkNjumKal+NDOLE3xzFsktaX6zZUHZuFsPkPb6y609rT21OPyEQjH5uQg1e36zs
         D7oo4cYNMf49DEOIV4y98CIU5dv5uB4ZETTjpLxfT3eE1eNv2LxdjVDyCczfnuB1R6Xd
         33ybazucq39erLx2RxcS4lskzvHHziQ6oGsSsLSWlayRMkw7iqkIyzICQ/TDr2Ymhabm
         N8zw==
X-Gm-Message-State: ANoB5pno4ZpV89SupRx36IqS+Sp0MLG5xupklLhnH8Qi5eAAjcyLB0oa
        8f5BwL0O+MApMOi/3i6GhYY=
X-Google-Smtp-Source: AA0mqf6f3gGxlcNx7MD9+CfAqjdlqJQWHH5rdiA8M4FEPmI3kF6GREnl1Hl7ybX/WRv0uIbbQoKZTg==
X-Received: by 2002:a05:600c:4fd0:b0:3b4:9a09:2cf1 with SMTP id o16-20020a05600c4fd000b003b49a092cf1mr1687667wmq.13.1668521601958;
        Tue, 15 Nov 2022 06:13:21 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id e12-20020adffd0c000000b00236576c8eddsm12673826wrr.12.2022.11.15.06.13.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 15 Nov 2022 06:13:21 -0800 (PST)
Date:   Tue, 15 Nov 2022 17:13:18 +0300
From:   Dan Carpenter <error27@gmail.com>
To:     james.smart@broadcom.com
Cc:     linux-scsi@vger.kernel.org
Subject: [bug report] scsi: lpfc: Rework locations of ndlp reference taking
Message-ID: <Y3OefhyyJNKH/iaf@kili>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello James Smart,

The patch 4430f7fd09ec: "scsi: lpfc: Rework locations of ndlp
reference taking" from Nov 15, 2020, leads to the following Smatch
static checker warning:

	drivers/scsi/lpfc/lpfc_els.c:5221 lpfc_cmpl_els_logo_acc()
	warn: 'ndlp' was already freed.

drivers/scsi/lpfc/lpfc_els.c
    5162 static void
    5163 lpfc_cmpl_els_logo_acc(struct lpfc_hba *phba, struct lpfc_iocbq *cmdiocb,
    5164                        struct lpfc_iocbq *rspiocb)
    5165 {
    5166         struct lpfc_nodelist *ndlp = cmdiocb->ndlp;
    5167         struct lpfc_vport *vport = cmdiocb->vport;
    5168         u32 ulp_status, ulp_word4;
    5169 
    5170         ulp_status = get_job_ulpstatus(phba, rspiocb);
    5171         ulp_word4 = get_job_word4(phba, rspiocb);
    5172 
    5173         lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_RSP,
    5174                 "ACC LOGO cmpl:   status:x%x/x%x did:x%x",
    5175                 ulp_status, ulp_word4, ndlp->nlp_DID);
    5176         /* ACC to LOGO completes to NPort <nlp_DID> */
    5177         lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS,
    5178                          "0109 ACC to LOGO completes to NPort x%x refcnt %d "
    5179                          "Data: x%x x%x x%x\n",
    5180                          ndlp->nlp_DID, kref_read(&ndlp->kref), ndlp->nlp_flag,
    5181                          ndlp->nlp_state, ndlp->nlp_rpi);
    5182 
    5183         /* This clause allows the LOGO ACC to complete and free resources
    5184          * for the Fabric Domain Controller.  It does deliberately skip
    5185          * the unreg_rpi and release rpi because some fabrics send RDP
    5186          * requests after logging out from the initiator.
    5187          */
    5188         if (ndlp->nlp_type & NLP_FABRIC &&
    5189             ((ndlp->nlp_DID & WELL_KNOWN_DID_MASK) != WELL_KNOWN_DID_MASK))
    5190                 goto out;
    5191 
    5192         if (ndlp->nlp_state == NLP_STE_NPR_NODE) {
    5193                 /* If PLOGI is being retried, PLOGI completion will cleanup the
    5194                  * node. The NLP_NPR_2B_DISC flag needs to be retained to make
    5195                  * progress on nodes discovered from last RSCN.
    5196                  */
    5197                 if ((ndlp->nlp_flag & NLP_DELAY_TMO) &&
    5198                     (ndlp->nlp_last_elscmd == ELS_CMD_PLOGI))
    5199                         goto out;
    5200 
    5201                 /* NPort Recovery mode or node is just allocated */
    5202                 if (!lpfc_nlp_not_used(ndlp)) {
                                                ^^^^
lpfc_nlp_not_used() is a nightmare function from 2007 that frees ndlp if
it's holding the last reference.

    5203                         /* A LOGO is completing and the node is in NPR state.
    5204                          * Just unregister the RPI because the node is still
    5205                          * required.
    5206                          */
    5207                         lpfc_unreg_rpi(vport, ndlp);
    5208                 } else {
    5209                         /* Indicate the node has already released, should
                                                 ^^^^^^^^^^^^^^^^^^^^^^^^^
Node already released on this path.

    5210                          * not reference to it from within lpfc_els_free_iocb.
    5211                          */
    5212                         cmdiocb->ndlp = NULL;
    5213                 }
    5214         }
    5215  out:
    5216         /*
    5217          * The driver received a LOGO from the rport and has ACK'd it.
    5218          * At this point, the driver is done so release the IOCB
    5219          */
    5220         lpfc_els_free_iocb(phba, cmdiocb);
--> 5221         lpfc_nlp_put(ndlp);
                              ^^^^
Double free.

    5222 }

regards,
dan carpenter
