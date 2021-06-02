Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DC31AC4708F
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Jun 2021 15:26:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C5C8161242
	for <linux-scsi@archiver.kernel.org>; Wed,  2 Jun 2021 15:26:47 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231751AbhFBP2a (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 2 Jun 2021 11:28:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51950 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230479AbhFBP23 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Jun 2021 11:28:29 -0400
Received: from mail-qv1-xf35.google.com (mail-qv1-xf35.google.com [IPv6:2607:f8b0:4864:20::f35])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 05DFDC061574
        for <linux-scsi@vger.kernel.org>; Wed,  2 Jun 2021 08:26:30 -0700 (PDT)
Received: by mail-qv1-xf35.google.com with SMTP id u13so1486401qvt.7
        for <linux-scsi@vger.kernel.org>; Wed, 02 Jun 2021 08:26:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=Aa29NoohpvQBP2zYadv1ijqbMXjPa46Bq9pr2d7Rx1Y=;
        b=nHPgEflQvGJLhWuvp2WAi33olXKIeQtPEh3gx9I6fNzsexGkXDsdwK3PeuQQ3AAxTZ
         tSqN+yc83ScwB4SrI0knFNhAQmWV7PzHSC20ziTGn8T8sml6YDpcJDWH1g/HzAD/CBnF
         2/0+KQEvbqpvmRCZTRmOz15fj+Y5AlhYYMSMWFfpEr1PJlyt7MgIm/oRLlz0wCgaaeTG
         xgr9criN0JzApI6601NKRhCZm+ca9GPz8HzoEDDQPbMnYk90XHAA93Jz5cSHyHsWs1gv
         Pbh+uwFkWGnrnvZFZHUNytVaFOzLcrMJq0/AonzyHkKdKI14hMbJLJRwV8/NwoUr2OTe
         txgw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=Aa29NoohpvQBP2zYadv1ijqbMXjPa46Bq9pr2d7Rx1Y=;
        b=VVY8HbU06mZ2Xbbcpr+Gi84J/6dMWerUSoHz62drmVV2C5MzKwhYdg8EOjaJEjJ3XG
         i1qbB7m5FR7T/L72agKNKfpfjiLqKfKUBOanPCZrQNEXETMU5jyDIc4mXbeD93xpncHi
         iy9x2DltgLkp4Yvi6YJ5pRRnnwiwNYGGvasXDsjc/0rcOT8pFo3S9yw/eymb5+t5qwEB
         t1qBcHR8McjDz88X+YTwbHhn7E5pX7wkzngBAXsgPXpKz2qC2ZF3RjDq1WVLmi8VvMHd
         uWMRkVUbyvHDFQeglD8Ma0C9ZxYw01tJGr2Z/rxxuCCiBJYIuJS6d0sHS8wdpz74dRzR
         wCsQ==
X-Gm-Message-State: AOAM531FSrbAWr+z/WT6zmwQczT2JJJz56m+2bNcZ0UkIHC8fOFLU3z8
        1/mum2+8RYK1fJr7G1eayPo=
X-Google-Smtp-Source: ABdhPJyUl1OcE4v+CF3AiWFXTV13U74zLmKjgwPC/4toQb2Nn9n7WmOI3SuiRJL5MJQ+1cbToINLDg==
X-Received: by 2002:ad4:56e2:: with SMTP id cr2mr22727045qvb.19.1622647589223;
        Wed, 02 Jun 2021 08:26:29 -0700 (PDT)
Received: from david-pc (c-73-82-11-57.hsd1.ga.comcast.net. [73.82.11.57])
        by smtp.gmail.com with ESMTPSA id a128sm14838qkd.76.2021.06.02.08.26.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Jun 2021 08:26:28 -0700 (PDT)
Date:   Wed, 2 Jun 2021 11:26:26 -0400
From:   David Sebek <dasebek@gmail.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        jejb@linux.ibm.com, linux-scsi@vger.kernel.org
Subject: Re: [PATCH] scsi: Set BLIST_TRY_VPD_PAGES for WD Black P10 external
 HDD
Message-ID: <YLejIoBJ8YJuonVZ@david-pc>
References: <YLVThaYJ0cXzy57D@david-pc>
 <yq1czt5q8wu.fsf@ca-mkp.ca.oracle.com>
 <yq17djdq8ly.fsf@ca-mkp.ca.oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq17djdq8ly.fsf@ca-mkp.ca.oracle.com>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Martin,

Thank you for the clarification.

>> Is BLIST_INQUIRY_36 really needed?

No, BLIST_INQUIRY_36 is not needed. I included it only because the nearby
comment "Note that all USB devices should have the BLIST_INQUIRY_36 flag."
said so.

David Sebek
