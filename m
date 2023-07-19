Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 99899C0015E
	for <linux-scsi@archiver.kernel.org>; Wed, 19 Jul 2023 18:15:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229812AbjGSSPT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 19 Jul 2023 14:15:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48420 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229765AbjGSSPT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 19 Jul 2023 14:15:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7B87DB6
        for <linux-scsi@vger.kernel.org>; Wed, 19 Jul 2023 11:14:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1689790470;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=FPyLATJyncOfWwr+BjaorlQZp4BWYUBQYZoHTu3qX70=;
        b=RxDhlehQVjh1FXymiEhNLXLPvCEleUMEkcy13N+IrT/FHYGX62YcC76DORfv1OiOtlLDzs
        42Y26Va1vcwCtohgTJD7zBCmHip6kBrMlixqh+7l6allfoeIklFOm8sR/UfBCNPH1QsHLJ
        NL2l18nyHxVBnJevaB65GPnCMZc5ggs=
Received: from mimecast-mx02.redhat.com (mimecast-mx02.redhat.com
 [66.187.233.88]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-246-1rnTBtsPPzy298j9_exNcg-1; Wed, 19 Jul 2023 14:14:28 -0400
X-MC-Unique: 1rnTBtsPPzy298j9_exNcg-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 3DEA5185A793;
        Wed, 19 Jul 2023 18:14:28 +0000 (UTC)
Received: from rhel-developer-toolbox-latest (unknown [10.2.16.238])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id D170C40C206F;
        Wed, 19 Jul 2023 18:14:27 +0000 (UTC)
Date:   Wed, 19 Jul 2023 11:14:25 -0700
From:   Chris Leech <cleech@redhat.com>
To:     hanyu001@208suo.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: qla4xxx: Convert snprintf to scnprintf
Message-ID: <ZLgoARU6tZP8sMfT@rhel-developer-toolbox-latest>
References: <tencent_F14720A15AAC92683C94E88876A876E7FC05@qq.com>
 <4a69897245577acfb2f095501b21cd78@208suo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4a69897245577acfb2f095501b21cd78@208suo.com>
X-Scanned-By: MIMEDefang 3.1 on 10.11.54.1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Jul 17, 2023 at 02:18:31PM +0800, hanyu001@208suo.com wrote:
> Fix the following coccicheck warnings:
> 
> ./drivers/scsi/qla4xxx/ql4_attr.c:200:8-16: WARNING: use scnprintf or
> sprintf
> ./drivers/scsi/qla4xxx/ql4_attr.c:273:8-16: WARNING: use scnprintf or
> sprintf
> ./drivers/scsi/qla4xxx/ql4_attr.c:281:8-16: WARNING: use scnprintf or
> sprintf
> ./drivers/scsi/qla4xxx/ql4_attr.c:303:8-16: WARNING: use scnprintf or
> sprintf
> ./drivers/scsi/qla4xxx/ql4_attr.c:210:8-16: WARNING: use scnprintf or
> sprintf
> ./drivers/scsi/qla4xxx/ql4_attr.c:264:8-16: WARNING: use scnprintf or
> sprintf
> ./drivers/scsi/qla4xxx/ql4_attr.c:312:8-16: WARNING: use scnprintf or
> sprintf
> ./drivers/scsi/qla4xxx/ql4_attr.c:159:9-17: WARNING: use scnprintf or
> sprintf
> ./drivers/scsi/qla4xxx/ql4_attr.c:256:8-16: WARNING: use scnprintf or
> sprintf
> ./drivers/scsi/qla4xxx/ql4_attr.c:247:8-16: WARNING: use scnprintf or
> sprintf
> ./drivers/scsi/qla4xxx/ql4_attr.c:181:8-16: WARNING: use scnprintf or
> sprintf
> ./drivers/scsi/qla4xxx/ql4_attr.c:190:8-16: WARNING: use scnprintf or
> sprintf
> ./drivers/scsi/qla4xxx/ql4_attr.c:223:8-16: WARNING: use scnprintf or
> sprintf
> ./drivers/scsi/qla4xxx/ql4_attr.c:235:8-16: WARNING: use scnprintf or
> sprintf
> ./drivers/scsi/qla4xxx/ql4_attr.c:173:8-16: WARNING: use scnprintf or
> sprintf
> 
> Signed-off-by: ztt <1549089851@qq.com>

These should all be converted to sysfs_emit, and not scnprintf.

Thanks,
- Chris Leech

