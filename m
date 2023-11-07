Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED180C4167B
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Nov 2023 15:26:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235475AbjKGP0I (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Nov 2023 10:26:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343976AbjKGPZz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Nov 2023 10:25:55 -0500
Received: from mail-ej1-x62b.google.com (mail-ej1-x62b.google.com [IPv6:2a00:1450:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F2B6A1BD7
        for <linux-scsi@vger.kernel.org>; Tue,  7 Nov 2023 07:19:32 -0800 (PST)
Received: by mail-ej1-x62b.google.com with SMTP id a640c23a62f3a-9db6cf8309cso852927166b.0
        for <linux-scsi@vger.kernel.org>; Tue, 07 Nov 2023 07:19:32 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1699370371; x=1699975171; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=qh0AEKO3JvgveIOYdbqx1DoIjIGYMQAi1JtMmos8/ww=;
        b=vaTgJulnIOn7zhYFITs3yk/5fjjraj+e0YyLSq2T0uNaShmbfd10te/AgzUu1gjHCW
         xxly48bNuFZXyD4ueOzWPuUmtlWgyJEc3cK2qONWEEUIcMzxNyqQJE/TG/fVtMddJUD0
         mcM2u6QIFQbTdHC+4LQdcwgMzrDPMlg3XyCxYvtePdwUSxjrTmLSid0ur9bdhPTtI2M9
         XgRrV8ApsfbbBkcAg0igj60Qo/jkc1txWS1zq8NwcKHGyNPleyRDGJFw2P0CqlRvcJBc
         7NQ8Um788dghtSeU2PzdbFBUBRNufQxWFgwszzQ/2J3jhi/SGwjlhrDdu6666p2uK/BF
         6+aA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699370371; x=1699975171;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=qh0AEKO3JvgveIOYdbqx1DoIjIGYMQAi1JtMmos8/ww=;
        b=O3Cyhz6DlACxgmCi0UAMHiCXm+MrLL6EH5/3KspWrHVcnM9oyRQXDBx3ywGbWMVh2q
         pi0U8Xu59eK/m2YeZx4uG8BClm6N50/leDxmY+eUx257DZYfPRqR79+1Rrr2RDl4oHM7
         LaH0WEFdVt0QhNIvIVQ5O//dkvyLEP4LXj3fGkFxbasLsHhv4BpfsgV6BU5dOKOCd0Wv
         nTLhLFonQESYkT1VsIVSlofckbbOw31y1w3JXsvb6mVh9CGwjSl2boUqNdXwPPjh5jxY
         DVcuv01FC/Q0lqEtndBCNaVzjO4dHvPwk+dZmBDIqM/5WGZz9R+mMi8q3TKLCKAfNbPC
         r7qA==
X-Gm-Message-State: AOJu0Yz+3ji+qPjj9N8Z+FEYpaNVGzvWTZalhkTniaVxoz4NDJkcXk2N
        jyzF0ytsk867D6UaeWbH7+sVww==
X-Google-Smtp-Source: AGHT+IFhJnnlFQHIFnxd6jP38QmnwfJl2yvlWUedii/ogZgIPLfM/Y4DljPVGeU9Ac5fk0HWqAwTWA==
X-Received: by 2002:a17:906:c141:b0:9dd:7db7:a0af with SMTP id dp1-20020a170906c14100b009dd7db7a0afmr10420985ejc.56.1699370371453;
        Tue, 07 Nov 2023 07:19:31 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id h20-20020a170906111400b009dda94509casm1150471eja.102.2023.11.07.07.19.30
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 07 Nov 2023 07:19:31 -0800 (PST)
Date:   Tue, 7 Nov 2023 18:19:27 +0300
From:   Dan Carpenter <dan.carpenter@linaro.org>
To:     jsmart2021@gmail.com
Cc:     linux-scsi@vger.kernel.org
Subject: [bug report] scsi: lpfc: Add EDC ELS support
Message-ID: <d3e2ffd8-3ebe-4e28-8509-c76f2b991ca3@moroto.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello James Smart,

The patch 9064aeb2df8e: "scsi: lpfc: Add EDC ELS support" from Aug
16, 2021 (linux-next), leads to the following Smatch static checker
warning:

	drivers/scsi/lpfc/lpfc_els.c:4353 lpfc_issue_els_edc()
	warn: missing unwind goto?

drivers/scsi/lpfc/lpfc_els.c
    4290 int
    4291 lpfc_issue_els_edc(struct lpfc_vport *vport, uint8_t retry)
    4292 {
    4293         struct lpfc_hba  *phba = vport->phba;
    4294         struct lpfc_iocbq *elsiocb;
    4295         struct fc_els_edc *edc_req;
    4296         struct fc_tlv_desc *tlv;
    4297         u16 cmdsize;
    4298         struct lpfc_nodelist *ndlp;
    4299         u8 *pcmd = NULL;
    4300         u32 cgn_desc_size, lft_desc_size;
    4301         int rc;
    4302 
    4303         if (vport->port_type == LPFC_NPIV_PORT)
    4304                 return -EACCES;
    4305 
    4306         ndlp = lpfc_findnode_did(vport, Fabric_DID);
    4307         if (!ndlp || ndlp->nlp_state != NLP_STE_UNMAPPED_NODE)
    4308                 return -ENODEV;
    4309 
    4310         cgn_desc_size = (phba->cgn_init_reg_signal) ?
    4311                                 sizeof(struct fc_diag_cg_sig_desc) : 0;
    4312         lft_desc_size = (lpfc_link_is_lds_capable(phba)) ?
    4313                                 sizeof(struct fc_diag_lnkflt_desc) : 0;
    4314         cmdsize = cgn_desc_size + lft_desc_size;
    4315 
    4316         /* Skip EDC if no applicable descriptors */
    4317         if (!cmdsize)
    4318                 goto try_rdf;
    4319 
    4320         cmdsize += sizeof(struct fc_els_edc);
    4321         elsiocb = lpfc_prep_els_iocb(vport, 1, cmdsize, retry, ndlp,
    4322                                      ndlp->nlp_DID, ELS_CMD_EDC);
    4323         if (!elsiocb)
    4324                 goto try_rdf;
    4325 
    4326         /* Configure the payload for the supported Diagnostics capabilities. */
    4327         pcmd = (u8 *)elsiocb->cmd_dmabuf->virt;
    4328         memset(pcmd, 0, cmdsize);
    4329         edc_req = (struct fc_els_edc *)pcmd;
    4330         edc_req->desc_len = cpu_to_be32(cgn_desc_size + lft_desc_size);
    4331         edc_req->edc_cmd = ELS_EDC;
    4332         tlv = edc_req->desc;
    4333 
    4334         if (cgn_desc_size) {
    4335                 lpfc_format_edc_cgn_desc(phba, tlv);
    4336                 phba->cgn_sig_freq = lpfc_fabric_cgn_frequency;
    4337                 tlv = fc_tlv_next_desc(tlv);
    4338         }
    4339 
    4340         if (lft_desc_size)
    4341                 lpfc_format_edc_lft_desc(phba, tlv);
    4342 
    4343         lpfc_printf_vlog(vport, KERN_INFO, LOG_ELS | LOG_CGN_MGMT,
    4344                          "4623 Xmit EDC to remote "
    4345                          "NPORT x%x reg_sig x%x reg_fpin:x%x\n",
    4346                          ndlp->nlp_DID, phba->cgn_reg_signal,
    4347                          phba->cgn_reg_fpin);
    4348 
    4349         elsiocb->cmd_cmpl = lpfc_cmpl_els_disc_cmd;
    4350         elsiocb->ndlp = lpfc_nlp_get(ndlp);
    4351         if (!elsiocb->ndlp) {
    4352                 lpfc_els_free_iocb(phba, elsiocb);
--> 4353                 return -EIO;

This is a couple years old but apparently, but I've never reported it
before.  Smatch wanted a goto try_rdf; here.  Not sure if Smatch is
correct.  If not just ignore this it.  These are one time emails.

    4354         }
    4355 
    4356         lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_ELS_CMD,
    4357                               "Issue EDC:     did:x%x refcnt %d",
    4358                               ndlp->nlp_DID, kref_read(&ndlp->kref), 0);
    4359         rc = lpfc_sli_issue_iocb(phba, LPFC_ELS_RING, elsiocb, 0);
    4360         if (rc == IOCB_ERROR) {
    4361                 /* The additional lpfc_nlp_put will cause the following
    4362                  * lpfc_els_free_iocb routine to trigger the rlease of
    4363                  * the node.
    4364                  */
    4365                 lpfc_els_free_iocb(phba, elsiocb);
    4366                 lpfc_nlp_put(ndlp);
    4367                 goto try_rdf;
    4368         }
    4369         return 0;
    4370 try_rdf:
    4371         phba->cgn_reg_fpin = LPFC_CGN_FPIN_WARN | LPFC_CGN_FPIN_ALARM;
    4372         phba->cgn_reg_signal = EDC_CG_SIG_NOTSUPPORTED;
    4373         rc = lpfc_issue_els_rdf(vport, 0);
    4374         return rc;
    4375 }

regards,
dan carpenter
