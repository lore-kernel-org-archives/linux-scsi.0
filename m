Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2781BC4361B
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 17:56:35 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EFF1B2376F
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Dec 2020 17:56:34 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726184AbgLGR4B (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Dec 2020 12:56:01 -0500
Received: from new4-smtp.messagingengine.com ([66.111.4.230]:50459 "EHLO
        new4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725901AbgLGR4B (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 7 Dec 2020 12:56:01 -0500
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailnew.nyi.internal (Postfix) with ESMTP id C8579580426;
        Mon,  7 Dec 2020 12:55:14 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 07 Dec 2020 12:55:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kroah.com; h=
        date:from:to:cc:subject:message-id:references:mime-version
        :content-type:in-reply-to; s=fm2; bh=VRVtGXoQD9AI9Ni8bRVQ2nQ4sFY
        cJwVAKfRYupJxLUU=; b=IawfgYm7t8a+rzgPkZs+TijYsyyYF7Gr2rn4rDgLHdz
        s/1hEYdHxh2IyNq67QXPQLZj9CABug1lp8Y1kHEujWr9Lin4R4x2wSRXj4wiShcy
        A7FPkTQjT19spRBKAYNaH8zWRovXiHq3daNrhB0CL9ZR6OAIrRviOCuP4ESg/DpZ
        /BG/+OCxVcVYbrL9cW28MNZUIwfdHxQv0r0N/EpC551j1UL5iydy9c9zJ0j8mDay
        hmrgmWFMCZVv2aLVIUK5+2mIREqtoY8eUZh+sFTdBsJOEs5LuRvMPFW5fcD6uG4t
        kru7x4Z6G/rLjrCVZVlNGhD5Yq621/oQg97dVR/MO5A==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm1; bh=VRVtGX
        oQD9AI9Ni8bRVQ2nQ4sFYcJwVAKfRYupJxLUU=; b=oRXmzuaCpxxEB9PiGf1WDg
        2c2tTSUo1kKPSt2SO3wD4PejasA7zEhFsl/Z5Iib7wPy7kade647AqsU2BsnyJo1
        c6vez71oIiQIr4oqbo1mlHMWXINO0Iy060vmtZPnrp1vp3UVl+Q+h12sSGx8M7pf
        6gEo/zrx41frl+ZXY3F9VAs40XJ6z+HHiIz3nm2Ccx5nl7LUfg3ApsOtbgP1Ymkw
        x7eE2YgBr/4NpQ5Zd0nLzLI2DEs4zSXbuSJurvHOPlUQbVanzJokuixmZ0zS3SHK
        U2alnv6ZHiNOg2hR/mt8ZiaY6kYvwuwe5B/uH12MwXL6M5yHIK6Z047SZmiEw9iw
        ==
X-ME-Sender: <xms:gWzOXxBK0R4ipC7ydV5qfprCeTWcVqD_wx-V9aF6m8zD88ZYZo_vSg>
    <xme:gWzOX_gEXZY0jJbg63OSyGoXXa9Eri_ouIZyk37sZZZj0LR40_-89O2OkGSg085EZ
    3NcV9I88B4XVQ>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedujedrudejgedguddthecutefuodetggdotefrod
    ftvfcurfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfgh
    necuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
    enucfjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepifhrvghg
    ucfmjfcuoehgrhgvgheskhhrohgrhhdrtghomheqnecuggftrfgrthhtvghrnhepveeuhe
    ejgfffgfeivddukedvkedtleelleeghfeljeeiueeggeevueduudekvdetnecukfhppeek
    fedrkeeirdejgedrieegnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrg
    hilhhfrhhomhepghhrvghgsehkrhhorghhrdgtohhm
X-ME-Proxy: <xmx:gWzOX8lFEjRDhrCLqfnrmNWzjTBOf59et1G9XkvZ-Fwo7aoUtP7jLQ>
    <xmx:gWzOX7y4qX63EIfhVNefx0-0DrYdIxPTiavQWBCgwR0173GIMCHhkQ>
    <xmx:gWzOX2RU0Puw7z8MYrig2DE_y1SUS-mH06JENVgxfCRj5lqA80y2UA>
    <xmx:gmzOX3I9ZCp_YZf-anQaOdcLskuV6UfLUy-AK67LXRnEdy6NB1LMsw>
Received: from localhost (83-86-74-64.cable.dynamic.v4.ziggo.nl [83.86.74.64])
        by mail.messagingengine.com (Postfix) with ESMTPA id 0A87C24005B;
        Mon,  7 Dec 2020 12:55:13 -0500 (EST)
Date:   Mon, 7 Dec 2020 18:56:23 +0100
From:   Greg KH <greg@kroah.com>
To:     Daejun Park <daejun7.park@samsung.com>
Cc:     "avri.altman@wdc.com" <avri.altman@wdc.com>,
        "jejb@linux.ibm.com" <jejb@linux.ibm.com>,
        "martin.petersen@oracle.com" <martin.petersen@oracle.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        "beanhuo@micron.com" <beanhuo@micron.com>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "bvanassche@acm.org" <bvanassche@acm.org>,
        "tomas.winkler@intel.com" <tomas.winkler@intel.com>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "gregkh@google.com" <gregkh@google.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Sang-yoon Oh <sangyoon.oh@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        yongmyung lee <ymhungry.lee@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>,
        SEUNGUK SHIN <seunguk.shin@samsung.com>
Subject: Re: [PATCH v13 0/3] scsi: ufs: Add Host Performance Booster Support
Message-ID: <X85sxxgpdtFXiKsg@kroah.com>
References: <CGME20201103044021epcms2p8f1556853fc23414442b9e958f20781ce@epcms2p8>
 <2038148563.21604378702426.JavaMail.epsvc@epcpadp3>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2038148563.21604378702426.JavaMail.epsvc@epcpadp3>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Nov 03, 2020 at 01:40:21PM +0900, Daejun Park wrote:
> Changelog:
> 
> v12 -> v13
> 1. Cleanup codes by comments from Can Guo.
> 2. Add HPB related descriptor/flag/attributes in sysfs.
> 3. Change base commit from 5.10/scsi-queue to 5.11/scsi-queue.

What ever happened to this patchset?  Did it get merged into a scsi tree
for 5.11-rc1, or is there something still pending that needs to be done
on it to make it acceptable?

thanks,

greg k-h
