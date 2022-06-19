Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 119B8C433EF
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Jun 2022 06:22:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231349AbiFSGWU (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 19 Jun 2022 02:22:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbiFSGWT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 19 Jun 2022 02:22:19 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC44C65F4;
        Sat, 18 Jun 2022 23:22:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=H19VhEh5ExQrq6coNq39rP3fLRif6puGzLlaMZs49cY=; b=e5qeQS/03+KEr0TmlzVfNa7uP6
        qP/DCa8f6yx1GW+aX+eNg+CvMp+oTu2E9r3zdDxxU1SRASEHzOXHLP+s6p4w9DyL6qvJuiN2w+JZN
        NGhlUH7wfQMFWJLYQbnH1R8b/VYmAtu+6/Kzgnk4/IGHJKXPlZlUALXLHfMVHXTnBB5XDXCBEDVoS
        vM4oj11l0zaCTSlCqPeOxZJpAhr7F28gRz7YMRdUy801GYJ8ZcIBmzklXw7NokYDpidtGEylOqTS8
        0dr88VXrsjbnPgid0Y+YLm3g43nba8nuPyuPTbRAEreX3QOzMw5f6ILH1lF2b61C7F4/5UvODO6/x
        lEXRkZsA==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o2oK9-00DLT6-8Q; Sun, 19 Jun 2022 06:22:17 +0000
Date:   Sat, 18 Jun 2022 23:22:17 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Subject: Re: [PATCH 1/4] scsi: target: Fix WRITE_SAME NDOB size check
Message-ID: <Yq7AmRBWtkyqzt0g@infradead.org>
References: <20220617030440.116427-1-michael.christie@oracle.com>
 <20220617030440.116427-2-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220617030440.116427-2-michael.christie@oracle.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Jun 16, 2022 at 10:04:36PM -0500, Mike Christie wrote:
> If the WRITE_SAME NDOB bit is set then there is not going to be a
> buffer. LIO core will then complain:
> 
> TARGET_CORE[iSCSI]: Expected Transfer Length: 0 does not match SCSI CDB
> Length: 512 for SAM Opcode: 0x93
> 
> This fixes the issue by detecting when the bit is set and adjusting the
> size.


The patch looks good and useful, but right the taret code doesn't even
support MI_REPORT_SUPPORTED_OPERATION_CODES to report support for NDOB,
so who ends up using it?
