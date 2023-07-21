Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B5F4BEB64DD
	for <linux-scsi@archiver.kernel.org>; Fri, 21 Jul 2023 17:49:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbjGURtf (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 21 Jul 2023 13:49:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbjGURte (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 21 Jul 2023 13:49:34 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB45630FF
        for <linux-scsi@vger.kernel.org>; Fri, 21 Jul 2023 10:48:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1689961725;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=4gRIrwj0GsRbDsoQLu/wdlhqB+Zp6TWGF0yyPNQWXHs=;
        b=cMfxQ5uAKYaZzMBY1YAK0Biwhc2chXkETBrGaSkxUlxLlfxqPXCIfhryFhOJzJwuFzxEZA
        eRY10gpSW867b4lMTaN5whB6Th8XIUZJ/HP2VFWf5o9EmNHf1LQ5KddAtY/6pXkHCkdMMl
        W3t/sIdSiaAFw0jzdGX02SpLXp1JcEI=
Received: from mail-qv1-f69.google.com (mail-qv1-f69.google.com
 [209.85.219.69]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-526-0XmS99QvMQGpVHbk7gpKVg-1; Fri, 21 Jul 2023 13:48:43 -0400
X-MC-Unique: 0XmS99QvMQGpVHbk7gpKVg-1
Received: by mail-qv1-f69.google.com with SMTP id 6a1803df08f44-635e664d2f8so25851266d6.3
        for <linux-scsi@vger.kernel.org>; Fri, 21 Jul 2023 10:48:43 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1689961723; x=1690566523;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=4gRIrwj0GsRbDsoQLu/wdlhqB+Zp6TWGF0yyPNQWXHs=;
        b=lTxTgLE92+u8Z64dvX4AJEWYRhVx25f+5QmZMVlbn1FYhMWwAiL+Hpt8QKNBTMuBQP
         USH6392Olm4K4gNRX5lkWor5wYRNLyKpW4sTZET7Qio+pdcri6tdWt4RKKF5rbxUwvmT
         zIpzID2/kJx1IdXlCP5IcUo0zqxLGJxabatE8TyVr/35MVr3oU5c/JFOuG0zNAlWMSiw
         /aEMCuSKBHnsVsJ81Y0IRMRM4F0wNCLHxCD+n3TfjUmXueUNeeL/SGpxbPGyDZJd5FLj
         WjZLeRZ5qyb+gAtGj7ODAtkOIF1A08t6ECICt1NmYwj8e6GXWbfswYFc2nowxaudqo6E
         /TCQ==
X-Gm-Message-State: ABy/qLb+67kVcuITiBT0fEPb7aJF3SSwDDqF/cyCycgaP2zkN6zFqRGK
        pc4ZrjAH5Sy71YoYIdmvZXh2tUfPlGxcy9ZXTYWEW0qhSOrnyWLRlI6gJIgxTatYon0qiT3/iRo
        /gHsQJvZjVRPe/YHpqY+++Q==
X-Received: by 2002:ac8:5747:0:b0:403:3af1:367a with SMTP id 7-20020ac85747000000b004033af1367amr852059qtx.2.1689961722954;
        Fri, 21 Jul 2023 10:48:42 -0700 (PDT)
X-Google-Smtp-Source: APBJJlHUAlmaZ0ilwuUmzRxDJ2XQlbKBL5/FDKlvMYBSPDJnNCvpuHetg+NbALbM4fNPG4WAxqB5cw==
X-Received: by 2002:ac8:5747:0:b0:403:3af1:367a with SMTP id 7-20020ac85747000000b004033af1367amr852047qtx.2.1689961722734;
        Fri, 21 Jul 2023 10:48:42 -0700 (PDT)
Received: from localhost (ip98-179-76-75.ph.ph.cox.net. [98.179.76.75])
        by smtp.gmail.com with ESMTPSA id d3-20020ac81183000000b00402364e77dcsm1388077qtj.7.2023.07.21.10.48.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Jul 2023 10:48:42 -0700 (PDT)
Date:   Fri, 21 Jul 2023 10:48:40 -0700
From:   Jerry Snitselaar <jsnitsel@redhat.com>
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     Saurav Kashyap <skashyap@marvell.com>, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, Nilesh Javali <njavali@marvell.com>
Subject: Re: [PATCH] bnx2fc: Remove dma_alloc_coherent to suppress the BUG_ON.
Message-ID: <benqe3zwp3go3w2s2fmhsyjft3d7vqiewffjqhb22y4hlpw5p4@46pxi3bd2zsn>
References: <20230721102320.9559-1-skashyap@marvell.com>
 <642a49ed-4920-9c74-40aa-81d5c859ce79@acm.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <642a49ed-4920-9c74-40aa-81d5c859ce79@acm.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Fri, Jul 21, 2023 at 07:58:26AM -0700, Bart Van Assche wrote:
> On 7/21/23 03:23, Saurav Kashyap wrote:
> > From: Jerry Snitselar <jsnitsel@redhat.com>
> > [ ... ]
> > Signed-off-by: Jerry Snitselar <jsnitsel@redhat.com>
> 
> Has Jerry's name changed or has his name been misspelled? I think
> a letter 'a' is missing from his name.

No, and yes. :)

This was originally passed along in a bugzilla bug as an example of a
possible solution, but I didn't figure it would be the final patch.

The original patch had the following summary and description above
the stack trace:

    scsi: bnx2fc: Don't use dma_*_coherent for session resources
    
    With commit f5ff79fddf0e ("dma-mapping: remove CONFIG_DMA_REMAP") a
    crash can be seen with bnx2fc, because dma_free_coherent can not be
    called in an interrupt context. Replace the dma_*_coherent code in
    bnx2fc_alloc_session_resc and bnx2fc_free_session_resc, with kzalloc +
    dma_map_single, and kfree + dma_unmap_single calls. Also properly
    unwind in the error path for bnx2fc_alloc_session_resc, cleaning up
    what it did succeed in allocating and mapping. This deals with seeing
    the following panic:


Regards,
Jerry

> 
> Bart.
> 

