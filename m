Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A603EEE49B7
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Sep 2023 01:49:53 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238121AbjIMBt5 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Sep 2023 21:49:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238110AbjIMBt4 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Sep 2023 21:49:56 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E261010F7;
        Tue, 12 Sep 2023 18:49:51 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id d2e1a72fcca58-68fbb10dec7so2729132b3a.3;
        Tue, 12 Sep 2023 18:49:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694569791; x=1695174591; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=p/dI5UNys8XFb8RLLtavncz3Is9+ORDUqMBUWeYOdQw=;
        b=UdsoWi+TopQQMewjnw6WS+WmS74JnvmbcJ0/lmB2exGeew9LOeIBbTUHlU7N9YIXev
         cPcjKAyhTBLI7PGAAo63TGWUq1M8ScQc7XHQTKSdvaAxN+U74W99FU0YwA+bCpy52Fqh
         ULZwPuy2b3w/x2LxdqewL7Hf/vqaVx0MqRC7ek25ROwvFRDIr1vGCt5w7TL1kcdtEEdz
         K/1ouivA52RisCDJ+xDA2Ta9WoOZFxkDSwYWI9CIFdKec9lyY0qcMQZwkOHr6oD0USnQ
         14lSsgWr6FRaFf2uMtkI8ZWn1dgPE0IMZ/FX8CEolZm5I7McAtxI9VXDgTsWu1vYsqHF
         HA6g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694569791; x=1695174591;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=p/dI5UNys8XFb8RLLtavncz3Is9+ORDUqMBUWeYOdQw=;
        b=o5l0XFD/gaKr+4lfgfK0nSX1/HR4+j32+w0NzRlNcBxdr01W1Z5Dzu506a5Q8C7pfO
         YC1pSRMxZZu9gU4Beqy/x2mcPXQhFB8XzmeRohjHckpJXWadUQi0blzIb3V5vI7YLNgW
         8SyWbLBNnI+x/BGOcFBWJMzLVyT/0OL2RA6S8tXt8ZPZqBIEkZHpAC95C6ndPYWqRDSu
         BMT3J2k3Dxmt2QnkPc6Qx53d4Mu4oLhNl8VWIV2AkZ82ynfTfZbKQAJ7XVacHyiAxoJj
         3YkUTPei4obZzVxCwrE9eZsmf0nlycQmJeaTJ8yu3HEG3KcvMIB7F9jqT3CLlESmz0L7
         Px4w==
X-Gm-Message-State: AOJu0YxZZp9AWgtMEcT0oyDc3x73MAWFlmVoQI7Amo9QXzru/6nNTWkL
        AOJbvyhGoS8sXmUEcEAYPxA=
X-Google-Smtp-Source: AGHT+IEHOHjyf8NirHRb7WKrsb4PiAPE4ZXfsZMMiQL7hzJnGEA5GJAFUsMpeUrg7YoUjTDQYEAIeg==
X-Received: by 2002:a05:6a00:168a:b0:68f:b3ed:7d4d with SMTP id k10-20020a056a00168a00b0068fb3ed7d4dmr1693611pfc.15.1694569791376;
        Tue, 12 Sep 2023 18:49:51 -0700 (PDT)
Received: from acelan-xps15-9560 (118-163-61-247.hinet-ip.hinet.net. [118.163.61.247])
        by smtp.gmail.com with ESMTPSA id j1-20020aa78dc1000000b006883561b421sm7993803pfr.162.2023.09.12.18.49.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Sep 2023 18:49:51 -0700 (PDT)
Sender: AceLan Kao <acelan@gmail.com>
Date:   Wed, 13 Sep 2023 09:49:47 +0800
From:   "Chia-Lin Kao (AceLan)" <acelan.kao@canonical.com>
To:     Damien Le Moal <dlemoal@kernel.org>
Cc:     linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>
Subject: Re: [PATCH 19/19] ata: libata: Cleanup inline DMA helper functions
Message-ID: <ZQEVO8gaCmqCA+ea@acelan-xps15-9560>
References: <20230911040217.253905-1-dlemoal@kernel.org>
 <20230911040217.253905-20-dlemoal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230911040217.253905-20-dlemoal@kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Sep 11, 2023 at 01:02:17PM +0900, Damien Le Moal wrote:
> Simplify the inline DMA helper functions ata_using_mwdma(),
> ata_using_udma() and ata_dma_enabled() to directly return as a boolean
> the result of their test condition.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Tested-by: Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>
