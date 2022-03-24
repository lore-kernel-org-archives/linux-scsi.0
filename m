Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 09323C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Mar 2022 09:50:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349351AbiCXJw0 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Mar 2022 05:52:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49104 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239549AbiCXJw0 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Mar 2022 05:52:26 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 71D925549E
        for <linux-scsi@vger.kernel.org>; Thu, 24 Mar 2022 02:50:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=8ZzLcTWo8SmylIDKSq9r8TeT+MFH1XqzQmHdecwhJQQ=; b=3eaqM3Cj2TzufmPPxE2NvhYpJB
        kX0V9qt2nCL9zC3KqDyNEaWcGD+srXsFys3AGVLBbgda5ANKom+d5N6bVmJSBJ35nDif8ZXCF8mRU
        iwFNTgcisfrkIGQBc5/K9wr3uCpTHFyYMX5aTYy9bEJNrv7gahiMR/vS+tXRsLrYx/FMON+jngvc9
        Wik55KHE11gP1h+B8ndjBilhV31Rceaw45gQxRuWLf3bwzBIIj7SwJskBYsnDcGgZnhe04Gmky4qy
        UOByciiwdUx2t+9xLdTHUVvpm5eSVGWEtal3hB0CNU2lRKgN0ZKP3HMnBWBIVEu+Q6D364RzhVTQD
        cp7aiJfQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1nXK7I-00GAbF-Uk; Thu, 24 Mar 2022 09:50:52 +0000
Date:   Thu, 24 Mar 2022 02:50:52 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Chandrakanth patil <chandrakanth.patil@broadcom.com>
Cc:     linux-scsi@vger.kernel.org, kashyap.desai@broadcom.com,
        sumit.saxena@broadcom.com
Subject: Re: [PATCH] megaraid_sas: device scan on logical target with invalid
 LUN ID deletes that target from the OS
Message-ID: <Yjw+/LJiovLV9VhB@infradead.org>
References: <20220324094711.48833-1-chandrakanth.patil@broadcom.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220324094711.48833-1-chandrakanth.patil@broadcom.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Mar 24, 2022 at 02:47:11AM -0700, Chandrakanth patil wrote:
> The megaraid_sas driver supports single LUN, that is LUN 0. And all other
> LUNs are unsupported.
> When a device scan on logical target with invalid lun is invoked through
> sysfs that target itself is getting removed from the OS. So added a LUN
> ID validation in the slave destroy to avoid the target deletion.

Please set the max_lun member ins the host template isntead of papering
over this in the driver.
