Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 825B1C43334
	for <linux-scsi@archiver.kernel.org>; Tue, 28 Jun 2022 05:03:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244616AbiF1FDX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 28 Jun 2022 01:03:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244640AbiF1FDW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 28 Jun 2022 01:03:22 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9CAF42658;
        Mon, 27 Jun 2022 22:03:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=xkFBj5EMmZEuNZfUllvLIZ59EHUx0Ld5aHv1ABJQBfc=; b=3+87R/QAflC12rDTpwq3D0FiR2
        O708xUvdmqsdL4sTduDNsM4oayXIeK4exs4a03Q2jeQRNbV5f1WLATnjJqNBAVwGqCVV1fWKwEMOT
        CZR77xkumjgQ2fxQd96MgHAHvY/Xi4ZbJBzJa1YokSoYF8vNgnEIep+J+3ntLavpW9/gZUEtMImgW
        ZyzJaf9c2rUSUqCDXAQk1b0YLPLu4sUxGNTiaq6Y848Ph6P4nr8u3oUarnrrASidmmeH0Bwm1DaBn
        z5LBRfoyuZL5GBGdrbEL8h2vfJakCYddzBo/v79OQo0YDqubfyy9dfywEupmNp3Bo6//DiPGMqRPg
        lUrmUq7A==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o63Ng-004J6Z-Hp; Tue, 28 Jun 2022 05:03:20 +0000
Date:   Mon, 27 Jun 2022 22:03:20 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     hch@infradead.org, martin.petersen@oracle.com,
        james.bottomley@hansenpartnership.com, linux-scsi@vger.kernel.org,
        target-devel@vger.kernel.org
Subject: Re: [PATCH 1/5] scsi: target: Remove incorrect zero blocks
 WRITE_SAME check
Message-ID: <YrqLmMaF0JRkZMsn@infradead.org>
References: <20220628022953.20948-1-michael.christie@oracle.com>
 <20220628022953.20948-2-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220628022953.20948-2-michael.christie@oracle.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Jun 27, 2022 at 09:29:49PM -0500, Mike Christie wrote:
> We use WSNZ=1 so if we get a WRITE_SAME with zero logical blocks we are
> supposed to fail it. We do this check and failure in target_core_sbc.c
> before calling into the backend, so we can remove the incorrect check in
> target_core_file.

Looks good:

Reviewed-by: Christoph Hellwig <hch@lst.de>
