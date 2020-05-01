Return-Path: <SRS0=ePHC=6P=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 32883C47254
	for <linux-scsi@archiver.kernel.org>; Fri,  1 May 2020 22:27:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 17601208DB
	for <linux-scsi@archiver.kernel.org>; Fri,  1 May 2020 22:27:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726377AbgEAW1N (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 May 2020 18:27:13 -0400
Received: from smtp.infotech.no ([82.134.31.41]:51253 "EHLO smtp.infotech.no"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726336AbgEAW1N (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Fri, 1 May 2020 18:27:13 -0400
Received: from localhost (localhost [127.0.0.1])
        by smtp.infotech.no (Postfix) with ESMTP id A663E20416A;
        Sat,  2 May 2020 00:27:10 +0200 (CEST)
X-Virus-Scanned: by amavisd-new-2.6.6 (20110518) (Debian) at infotech.no
Received: from smtp.infotech.no ([127.0.0.1])
        by localhost (smtp.infotech.no [127.0.0.1]) (amavisd-new, port 10024)
        with ESMTP id 129AGpWePjQj; Sat,  2 May 2020 00:27:09 +0200 (CEST)
Received: from [192.168.48.23] (host-23-251-188-50.dyn.295.ca [23.251.188.50])
        by smtp.infotech.no (Postfix) with ESMTPA id 29638204162;
        Sat,  2 May 2020 00:27:07 +0200 (CEST)
Reply-To: dgilbert@interlog.com
Subject: Re: [PATCH V2] scsi: put hot fields of scsi_host_template into one
 cacheline
To:     Ming Lei <ming.lei@redhat.com>,
        James Bottomley <James.Bottomley@HansenPartnership.com>,
        linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Bart Van Assche <bvanassche@acm.org>,
        Christoph Hellwig <hch@lst.de>,
        John Garry <john.garry@huawei.com>
References: <20200422095425.319674-1-ming.lei@redhat.com>
From:   Douglas Gilbert <dgilbert@interlog.com>
Message-ID: <841bd018-eff5-d242-97dd-416384eb4b08@interlog.com>
Date:   Fri, 1 May 2020 18:27:07 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.7.0
MIME-Version: 1.0
In-Reply-To: <20200422095425.319674-1-ming.lei@redhat.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-CA
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2020-04-22 5:54 a.m., Ming Lei wrote:
> The following three fields of scsi_host_template are referenced in
> scsi IO submission path, so put them together into one cacheline:
> 
> - cmd_size
> - queuecommand
> - commit_rqs
> 
> Cc: Bart Van Assche <bvanassche@acm.org>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: John Garry <john.garry@huawei.com>
> Signed-off-by: Ming Lei <ming.lei@redhat.com>
> ---
> V2:
> 	- move the 3 fields at the beginning of scsi_host_template
> 	- comment why we do this way
> 
>   include/scsi/scsi_host.h | 72 ++++++++++++++++++++++------------------
>   1 file changed, 39 insertions(+), 33 deletions(-)

Hi,
I would like to test this patch. However it doesn't apply on Martin's
tree (all 3 chunks fail). Could you post a clean version?

Doug Gilbert

