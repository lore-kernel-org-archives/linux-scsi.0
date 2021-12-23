Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 33101C433EF
	for <linux-scsi@archiver.kernel.org>; Thu, 23 Dec 2021 06:33:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232600AbhLWGdc (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 23 Dec 2021 01:33:32 -0500
Received: from verein.lst.de ([213.95.11.211]:52783 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232444AbhLWGdc (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 23 Dec 2021 01:33:32 -0500
Received: by verein.lst.de (Postfix, from userid 2407)
        id 434CF68AFE; Thu, 23 Dec 2021 07:33:29 +0100 (CET)
Date:   Thu, 23 Dec 2021 07:33:29 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Jackie Liu <liu.yun@linux.dev>
Cc:     Guenter Roeck <linux@roeck-us.net>, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, hch@lst.de, axboe@kernel.dk
Subject: Re: [PATCH v2] scsi: bsg: fix errno when scsi_bsg_register_queue
 fails
Message-ID: <20211223063329.GA3882@lst.de>
References: <20211022010201.426746-1-liu.yun@linux.dev> <20211222165435.GA283263@roeck-us.net> <6671fc20-e543-71c5-c505-395e6ee7e744@linux.dev> <d9f64463-fdf3-0b67-cc34-7838864e1c77@roeck-us.net> <6e8e5593-eeed-dcb6-2b4d-008b82c8d14c@linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <6e8e5593-eeed-dcb6-2b4d-008b82c8d14c@linux.dev>
User-Agent: Mutt/1.5.17 (2007-11-01)
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Dec 23, 2021 at 10:42:30AM +0800, Jackie Liu wrote:
> I see, Thanks for point out, after commit ee37e09d81a4 ("[SCSI] fix
> duplicate removal on error path in scsi_sysfs_add_sdev"), Before this
> errno will be forced to return 0.
>
> After:
>
> [1] error = device_create_file(&sdev->sdev_gendev,  	
>                            sdev->host->hostt->sdev_attrs[i]);
>
> Then:
>
> with 92c4b58b15c5 ("scsi: core: Register sysfs attributes earlier")
> delete code [1], so we force return errno.
>
> I don’t know if I should restore the original logic or delete
> this comment information. Guenter and Christoph, What do you think? I
> can send another patch based on this.

I think we should just handle the error properly and remove the comment.
There's no good reason to ignore bsg registration errors.
