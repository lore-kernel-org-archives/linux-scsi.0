Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82504C433E0
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Feb 2021 08:17:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 3CC7F64E7D
	for <linux-scsi@archiver.kernel.org>; Mon,  8 Feb 2021 08:17:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229839AbhBHIRY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 8 Feb 2021 03:17:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229788AbhBHIRO (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 8 Feb 2021 03:17:14 -0500
Received: from mail-ej1-x633.google.com (mail-ej1-x633.google.com [IPv6:2a00:1450:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5A369C06174A;
        Mon,  8 Feb 2021 00:16:33 -0800 (PST)
Received: by mail-ej1-x633.google.com with SMTP id a9so23188779ejr.2;
        Mon, 08 Feb 2021 00:16:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ZtADIpfnICWUoMJy2Q5wzROr8VGk0ZeRS5CXLMvKEiI=;
        b=q6Ct2Hw49C/Gi/XBddTjzvI6+g3zTEzJ/tOklEgaB7XAPuN5uAGvvw4JAmmZy6+h+9
         IfiDzwKA5XKV6ih734vzJ0SdkJgCKgQg+PyhOpnymFLaO+ruu+60u3YrcUIKicsb8yOh
         CUrCK8N+MTu1s2kjFUZTlmGQrGKzR9HGIfI828C13cFkujC56GgyXoU5MA9VFLKv73mQ
         aumALtXRGK2LNZb0McRIPOX1UKj04a78SzgzVruprBFc5JVv3VNu+E5nNWHW1O0loShk
         jbenK27DrZdxAcDpg74e7jY6WPhtt9c35bWo0hqEAtr6I51ijAUsrgRk1aAFqBDRnd1N
         dwUQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ZtADIpfnICWUoMJy2Q5wzROr8VGk0ZeRS5CXLMvKEiI=;
        b=OapvHWSNOZFVgcMApWKx0bqMygY0v+MHb+1pBxCnZ7YvyC0jkfmrOEy63sPangypwC
         aaGvc6ixTRLnT03UFXhNQBNCwsaFh6DiMrmzxZqIwKGv/0IhryFtFpTN7QUd7FAAf6cI
         9pduOmJ9dMsXw9kio1z5tohPxoEci44Gim2WJ+Ib+OV2ZAkR4bSiEd3Q+bt/iJvi29Jw
         JWjiteXQ9oQ5yAhNUz2Z1F9uBnd0zUsp/V0w3f08pIJZ0FS5igjw0ZDj+V16IPDLR/1N
         kB8pI7XGvCuP+U9ByJOEhrnlZLgQJwaRqDyAnMhwWi2Ya5UnhrRmgdVbANKKwglWW2jR
         oYOw==
X-Gm-Message-State: AOAM532GI8OxObm73lDaXbMumMioUAWhmFD4JiQ9YO5FU7gRb2xc8TYV
        gg2NVTmDyzpo8QAm3lG3Ubk=
X-Google-Smtp-Source: ABdhPJya38KqXNtYb4hb+bAC6ShydKxjwHtMoJ4lhRaKi/mJnvu3DMbpVLAcBxgDXdUAqKll0RfaEA==
X-Received: by 2002:a17:906:d93:: with SMTP id m19mr15572426eji.212.1612772192123;
        Mon, 08 Feb 2021 00:16:32 -0800 (PST)
Received: from ubuntu-laptop (ip5f5bee1b.dynamic.kabel-deutschland.de. [95.91.238.27])
        by smtp.googlemail.com with ESMTPSA id mh4sm5372912ejb.122.2021.02.08.00.16.30
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Mon, 08 Feb 2021 00:16:31 -0800 (PST)
Message-ID: <a95af313ee4dfb7173b0c5a23b52d2168a94f87a.camel@gmail.com>
Subject: Re: [PATCH v19 3/3] scsi: ufs: Prepare HPB read for cached
 sub-region
From:   Bean Huo <huobean@gmail.com>
To:     Can Guo <cang@codeaurora.org>, daejun7.park@samsung.com
Cc:     Greg KH <gregkh@linuxfoundation.org>, avri.altman@wdc.com,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        asutoshd@codeaurora.org, stanley.chu@mediatek.com,
        bvanassche@acm.org, ALIM AKHTAR <alim.akhtar@samsung.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>
Date:   Mon, 08 Feb 2021 09:16:29 +0100
In-Reply-To: <7f25ccb1d857131baa1c0424c4542e33@codeaurora.org>
References: <20210129052848epcms2p6e5797efd94e6282b76ad9ae6c99e3ab5@epcms2p6>
         <CGME20210129052848epcms2p6e5797efd94e6282b76ad9ae6c99e3ab5@epcms2p5>
         <20210129053042epcms2p538e7fa396c3c2104594c44e48be53eb8@epcms2p5>
         <7f25ccb1d857131baa1c0424c4542e33@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, 2021-02-05 at 11:29 +0800, Can Guo wrote:
> > +     return ppn_table[offset];
> > +}
> > +
> > +static void
> > +ufshpb_get_pos_from_lpn(struct ufshpb_lu *hpb, unsigned long lpn,
> > int 
> > *rgn_idx,
> > +                     int *srgn_idx, int *offset)
> > +{
> > +     int rgn_offset;
> > +
> > +     *rgn_idx = lpn >> hpb->entries_per_rgn_shift;
> > +     rgn_offset = lpn & hpb->entries_per_rgn_mask;
> > +     *srgn_idx = rgn_offset >> hpb->entries_per_srgn_shift;
> > +     *offset = rgn_offset & hpb->entries_per_srgn_mask;
> > +}
> > +
> > +static void
> > +ufshpb_set_hpb_read_to_upiu(struct ufshpb_lu *hpb, struct
> > ufshcd_lrb 
> > *lrbp,
> > +                               u32 lpn, u64 ppn,  unsigned int
> > transfer_len)
> > +{
> > +     unsigned char *cdb = lrbp->cmd->cmnd;
> > +
> > +     cdb[0] = UFSHPB_READ;
> > +
> > +     put_unaligned_be64(ppn, &cdb[6]);
> 
> You are assuming the HPB entries read out by "HPB Read Buffer" cmd
> are 
> in Little
> Endian, which is why you are using put_unaligned_be64 here. 
> 


Actaully, here uses put_unaligned_be64 is no problem. SCSI command
should be big-endian filled. I Think the problem is that geting ppn
from HPB cache in ufshpb_get_ppn().

...
e0000001f: 12 34 56 78 90 fa de ef
...

+
+static u64 ufshpb_get_ppn(struct ufshpb_lu *hpb,
+			  struct ufshpb_map_ctx *mctx, int pos, int
*error)
+{
+	u64 *ppn_table;  // It s a 64 bits pointer
+	struct page *page;
+	int index, offset;
+
+	index = pos / (PAGE_SIZE / HPB_ENTRY_SIZE);
+	offset = pos % (PAGE_SIZE / HPB_ENTRY_SIZE);
+
+	page = mctx->m_page[index];
+	if (unlikely(!page)) {
+		*error = -ENOMEM;
+		dev_err(&hpb->sdev_ufs_lu->sdev_dev,
+			"error. cannot find page in mctx\n");
+		return 0;
+	}
+
+	ppn_table = page_address(page);
+	if (unlikely(!ppn_table)) {
+		*error = -ENOMEM;
+		dev_err(&hpb->sdev_ufs_lu->sdev_dev,
+			"error. cannot get ppn_table\n");
+		return 0;
+	}
+
+	return ppn_table[offset];
+}




> this assumption
> is not right for all the other flash vendors - HPB entries read out
> by 
> "HPB Read Buffer"
> cmd may come in Big Endian, if so, their random read performance are 
> screwed.
> Actually, I have seen at least two flash vendors acting so. I had to 
> modify this line
> to get the code work properly on my setups.
> 
> Meanwhile, in your cover letter, you mentioned that the performance
> data 
> is collected
> on a UFS2.1 device. Please re-collect the data on a real UFS3.1
> device 
> and let me
> know the part number. Otherwise, the data is not quite convincing to
> us.
> 
> Regards,
> Can Guo.

