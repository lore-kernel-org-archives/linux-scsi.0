Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0C3AC433EF
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Sep 2021 00:39:22 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C812561130
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Sep 2021 00:39:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237513AbhIHAk3 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 7 Sep 2021 20:40:29 -0400
Received: from wout4-smtp.messagingengine.com ([64.147.123.20]:49403 "EHLO
        wout4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229946AbhIHAk2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 7 Sep 2021 20:40:28 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailout.west.internal (Postfix) with ESMTP id C6D05320039A;
        Tue,  7 Sep 2021 20:39:20 -0400 (EDT)
Received: from mailfrontend1 ([10.202.2.162])
  by compute6.internal (MEProxy); Tue, 07 Sep 2021 20:39:21 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=ufRYoz
        2yVgifzFCVqXXScN8SZHhn8AKyavF52/GWzZk=; b=my40rX8YEk4InKqnX58Prr
        w/GUcvRDjwmOSGHG4C1TDYfbjBQtAF8M0JOKQqfja/+VCwYcAKGB5HItJOpvjGFF
        LLWQOuGWp3rbZAQ42cFxrxoU6Hu4Bdi6TCs08kjK4KQrb385Zf4vqEIcKv4BcKht
        V9YANa8ZMRmKPyJ5UlDrr22c2hi7szMYuqZhs8eR5/qi51A2AYyff2HEXUtbveOh
        l+R3Z/qIaRci6Q82YDEqmzND6RIPSdlpQg44ZvWdYj1lThHOG+Y/R+5nk1GGm6H/
        H5hTNPfi4QjxdeDgS0Pm4B9r457PvcKTmhJMuoam9/GyP5YDQmyzrml9IJB+zwyw
        ==
X-ME-Sender: <xms:NgY4YSdYg_f6UNp5_DDyvKm3NxEDY_cEdqdWZ29I7xb3hWO18O2JWg>
    <xme:NgY4YcOuCcLlyCgBPyZGuctsJIl-7IKMY8LD30NvwITIl80YOpNsZ_YhyOj0ZlaiK
    gWvjtmx5nImyyNMIYA>
X-ME-Received: <xmr:NgY4YTjzRn5Ap1yztHPgmWcuc9oRMbuzljVvZW1wNG_cqiJ0vumj3RcT8RPDW98YpONEkauW6OWsmoB-q4XZr_9kdYAm0UfI4VRGYw>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrudefiedgfeegucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffujgfkfhggtgesthdtredttddtvdenucfhrhhomhephfhinhhnucfv
    hhgrihhnuceofhhthhgrihhnsehlihhnuhigqdhmieekkhdrohhrgheqnecuggftrfgrth
    htvghrnhepffduhfegfedvieetudfgleeugeehkeekfeevfffhieevteelvdfhtdevffet
    uedunecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepfh
    hthhgrihhnsehlihhnuhigqdhmieekkhdrohhrgh
X-ME-Proxy: <xmx:NgY4Yf9KPY-C_Qmd-uFSR3zz5yXMIdLe6aZta_3CdDCxva1HeA_HOg>
    <xmx:NgY4YevM0Y-V89BcwgQX8NhUSaT7RF80O2I1yL_SJ5F80_SozhsrvA>
    <xmx:NgY4YWH--e23TLlcczqUf4hogjQyfx3A3Hdo3HCq5BkDtFotuV3mOQ>
    <xmx:OAY4YSgVIxwsjYdS0wfOaIctzfRaIyUzglxO2x04XJr6akZCv2iBKA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 7 Sep 2021 20:39:16 -0400 (EDT)
Date:   Wed, 8 Sep 2021 10:39:10 +1000 (AEST)
From:   Finn Thain <fthain@linux-m68k.org>
To:     Tong Zhang <ztong0001@gmail.com>
cc:     Oliver Neukum <oliver@neukum.org>, Ali Akcaagac <aliakc@web.de>,
        Jamie Lenehan <lenehan@twibble.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        dc395x@twibble.org, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v1] scsi: dc395: fix error case unwinding
In-Reply-To: <20210907040702.1846409-1-ztong0001@gmail.com>
Message-ID: <eb4f2f15-dab8-16da-4fe6-ae90638018e1@linux-m68k.org>
References: <20210907040702.1846409-1-ztong0001@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


According to Documentation/process/submitting-patches.rst
it would be appropriate to put "RESEND" in the subject line.
