Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 61FCAC433EF
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Jul 2022 13:11:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235845AbiGMNL6 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 13 Jul 2022 09:11:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235819AbiGMNL6 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 13 Jul 2022 09:11:58 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.129.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 832B3DBF
        for <linux-scsi@vger.kernel.org>; Wed, 13 Jul 2022 06:11:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1657717911;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=UCrelzCP57Cv6KnBFo49I91GxcTZsuGCeHP+3vdovVo=;
        b=TfLIn8HQiclsdZrBEehAgY5h3yBi61oKZKwFaIaKJao8dEELMSyDomB4ZpyZUV3pECC02s
        LAIE3mH7tioyLbIDZAl0UcPIIrhyATpl2glV/qGgc3yK0FrzrBltNEksYodZEDadGfYOTp
        5kavqh1m5ofg2gQP4uF5Xj3RUj5iu6I=
Received: from mimecast-mx02.redhat.com (mx3-rdu2.redhat.com
 [66.187.233.73]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 us-mta-133-uIa1xmKqNL-VzNqgR3SnxA-1; Wed, 13 Jul 2022 09:11:48 -0400
X-MC-Unique: uIa1xmKqNL-VzNqgR3SnxA-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.rdu2.redhat.com [10.11.54.1])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx02.redhat.com (Postfix) with ESMTPS id 123061C0F699;
        Wed, 13 Jul 2022 13:11:48 +0000 (UTC)
Received: from T590 (ovpn-8-16.pek2.redhat.com [10.72.8.16])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 639E640CFD05;
        Wed, 13 Jul 2022 13:11:44 +0000 (UTC)
Date:   Wed, 13 Jul 2022 21:11:40 +0800
From:   Ming Lei <ming.lei@redhat.com>
To:     Tasmiya Nalatwad <tasmiya@linux.vnet.ibm.com>
Cc:     linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Subject: Re: [linux-next] [5.19.0-rc1] kernel crashes while performing driver
 bind/unbind test with SLUB_DEBUG enabled
Message-ID: <Ys7EXeoVbLRZj9CL@T590>
References: <c1846219-cea9-e82c-7337-6f6d9ffadd3d@linux.vnet.ibm.com>
 <Yqksbtth8zzEmjp4@T590>
 <d789d8f6-71c3-3927-7708-141b43c3ba0b@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d789d8f6-71c3-3927-7708-141b43c3ba0b@linux.vnet.ibm.com>
X-Scanned-By: MIMEDefang 2.84 on 10.11.54.1
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Jul 13, 2022 at 03:49:05PM +0530, Tasmiya Nalatwad wrote:
> Greetings,
> 
> While running plain bind/unbind test on scsi I had enabled slub_debug
> 
> System has FC adapter with multipath enabled.
> 
> Step 1 : Added slub_debug in /etc/default/grub saved the configuration and
> rebooted the machine.
> Step 2 : Performed normal driver bind/unbind test.

Hello,

Can you try the following patches and see if they are helpful?


Thanks,
Ming

