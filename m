Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0618FCDB465
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Oct 2023 13:30:05 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233586AbjJPNaD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Oct 2023 09:30:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233568AbjJPNaC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Oct 2023 09:30:02 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E0A00F7
        for <linux-scsi@vger.kernel.org>; Mon, 16 Oct 2023 06:29:59 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id DADB46732D; Mon, 16 Oct 2023 15:29:55 +0200 (CEST)
Date:   Mon, 16 Oct 2023 15:29:55 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Hannes Reinecke <hare@suse.de>
Cc:     Christoph Hellwig <hch@lst.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 01/17] pmcraid: add missing scsi_device_put() in
 pmcraid_eh_target_reset_handler()
Message-ID: <20231016132955.GA27635@lst.de>
References: <20231016092430.55557-1-hare@suse.de> <20231016092430.55557-2-hare@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231016092430.55557-2-hare@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Oct 16, 2023 at 11:24:14AM +0200, Hannes Reinecke wrote:
> When breaking out of a shost_for_each_device() loop one need to do
> an explicit scsi_device_put(). And while at it convert to use
> shost_priv() instead of a direct reference to ->hostdata.

While both part of the patch looks good, mixing these totally unrelated
bits doesn't seem like a good idea.

