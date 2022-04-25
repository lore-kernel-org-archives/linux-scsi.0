Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 37241C433EF
	for <linux-scsi@archiver.kernel.org>; Mon, 25 Apr 2022 06:30:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234633AbiDYGdj (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 25 Apr 2022 02:33:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43330 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234073AbiDYGdg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 25 Apr 2022 02:33:36 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id DA6D05C66D
        for <linux-scsi@vger.kernel.org>; Sun, 24 Apr 2022 23:30:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1650868229;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=aAOYuvjf2Z99uDXXSQv74Ccz3QD2873YQUreZ0ql7qg=;
        b=aCR/kC7JUs22dbXIYIjsbKPHD80ONfhbVGIvstTgd+oSZb2Z/6rOI0Kom5TS5EAGQ3Ys0/
        Uyhd9bayZPJryPPAjOp2fC0fmRE9h14QIGIe6pDwbDRyc/m5gj5bD5AmszB8iQwopSTY7y
        mVcqCxELm0WbN9fSlqTfptnJh38LhsM=
Received: from mail-wm1-f71.google.com (mail-wm1-f71.google.com
 [209.85.128.71]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-244-9Vj6d0ldMxG7Tkx5Ww-pGg-1; Mon, 25 Apr 2022 02:30:28 -0400
X-MC-Unique: 9Vj6d0ldMxG7Tkx5Ww-pGg-1
Received: by mail-wm1-f71.google.com with SMTP id q6-20020a1cf306000000b0038c5726365aso6774691wmq.3
        for <linux-scsi@vger.kernel.org>; Sun, 24 Apr 2022 23:30:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=aAOYuvjf2Z99uDXXSQv74Ccz3QD2873YQUreZ0ql7qg=;
        b=zY4jTrfZ8EXfrJyaQWeD80pEzbJcDWSXzdxEktZ+dWsvQgb4/4gH/Ze2GqSI3GBg6P
         k6bkbDqn9wObSh1XhRpkM4gEFIgHtMVqnKxmbUTEnwyLmF5rlikCPfufxwUspdIzD/9R
         OoM9AelZb6FQClb/yQSq7MalN3RxI+G7YLEkE47Y8Myi1l7+Qlwj/vAAaoj6/sWdFCgG
         U8uP7EGem1c9I8hyrkBlTRTF/6AsvJVphpab5kVfHsk7B11qUCw6auZ4gVs7Mk65tpUu
         J4A9ivs3IPW+xIzlZZaEW/tkVqkuZhAM9T03QHvtqTU53eTIaCI5tlJMi+fqd3iLhmmE
         7K7A==
X-Gm-Message-State: AOAM531QpwfPWQxovAGUfXgPgJUyiq7N4mEDWuywsc/glsX2PjLJPBV+
        O4RjAzGE0RAVoPrLIA8lLDu6oA1qWkWhJhOWb3JdxP8S2Nr9keIaKTDb9nLibGEK+IrpdfzZ5NK
        PsLJcNpCZLYWTyzhnH7f23vpo+OztAMRvGxygNQ==
X-Received: by 2002:a05:600c:9:b0:393:ea67:1c68 with SMTP id g9-20020a05600c000900b00393ea671c68mr5025000wmc.92.1650868226844;
        Sun, 24 Apr 2022 23:30:26 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJwAoDTDAKFjxim6H5YkAIkiTcgJdHJuZ/7yrd6jlXj5gjsXYS0x2kfi3vCAVupOziM5SgpoxAFaiez+KFVqRhA=
X-Received: by 2002:a05:600c:9:b0:393:ea67:1c68 with SMTP id
 g9-20020a05600c000900b00393ea671c68mr5024988wmc.92.1650868226606; Sun, 24 Apr
 2022 23:30:26 -0700 (PDT)
MIME-Version: 1.0
References: <069b69ad-5aeb-5612-ae16-cb780ee067f9@cornelisnetworks.com> <16e64a18-6f59-bda3-4058-31fed422d82f@oracle.com>
In-Reply-To: <16e64a18-6f59-bda3-4058-31fed422d82f@oracle.com>
From:   Maurizio Lombardi <mlombard@redhat.com>
Date:   Mon, 25 Apr 2022 08:30:15 +0200
Message-ID: <CAFL455=6+XqBLXC54UNHkdWW8xqpp3oOmU5HFPOQX+PfOHA8Cw@mail.gmail.com>
Subject: Re: Problems removing ramdisk backed luns
To:     Mike Christie <michael.christie@oracle.com>
Cc:     Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        mingzhe.zou@easystack.cn, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, target-devel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

=C4=8Dt 14. 4. 2022 v 23:14 odes=C3=ADlatel Mike Christie
<michael.christie@oracle.com> napsal:
>
> Zou fixed this in the current rtslib tree:
>
> https://github.com/open-iscsi/rtslib-fb/commit/8d2543c4da62e962661011fea5=
b19252b9660822
>
> If you grab that patch and are running the upstream kernel you
> probably also want:
>
> https://github.com/open-iscsi/rtslib-fb/pull/184
>
> which should fix a warning you might see after you apply Zou's fix

I will release a new version of rtslib tomorrow, so the distros can
update their packages.

Maurizio

