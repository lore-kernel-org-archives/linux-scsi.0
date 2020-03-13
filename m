Return-Path: <SRS0=Yi3m=46=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2CC31C5ACBF
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Mar 2020 11:08:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0E77E20724
	for <linux-scsi@archiver.kernel.org>; Fri, 13 Mar 2020 11:08:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726423AbgCMLII (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 13 Mar 2020 07:08:08 -0400
Received: from verein.lst.de ([213.95.11.211]:41984 "EHLO verein.lst.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726414AbgCMLII (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 13 Mar 2020 07:08:08 -0400
Received: by verein.lst.de (Postfix, from userid 2407)
        id EBF8968C4E; Fri, 13 Mar 2020 12:08:04 +0100 (CET)
Date:   Fri, 13 Mar 2020 12:08:04 +0100
From:   Christoph Hellwig <hch@lst.de>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        "James E . J . Bottomley" <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kai Makisara <Kai.Makisara@kolumbus.fi>,
        "James E . J . Bottomley" <jejb@linux.ibm.com>
Subject: Re: [PATCH v2 4/5] scsi/st: Use get_unaligned_be24() and
 sign_extend32()
Message-ID: <20200313110804.GC8132@lst.de>
References: <20200313023718.21830-1-bvanassche@acm.org> <20200313023718.21830-5-bvanassche@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200313023718.21830-5-bvanassche@acm.org>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Thu, Mar 12, 2020 at 07:37:17PM -0700, Bart Van Assche wrote:
> @@ -2680,8 +2681,7 @@ static void deb_space_print(struct scsi_tape *STp, int direction, char *units, u
>  	if (!debugging)
>  		return;
>  
> -	sc = cmd[2] & 0x80 ? 0xff000000 : 0;
> -	sc |= (cmd[2] << 16) | (cmd[3] << 8) | cmd[4];
> +	sc = sign_extend32(get_unaligned_be24(&cmd[2]), 23);

Btw, didn't the old code here have undefined behavior if cmd[] is
a u8 and we shift by a larger amount?
