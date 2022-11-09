Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33EC6C433FE
	for <linux-scsi@archiver.kernel.org>; Wed,  9 Nov 2022 06:53:44 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229781AbiKIGxn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 9 Nov 2022 01:53:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229777AbiKIGxm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 9 Nov 2022 01:53:42 -0500
Received: from verein.lst.de (verein.lst.de [213.95.11.211])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C88D813D64;
        Tue,  8 Nov 2022 22:53:41 -0800 (PST)
Received: by verein.lst.de (Postfix, from userid 2407)
        id 37FB868BEB; Wed,  9 Nov 2022 07:53:39 +0100 (CET)
Date:   Wed, 9 Nov 2022 07:53:38 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Mike Christie <michael.christie@oracle.com>
Cc:     kbusch@kernel.org, axboe@fb.com, hch@lst.de, sagi@grimberg.me,
        martin.petersen@oracle.com, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org, linux-nvme@lists.infradead.org,
        linux-block@vger.kernel.org
Subject: Re: [PATCH 3/3] nvme: Convert NVMe errors to PT_STS errors
Message-ID: <20221109065338.GC11097@lst.de>
References: <20221109031106.201324-1-michael.christie@oracle.com> <20221109031106.201324-4-michael.christie@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20221109031106.201324-4-michael.christie@oracle.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, Nov 08, 2022 at 09:11:06PM -0600, Mike Christie wrote:
> +	case NVME_SC_ONCS_NOT_SUPPORTED:
> +		sts = PR_STS_OP_NOT_SUPP;
> +		break;
> +	case NVME_SC_BAD_ATTRIBUTES:
> +	case NVME_SC_INVALID_OPCODE:
> +	case NVME_SC_INVALID_FIELD:
> +	case NVME_SC_INVALID_NS:
> +		sts = PR_STS_OP_INVALID;
> +		break;

Second thoughts on these: shouldn't we just return negative Linux
errnos here?
