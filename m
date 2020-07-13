Return-Path: <SRS0=+RX4=AY=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id AAF98C433EB
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 11:53:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8889D20738
	for <linux-scsi@archiver.kernel.org>; Mon, 13 Jul 2020 11:53:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="yn3NsfAH"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729711AbgGMLxw (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 13 Jul 2020 07:53:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60236 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729581AbgGMLxv (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 13 Jul 2020 07:53:51 -0400
Received: from mail-wm1-x343.google.com (mail-wm1-x343.google.com [IPv6:2a00:1450:4864:20::343])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 81119C061755
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2020 04:53:51 -0700 (PDT)
Received: by mail-wm1-x343.google.com with SMTP id a6so13178074wmm.0
        for <linux-scsi@vger.kernel.org>; Mon, 13 Jul 2020 04:53:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=LqnxdlraFGa9oyC6Dgb6a9mOJnjee/T6OYCQNFyIlz8=;
        b=yn3NsfAHu+FbIXw3Q92w6Rs3PfR7AzddGXKTkkZN3Sjt5HbDm21Nt7B7NRDaZaW5q2
         KGPrl1rORhcNfB0tp6QcMj+cqdy22R+ZIHy+6AS16r/ee1MR9NYT5QQ+kRSzMKkc7WlJ
         VuUaFCIuxBTcPzmMQiRAvySDxAKlvvXFElboMKsCp/iwC6opkzVI3AvXaCEun3ScX1Gy
         QJwmpOU3qw2sT2XM8r7zYRuVBNSmo22fG9Lis5Sikq1ulkca0fIHBxZmdKLKMMFARY20
         j8v/5DyCyvZeSk0PML/VGuU5l8D/jqvHc9+c8I7iTkyNbx/YolQV5SuZqHs8qeanjHQu
         4fog==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=LqnxdlraFGa9oyC6Dgb6a9mOJnjee/T6OYCQNFyIlz8=;
        b=rO+yKGc89O7iSDNEEV9xHxlwNcyWWP7XgMWy4kfQhVUVwXLlnX53zEkRpRSldGqRqy
         yXeTSU8TlKLYCZnJejsddrKZ2hjAI7SkSGcLIA6Tcxu+dky5Ja2ETqaO9pLL6wYOFPm9
         c2b4ssOTUZtz5egcCez0EvhWAHN+IIStHmefCh+kVuytDvKb2mh972PeLEW3e4Jwg6Pg
         6G4qe6+nWuOxk4bxnjwjNwoNDk89JJrSx6N0IgkItH8r9gAWwzBgzC6unYhDQ1hjijQe
         aZ7ZkdGCRgOTELgZI4+1sLl00UU5MZ+H60zKDuze3dcEM/bJd0fJegufLVRrSZayDpOD
         7O1A==
X-Gm-Message-State: AOAM531FX8lqAyUqOU7Se3/lyozfieH56/BMrCQyEldecg7e8QmTgq31
        SGjroLHuO4KjQcHuo0WtXZTfOg==
X-Google-Smtp-Source: ABdhPJxjRNlt8Qj/SHfDfkN36guWr5K2uFmxbVr9DmVfJpCdP/YsDE++05I/pvn3FJdwDptIzOC2Sw==
X-Received: by 2002:a05:600c:2dc1:: with SMTP id e1mr17527976wmh.108.1594641230264;
        Mon, 13 Jul 2020 04:53:50 -0700 (PDT)
Received: from dell ([2.31.163.6])
        by smtp.gmail.com with ESMTPSA id z10sm24303484wrm.21.2020.07.13.04.53.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 13 Jul 2020 04:53:49 -0700 (PDT)
Date:   Mon, 13 Jul 2020 12:53:48 +0100
From:   Lee Jones <lee.jones@linaro.org>
To:     "Michael S. Tsirkin" <mst@redhat.com>
Cc:     jejb@linux.ibm.com, martin.petersen@oracle.com,
        linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org,
        Jason Wang <jasowang@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        virtualization@lists.linux-foundation.org,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2 12/24] scsi: virtio_scsi: Demote seemingly
 unintentional kerneldoc header
Message-ID: <20200713115348.GE3500@dell>
References: <20200713080001.128044-1-lee.jones@linaro.org>
 <20200713080001.128044-13-lee.jones@linaro.org>
 <20200713071453-mutt-send-email-mst@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200713071453-mutt-send-email-mst@kernel.org>
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, 13 Jul 2020, Michael S. Tsirkin wrote:

> On Mon, Jul 13, 2020 at 08:59:49AM +0100, Lee Jones wrote:
> > This is the only use of kerneldoc in the sourcefile and no
> > descriptions are provided.
> > 
> > Fixes the following W=1 kernel build warning(s):
> > 
> >  drivers/scsi/virtio_scsi.c:109: warning: Function parameter or member 'vscsi' not described in 'virtscsi_complete_cmd'
> >  drivers/scsi/virtio_scsi.c:109: warning: Function parameter or member 'buf' not described in 'virtscsi_complete_cmd'
> > 
> > Cc: "Michael S. Tsirkin" <mst@redhat.com>
> > Cc: Jason Wang <jasowang@redhat.com>
> > Cc: Stefan Hajnoczi <stefanha@redhat.com>
> > Cc: virtualization@lists.linux-foundation.org
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> > Acked-by: Paolo Bonzini <pbonzini@redhat.com>
> 
> Acked-by: Michael S. Tsirkin <mst@redhat.com>

Thank you Michael.

> Pls merge with the rest of the patches (which tree is this for?)

My assumption is that Martin will take all of these (and the other
sets) via the SCSI repo.

-- 
Lee Jones [李琼斯]
Senior Technical Lead - Developer Services
Linaro.org │ Open source software for Arm SoCs
Follow Linaro: Facebook | Twitter | Blog
