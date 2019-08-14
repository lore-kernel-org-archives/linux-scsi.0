Return-Path: <SRS0=JpCa=WK=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_SANE_1
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BBA47C433FF
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 01:35:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8549920842
	for <linux-scsi@archiver.kernel.org>; Wed, 14 Aug 2019 01:35:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726968AbfHNBfR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 13 Aug 2019 21:35:17 -0400
Received: from smtp.infotech.no ([82.134.31.41]:43589 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726843AbfHNBfR (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 13 Aug 2019 21:35:17 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id D2E6D20423A;
        Wed, 14 Aug 2019 03:35:15 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 735AlbxH1Iu7; Wed, 14 Aug 2019 03:35:14 +0200 (CEST)
Received: from [192.168.48.23] (host-23-251-188-50.dyn.295.ca [23.251.188.50])
        by smtp.infotech.no (Postfix) with ESMTPA id 4CA5120414F;
        Wed, 14 Aug 2019 03:35:12 +0200 (CEST)
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH v3 05/20] sg: bitops in sg_device
To:     Christoph Hellwig <hch@infradead.org>
Cc:     linux-scsi@vger.kernel.org, martin.petersen@oracle.com,
        jejb@linux.vnet.ibm.com, hare@suse.de, bvanassche@acm.org
References: <20190807114252.2565-1-dgilbert@interlog.com>
 <20190807114252.2565-6-dgilbert@interlog.com>
 <20190812142328.GE8105@infradead.org>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <956fb8f9-5e60-2a72-3011-734f96bd0bd3@interlog.com>
Date:   Tue, 13 Aug 2019 21:35:12 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190812142328.GE8105@infradead.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2019-08-12 10:23 a.m., Christoph Hellwig wrote:
> On Wed, Aug 07, 2019 at 01:42:37PM +0200, Douglas Gilbert wrote:
>> +	unsigned long fdev_bm[1];	/* see SG_FDEV_* defines above */
> 
> No need for the array of one here.

Justification here:
    https://www.spinics.net/lists/linux-scsi/msg132477.html

>> +#define SG_IS_DETACHING(sdp) test_bit(SG_FDEV_DETACHING, (sdp)->fdev_bm)
>> +#define SG_HAVE_EXCLUDE(sdp) test_bit(SG_FDEV_EXCLUDE, (sdp)->fdev_bm)
> 
> No real need for these wrappers.

True of all wrappers. Again, these wrappers are fighting the tyranny of
checkpatch.pl

> Otherwise this looks sane to me.
> 

