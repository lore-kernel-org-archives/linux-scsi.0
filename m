Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-4.2 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	URIBL_BLOCKED,USER_AGENT_SANE_2 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DB79DC433E0
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 09:14:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 9BD7622D58
	for <linux-scsi@archiver.kernel.org>; Tue, 12 Jan 2021 09:14:18 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389624AbhALJN4 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Jan 2021 04:13:56 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53588 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732726AbhALJN4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Jan 2021 04:13:56 -0500
Received: from mail-ej1-x634.google.com (mail-ej1-x634.google.com [IPv6:2a00:1450:4864:20::634])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E96B3C061575;
        Tue, 12 Jan 2021 01:13:15 -0800 (PST)
Received: by mail-ej1-x634.google.com with SMTP id t16so2400913ejf.13;
        Tue, 12 Jan 2021 01:13:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=IGnH6pyj0wE74SBCSOC+j1GpxuVSjHdGUM/hxz5Ygfk=;
        b=V98JukMSsmuUMqSi9DPSvZdEmlqy0JXdVny3xWqD7owk3L/i9UdbxkGVfwy0Wnscep
         fEQfC2vyMCxnAkbN0qHmjZ+XSPVNHSq6mu0mO85JsYayKyLEjdL3QernDvCfpb7iAIVx
         Vc+yF4UaY0k/tUJ+FFOye5sBQMePmiIdBZJAHkUn1B3LvLc+gdsLMZhsq4SCPy4P3xer
         ShciYCKA6QcG4Z91TMP2GYyjpauXfPjahMYj2BPAafqtZBqVhoBLcuKO1COkBBVxop36
         AgedPZaKGywaMv/4AM14NvpbPmUpPcBlPAT8eJn/M3BLZeIN+i0qQexg1G7iZzV5DRlH
         mx8Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=IGnH6pyj0wE74SBCSOC+j1GpxuVSjHdGUM/hxz5Ygfk=;
        b=YqRahtAV158TFJhIqaQKrWbrOc7kJ5bvXKztBxDsVPhXxACuBOY64p/qPFJxcfoEAO
         FV/QLcM8t8PrUXRv0yP84EfsnGQUKdkp/cPj+rh4Rreq9d9m8xJd9kVrtkclIAM2VQud
         IsC6tZnVsMAwdmTKd3Cz1WAx/eY89oA0XxOOkCfC3EQYhNbL2GEKZNRS6L4BtOqyRhm+
         hwQsB0XXJlVYba1/ApCdifD2PgwmwYdgtSiaddr+QL0bDfwY5CHiXwvWvhXO+dlj54xH
         zZUpXTMbUJ8LqQVmj3L7t0ixdCBwZ0A/b4Ix7AwxgqfIpVlqpd2xOqU5l/U3mv7J4DBG
         upzw==
X-Gm-Message-State: AOAM5319X7VmUfJg8HMkW4A6P1Gh+UYaHaolhHMBjg1qA+v7MCqqQn5J
        T1cx3qT7sq3DlrnTOKcqZho=
X-Google-Smtp-Source: ABdhPJxjjWv9r65cEz8v9s1G3B0tJaE3DJa9rNAq/RkKZ5bvbT4ptK+m+jTVy5c0kL8VqYlJrrxmuw==
X-Received: by 2002:a17:906:f949:: with SMTP id ld9mr2562029ejb.401.1610442794667;
        Tue, 12 Jan 2021 01:13:14 -0800 (PST)
Received: from ubuntu-laptop (ip5f5bfcff.dynamic.kabel-deutschland.de. [95.91.252.255])
        by smtp.googlemail.com with ESMTPSA id t8sm919063eju.69.2021.01.12.01.13.13
        (version=TLS1_2 cipher=ECDHE-ECDSA-CHACHA20-POLY1305 bits=256/256);
        Tue, 12 Jan 2021 01:13:14 -0800 (PST)
Message-ID: <cbc5782c0148422dd524ea1c825731d2232fb7e9.camel@gmail.com>
Subject: Re: [PATCH v2 1/2] scsi: hisi_sas: Remove unnecessary devm_kfree
From:   Bean Huo <huobean@gmail.com>
To:     John Garry <john.garry@huawei.com>, alim.akhtar@samsung.com,
        avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, ebiggers@google.com, satyat@google.com,
        shipujin.t@gmail.com
Cc:     linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bean Huo <beanhuo@micron.com>
Date:   Tue, 12 Jan 2021 10:13:13 +0100
In-Reply-To: <b34eac20-e194-783b-f29e-83eec8bb127c@huawei.com>
References: <20210111231058.14559-1-huobean@gmail.com>
         <20210111231058.14559-2-huobean@gmail.com>
         <b34eac20-e194-783b-f29e-83eec8bb127c@huawei.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.28.5-0ubuntu0.18.04.2 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Tue, 2021-01-12 at 09:03 +0000, John Garry wrote:
> On 11/01/2021 23:10, Bean Huo wrote:
> > From: Bean Huo <beanhuo@micron.com>
> > 
> > The memory allocated with devm_kzalloc() is freed automatically
> > no need to explicitly call devm_kfree.
> > 
> 
> This change is not right - we use devm_kfree() to manually release
> the 
> devm-allocated debugfs memories upon memory allocation failure for 
> driver debugfs feature during probe. The reason is that we allow the 
> driver probe can still continue (for this failure).
> 
> Thanks,
> John

yea, I see, probe didn't deal with ENOMEM error. will drop this change.
thanks.

Bean

