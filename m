Received: from mail-wm1-f54.google.com (mail-wm1-f54.google.com [209.85.128.54])
	(using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 257E91F873D
	for <linux-scsi@vger.kernel.org>; Tue, 18 Mar 2025 09:11:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=209.85.128.54
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742289117; cv=none; b=a+VHcajNRgvyWrJafF8alZGx+xfkmN4NjqsIyZxBSVSGQalNqsssrmi2nh6F359mTZEUiPf5/4XLD2oBZxrmLEgWBGU4axb7C4FnwbHuL43iKKQUl4OrjTlmjMEb0GzYeQJ9fRXomiqWQSk0brubqsOewVflVd6hZlpJOOoSQao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742289117; c=relaxed/simple;
	bh=Dk2uzpNz+5busPHj/HO5pRzUbFqQ7Z/+RMBWW/0cZ4E=;
	h=Date:From:To:Cc:Subject:Message-ID:MIME-Version:Content-Type:
	 Content-Disposition; b=n9ybqyDUML2aP5VdPsg7jGiOMs5XMohNK5B2X/ui8nWDEM6R0E4eSaZDLX4p42HqjZEgCFe4yppr8xJKtJbcJUO6VmDU4n0PGPrNUoQEYDdDaErcfKrOrFUVv+Qs8laeQGag0K6e8o51DxXgQTAwIPqQ5y7bztXtm+mQqf64Clk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org; spf=pass smtp.mailfrom=linaro.org; dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b=m0OrK57g; arc=none smtp.client-ip=209.85.128.54
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=linaro.org
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=linaro.org
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="m0OrK57g"
Received: by mail-wm1-f54.google.com with SMTP id 5b1f17b1804b1-4394a0c65fcso28359495e9.1
        for <linux-scsi@vger.kernel.org>; Tue, 18 Mar 2025 02:11:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1742289113; x=1742893913; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=iidg/ahGOK8oeHMroDUoiPGv5XNXao3CCpycLWmOl4M=;
        b=m0OrK57g2WFWzo4vrqpl4QZEG30lT/Upb3kiRto2ujLjZuC7ibS9IGVjt7voLCeEJ7
         kf6SAv6P2iEeVf06+WeS5dxjhVUdsHALLWeMdqYGH93LNYWr4iZtuucy0VsT+50yzWRh
         4/DMuR+3FtEklLVq1V07OkBane4L2R0+rhVW53ZFmG4EOuymz2eKbUrUMlbe+Ljpx8kK
         IPqchWOjyH41AtyhuSPZQ9sBkz1hHZ/ScaXKdIHjzdFEtEGwwLGeSslfsB9Bmn7Ooiw5
         xj0o9mEgWhEr2lmH0T0VviniuYBIaFdo7ScxNgxoN+b4fN5LqPxhtfiA5ye7+gNdaLPn
         JvtA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1742289113; x=1742893913;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=iidg/ahGOK8oeHMroDUoiPGv5XNXao3CCpycLWmOl4M=;
        b=FLsR8fOo+j6Ce7BZQMcR4nsy43KunZeRTg0bsSg5BqDvSVWAcT9xbN7v6YBpo7ulXM
         mTMPikKURvqtnMAPgbIG3tnhoim4a0cV04QV0y2mhhwrRchrd81kmj1NIljsrp+KrpSD
         F7XbvdS7D1JGmFdE/+34kj5PZ293Eq70WuKAq9E9jczKU85m5q03tc2fVPCXJtE8cDDo
         xdfL2cG+hAwtA0bDZajgn2kNc0PHXJlmfgTaKtayUJCHFduhrEuXyXaZKEVTW/7JGYkH
         o9vGhtSIzZNBAZw/soWtHE5StubfIula4gumW+4VjgUiWwcJE+n6XHzbvtZMnWNTpUVe
         Ss5g==
X-Gm-Message-State: AOJu0YxDSwKXLpGRR42xm4/XCKzIhJntyguHX6XQUldbySY5A+268hv5
	szSdfvhPRTGRbKcf2RRXpeg8HpPjt8Mo+096nWHsm+OZXAhjktygjX/uXUPxKKE=
X-Gm-Gg: ASbGncvgHn9+lCJc/1JLF2FlkqKGQTbpfEuHLE2D1X0/nAeK8VHFG4cmDrbNfr2fjVf
	AhOcAwe3zaw0SVOVgMSgTJH0/jJDCWlsSklO/3HZ9ctNeX3bAo/aci1pv+r5a9nYuGMuIzLb7xP
	vCSFL4YVB2LvxSEEFKrU6LmxTkuCbKbfld820egIMTRKngPEChu3wIFEVyl0Lneok+DSlkFfs57
	vBwk02Ak8Cd0alzGEb+D61NJcCXjNC+N/rOpqMciK0ukgrcQVWi6/7JIVmuVSh2DKFNxhloKbpp
	cMCcesXSsIg5YrAo1t80lUR3wljrepVXSrK62fFDv3mJa9bFzQ==
X-Google-Smtp-Source: AGHT+IGvNYy/7xSg3SWPJUp0iXymKq+/tSy3ElsRQtZ8OUIgGC1+8jsi3Qb2xFKdSH7fhXzWc79EOA==
X-Received: by 2002:a05:600c:5116:b0:439:9a40:aa0b with SMTP id 5b1f17b1804b1-43d3ba27a5emr10449885e9.25.1742289113191;
        Tue, 18 Mar 2025 02:11:53 -0700 (PDT)
Received: from localhost ([196.207.164.177])
        by smtp.gmail.com with UTF8SMTPSA id 5b1f17b1804b1-43d33f5771dsm40016145e9.38.2025.03.18.02.11.52
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Mar 2025 02:11:52 -0700 (PDT)
Date: Tue, 18 Mar 2025 12:11:49 +0300
From: Dan Carpenter <dan.carpenter@linaro.org>
To: Justin Tee <justin.tee@broadcom.com>
Cc: linux-scsi@vger.kernel.org
Subject: [bug report] scsi: lpfc: Prevent NDLP reference count underflow in
 dev_loss_tmo callback
Message-ID: <41c1d855-9eb5-416f-ac12-8b61929201a3@stanley.mountain>
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hello Justin Tee,

Commit 4281f44ea8bf ("scsi: lpfc: Prevent NDLP reference count
underflow in dev_loss_tmo callback") from Oct 31, 2024 (linux-next),
leads to the following Smatch static checker warning:

drivers/scsi/lpfc/lpfc_hbadisc.c:220 lpfc_dev_loss_tmo_callbk() error: dereferencing freed memory 'ndlp' (line 211)

// presumably these are fine
drivers/scsi/lpfc/lpfc_els.c:1021 lpfc_cmpl_els_flogi() error: dereferencing freed memory 'ndlp' (line 1019)
drivers/scsi/lpfc/lpfc_els.c:1021 lpfc_cmpl_els_flogi() error: dereferencing freed memory 'ndlp' (line 1019)
drivers/scsi/lpfc/lpfc_els.c:4993 lpfc_els_retry() error: we previously assumed 'ndlp' could be null (see line 4970)
drivers/scsi/lpfc/lpfc_els.c:5278 lpfc_mbx_cmpl_dflt_rpi() error: dereferencing freed memory 'ndlp' (line 5277)
drivers/scsi/lpfc/lpfc_els.c:8634 lpfc_els_rsp_rls_acc() error: dereferencing freed memory 'ndlp' (line 8602)
drivers/scsi/lpfc/lpfc_nvme.c:2654 lpfc_nvme_unregister_port() error: dereferencing freed memory 'ndlp' (line 2642)
drivers/scsi/lpfc/lpfc_nportdisc.c:1875 lpfc_rcv_logo_reglogin_issue() error: dereferencing freed memory 'ndlp' (line 1867)

// this one has a comment saying it's fine
drivers/scsi/lpfc/lpfc_hbadisc.c:4335 lpfc_mbx_cmpl_ns_reg_login() error: dereferencing freed memory 'ndlp' (line 4327)

drivers/scsi/lpfc/lpfc_hbadisc.c
    156 void
    157 lpfc_dev_loss_tmo_callbk(struct fc_rport *rport)
    158 {
    159         struct lpfc_nodelist *ndlp;
    160         struct lpfc_vport *vport;
    161         struct lpfc_hba   *phba;
    162         struct lpfc_work_evt *evtp;
    163         unsigned long iflags;
    164         bool nvme_reg = false;
    165 
    166         ndlp = ((struct lpfc_rport_data *)rport->dd_data)->pnode;
    167         if (!ndlp)
    168                 return;
    169 
    170         vport = ndlp->vport;
    171         phba  = vport->phba;
    172 
    173         lpfc_debugfs_disc_trc(vport, LPFC_DISC_TRC_RPORT,
    174                 "rport devlosscb: sid:x%x did:x%x flg:x%lx",
    175                 ndlp->nlp_sid, ndlp->nlp_DID, ndlp->nlp_flag);
    176 
    177         lpfc_printf_vlog(ndlp->vport, KERN_INFO, LOG_NODE,
    178                          "3181 dev_loss_callbk x%06x, rport x%px flg x%lx "
    179                          "load_flag x%lx refcnt %u state %d xpt x%x\n",
    180                          ndlp->nlp_DID, ndlp->rport, ndlp->nlp_flag,
    181                          vport->load_flag, kref_read(&ndlp->kref),
    182                          ndlp->nlp_state, ndlp->fc4_xpt_flags);
    183 
    184         /* Don't schedule a worker thread event if the vport is going down. */
    185         if (test_bit(FC_UNLOADING, &vport->load_flag) ||
    186             !test_bit(HBA_SETUP, &phba->hba_flag)) {
    187 
    188                 spin_lock_irqsave(&ndlp->lock, iflags);
    189                 ndlp->rport = NULL;
    190 
    191                 if (ndlp->fc4_xpt_flags & NVME_XPT_REGD)
    192                         nvme_reg = true;
    193 
    194                 /* The scsi_transport is done with the rport so lpfc cannot
    195                  * call to unregister.
    196                  */
    197                 if (ndlp->fc4_xpt_flags & SCSI_XPT_REGD) {
    198                         ndlp->fc4_xpt_flags &= ~SCSI_XPT_REGD;
    199 
    200                         /* If NLP_XPT_REGD was cleared in lpfc_nlp_unreg_node,
    201                          * unregister calls were made to the scsi and nvme
    202                          * transports and refcnt was already decremented. Clear
    203                          * the NLP_XPT_REGD flag only if the NVME Rport is
    204                          * confirmed unregistered.
    205                          */
    206                         if (!nvme_reg && ndlp->fc4_xpt_flags & NLP_XPT_REGD) {
    207                                 ndlp->fc4_xpt_flags &= ~NLP_XPT_REGD;
    208                                 spin_unlock_irqrestore(&ndlp->lock, iflags);
    209                                 lpfc_nlp_put(ndlp); /* may free ndlp */

If nvme_reg is false then sometimes we free ndlp.  I would normally
ignore this warning because obviously the code is doing something
subtle, but there is a comment which says that it does free ndlp.

    210                         } else {
    211                                 spin_unlock_irqrestore(&ndlp->lock, iflags);
    212                         }
    213                 } else {
    214                         spin_unlock_irqrestore(&ndlp->lock, iflags);
    215                 }
    216 
    217                 /* Only 1 thread can drop the initial node reference.  If
    218                  * another thread has set NLP_DROPPED, this thread is done.
    219                  */
--> 220                 if (nvme_reg || test_bit(NLP_DROPPED, &ndlp->nlp_flag))
                                                               ^^^^
Here we know nvme_reg is false but we're still dereferencing "ndlp".

    221                         return;
    222 
    223                 set_bit(NLP_DROPPED, &ndlp->nlp_flag);
                                              ^^^^
Here nvme_reg is false again but this is even more dereferencing.

    224                 lpfc_nlp_put(ndlp);
                                     ^^^^
And here.

    225                 return;
    226         }
    227 

regards,
dan carpenter
