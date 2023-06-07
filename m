Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 2FC31C7EE2F
	for <linux-scsi@archiver.kernel.org>; Wed,  7 Jun 2023 01:21:09 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240475AbjFGBVH (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 6 Jun 2023 21:21:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240461AbjFGBU6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Jun 2023 21:20:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1496FE6B
        for <linux-scsi@vger.kernel.org>; Tue,  6 Jun 2023 18:20:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1686100819;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=qGEHQH/dGpmg+Jhug+Ls4D+Tdbcp6OnKOZC6+fEmDVg=;
        b=FxLZuwXpYZ97yhP4RqRe4NW80GbU4uRUNdAgZhjkMBzkUDGGfhnuQOZZ/fLUw9OBqjPkuN
        SDZWZOOp4PaB/CtZkV5QArGp9JoM7LUMvMAeTQBfYX4dqnvgATWxcEAWJubZ98NBNaNJUD
        mxaoq9/9CHzRdEO5metdjUS0soaq32E=
Received: from mail-vs1-f70.google.com (mail-vs1-f70.google.com
 [209.85.217.70]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-647-uNXBKirZOdyHXygn1DC0zw-1; Tue, 06 Jun 2023 21:20:17 -0400
X-MC-Unique: uNXBKirZOdyHXygn1DC0zw-1
Received: by mail-vs1-f70.google.com with SMTP id ada2fe7eead31-43c42175872so20884137.1
        for <linux-scsi@vger.kernel.org>; Tue, 06 Jun 2023 18:20:17 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1686100817; x=1688692817;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=qGEHQH/dGpmg+Jhug+Ls4D+Tdbcp6OnKOZC6+fEmDVg=;
        b=dFtGF+7NG9gsIRYG54Y/V347S23n9LPqYFN0gucvCcAfSRj/Lt8ASb2kzAIitezihR
         WnZch2xfBorHUwbn+QdoxZmNMymwsuPdVvxhb4w37vkYxiF2r6P8QU64YZBnTQ7owsfV
         8GNX+Q29ELz8ZC1PN6FrDweaH+q6wGc56XcFFtUIobd9kAZLCPBC2UZa75k287yMlwzg
         CaJSkxCd1rdiCgcjxTf1qVGMsmfuJ8HLKnICSjNt7kGzAG93e2RJH3KahVHbOhxCjmf8
         3noeI9GWuw2EOVDYDyeGSZQLU9azTAemz3VoIf3BZY24EsL8drzbiPaIAc+5iowNFp44
         Wlrg==
X-Gm-Message-State: AC+VfDweab06TgBToB9jjg+nU/hdpgTABRHOKsG1b84DP0QcNmJyZ4uf
        2V6jhym9MMps+Rmy3+NKaKIz2UIHgW6G1772G72WnUw2qu+T94sJpJ4s+8bpz0J5Gle+pR/ixeS
        BEZ8icxvyKA92XWKcHkv5+4wYhXeLTyC6pVCmFg==
X-Received: by 2002:a05:6102:5121:b0:425:cf4e:f58 with SMTP id bm33-20020a056102512100b00425cf4e0f58mr1593149vsb.2.1686100817287;
        Tue, 06 Jun 2023 18:20:17 -0700 (PDT)
X-Google-Smtp-Source: ACHHUZ4tvkBBtCkFMOto9z7RJD3p455MoOxxtmj42Gna8mX89BjHPvyAtv78zxYrHdGdjJ3nV0tmgoKXvgVFgV7tXH4=
X-Received: by 2002:a05:6102:5121:b0:425:cf4e:f58 with SMTP id
 bm33-20020a056102512100b00425cf4e0f58mr1593137vsb.2.1686100817038; Tue, 06
 Jun 2023 18:20:17 -0700 (PDT)
MIME-Version: 1.0
References: <20230606193845.9627-1-mwilck@suse.com>
In-Reply-To: <20230606193845.9627-1-mwilck@suse.com>
From:   Ming Lei <ming.lei@redhat.com>
Date:   Wed, 7 Jun 2023 09:20:06 +0800
Message-ID: <CAFj5m9+2jejQr2ZM=Nre0__n3Fjc8OyDphm=GnPTbHC_gCHUrg@mail.gmail.com>
Subject: Re: [PATCH v2 0/3] scsi: fixes for targets with many LUNs
To:     mwilck@suse.com
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Christoph Hellwig <hch@lst.de>,
        Bart Van Assche <Bart.VanAssche@sandisk.com>,
        James Bottomley <jejb@linux.vnet.ibm.com>,
        linux-scsi@vger.kernel.org, linux-block@vger.kernel.org,
        Hannes Reinecke <hare@suse.de>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jun 7, 2023 at 3:38=E2=80=AFAM <mwilck@suse.com> wrote:
>
> From: Martin Wilck <mwilck@suse.com>
>
> This patch series addresses some issues we saw in a test setup
> with a large number of SCSI LUNs. The first two patches simply
> increase the number of available sg and bsg devices. The last one
> fixes an large delay we encountered between blocking a Fibre Channel
> remote port and the dev_loss_tmo.
>
> Changes v1 -> v2:
>  - call blk_mq_wait_quiesce_done() from scsi_target_block() to
>    cover the case where BLK_MQ_F_BLOCKING is set (Bart van Assche)


Reviewed-by: Ming Lei <ming.lei@redhat.com>

Thanks,

