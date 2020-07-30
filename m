Return-Path: <SRS0=dYxQ=BJ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C6395C433E1
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Jul 2020 10:23:30 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 985B72082E
	for <linux-scsi@archiver.kernel.org>; Thu, 30 Jul 2020 10:23:30 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SgqlNcWC"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729242AbgG3KX1 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 30 Jul 2020 06:23:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45504 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726883AbgG3KX1 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 30 Jul 2020 06:23:27 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D974C061794;
        Thu, 30 Jul 2020 03:23:27 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id lx9so4087556pjb.2;
        Thu, 30 Jul 2020 03:23:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=1TfTR8Lp7hRKQ+lCxjn1lE5hq4Qzl/G7eGSS/NXpthA=;
        b=SgqlNcWCpJUaLfLBwM02ixJFhCj4xCMvydh2bBlK+bU/6gsSrxVBlDeQqW3sdpjcpS
         ql2RfXZF+/z5wYVZ/ajCmbuaaYFwlDRoMtZsfGOq3ojCNjBipuSwC7sM6Sj3sCmgibUy
         6BA1LRisHrKgr+FDYaXgEvwAWX/59rj6nrI4DMNiJUwnbpIkbnwIUuhGUy1YWZOSTkbS
         FOEeO5IMRy4z9Hlf2JoxUR9CVT+A55JjHX/Oyc33st0X9JSzbbb6+JGByea1m2/gSgm7
         GEdwEooCZDqwu105hUNFFh5ZydPXtdoPyVxaHrr8C+PY5wnMAxmbX09kBmVoO7Edp0oa
         fH9w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=1TfTR8Lp7hRKQ+lCxjn1lE5hq4Qzl/G7eGSS/NXpthA=;
        b=bl4T4JIGxc8FFddlToWFW85vudh+QQeQN4poMPwo09PZjUKXY3rE2mo6wEEHUDkOVi
         mIst3Gfm2UYzA4UAVcehh3+Qs25yE6wUyIm4R58RgalMnpNsHpzi0xBKaaK5TWFlnG9N
         /6buocrWjp6rimlYHvLSntGvsGI6+SgdY7AHRZBu17mxOsKPrPV8F+0dXJyZNwdj/Idv
         1T5ZdDpcm2FUpAviqOmvtXh3rkT5mu8GLszGCn7VSvONewmpW0IdeDINQx+VLd9NBc7u
         RwAtVQ5M94yy6vCXupOvCnGPqX7ymc8YvBX1ao3eLQbCMp2ZDaCqKkC6I5FWsmGoGxZL
         kXKg==
X-Gm-Message-State: AOAM530xTT1ygyhLjiutS9N9RR48LPFZC1hBNyI2elKLHOpVadd0hwTc
        qQOzursp/VBEPMYFZxguGJA=
X-Google-Smtp-Source: ABdhPJwtUE3R0FEcG2no1f+PaKbEvfyDitIH4cyALH9m+3bRtaBL1KTwLLao4m/kkUElXedWB7iaRQ==
X-Received: by 2002:aa7:91cd:: with SMTP id z13mr2664104pfa.133.1596104605709;
        Thu, 30 Jul 2020 03:23:25 -0700 (PDT)
Received: from gmail.com ([103.105.152.86])
        by smtp.gmail.com with ESMTPSA id t28sm2507739pgn.81.2020.07.30.03.23.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 30 Jul 2020 03:23:25 -0700 (PDT)
Date:   Thu, 30 Jul 2020 15:51:59 +0530
From:   Vaibhav Gupta <vaibhavgupta40@gmail.com>
To:     Bjorn Helgaas <helgaas@kernel.org>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Bjorn Helgaas <bjorn@helgaas.com>,
        Vaibhav Gupta <vaibhav.varodek@gmail.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Shuah Khan <skhan@linuxfoundation.org>
Subject: Re: [PATCH v2] scsi: stex: use generic power management
Message-ID: <20200730102159.GA595053@gmail.com>
References: <20200730101658.576205-1-vaibhavgupta40@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20200730101658.576205-1-vaibhavgupta40@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

The patch is compile-tested only.

Thanks
Vaibhav Gupta
