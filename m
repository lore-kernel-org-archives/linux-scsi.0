Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 26FCCC433EF
	for <linux-scsi@archiver.kernel.org>; Sun, 19 Jun 2022 06:29:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232316AbiFSG3z (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 19 Jun 2022 02:29:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229791AbiFSG3y (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 19 Jun 2022 02:29:54 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:3::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9965ADFC2;
        Sat, 18 Jun 2022 23:29:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=In-Reply-To:Content-Type:MIME-Version
        :References:Message-ID:Subject:Cc:To:From:Date:Sender:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=yfv0/9JXUJSHjLjMcbE910TOTsgGVBbY7XlaNVCKNrk=; b=bkjUfiHoq7toqQo1dP5NZyW31r
        OfsxtetWp66iHJIRKY4RHIWmgWBuu0fe4kPBP3B3n/y1IMf8jri/n5SrUfTk3rTeJH1cymso/9Ktl
        ALgYFND8dR1aaJPjs1QOOb3P9SHPbjr6RNejVDuMehr2If4fZeuUYo+qG8WKiHGV5JSt+N1wW88ko
        QNusgo0ZoUzaSebLdSXPGUl6IOaz5xgOku9bK7QwGIWQ0xmCOEBDQXMYxQrb3BWMMOB/fbmyFkQtp
        bGbsYmVD2mgI1JdO6sxoB+/qBX8vvhrt1FOrvuxo3WLBhggliiU5RNSaDRSzebh1S58oG5HE+XQhU
        BEVrlBPQ==;
Received: from hch by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1o2oRT-00DLtI-0K; Sun, 19 Jun 2022 06:29:51 +0000
Date:   Sat, 18 Jun 2022 23:29:50 -0700
From:   Christoph Hellwig <hch@infradead.org>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     martin.petersen@oracle.com, james.bottomley@hansenpartnership.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Subject: Re: [PATCH 4/4] scsi: target: Detect unmap support post configuration
Message-ID: <Yq7CXsFo4810SVJj@infradead.org>
References: <20220617030440.116427-1-michael.christie@oracle.com>
 <20220617030440.116427-5-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220617030440.116427-5-michael.christie@oracle.com>
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org. See http://www.infradead.org/rpr.html
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Jun 16, 2022 at 10:04:39PM -0500, Mike Christie wrote:
> On our backend we can do something similar to LIO where we can enable and
> disable unmap support on the fly. In the scsi/block layer we can detect
> this by just doing a rescan. However, LIO cannot detect this change
> because we only check during the initial configuration. This patch
> allows unmap detection to also happen when the user tries to turn it on.

Please also call the new callback from the generic code during initial
setup instead of leaving that to the backends.
