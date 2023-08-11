Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AF5ECC001B0
	for <linux-scsi@archiver.kernel.org>; Fri, 11 Aug 2023 18:43:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229987AbjHKSnq (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 11 Aug 2023 14:43:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233938AbjHKSnn (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Aug 2023 14:43:43 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0062E30E6
        for <linux-scsi@vger.kernel.org>; Fri, 11 Aug 2023 11:42:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1691779376;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=cv6Mzmbr2OMxhgIgH25m8RNp8mlOWiCTlPRPpjLxL5o=;
        b=QgGrytYJOuREChTOQPm/xMpw6cITMt729dO7BfPwbmjM2KCQfjMXzNNij8JK1OF23RFK2B
        Uz4g9SGHpd5Mrd1Og3ZFGi1iLYYTXDMO3ImnJGgAN1eNlQRpmjqQmM5/RC9k01dd88v9xz
        YyASlDwqy8rxkv1F0c57cE5dMzoPFQI=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-142-xKIHEZ8aOGGW1rFTbYb-RA-1; Fri, 11 Aug 2023 14:42:53 -0400
X-MC-Unique: xKIHEZ8aOGGW1rFTbYb-RA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.rdu2.redhat.com [10.11.54.8])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 8D0C48DC660;
        Fri, 11 Aug 2023 18:42:52 +0000 (UTC)
Received: from [10.22.10.6] (unknown [10.22.10.6])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 38619C15BAE;
        Fri, 11 Aug 2023 18:42:52 +0000 (UTC)
Message-ID: <731b5514-9c72-7948-2376-fadfbed828b3@redhat.com>
Date:   Fri, 11 Aug 2023 14:42:52 -0400
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.13.0
Subject: Re: [PATCH] bnx2fc: Remove dma_alloc_coherent to suppress the BUG_ON.
Content-Language: en-US
To:     Jerry Snitselaar <jsnitsel@redhat.com>,
        Bart Van Assche <bvanassche@acm.org>
Cc:     Saurav Kashyap <skashyap@marvell.com>, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, Nilesh Javali <njavali@marvell.com>
References: <20230721102320.9559-1-skashyap@marvell.com>
 <642a49ed-4920-9c74-40aa-81d5c859ce79@acm.org>
 <benqe3zwp3go3w2s2fmhsyjft3d7vqiewffjqhb22y4hlpw5p4@46pxi3bd2zsn>
From:   John Meneghini <jmeneghi@redhat.com>
Organization: RHEL Core Storge Team
In-Reply-To: <benqe3zwp3go3w2s2fmhsyjft3d7vqiewffjqhb22y4hlpw5p4@46pxi3bd2zsn>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.8
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Saurav, please rework this patch and add the missing description. It would also be good to consolidate some of the repeated 
tasks into one or two sub-routines.

Please publish a v2 patch series.

/John

On 7/21/23 13:48, Jerry Snitselaar wrote:
> On Fri, Jul 21, 2023 at 07:58:26AM -0700, Bart Van Assche wrote:
>> On 7/21/23 03:23, Saurav Kashyap wrote:
>>> From: Jerry Snitselar <jsnitsel@redhat.com>
>>> [ ... ]
>>> Signed-off-by: Jerry Snitselar <jsnitsel@redhat.com>
>>
>> Has Jerry's name changed or has his name been misspelled? I think
>> a letter 'a' is missing from his name.
> 
> No, and yes. :)
> 
> This was originally passed along in a bugzilla bug as an example of a
> possible solution, but I didn't figure it would be the final patch.
> 
> The original patch had the following summary and description above
> the stack trace:
> 
>      scsi: bnx2fc: Don't use dma_*_coherent for session resources
>      
>      With commit f5ff79fddf0e ("dma-mapping: remove CONFIG_DMA_REMAP") a
>      crash can be seen with bnx2fc, because dma_free_coherent can not be
>      called in an interrupt context. Replace the dma_*_coherent code in
>      bnx2fc_alloc_session_resc and bnx2fc_free_session_resc, with kzalloc +
>      dma_map_single, and kfree + dma_unmap_single calls. Also properly
>      unwind in the error path for bnx2fc_alloc_session_resc, cleaning up
>      what it did succeed in allocating and mapping. This deals with seeing
>      the following panic:
> 
> 
> Regards,
> Jerry
> 
>>
>> Bart.
>>
> 

