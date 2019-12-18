Return-Path: <SRS0=fPmA=2I=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E9D06C43603
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Dec 2019 18:45:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id CB4982176D
	for <linux-scsi@archiver.kernel.org>; Wed, 18 Dec 2019 18:45:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727145AbfLRSpp (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 18 Dec 2019 13:45:45 -0500
Received: from imap2.colo.codethink.co.uk ([78.40.148.184]:34720 "EHLO
        imap2.colo.codethink.co.uk" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726699AbfLRSpp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 18 Dec 2019 13:45:45 -0500
Received: from [167.98.27.226] (helo=xylophone)
        by imap2.colo.codethink.co.uk with esmtpsa  (Exim 4.92 #3 (Debian))
        id 1iheKH-0007I2-Gm; Wed, 18 Dec 2019 18:45:37 +0000
Message-ID: <22903f0af805452bfabf9c0b476a1b67646e544c.camel@codethink.co.uk>
Subject: Re: [PATCH v2 17/27] compat_ioctl: ide: floppy: add handler
From:   Ben Hutchings <ben.hutchings@codethink.co.uk>
To:     Arnd Bergmann <arnd@arndb.de>, Jens Axboe <axboe@kernel.dk>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        y2038@lists.linaro.org, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>, linux-doc@vger.kernel.org,
        corbet@lwn.net, viro@zeniv.linux.org.uk,
        linux-fsdevel@vger.kernel.org
Date:   Wed, 18 Dec 2019 18:45:36 +0000
In-Reply-To: <20191217221708.3730997-18-arnd@arndb.de>
References: <20191217221708.3730997-1-arnd@arndb.de>
         <20191217221708.3730997-18-arnd@arndb.de>
Organization: Codethink Ltd.
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.30.5-1.1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2019-12-17 at 23:16 +0100, Arnd Bergmann wrote:
> Rather than relying on fs/compat_ioctl.c, this adds support
> for a compat_ioctl() callback in the ide-floppy driver directly,
> which lets it translate the scsi commands.
[...]

After this, and before "compat_ioctl: move HDIO ioctl handling into
drivers/ide", compat ioctls on an IDE hard drive will result in a null
pointer dereference in ide_gd_compat_ioctl().  Not sure how much that
really matters though.

Ben.

-- 
Ben Hutchings, Software Developer                         Codethink Ltd
https://www.codethink.co.uk/                 Dale House, 35 Dale Street
                                     Manchester, M1 2HF, United Kingdom

