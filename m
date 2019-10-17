Return-Path: <SRS0=lSD6=YK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D9771FA3733
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Oct 2019 11:36:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id AFCD121848
	for <linux-scsi@archiver.kernel.org>; Thu, 17 Oct 2019 11:36:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=lca.pw header.i=@lca.pw header.b="inLSz4cP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2409212AbfJQLgx (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 17 Oct 2019 07:36:53 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:40197 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405493AbfJQLgx (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 17 Oct 2019 07:36:53 -0400
Received: by mail-qk1-f193.google.com with SMTP id y144so1503453qkb.7
        for <linux-scsi@vger.kernel.org>; Thu, 17 Oct 2019 04:36:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=lca.pw; s=google;
        h=content-transfer-encoding:from:mime-version:subject:date:message-id
         :references:cc:in-reply-to:to;
        bh=8/Lz6l8sQ6PNj+KFicIECgEvYNy1usZIJng2CZIsbQg=;
        b=inLSz4cPMI+GJ9z0YEfQf9RIV4d9DhKHvhpv9tRsAhG8lBPHCahDt7L4dZdCUDpNT3
         V0qQsIIWtsi1zCvqA2zEvouImw2pz4PKQq7hNViCPYJJovM/WhPMwRFyY2ASg8xwBJ9e
         3W7+KJNGsqtkQD7da4idydHyGxNm4S89TLBE1EO5Nsrb7rxQFLv7OHaNsX/MyjrqvoQf
         sm4KR/GZnvc1LUVfYS7OZDzwz3t4PvX1fBGcOPD7sxVYWgEMvd2t+Q5JPWvhC3dGKSBs
         ZmiLjM0dWcfgsG936+m01CkzNYi/KsWTeJ9XauEjKWmMjpkupFQQrtOUJwu1GXjwYO4O
         E4Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:content-transfer-encoding:from:mime-version
         :subject:date:message-id:references:cc:in-reply-to:to;
        bh=8/Lz6l8sQ6PNj+KFicIECgEvYNy1usZIJng2CZIsbQg=;
        b=RkWiCIC+0CMUxxBIpX41sXvAcD+X0uBMmi4MUTSf5bBrqGwU6PaIZLkPTjqQcINTeL
         idbgXtE9L3Kuqc1WBZ6wTjxAF/Qu+5v/utpSDxsHXlahUI3+xXYAex4BLuiVzQOLRton
         c1xSQwaz1BXV4BMFBaa4VKnjaPh/Iv/bBDcUxyzR1NqLQskfnBBnH3QRZU8V+xT3WYQg
         NOjlv/iliZQEnOID9eh0j71zA0DkFm3su4rc31fMJ05W0Kp4z8/XV65arxJ4czV5TtoS
         hcbDWkN2BoSrsnJvRUi6Qde2cDxCLYWNrCgBjNndtThr6741ENG/zbgPG8lBxEcw35IN
         TrQA==
X-Gm-Message-State: APjAAAXG6ygaJBlFawdA6qnUHWA1x+gpeVEdsINUyM9W5r+Sj4ZLojSi
        ITE7mBLAI2YFt85f8J/9sBkyZQ==
X-Google-Smtp-Source: APXvYqxdX0AeuN/dq2A2s87VdUR+xtxVcyeC34SKMarZg2FnGvyBY3fPdW9PrLgHFt8PN82r/JKQvw==
X-Received: by 2002:a37:68a:: with SMTP id 132mr2773971qkg.359.1571312212534;
        Thu, 17 Oct 2019 04:36:52 -0700 (PDT)
Received: from [192.168.1.183] (pool-71-184-117-43.bstnma.fios.verizon.net. [71.184.117.43])
        by smtp.gmail.com with ESMTPSA id c6sm1631979qtc.83.2019.10.17.04.36.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 17 Oct 2019 04:36:51 -0700 (PDT)
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: quoted-printable
From:   Qian Cai <cai@lca.pw>
Mime-Version: 1.0 (1.0)
Subject: Re: [PATCH -next] iommu/amd: fix a warning in increase_address_space
Date:   Thu, 17 Oct 2019 07:36:51 -0400
Message-Id: <577A2A6B-3012-4CDE-BE57-3E0D628572CB@lca.pw>
References: <20191016225859.j3jq6pt73mn56chn@cantor>
Cc:     jroedel@suse.de, don.brace@microsemi.com,
        martin.petersen@oracle.com, linux-scsi@vger.kernel.org,
        jejb@linux.ibm.com, esc.storagedev@microsemi.com,
        linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org
In-Reply-To: <20191016225859.j3jq6pt73mn56chn@cantor>
To:     Jerry Snitselaar <jsnitsel@redhat.com>
X-Mailer: iPhone Mail (17A878)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org



> On Oct 16, 2019, at 6:59 PM, Jerry Snitselaar <jsnitsel@redhat.com> wrote:=

>=20
> I guess the mode level 6 check is really for other potential callers
> increase_address_space, none exist at the moment, and the condition
> of the while loop in alloc_pte should fail if the mode level is 6.

Because there is no locking around iommu_map_page(), if there are several co=
ncurrent callers of it for the same domain, could it be that it silently cor=
rupt data due to invalid access?=
