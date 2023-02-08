Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7747CC636CC
	for <linux-scsi@archiver.kernel.org>; Wed,  8 Feb 2023 06:33:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229688AbjBHGdC (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 8 Feb 2023 01:33:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229509AbjBHGdB (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 8 Feb 2023 01:33:01 -0500
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30C8B38B67
        for <linux-scsi@vger.kernel.org>; Tue,  7 Feb 2023 22:32:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=MqWmOc+AThDgmZNAyYDq3MGtxsx7jZHqT7sgOg4RaKA=; b=craC6b7EJsYQqLm+dF9JD5aXV7
        44+7CDCsZrZUkS7ZgViDuLYX3mZCrHWU7Wj1gBL/pun45ONHDwUM4ecaMssW3UXQlcwv+FoEcp0IV
        OYcVPSA8z0Lp8FlpxmBxGjRNbn4U4F17RJTXGS6B4bugNF2ejzi+eVyjwYSORBRi4fuCIn4Bq4VQf
        C8sNCrvyA4TV5it198acbfch/1SwxrD/LWWW6TzhlYfo28u5t5Za9z53MLZIs+/aHg82K5kg1xwvC
        an/OCJMV7iGFUzMAHrw3N5DbD/3b1grJ93oGEq5ELuruv/sS8JSyhkT1XxKVGN+mk1TPx9MvtY9Lj
        7qYFUaxQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1pPe0d-00EJJQ-Kh; Wed, 08 Feb 2023 06:32:47 +0000
Date:   Tue, 7 Feb 2023 22:32:47 -0800
From:   Christoph Hellwig <hch@infradead.org>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Christoph Hellwig <hch@infradead.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>,
        Avri Altman <avri.altman@wdc.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH v2 0/2] Use SYNCHRONIZE CACHE instead of FUA for UFS
 devices
Message-ID: <Y+NCDzvuLJYGwyhC@infradead.org>
References: <20230202220041.560919-1-bvanassche@acm.org>
 <Y9yp+H1qkuAxrB8j@infradead.org>
 <235d32fe-1d78-2eff-2e13-5ac82b337793@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <235d32fe-1d78-2eff-2e13-5ac82b337793@acm.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Feb 03, 2023 at 09:54:24AM -0800, Bart Van Assche wrote:
> We can ask our suppliers politely to not claim FUA support in future
> devices. However we still need patch 1/2 for existing UFS devices.

Please add quirks for the actually affected devices, and do not
block fua for an entire transport.
