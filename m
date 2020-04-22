Return-Path: <SRS0=1vX0=6G=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1EA26C5518E
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Apr 2020 06:55:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id EC9B6206D9
	for <linux-scsi@archiver.kernel.org>; Wed, 22 Apr 2020 06:55:43 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="fthiscYY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726071AbgDVGzm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 22 Apr 2020 02:55:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59802 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725810AbgDVGzl (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Apr 2020 02:55:41 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D8436C03C1A6;
        Tue, 21 Apr 2020 23:55:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=toV+NSb+8ljlbY2El040Sc4yeZwXLdJCYA1mR+KrkrA=; b=fthiscYYhphnRfRvDZfoBTzzZr
        2CHK6PnfeHNXf6TfkzAy8RFdhlYqp91JZ7edAdhlPssXhal8EW7q4TQapKjDoKnKgUadIs8XYIgB/
        DUtvpa6o8pWCUMaNbuU9xuiRurXQn6xv/WRwnajyMtzMQU5QxknQn7mqbtq5cIwNCx26Ghvur1EKg
        yIw/wtLoXrUYLVxh6IPjHoJO1R3zPUUveqY14RNCuMvC15fHZlqpV69kTFNC7psHtvThUB68YRwdB
        kg/m1x2ajTf8fehVqkeQyvNuAUPHMdY6Kd5Ll5E/YK1+UKbszzEJ9WcqbRmV2Ka6+oF2CTzLtZiRa
        u84qKNXA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jR9IL-0007dV-6c; Wed, 22 Apr 2020 06:55:41 +0000
Date:   Tue, 21 Apr 2020 23:55:41 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Alim Akhtar <alim.akhtar@samsung.com>
Cc:     robh@kernel.org, devicetree@vger.kernel.org,
        linux-scsi@vger.kernel.org, krzk@kernel.org, avri.altman@wdc.com,
        martin.petersen@oracle.com, kwmad.kim@samsung.com,
        stanley.chu@mediatek.com, cang@codeaurora.org,
        linux-samsung-soc@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v6 05/10] scsi: ufs: add quirk to fix abnormal ocs fatal
 error
Message-ID: <20200422065541.GL20318@infradead.org>
References: <20200417175944.47189-1-alim.akhtar@samsung.com>
 <CGME20200417181016epcas5p2ee7ac86d743ceee9076690dc5b1e2f08@epcas5p2.samsung.com>
 <20200417175944.47189-6-alim.akhtar@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200417175944.47189-6-alim.akhtar@samsung.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Apr 17, 2020 at 11:29:39PM +0530, Alim Akhtar wrote:
> From: Kiwoong Kim <kwmad.kim@samsung.com>
> 
> Some architectures determines if fatal error for OCS
> occurrs to check status in response upiu. This patch
> is to prevent from reporting command results with that.

What does "Some architectures" mean?  All this seems to be about
error propagation to the SCSI midlyaer, so this sounds rather
strange.
