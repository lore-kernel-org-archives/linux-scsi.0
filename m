Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7B155EE3F3F
	for <linux-scsi@archiver.kernel.org>; Wed, 13 Sep 2023 01:45:57 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238103AbjIMBqA (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Tue, 12 Sep 2023 21:46:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45282 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234247AbjIMBp7 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 12 Sep 2023 21:45:59 -0400
Received: from mail-pf1-x429.google.com (mail-pf1-x429.google.com [IPv6:2607:f8b0:4864:20::429])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BCAA310F7;
        Tue, 12 Sep 2023 18:45:55 -0700 (PDT)
Received: by mail-pf1-x429.google.com with SMTP id d2e1a72fcca58-68fb2e9ebbfso2612315b3a.2;
        Tue, 12 Sep 2023 18:45:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20221208; t=1694569555; x=1695174355; darn=vger.kernel.org;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:from:to:cc:subject:date:message-id
         :reply-to;
        bh=jDmOdoPH2l39gpvwRa0r3lDWCY2IAoBJcRIQiT1wU4I=;
        b=hLL97GBPv8BANkCnPJTxZx/kbOYSYCD3TgT72dLu4cPiw7tZRqCjZLVr4E2MsMyJ/1
         0zjIXpbrSnx4D4RLr3SEaWGdo61Wme331I9y/n48xBvf9aXFK8Y6/ghv0dDiyaJAaVbW
         1/Ye9hnm6xodSDdn1ET4ba682hWcSd1L/UXKBRzkf03uwaGhF7e+AxCa63QxfrFGEtS+
         eahM5bH8gmVyORlyYMi+AbMASz2RTIT5PPrH/x9loCju/VLVsEK2RSmyk5pWGkzBlFdh
         bMXHuh4SlrD3HbZBV0QxGw8t9PFR9CDE9ElnnERWzXgO+SpEMuP/ZvRfxBlyyDDnRaOc
         DWJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1694569555; x=1695174355;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:sender:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=jDmOdoPH2l39gpvwRa0r3lDWCY2IAoBJcRIQiT1wU4I=;
        b=WShg4mUDMPQya72NWvSk6l2dptzm3d2cS+cBLhgMmwmnGbAm9C0WHo229y3K3EMrEj
         UNk+1L1jwsbcvHkLEkR7yAsyF3VqKU4B/5TN8nC8ZZ99bPYpy/c4iELYH3xvwDx7Bx+4
         fhTd4bkl8XqDorvPdyithNKscLLe8UvvxaeJ+rJ/osiGa0VTvKQDJfc5ZhjH51bNzgZ8
         sx8WvhEv5Qo0r363sF2sGPr9GCdUW567b3vZVhg+tWOcQc8GQwK3JP1Cs929BOYAerSG
         wV29lVvEyhqAS1iDeR0PeoeOhXrioLdr2M+a6FHTN7XdXcxNXWskj2egzC7wfskToNQu
         2d4A==
X-Gm-Message-State: AOJu0YzAsHTT7iKRM1vUtIqbpF1tDgpJIUu2YXoj540PoLqetWBNnvrv
        UI83BmD0bnG+exz8n+fTx4k=
X-Google-Smtp-Source: AGHT+IE0MphY/Aa8MefewJTXYv4iMWHbYBlCqY1LB8pNDERS7pbIxMHlOKrOIp+cyZiNaTOreOi+Nw==
X-Received: by 2002:a05:6a21:a585:b0:154:fb34:5f01 with SMTP id gd5-20020a056a21a58500b00154fb345f01mr1650243pzc.6.1694569555136;
        Tue, 12 Sep 2023 18:45:55 -0700 (PDT)
Received: from acelan-xps15-9560 (118-163-61-247.hinet-ip.hinet.net. [118.163.61.247])
        by smtp.gmail.com with ESMTPSA id jh15-20020a170903328f00b001b9f7bc3e77sm9150299plb.189.2023.09.12.18.45.53
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 12 Sep 2023 18:45:54 -0700 (PDT)
Sender: AceLan Kao <acelan@gmail.com>
Date:   Wed, 13 Sep 2023 09:45:50 +0800
From:   "Chia-Lin Kao (AceLan)" <acelan.kao@canonical.com>
To:     Damien Le Moal <dlemoal@kernel.org>
Cc:     linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        John Garry <john.g.garry@oracle.com>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Paul Ausbeck <paula@soe.ucsc.edu>,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Joe Breuer <linux-kernel@jmbreuer.net>
Subject: Re: [PATCH 08/19] scsi: Remove scsi device no_start_on_resume flag
Message-ID: <ZQEUTlu+ux+t2Juq@acelan-xps15-9560>
References: <20230911040217.253905-1-dlemoal@kernel.org>
 <20230911040217.253905-9-dlemoal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230911040217.253905-9-dlemoal@kernel.org>
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Mon, Sep 11, 2023 at 01:02:06PM +0900, Damien Le Moal wrote:
> The scsi device flag no_start_on_resume is not set by any scsi low
> level driver. Remove it.
> 
> Signed-off-by: Damien Le Moal <dlemoal@kernel.org>
Tested-by: Chia-Lin Kao (AceLan) <acelan.kao@canonical.com>
