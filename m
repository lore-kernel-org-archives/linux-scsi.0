Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 271FECDB474
	for <linux-scsi@archiver.kernel.org>; Tue, 17 Oct 2023 13:56:14 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343894AbjJQN4M (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 17 Oct 2023 09:56:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1343571AbjJQN4L (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 17 Oct 2023 09:56:11 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41EF2F0
        for <linux-scsi@vger.kernel.org>; Tue, 17 Oct 2023 06:56:10 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id ffacd0b85a97d-32d9effe314so3391710f8f.3
        for <linux-scsi@vger.kernel.org>; Tue, 17 Oct 2023 06:56:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google; t=1697550969; x=1698155769; darn=vger.kernel.org;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=IyrTVojCdiQadpLB7YTHpYm3Mpi8Y2PLmKXB12se9s4=;
        b=j6WWDm3T83eIyzqyiAmEVSXDcjWK1JrdXsybOT6vm862A/wpIiATZBQaICXdUPvKLo
         itdPPUeN4PwvN8mfI/SXgVXOgvfbWT7BjD6FCeHMfmnGS13rvvnot6EhFkwF+Ac3jUmK
         9DBdZKB3Sb5JbJHJhA/xQbgvy4Fgc01tc4N5SLEZxVqSd9BD/qGD0bwC1pwO1TTTydu4
         8TMyexbAdi33kby+qB1rmFWBh4WxcuVC25wVSYiY/rOt/15DwLdqLsGPgB1MVPQG/ofc
         QzbnH9R1kqFAfyhdO0EMN+oxn+IaSKf/DhqN3SIzUJWnef6BE6Lhme7RLbkcr7PSoJXo
         eXWg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1697550969; x=1698155769;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=IyrTVojCdiQadpLB7YTHpYm3Mpi8Y2PLmKXB12se9s4=;
        b=CFNC3ly8bcSslIVza/wtkg5rS+PeAckZLz4oiobhVqMi86y5a3aOua72xMTVuYNtjL
         mj4YMITJisuFm/VaGzM13JRHKWv7PHo1TlFdNmziL2AFcUKmGf+GjLJx5xwZUfwwEu25
         dp5S7OL4TTCRtegY1G1IIe5Q/ewqL+iOf0W9T+Y/g2jjVkt8ePjj7YRBu61PAorCVHrS
         9ecdIa8fx5LYaujv3ziO9QRDEVIL/NVFzKGszsjNIXkElieRE234FdrXvcHCxESxPjGD
         t6kYT7rqr5SF/z3jYPDXTihlDd9j+xxAGk8ir4XneJVEkTRJLDwaFQ7YCQh49qRhb98i
         WcCw==
X-Gm-Message-State: AOJu0YxDGrgkw2wZ4eQhj6WoFgDDlgPNcu93o83ZY5JHUaoTaXSZ/sMR
        fTr3u+N9kg77XSOL0E6CH64PFA==
X-Google-Smtp-Source: AGHT+IHh/7hfzigzWw+/BZ0FxWQWtRypmmOqLXHBeKcpTZXHRHL0Q+s8cvUJgQHD8GjC2MSyqNrn2Q==
X-Received: by 2002:a5d:55d1:0:b0:32d:a0ab:9bae with SMTP id i17-20020a5d55d1000000b0032da0ab9baemr2001393wrw.57.1697550968668;
        Tue, 17 Oct 2023 06:56:08 -0700 (PDT)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id o14-20020a5d62ce000000b0031779a6b451sm1732650wrv.83.2023.10.17.06.56.07
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 17 Oct 2023 06:56:08 -0700 (PDT)
Date:   Tue, 17 Oct 2023 16:56:04 +0300
From:   Dan Carpenter <dan.carpenter@linaro.org>
To:     hare@suse.de
Cc:     linux-scsi@vger.kernel.org
Subject: [bug report] scsi: megaraid: Pass in NULL scb for host reset
Message-ID: <731d9834-76a7-4e01-be8e-f2850c50b45a@moroto.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello Hannes Reinecke,

The patch 5bcd3bfbda02: "scsi: megaraid: Pass in NULL scb for host
reset" from Oct 2, 2023 (linux-next), leads to the following Smatch
static checker warning:

    drivers/scsi/megaraid.c:1901 megaraid_reset()
    error: NULL dereference inside function 'megaraid_abort_and_reset()'

    drivers/scsi/megaraid.c:1940 megaraid_abort_and_reset()
    warn: variable dereferenced before check 'cmd' (see line 1928)

drivers/scsi/megaraid.c
    1899         spin_lock_irq(&adapter->lock);
    1900 
--> 1901         rval =  megaraid_abort_and_reset(adapter, NULL, SCB_RESET);
                                                           ^^^^
The debug code dereferences this unconditionally...

    1902 
    1903         /*
    1904          * This is required here to complete any completed requests
    1905          * to be communicated over to the mid layer.
    1906          */
    1907         mega_rundoneq(adapter);
    1908         spin_unlock_irq(&adapter->lock);
    1909 
    1910         return rval;
    1911 }

regards,
dan carpenter
