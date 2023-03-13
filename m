Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87FF0C74A4B
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Mar 2023 01:44:56 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229638AbjCMBoz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 12 Mar 2023 21:44:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229561AbjCMBoz (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 12 Mar 2023 21:44:55 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2526B28D3D;
        Sun, 12 Mar 2023 18:44:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CA77FB80DC8;
        Mon, 13 Mar 2023 01:44:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1551AC433D2;
        Mon, 13 Mar 2023 01:44:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678671891;
        bh=o0ATLULxPasoiLpbkvNZurekwvW9bghe33IouHklmN8=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=SAU949H3GdB/cxGqrtOOQNKVXLChr8KrcYhL0l2gMB9hnaPdYRUbXzlFRbWnL3y12
         T3Ax6Br+qr9z7D5PkXlKuKC9298s3LsjYBsSnzw4IEcn07HBEbzwYw3Ar54OfB33e6
         t4r4m4K9ov8af6aKBQP6f8N6UXrSXriSrlxBOb+MmLvqMWxx0r4PZicXkhjOPagRWQ
         Y+dv1GXgf67NbDQIMzxbxv5VjtraxegaVByJk78O9n3CDDOwyzyW8BW+MrgiMSut3o
         2GDUvWu+CScniezgwohPU/EnfPM8TX2eTJvUrhOUeubVFnXg1ZregCcgyDjZY6eJSh
         gpQ1LjyD+xDHQ==
Message-ID: <9e3ffff0-6cc8-b01a-4d2e-5ec49a936415@kernel.org>
Date:   Mon, 13 Mar 2023 09:44:47 +0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Subject: Re: [PATCH v5] scsi: support packing multi-segment in UNMAP command
Content-Language: en-US
To:     Christoph Hellwig <hch@infradead.org>
Cc:     martin.petersen@oracle.com, jejb@linux.ibm.com, bvanassche@acm.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230310123604.1820231-1-chao@kernel.org>
 <ZAs4h2Mu90u4gc3/@infradead.org>
From:   Chao Yu <chao@kernel.org>
In-Reply-To: <ZAs4h2Mu90u4gc3/@infradead.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 2023/3/10 22:02, Christoph Hellwig wrote:
>> -	/* If command type is WRITE or DISCARD, set bitmap as dirty */
>> -	if (ufshpb_is_write_or_discard(cmd)) {
>> +	/* If command type is WRITE, set bitmap as dirty */
>> +	if (op_is_write(req_op(scsi_cmd_to_rq(cmd)))) {
> 
> Umm, a driver has absolutely no business poking into the UNMAP
> payload.   Someone needs to fix the UFS driver first to not do this.

IIUC，originally, HPB driver tries to lookup LBA range{,s} from WRITE/DISCARD
request, and will dirty mapped HPB regions based on LBA range{,s}, do you mean
HPB driver should not parse DISCARD request?

