Return-Path: <SRS0=K+7G=YL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EBF2CA9EA0
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Oct 2019 21:45:31 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2F28421925
	for <linux-scsi@archiver.kernel.org>; Fri, 18 Oct 2019 21:45:31 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="QjZsYhpU"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505685AbfJRVpa (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 18 Oct 2019 17:45:30 -0400
Received: from mail-pg1-f196.google.com ([209.85.215.196]:45341 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503048AbfJRVpa (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 18 Oct 2019 17:45:30 -0400
Received: by mail-pg1-f196.google.com with SMTP id r1so4035528pgj.12
        for <linux-scsi@vger.kernel.org>; Fri, 18 Oct 2019 14:45:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=qcE5KhfpQ4NQbD/twtaTD/BxOHqJos9I+trErW0JNF4=;
        b=QjZsYhpUxEaRSHj9jcHhoBzjjM3Mb7b9Ie94VssK0xtt6gci+Wp5FQWj4nc0ZGIi5x
         hydrbUBrpMsnnNI11flAO99jX9lnyRLEaORGZtZ0gLdLcsg2tBVummd1ULTPRJ/JpYIo
         DBriQJMtiM6jddHCsAObBmnABcXtTVvkyXGd8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=qcE5KhfpQ4NQbD/twtaTD/BxOHqJos9I+trErW0JNF4=;
        b=f+dWTAh0QWTvngMPsw4/sV7+REG3z9jTYKmnL4gCgkq+8OfogEvo0/r4kvCy8QKCpH
         IbmgBjRiTcTeP6wzXmWk6YyLWb+02pr9v1/dAiA8/oV78oWejlJNSn8ZgVn37EfooBk4
         K81ZR+yA0DW1fSFXJrfSrWRuBSdBMH/awjs73iqwacN92jPaYHo7La63JkXKL20+/N2H
         K7FfKiiC72nFq+ngDSyCKPOZHwyUknRWwIlOt2nQc2Ap6k283B67uCYjaIp6jjZX/0tK
         EPFj3WtAXg/djgbudcTkyHFbdIhqUUNAo6iTHuFDbYND9e07AggpkklI85ol03OLLyW+
         2npw==
X-Gm-Message-State: APjAAAVjoyGhAe1oM8Z7d8+ypxcfA7A1Q45rtlZuYiQPQ1g9v8rrAMhw
        p1E4qe4OI4XmoNMHlB8Waxq63kBEEAg=
X-Google-Smtp-Source: APXvYqyNIzyN/twh3somuhGuev4cQL74ZCp+7iw2J8fRZidB0noAMVpwV5TxEMlTLr+jTVsUwPtXSA==
X-Received: by 2002:a17:90a:234d:: with SMTP id f71mr13755557pje.134.1571435129769;
        Fri, 18 Oct 2019 14:45:29 -0700 (PDT)
Received: from [10.69.45.46] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id y144sm8065816pfb.188.2019.10.18.14.45.26
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 18 Oct 2019 14:45:28 -0700 (PDT)
Subject: Re: [RFC PATCH 0/3] lpfc: nodelist pointer cleanup
To:     Hannes Reinecke <hare@suse.de>
Cc:     Dick Kennedy <dick.kennedy@broadcom.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org, James Smart <james.smart@broadcom.com>
References: <20191018075010.55653-1-hare@suse.de>
From:   James Smart <james.smart@broadcom.com>
Message-ID: <ced4e239-40b2-508a-f52a-1b7baf674f04@broadcom.com>
Date:   Fri, 18 Oct 2019 14:45:24 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <20191018075010.55653-1-hare@suse.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/18/2019 12:50 AM, Hannes Reinecke wrote:
> Hi James,
>
> trying to figure this annoying lpfc_set_rrq_active() bug
> I've found the nodelist pointer handling in the lpfc io buffers
> a bit strange; there's a 'ndlp' pointer, but for scsi the nodelist
> is primarily accessed via the 'rdata' pointer (although not everywhere).
> For NVMe it's primarily the 'ndlp' pointer, apparently, but the
> usage is quite confusing.
> So here's a patchset to straighten things up; it primarily moves
> the anonymous protocol-specific structure in the io buffer to a named
> one, and always accesses the nodelist through the protocol-specific
> rport data structure.
>
> It also has the nice side-effect that the protocol-specific areas are
> aligned now, so clearing the 'rdata' pointer on the scsi side will
> be equivalent to clearing the 'rport' pointer on the nvme side.
> And it reduces the size of the io buffer.
>
> Let me know what you think.
>
> Hannes Reinecke (3):
>    lpfc: use named structure for combined I/O buffer
>    lpfc: access nodelist through scsi-specific rdata pointer
>    lpfc: access nvme nodelist through nvme rport structure
>
>   drivers/scsi/lpfc/lpfc_init.c |   2 +-
>   drivers/scsi/lpfc/lpfc_nvme.c |  56 ++++++------
>   drivers/scsi/lpfc/lpfc_scsi.c | 196 +++++++++++++++++++++---------------------
>   drivers/scsi/lpfc/lpfc_sli.c  |  26 +++---
>   drivers/scsi/lpfc/lpfc_sli.h  |   6 +-
>   5 files changed, 143 insertions(+), 143 deletions(-)
>

Well, the problem I think you are trying to solve is ultimately the root 
issue that is solved by this patch in the just-posted 12.6.0.0 patch set:
[PATCH 05/16] lpfc: Fix bad ndlp ptr in xri aborted handling

As such, I'd like to see if the 12.6.0.0 patch resolves the issue before 
going through all the shifting in your patches.
Note: the failing routine can change as it's totally dependent on where 
the bogus pointer value takes you.  The key is the 
lpfc_sli4_sp_handle_abort_xri_wcqe() routine on the stack.

-- james

