Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E6A8CC4332F
	for <linux-scsi@archiver.kernel.org>; Mon,  6 Nov 2023 13:44:23 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232700AbjKFNoZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 6 Nov 2023 08:44:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38624 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232625AbjKFNoX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Nov 2023 08:44:23 -0500
Received: from mail-ej1-x632.google.com (mail-ej1-x632.google.com [IPv6:2a00:1450:4864:20::632])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF3A713E
        for <linux-scsi@vger.kernel.org>; Mon,  6 Nov 2023 05:44:20 -0800 (PST)
Received: by mail-ej1-x632.google.com with SMTP id a640c23a62f3a-9e1021dbd28so96663866b.3
        for <linux-scsi@vger.kernel.org>; Mon, 06 Nov 2023 05:44:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1699278259; x=1699883059; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:from:to:cc:subject:date:message-id:reply-to;
        bh=q7e9Ec68Ydmk63OSQsConTxB03oSMTJh6BRkMmt0d9Q=;
        b=CFiq9kxQ6L5v+VEMUaAnW1eP2+D2lSjPOwFh49bcjoukS7WDcwu7d7ZaF8TrZx3GQ2
         VFwc08ajL9hr+R8TwD8eUEzruP0kThul84LT+H8ua0WZeUm12xW1n70hfvvxuO6uBruO
         gL3nvVkVNiGgV5E4MRl4jvttzLv/AqYlW7vvI594AUcIx9caDNNrzJzGPFfMTvJfD8wj
         BtdLRJkK8d/2nDNvtL0xdY1lou39kTbiVenDvdROqw3MuBovCee6NEyFZ5J2TMJed5r7
         8qqRhLirOvTjcNfNIG8fEJuoDXVtgDe44dE/QrSPBDBsG+PporWhuvzgPe9dF7CHqJJZ
         M7ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1699278259; x=1699883059;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=q7e9Ec68Ydmk63OSQsConTxB03oSMTJh6BRkMmt0d9Q=;
        b=TTF4EkTkoIXLS0L9gB7GSHsU98/3gTqxDwm1N6puVKmjf0CzgwMSobjX89h7hxguYb
         3azI7dttVTaecxurFdHdBOA3O2q092jFpvkgd3PivsWAMDdCSL/0H/VAQUYrxpX6gxpo
         jei7kOG/9vEwiqVk+MXQr9T84r2c4LxFR+FqvBc5sKgLlOgwa8QIr8THcDQwndcfyg4S
         BBJD6W4AvXrxnn/RHZFqSyTkaTvdqjVGiwZzU9QjPQUj/q+K2E1qV/7qo4IpEee2G8ck
         7eUpsxBnQYQKAiTpGh3TMYzAPqkYKYZRF5l9rdyLXTTv/DHBxrJb7Jcr00jeSSDtsaEx
         0QIQ==
X-Gm-Message-State: AOJu0YzwO04oVKoKqDC64G0QHyS/nPGBb0YowRVuJCuoDJRpiTZi3tbX
        z1gWZ5ivUuF41QDA8HzGc8W9Zw==
X-Google-Smtp-Source: AGHT+IHiakzgI6LCjuKf2DUxW4dwg+isgj008eu/G7z8A0PZqUSpMz2yarqnNJAljDV/TJ/7ffeHxQ==
X-Received: by 2002:a17:907:26c9:b0:9e0:dde:cc9f with SMTP id bp9-20020a17090726c900b009e00ddecc9fmr3038620ejc.22.1699278259262;
        Mon, 06 Nov 2023 05:44:19 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id jw24-20020a17090776b800b0098e78ff1a87sm4144742ejc.120.2023.11.06.05.44.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Nov 2023 05:44:18 -0800 (PST)
Date:   Mon, 6 Nov 2023 16:44:16 +0300
From:   Dan Carpenter <dan.carpenter@linaro.org>
To:     Wenchao Hao <haowenchao22@gmail.com>
Cc:     Wenchao Hao <haowenchao2@huawei.com>,
        Eugeniy Paltsev <Eugeniy.Paltsev@synopsys.com>,
        Vinod Koul <vkoul@kernel.org>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        Douglas Gilbert <dgilbert@interlog.com>,
        dmaengine@vger.kernel.org, linux-scsi@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 1/2] scsi: scsi_debug: fix some bugs in
 sdebug_error_write()
Message-ID: <ea7dff5a-3a5d-414d-8a8c-a737c8ec8004@kadam.mountain>
References: <96d50cf7-afec-46af-9d98-08099f8dc76e@moroto.mountain>
 <CAOptpSMTgGwyFkn8o6qAEnUKXh+_mOr8dQKAZUWfM_4QEnxzxw@mail.gmail.com>
 <44b0eca3-57c1-4edd-ab35-c389dc976273@kadam.mountain>
 <cbe14e3a-11c7-4da5-b125-5801244e27f2@gmail.com>
 <9767953c-480d-4ad9-a553-a45ae80c572b@kadam.mountain>
 <afe1eca8-cdf8-612b-867e-4fef50ad423f@huawei.com>
 <9207ed62-4e41-4b8c-8aee-5143c1a71bf8@kadam.mountain>
 <65b8f53d-4956-4440-bd4c-66475015aaff@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <65b8f53d-4956-4440-bd4c-66475015aaff@gmail.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Oh.  Duh.  The issue is that echo doesn't actually put a NUL terminator
on the end of the string...  Let's go with kzalloc(count + 1, as you
suggest.

regards,
dan carpenter

