Return-Path: <SRS0=Yj8A=7C=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67854C433DF
	for <linux-scsi@archiver.kernel.org>; Wed, 20 May 2020 17:56:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 33C17204EF
	for <linux-scsi@archiver.kernel.org>; Wed, 20 May 2020 17:56:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="AsjQ2Q0X"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726775AbgETR4E (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 20 May 2020 13:56:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60434 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726576AbgETR4D (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 20 May 2020 13:56:03 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D48B1C061A0E;
        Wed, 20 May 2020 10:56:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=4Am3TfCV9FAMwHU97EGrfWs3Wf0K8DZDEI58r+TwL5Q=; b=AsjQ2Q0XLd+qkzPdxqGGc0Wzxv
        gcVC7Y+3vxkTI6lT8c6eYvH/RdOZCJXPBCEbAwhv15VXN7iLfgkChlmSdsMOU9uO2jJUAX4pUO3Z1
        BEDsSfENhTS7VRbNIqWT09DEBtWNZzqCcnv895v0/3qTo6f8oDGwevgZ5ZYSPHsnAMSnOzvJPDWGj
        BwfFOFbL5NAwRTibe5fKVzAEXkJoGpVH/7unEe2Jjom6Bc9jOmJ9Hfmu+I54gDk33cRMCs43N3VTE
        8QKc/l/QhwLBMYrSU8qAIGik1ZCclU74FdxROtbitNMN4pzWGw+zT6eyBMdUNG5Lg/L0tCiTNfFPi
        msogt3kA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jbSwd-0003Jq-4U; Wed, 20 May 2020 17:55:55 +0000
Date:   Wed, 20 May 2020 10:55:55 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     yongmyung lee <ymhungry.lee@samsung.com>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Avri Altman <Avri.Altman@wdc.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ALIM AKHTAR <alim.akhtar@samsung.com>,
        "asutoshd@codeaurora.org" <asutoshd@codeaurora.org>,
        Zang Leigang <zangleigang@hisilicon.com>,
        Avi Shchislowski <Avi.Shchislowski@wdc.com>,
        Bean Huo <beanhuo@micron.com>,
        "cang@codeaurora.org" <cang@codeaurora.org>,
        "stanley.chu@mediatek.com" <stanley.chu@mediatek.com>,
        MOHAMMED RAFIQ KAMAL BASHA <md.rafiq@samsung.com>,
        Sang-yoon Oh <sangyoon.oh@samsung.com>,
        Jinyoung CHOI <j-young.choi@samsung.com>,
        Adel Choi <adel.choi@samsung.com>,
        BoRam Shin <boram.shin@samsung.com>,
        Sung-Jun Park <sungjun07.park@samsung.com>,
        Daejun Park <daejun7.park@samsung.com>
Subject: Re: Another approach of UFSHPB
Message-ID: <20200520175555.GA27975@infradead.org>
References: <835c57b9-f792-2460-c3cc-667031969d63@acm.org>
 <1589538614-24048-1-git-send-email-avri.altman@wdc.com>
 <d10b27f1-49ec-d092-b252-2bb8cdc4c66e@acm.org>
 <SN6PR04MB46408050B71E3A6225D6C495FCBA0@SN6PR04MB4640.namprd04.prod.outlook.com>
 <CGME20200516171420epcas2p108c570904c5117c3654d71e0a2842faa@epcms2p7>
 <231786897.01589928601376.JavaMail.epsvc@epcpadp1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <231786897.01589928601376.JavaMail.epsvc@epcpadp1>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Serious,

HPB is a completely fucked up concept and we shoud not merge it at all.
Especially not with a crazy bullshit vendor extension layer that makes
it even easier for vendors to implement even worse things than the
already horrible spec says.  Just stop this crap and implement sane
interfaces for the next generation hardware instead of wasting your
time on this idiotic idea.
