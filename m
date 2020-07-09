Return-Path: <SRS0=/8H4=AU=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.4 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CB546C433DF
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jul 2020 17:25:55 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 97247207DA
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Jul 2020 17:25:55 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=redhat.com header.i=@redhat.com header.b="NOYWusZY"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728302AbgGIRZy (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Jul 2020 13:25:54 -0400
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:57916 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727768AbgGIRZy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Jul 2020 13:25:54 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594315553;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ayL2zRv44zVA/vI/qKLO5dT3uiTyNFjJ4KJMkaO+qQI=;
        b=NOYWusZYSTTYq/IlckNtUQYpRxNfZcVxesIbtldoNN71VjvdAgOv0gP5q30R2Lxp92O5aw
        jkK6znaffM53tuoCNCeCeFi+NdqlTSy0aPfXvCcptkne2UZg7N5S3xpqZhLNknWRQFjmbs
        EzQogn8ODiPjhr/kPtE3gFecOR2ThQE=
Received: from mail-wr1-f71.google.com (mail-wr1-f71.google.com
 [209.85.221.71]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-208-NmsLRgZyOeauRJPvITRGYA-1; Thu, 09 Jul 2020 13:25:50 -0400
X-MC-Unique: NmsLRgZyOeauRJPvITRGYA-1
Received: by mail-wr1-f71.google.com with SMTP id y18so2586994wrq.4
        for <linux-scsi@vger.kernel.org>; Thu, 09 Jul 2020 10:25:50 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ayL2zRv44zVA/vI/qKLO5dT3uiTyNFjJ4KJMkaO+qQI=;
        b=BSWCC2mduVq8XkfgWqmbpJDYvUYdbyagnxsjHKufSow2CcI76yHxwsDI8Siy/lASmP
         hdThbZU9oZdXBwq+FeYR5LyuXgWhAuRvnCUXzNkm6iL7tShbnMAAUXMhKlEVeT5Rtflx
         UWmHpNBlFN6mVHHPaZCBgO9K+LMj4f411wEQOsCzuzHkVfEajS8PS/LIgwrjOKfKEL6p
         FQBE0ghudvBMRc+UNPEZY3bBmxYUpfgbwo1XRHqCKZ1nODsTf5Q5cQ7a/G7T1K8KUbGk
         nA0PJEOZYcTjbGLoc+mmPqDYNWioBwUGldMCihdUBvmV6XXz7z1hFdBVB+/odECI7ZFJ
         46TA==
X-Gm-Message-State: AOAM530+RsE+pOYtU8EfUTSRg9mzKZ+0jr4a5vYog41RuaDbfV0Xdyk/
        1ot4JxneF8UP0poPajgxlJC0Uh9y/yf1YEWAYssPK2RhFM3ckdrbTLRqP4xvE1kg3A7BVRGlct4
        12RwBJj0H3bYmK7kR/Gx3kw==
X-Received: by 2002:a1c:28a:: with SMTP id 132mr1009951wmc.109.1594315549628;
        Thu, 09 Jul 2020 10:25:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw2sedbzLwqgP/3k7XdcalLS7M8QME+eSe2xcF5rOIoSPUGVWnnJi2vGFbzZPqABCs7ueR2IQ==
X-Received: by 2002:a1c:28a:: with SMTP id 132mr1009940wmc.109.1594315549388;
        Thu, 09 Jul 2020 10:25:49 -0700 (PDT)
Received: from ?IPv6:2001:b07:6468:f312:9541:9439:cb0f:89c? ([2001:b07:6468:f312:9541:9439:cb0f:89c])
        by smtp.gmail.com with ESMTPSA id c15sm5608087wme.23.2020.07.09.10.25.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 09 Jul 2020 10:25:48 -0700 (PDT)
Subject: Re: [PATCH] scsi: virtio_scsi: Remove unnecessary condition checks
To:     Markus Elfring <Markus.Elfring@web.de>,
        Xianting Tian <xianting_tian@126.com>,
        linux-scsi@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Cc:     kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org,
        "James E. J. Bottomley" <jejb@linux.ibm.com>,
        Jason Wang <jasowang@redhat.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Stefan Hajnoczi <stefanha@redhat.com>
References: <a197f532-7020-0d8e-21bf-42bb66e8daec@web.de>
From:   Paolo Bonzini <pbonzini@redhat.com>
Message-ID: <e87746e6-813e-7c0e-e21e-5921e759da5d@redhat.com>
Date:   Thu, 9 Jul 2020 19:25:47 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <a197f532-7020-0d8e-21bf-42bb66e8daec@web.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 09/07/20 19:16, Markus Elfring wrote:
>> +	mempool_destroy(virtscsi_cmd_pool);
>> +	virtscsi_cmd_pool = NULL;
>> +	kmem_cache_destroy(virtscsi_cmd_cache);
>> +	virtscsi_cmd_cache = NULL;
>>  	return ret;
>>  }
> 
> How do you think about to add a jump target so that the execution
> of a few statements can be avoided according to a previous
> null pointer check?

The point of the patch is precisely to simplify the code, executing a
couple more instruction is not an issue.

Paolo

