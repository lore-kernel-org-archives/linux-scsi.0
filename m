Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2DA9ECDB465
	for <linux-scsi@archiver.kernel.org>; Mon, 16 Oct 2023 13:35:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233907AbjJPNfm (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 16 Oct 2023 09:35:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233912AbjJPNf2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 16 Oct 2023 09:35:28 -0400
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07450139
        for <linux-scsi@vger.kernel.org>; Mon, 16 Oct 2023 06:35:27 -0700 (PDT)
Received: by verein.lst.de (Postfix, from userid 2407)
        id BF8F868C7B; Mon, 16 Oct 2023 15:35:23 +0200 (CEST)
Date:   Mon, 16 Oct 2023 15:35:23 +0200
From:   Christoph Hellwig <hch@lst.de>
To:     Hannes Reinecke <hare@suse.de>
Cc:     Christoph Hellwig <hch@lst.de>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        James Bottomley <james.bottomley@hansenpartnership.com>,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH 03/17] bfa: Do not use scsi command to signal TMF status
Message-ID: <20231016133523.GA28162@lst.de>
References: <20231016092430.55557-1-hare@suse.de> <20231016092430.55557-4-hare@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20231016092430.55557-4-hare@suse.de>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Oct 16, 2023 at 11:24:16AM +0200, Hannes Reinecke wrote:
> The bfa driver hijacks the scsi command to signal the TMF status,
> which will no longer work if the TMF handler will be converted.
> So rework TMF handling to not use a scsi command but rather add
> new TMF fields to the per-device structure.

This looks good from a cursory review:

Reviewed-by: Christoph Hellwig <hch@lst.de>

but I'm not sure I'd even trust the current state of this driver.
Given that it's a giant unmaintained mess maybe it's time to mark
it broken or remove it?
