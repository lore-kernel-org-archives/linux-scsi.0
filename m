Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6582EC433FE
	for <linux-scsi@archiver.kernel.org>; Tue, 15 Nov 2022 09:14:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229690AbiKOJOu (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 15 Nov 2022 04:14:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43182 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237961AbiKOJOL (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Nov 2022 04:14:11 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 853CA63C9;
        Tue, 15 Nov 2022 01:14:10 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 1999B68C4E; Tue, 15 Nov 2022 10:14:04 +0100 (CET)
Date:   Tue, 15 Nov 2022 10:14:03 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     Christoph Hellwig <hch@lst.de>, kbusch@kernel.org, axboe@fb.com,
        sagi@grimberg.me, martin.petersen@oracle.com, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org
Subject: Re: [PATCH 3/3] nvme: Convert NVMe errors to PT_STS errors
Message-ID: <20221115091403.GA22594@lst.de>
References: <20221109031106.201324-1-michael.christie@oracle.com> <20221109031106.201324-4-michael.christie@oracle.com> <20221109065338.GC11097@lst.de> <8adcb890-ec08-cc75-6e1a-2b8dabdcd640@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8adcb890-ec08-cc75-6e1a-2b8dabdcd640@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Nov 09, 2022 at 11:20:07AM -0600, Mike Christie wrote:
> >> +	case NVME_SC_BAD_ATTRIBUTES:
> >> +	case NVME_SC_INVALID_OPCODE:
> >> +	case NVME_SC_INVALID_FIELD:
> >> +	case NVME_SC_INVALID_NS:
> >> +		sts = PR_STS_OP_INVALID;
> >> +		break;
> > 
> > Second thoughts on these: shouldn't we just return negative Linux
> > errnos here?
> 
> I wasn't sure. I might have over thought it.
> 
> I added the PR_STS error codes for those cases so a user could
> distinguish if the command was sent to the device and it
> reported it didn't support the command or the device determined it
> had an invalid field set.

But does it matter if the device or the kernel doesn't support
them?  The result for the users is very much the same.
