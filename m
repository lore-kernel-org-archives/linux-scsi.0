Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.7 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7A78AC4338F
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Aug 2021 15:24:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 52CDF610A8
	for <linux-scsi@archiver.kernel.org>; Mon,  2 Aug 2021 15:24:46 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234852AbhHBPYz (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 2 Aug 2021 11:24:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234789AbhHBPYy (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 2 Aug 2021 11:24:54 -0400
Received: from mail-wr1-x433.google.com (mail-wr1-x433.google.com [IPv6:2a00:1450:4864:20::433])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 09697C061760
        for <linux-scsi@vger.kernel.org>; Mon,  2 Aug 2021 08:24:44 -0700 (PDT)
Received: by mail-wr1-x433.google.com with SMTP id h13so8454878wrp.1
        for <linux-scsi@vger.kernel.org>; Mon, 02 Aug 2021 08:24:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=message-id:subject:from:to:cc:date:in-reply-to:references
         :user-agent:mime-version:content-transfer-encoding;
        bh=ebknOusjh/yi4rvlQyvQU3B8lOo8KXDPlVtM0QgkjMk=;
        b=Tj4gfaGQ0jry5fjeeWsUa3YShEsZbJyB7zbHH6r8VALuZRhM2/ktZkypKgkAiI5xXJ
         OOhAl9ude5Mba0LdkoDEN8Wb8jzE+F7JX9mNJsd26JlQ8CxbKRHvpVPc5pSkoGRkb2o0
         QaffUTiUAj4JiLPtizd8l0RqaaKTLT+2HBb7r1F7KWM302N+zVnHqTKBHHP6Oud+gh/U
         2OB8+RSnplHmn92zHF1IKf5vaVLEQwRIM+mcvoLkeWlyMo/V+sIyL/1Uxh7hzuP73xJ3
         +nRhWaRMqzxVbcfRkFMmEO+I8LkpRkG9srk06pHEkh+WkQcq4G5IZo85QlEjJLyMskMI
         WIXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:message-id:subject:from:to:cc:date:in-reply-to
         :references:user-agent:mime-version:content-transfer-encoding;
        bh=ebknOusjh/yi4rvlQyvQU3B8lOo8KXDPlVtM0QgkjMk=;
        b=Ky2MLHyYKodk4wUhfiNLznvpGaG4Hof393k5FWu+F0B6Sq2paxtHWgmX7l0aQxkud0
         lY9GEyQzAA+S8m61TnbGAnXIqcx8uQSzN+DOa1AxfPtnSCPnbJDBrrSfEF+NYAAPs2Xe
         AaKr2TiwmgEEPD9w0NyokaVbx45NXyu+Pa1JeLcw24UdYTwVgPGaldxgRqyuLzbVf/nG
         rlcfLB6ukrHXOQpaJXjSLv5tG6Q9wWAs4Y9deCpHxgJqaQZj5rRfc6Wy0rvGHVL3T0vf
         4WvsdScEEBMEyqspXUtXbi+54WpHbgrA/O2S4lAAeyYqm5R+dEDHTyVhf3MYzHuQyZGk
         oo/Q==
X-Gm-Message-State: AOAM531MqltVHzmfYWyjmhYD94Ac4PzNLPoaZKP2lrk4IiQrR2xcU4v4
        iLcAyDhsWUpcio1jHGg7XBQ=
X-Google-Smtp-Source: ABdhPJxjggRgjhynOfR4Mf8NxVdFNMZvQO7/+CGtJdnP9FjZbghiMhR4GXI8vh2RPcu6f9SGjXmegw==
X-Received: by 2002:a5d:4b4e:: with SMTP id w14mr18099569wrs.341.1627917882724;
        Mon, 02 Aug 2021 08:24:42 -0700 (PDT)
Received: from ubuntu-laptop (ip5f5bfdd7.dynamic.kabel-deutschland.de. [95.91.253.215])
        by smtp.googlemail.com with ESMTPSA id p10sm4150690wme.30.2021.08.02.08.24.41
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Aug 2021 08:24:42 -0700 (PDT)
Message-ID: <779aae9841331229e29fd3be23de55cec776af16.camel@gmail.com>
Subject: Re: [PATCH v3 11/18] scsi: ufs: Revert "Utilize Transfer Request
 List Completion Notification Register"
From:   Bean Huo <huobean@gmail.com>
To:     Bart Van Assche <bvanassche@acm.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org, Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Stanley Chu <stanley.chu@mediatek.com>,
        Can Guo <cang@codeaurora.org>,
        Asutosh Das <asutoshd@codeaurora.org>,
        Avri Altman <avri.altman@wdc.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Bean Huo <beanhuo@micron.com>,
        Kiwoong Kim <kwmad.kim@samsung.com>,
        Keoseong Park <keosung.park@samsung.com>,
        Caleb Connolly <caleb@connolly.tech>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>
Date:   Mon, 02 Aug 2021 17:24:41 +0200
In-Reply-To: <20210722033439.26550-12-bvanassche@acm.org>
References: <20210722033439.26550-1-bvanassche@acm.org>
         <20210722033439.26550-12-bvanassche@acm.org>
Content-Type: text/plain; charset="UTF-8"
User-Agent: Evolution 3.36.5-0ubuntu1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, 2021-07-21 at 20:34 -0700, Bart Van Assche wrote:
> Using the UTRLCNR register involves two MMIO accesses in the hot path
> while
> using the doorbell register only involves a single MMIO access. Since
> MMIO
> accesses take time, do not use the UTRLCNR register. The spinlock
> contention
> on the SCSI host lock that is reintroduced by this patch will be
> addressed
> by a later patch.
> 
> This reverts commit 6f7151729647e58ac7c522081255fd0c07b38105.
> 
> Cc: Adrian Hunter <adrian.hunter@intel.com>
> Cc: Stanley Chu <stanley.chu@mediatek.com>
> Cc: Can Guo <cang@codeaurora.org>
> Cc: Asutosh Das <asutoshd@codeaurora.org>
> Cc: Avri Altman <avri.altman@wdc.com>
> Signed-off-by: Bart Van Assche <bvanassche@acm.org>
> 

Hi Bart, 

I did the comparison test on my platform, it is very difficult to get a
very clear and fair result between two changes. but lamely speaking, on
the small chunk size read/write, your changes wins. but on the big
chunk size, It is not very clear, the gap between the two changes can
be ignored.

Tested-by: Bean Huo <beanhuo@micron.com>

Bean

