Return-Path: <SRS0=1vUj=CL=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,NICE_REPLY_A,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9675BC433E2
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Sep 2020 15:39:02 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 81408207EA
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Sep 2020 15:39:02 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728413AbgIBPjB (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Sep 2020 11:39:01 -0400
Received: from smtp.infotech.no ([82.134.31.41]:51366 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727895AbgIBPi6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Wed, 2 Sep 2020 11:38:58 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id 93E6A20418E;
        Wed,  2 Sep 2020 17:38:52 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id PCCwPRfO6cmJ; Wed,  2 Sep 2020 17:38:50 +0200 (CEST)
Received: from [192.168.48.23] (host-45-78-251-166.dyn.295.ca [45.78.251.166])
        by smtp.infotech.no (Postfix) with ESMTPA id 04A34204158;
        Wed,  2 Sep 2020 17:38:47 +0200 (CEST)
Reply-To: dgilbert@interlog.com
Subject: Re: rework check_disk_change()
To:     Christoph Hellwig <hch@lst.de>, Jens Axboe <axboe@kernel.dk>
Cc:     Denis Efremov <efremov@linux.com>, Tim Waugh <tim@cyberelk.net>,
        Michal Simek <michal.simek@xilinx.com>,
        Borislav Petkov <bp@alien8.de>,
        "David S. Miller" <davem@davemloft.net>,
        Song Liu <song@kernel.org>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Finn Thain <fthain@telegraphics.com.au>,
        Michael Schmitz <schmitzmic@gmail.com>,
        linux-m68k@lists.linux-m68k.org, linux-block@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-raid@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-fsdevel@vger.kernel.org
References: <20200902141218.212614-1-hch@lst.de>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <730eced4-c804-a78f-3d52-2a448dbd1b84@interlog.com>
Date:   Wed, 2 Sep 2020 11:38:45 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200902141218.212614-1-hch@lst.de>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-09-02 10:11 a.m., Christoph Hellwig wrote:
> Hi Jens,
> 
> this series replaced the not very nice check_disk_change() function with
> a new bdev_media_changed that avoids having the ->revalidate_disk call
> at its end.  As a result ->revalidate_disk can be removed from a lot of
> drivers.
> 

For over 20 years the sg driver has been carrying this snippet that hangs
off the completion callback:

        if (driver_stat & DRIVER_SENSE) {
                 struct scsi_sense_hdr ssh;

                 if (scsi_normalize_sense(sbp, sense_len, &ssh)) {
                         if (!scsi_sense_is_deferred(&ssh)) {
                                 if (ssh.sense_key == UNIT_ATTENTION) {
                                         if (sdp->device->removable)
                                                 sdp->device->changed = 1;
                                 }
                         }
                 }
         }

Is it needed? The unit attention (UA) may not be associated with the
device changing. Shouldn't the SCSI mid-level monitor UAs if they
impact the state of a scsi_device object?

Doug Gilbert

