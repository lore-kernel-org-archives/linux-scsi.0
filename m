Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E7F89C433F5
	for <linux-scsi@archiver.kernel.org>; Tue, 19 Apr 2022 20:28:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353340AbiDSUbl (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 19 Apr 2022 16:31:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346273AbiDSUbj (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Apr 2022 16:31:39 -0400
Received: from mail-pf1-f173.google.com (mail-pf1-f173.google.com [209.85.210.173])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11A413A5FE
        for <linux-scsi@vger.kernel.org>; Tue, 19 Apr 2022 13:28:56 -0700 (PDT)
Received: by mail-pf1-f173.google.com with SMTP id p8so9426883pfh.8
        for <linux-scsi@vger.kernel.org>; Tue, 19 Apr 2022 13:28:56 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=BGFL3x3e4ssqpOzhcDAAWRAaricLfZPYyPhyZ4LgZzo=;
        b=a37HkN97qhFqYhVvW3MyismyMSJ95MnSfMo6gxrHnMpEha4+CleKMA3Zzsb/O8kVtm
         +C8b69lokE6TejMcQaGGkH8Pv6OLMKxRjJ8bnhRCwgJ4GhtDRKkalebzZX76a1l4FGiR
         hzjN1A7ZqnYBE0XfvTSI/LPnPTotL83l/hJAN35egjc86dDXqJcylR2oJVq6O9kTMnPN
         1J0NodN86otW3xCaBdjGtk/GrjOHlqkmsfeleHjRs9gRmUttBfIbuxTsxdfDBB0AjDjL
         ailkDiqRxLKC3iUm8TSl5YP+BJsatbHzqS6pG1YpZ0DDpdGaHkcenTAxXuiC0Kei7pMA
         XqDA==
X-Gm-Message-State: AOAM531GWXc+FHnR9ljQ6aYe1hJzkizSmwtU5dq7z3FOO4TDwYdSWcDz
        8AL/QkoLIJbZLRenbSzSkfs=
X-Google-Smtp-Source: ABdhPJzrD7wFFgO92Da3/Yv3Hue0mm4Aj16/C/bIQzTf6AHQk0Src+7KH9u6QF6xSlbCaq8c4jckNA==
X-Received: by 2002:a63:541f:0:b0:399:3007:e7a2 with SMTP id i31-20020a63541f000000b003993007e7a2mr16235084pgb.568.1650400135440;
        Tue, 19 Apr 2022 13:28:55 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:59ec:2e90:f751:1806? ([2620:15c:211:201:59ec:2e90:f751:1806])
        by smtp.gmail.com with ESMTPSA id i2-20020a17090a138200b001cb6512b579sm16653700pja.44.2022.04.19.13.28.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 19 Apr 2022 13:28:54 -0700 (PDT)
Message-ID: <0d0c979e-5e16-e35b-e185-b53ddfc68abb@acm.org>
Date:   Tue, 19 Apr 2022 13:28:52 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH v2 29/29] scsi: ufs: Split the drivers/scsi/ufs directory
Content-Language: en-US
To:     Bean Huo <huobean@gmail.com>,
        "Martin K . Petersen" <martin.petersen@oracle.com>
Cc:     Jaegeuk Kim <jaegeuk@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        linux-scsi@vger.kernel.org, Avri Altman <avri.altman@wdc.com>,
        Bean Huo <beanhuo@micron.com>
References: <20220412181853.3715080-1-bvanassche@acm.org>
 <20220412183228.3729720-1-bvanassche@acm.org>
 <492cd10d-9964-6a5c-2896-9fc0d5397a54@acm.org>
 <e2cb03ed21a52e1bfd0d6eb197b43ebea6f9abba.camel@gmail.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <e2cb03ed21a52e1bfd0d6eb197b43ebea6f9abba.camel@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 4/19/22 01:25, Bean Huo wrote:
> Looks good to us, but we need to verify it on the two platforms, and
> need some time before add reviewed and tested tag.

Thanks for the feedback. I will move this patch to a future patch series 
such that it does not block merging of the previous patches in this series.

Thanks,

Bart.
