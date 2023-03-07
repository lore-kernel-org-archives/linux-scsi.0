Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 29072C61DA4
	for <linux-scsi@archiver.kernel.org>; Tue,  7 Mar 2023 00:05:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229699AbjCGAFR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Mar 2023 19:05:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229490AbjCGAFQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Mar 2023 19:05:16 -0500
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D5A42ED50
        for <linux-scsi@vger.kernel.org>; Mon,  6 Mar 2023 16:04:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1678147465;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XRzwMAY6dMLYvd+td6596SXU0roelK6/wDv8HydDMT8=;
        b=flQwOurZhqu1R8Y+4MCAauGbLB6/MeuYA4zrv5dFi+xs/Yt+KFFBT4caSRfWPnogtM8X8B
        lmS8VVMqZOLRyRQ0jDJSV9TCwaEkt6Kq6Wbr+P8WOJWhw1vEeLJ2DtyVacHPD+UY7npzsk
        CV6QV2ev/x6lftNrAKtvoUfly3Y+rgw=
Received: from mail-vs1-f72.google.com (mail-vs1-f72.google.com
 [209.85.217.72]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-401-CCkAj9LwOSSxaFtEpEPoiA-1; Mon, 06 Mar 2023 19:04:24 -0500
X-MC-Unique: CCkAj9LwOSSxaFtEpEPoiA-1
Received: by mail-vs1-f72.google.com with SMTP id k12-20020a056102116c00b0041eb4da08b5so3994270vsg.7
        for <linux-scsi@vger.kernel.org>; Mon, 06 Mar 2023 16:04:24 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678147463;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XRzwMAY6dMLYvd+td6596SXU0roelK6/wDv8HydDMT8=;
        b=uIcxRK1vQXKnZwc34I9GFtroCOFVg7qL6ck9A5xpNax24mqz9KIkz0ugoAvVRNlM8M
         lUyozAAtPXV3hBWIGsWI9sfE0Zi+0vkBEP8OX2UUgAvVpxMocIo0xwcVAS1JBYIGPdjW
         EAx3i/vZaE5BV1/H5z4fsUESybSs/9o8dv/yNe37oYl0QbYCQVSY0H+new0jTeonwJbM
         oJqGMFyMLDDGCzGnGj37OQKzPlCnQEQQltPeYeo1FqY7J5tptScsaGN50D9XXiB/BGCK
         pkt/7z8IezZi3G+sC922TP68J+sa4IIIJ3ZKtQsoovwOfSeCXRbfd0GbprNTfI32e0fI
         oqxQ==
X-Gm-Message-State: AO0yUKWaSn9Rs03IZg2gyoMJ+839KCRBFyZh883COIS2L7euXmdI3khF
        Fub3HdY9rjYAMPPc+stThieLMl4gf7e/OKXmuiOkmkfqm2nnmF0XzfRPK3QEMXRIvMy5krfeVie
        LOkwna0mogsjUYofV4dvY1HqRJy+AabQG5EOM5Q==
X-Received: by 2002:a67:b142:0:b0:412:bca:d304 with SMTP id z2-20020a67b142000000b004120bcad304mr8720181vsl.7.1678147463827;
        Mon, 06 Mar 2023 16:04:23 -0800 (PST)
X-Google-Smtp-Source: AK7set9V/D1pjgdhUsl0fXqRewdPS0HDMk4dFxCO0sFcPY5/Yd6tfRlNDc3uhszExfM9lHZQjZMQx1HTjn1tWzfhfPg=
X-Received: by 2002:a67:b142:0:b0:412:bca:d304 with SMTP id
 z2-20020a67b142000000b004120bcad304mr8720167vsl.7.1678147463602; Mon, 06 Mar
 2023 16:04:23 -0800 (PST)
MIME-Version: 1.0
References: <20230304003103.2572793-1-bvanassche@acm.org> <20230304003103.2572793-3-bvanassche@acm.org>
In-Reply-To: <20230304003103.2572793-3-bvanassche@acm.org>
From:   Ming Lei <ming.lei@redhat.com>
Date:   Tue, 7 Mar 2023 08:04:12 +0800
Message-ID: <CAFj5m9+5r9FbPoBeMCWuymPzNrHwUab6WheZyYtyf_WH=VjeeQ@mail.gmail.com>
Subject: Re: [PATCH 02/81] scsi: core: Declare most SCSI host template
 pointers const
To:     Bart Van Assche <bvanassche@acm.org>
Cc:     "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, Christoph Hellwig <hch@lst.de>,
        Hannes Reinecke <hare@suse.de>,
        John Garry <john.garry@huawei.com>,
        Mike Christie <michael.christie@oracle.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Sat, Mar 4, 2023 at 8:31=E2=80=AFAM Bart Van Assche <bvanassche@acm.org>=
 wrote:
>
> Prepare for constifying most SCSI host template pointers by constifying
> the SCSI host template pointer arguments and variables in the SCSI core.
>
> Cc: Christoph Hellwig <hch@lst.de>
> Cc: Ming Lei <ming.lei@redhat.com>
> Cc: Hannes Reinecke <hare@suse.de>
> Cc: John Garry <john.garry@huawei.com>
> Cc: Mike Christie <michael.christie@oracle.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>

Reviewed-by: Ming Lei <ming.lei@redhat.com>

