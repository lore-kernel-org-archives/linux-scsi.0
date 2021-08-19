Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-14.0 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,INCLUDES_CR_TRAILER,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF9C1C432BE
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Aug 2021 21:33:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8278A6109E
	for <linux-scsi@archiver.kernel.org>; Thu, 19 Aug 2021 21:33:55 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233743AbhHSVeZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 19 Aug 2021 17:34:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231951AbhHSVeX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 19 Aug 2021 17:34:23 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ECB94C061575;
        Thu, 19 Aug 2021 14:33:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description;
        bh=bdxkc83q6kJ9qh/y52VwJ2v/evqQNeNYte2MxskUxaw=; b=PYIoEvu47yHxjeJFlOgfoulVr6
        38dUcO4XtoUg5flQQQD4fX57Dr1j6r8oWfKgYVwqtJaCSXZn3FSeqVMskWEs8uFtFxz0pqb4QIgbt
        2MSGFNeWHNs/TY4SNW9ofWq4fax2udeqCDliT8toqoW7p/r562qKpBsRrj/pu3n2QiHima7OKtnHB
        dBKDZ+I65TWPs09aNHYhDIC+Pol6vFj60Zhku72xFIvHKuiIcnYL/qxmOjXqoaA/k3vH+rt9ALmYZ
        8XYAdiAMmP74JkCeVMxue10vEtb4RJUnAPePdXpNH1b7PdUZfEi3x4d3oWrm8N14MsU24oxL+0PUn
        nel/OOjw==;
Received: from mcgrof by bombadil.infradead.org with local (Exim 4.94.2 #2 (Red Hat Linux))
        id 1mGpfD-009Tx4-26; Thu, 19 Aug 2021 21:33:27 +0000
Date:   Thu, 19 Aug 2021 14:33:27 -0700
From:   Luis Chamberlain <mcgrof@kernel.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jens Axboe <axboe@kernel.dk>, Stefan Haberland <sth@linux.ibm.com>,
        Jan Hoeppner <hoeppner@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Doug Gilbert <dgilbert@interlog.com>,
        Kai =?iso-8859-1?Q?M=E4kisara?= <Kai.Makisara@kolumbus.fi>,
        linux-block@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [PATCH 3/9] sg: do not allocate a gendisk
Message-ID: <YR7OJ+lmps2H2fN/@bombadil.infradead.org>
References: <20210816131910.615153-1-hch@lst.de>
 <20210816131910.615153-4-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210816131910.615153-4-hch@lst.de>
Sender: Luis Chamberlain <mcgrof@infradead.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Aug 16, 2021 at 03:19:04PM +0200, Christoph Hellwig wrote:
> sg is a character driver and thus does not need to allocate a gendisk,
> which is only used for file system-like block layer I/O on block
> devices.
> 
> Signed-off-by: Christoph Hellwig <hch@lst.de>

You forgot to do something like this too:


diff --git a/drivers/scsi/st.c b/drivers/scsi/st.c
index c7d2c1c5a299..9d04929f03a1 100644
--- a/drivers/scsi/st.c
+++ b/drivers/scsi/st.c
@@ -3827,7 +3827,7 @@ static long st_ioctl(struct file *file, unsigned int cmd_in, unsigned long arg)
 		break;
 	}
 
-	retval = scsi_ioctl(STp->device, STp->disk, file->f_mode, cmd_in, p);
+	retval = scsi_ioctl(STp->device, NULL, file->f_mode, cmd_in, p);
 	if (!retval && cmd_in == SCSI_IOCTL_STOP_UNIT) {
 		/* unload */
 		STp->rew_at_close = 0;

Other than that:

Reviewed-by: Luis Chamberlain <mcgrof@kernel.org>

  Luis
