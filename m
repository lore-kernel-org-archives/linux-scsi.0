Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8C538C433F5
	for <linux-scsi@archiver.kernel.org>; Thu, 24 Feb 2022 06:52:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231398AbiBXGxX (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 24 Feb 2022 01:53:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44898 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229865AbiBXGxW (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 24 Feb 2022 01:53:22 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13D241275F1;
        Wed, 23 Feb 2022 22:52:53 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 8C4ED68AA6; Thu, 24 Feb 2022 07:52:49 +0100 (CET)
Date:   Thu, 24 Feb 2022 07:52:49 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Christoph Hellwig <hch@lst.de>, John Garry <john.garry@huawei.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Subject: Re: [PATCH 3/8] scsi: don't memset the entire scsi_cmnd in
 scsi_init_command
Message-ID: <20220224065249.GA20737@lst.de>
References: <20220222140443.589882-1-hch@lst.de> <20220222140443.589882-4-hch@lst.de> <f5c2f7e0-6b14-222f-ba16-696b29517296@huawei.com> <20220223123940.GA4205@lst.de> <75ccb490-3c77-b7d9-815a-8bf1698f0848@huawei.com> <20220223125855.GA4489@lst.de> <c22fa8f1-790d-faf8-a014-f00e0e357075@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c22fa8f1-790d-faf8-a014-f00e0e357075@acm.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Feb 23, 2022 at 12:16:24PM -0800, Bart Van Assche wrote:
> On 2/23/22 04:58, Christoph Hellwig wrote:
>> In general most of the zeroing here should go away entirely.  Right
>> now that code is a bit convolute due to the fake EH scsi command that
>> also uses scsi_init_command.  Once that is sorted out (I've just pinged
>> Hannes for his series) scsi_init_command can be folded into
>> scsi_prepare_cmd and a lot more of this can be cleaned up.
>
> Several SCSI LLDs rely on the SCSI core zeroing the driver-private data.
> I'd be more than happy if the code for zeroing of driver-private data would 
> be pushed into the LLD drivers. This may require the introduction of a new 
> per-command flag since that zeroing should only happen if scsi_queue_rq() 
> decided to call scsi_prepare_cmd().

If the driver provides a init_cmd_priv method it is not zeroed.  So if
a driver does not want it zeroed, it can always provide this callback,
including an empty one.
