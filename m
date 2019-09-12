Return-Path: <SRS0=buB8=XH=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 56AB2C49ED9
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Sep 2019 04:56:47 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 2011D20856
	for <linux-scsi@archiver.kernel.org>; Thu, 12 Sep 2019 04:56:47 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="LUVwinm0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726483AbfILE4q (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 12 Sep 2019 00:56:46 -0400
Received: from mail-pf1-f177.google.com ([209.85.210.177]:40826 "EHLO
        mail-pf1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725765AbfILE4q (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 12 Sep 2019 00:56:46 -0400
Received: by mail-pf1-f177.google.com with SMTP id x127so15132995pfb.7
        for <linux-scsi@vger.kernel.org>; Wed, 11 Sep 2019 21:56:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=GR7/tfUQexbSQFmNr1QEzkshtDfnzk9wlGaK/m84iow=;
        b=LUVwinm0QtrBY/NtbxMyfLfLrHG0VCKDRa3T6vOhVV0+6hfDwm4VaH9QFeqTZ0dm82
         g/nZQN+4oZRLimvnQ/Y356r5/dd1MhnNC+uZkGl4zNk+VsUV8cNCqd/dcufI9aIdKO7k
         UlBkwBJk6KCIYWG+hCaAaCUsFaawq2LIZHSx7tLj9qp6RxIpmpWHgVmToVGWCjK90qZs
         +lSSRADnOS4uHJEJ8j/uTPqKVDo0s0dQm7s+NuEOWgePEJ2hRJtCm0naPfHOMtnizhPa
         8Kp4/qHipNdjVLe3MowxifiLMW0QBxqv3LP7Bkg7QysfxO+bePcO8dxx4jLa1RS9dGkP
         LE/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:subject:from:in-reply-to:date:cc
         :content-transfer-encoding:message-id:references:to;
        bh=GR7/tfUQexbSQFmNr1QEzkshtDfnzk9wlGaK/m84iow=;
        b=jPcTMrWg8e5sPb5vArGz9SR39PG7rE+3qzTe9JrIj1xcF1aN1TnzUsvciVFaXbxTEe
         BE6Fk4kFg0aTBeztsT+ksAupRlTrzejrhKPnSYsPIvjSDMacwIAkmaVdTfq3bvJTfu3q
         BwtwuCm9yFoJ8uh3qFeowmseH0A+v1DueuneA/sy4PYRl5lVWip+EFi9fdIkF2v5LY4A
         AwPVdM4NFf+ZeTj1qFq6mydir02rBcAZ5eyPYFpQELvRh/+2jbnHbdsC1iUv8H2ns49v
         F62VGZIRUXGCLUnXW24snqzlAcRcqjhR/uCU1k1DAv/RRgoI8FE6ZjwbMOdJtJIkyv0k
         cluA==
X-Gm-Message-State: APjAAAVO/6eQLocXcQXnzQGPBDlnnHHr7adh8w12Ogy1IA5G4OkWk8qk
        h35QflJqIsiQHhqFVyKO5LI=
X-Google-Smtp-Source: APXvYqwk62hRZ3+Gq49x+bmAqUQMJaIgaaG82z8WbUjkgyzZkr/DVyUIWsfoiMuppZB9YTWm4nUKQg==
X-Received: by 2002:a17:90a:30e8:: with SMTP id h95mr9663889pjb.44.1568264205398;
        Wed, 11 Sep 2019 21:56:45 -0700 (PDT)
Received: from ibm-users-mbp-3.cn.ibm.com ([103.49.135.195])
        by smtp.gmail.com with ESMTPSA id d5sm10750054pfn.160.2019.09.11.21.56.43
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 11 Sep 2019 21:56:44 -0700 (PDT)
Content-Type: text/plain;
        charset=us-ascii
Mime-Version: 1.0 (Mac OS X Mail 12.4 \(3445.104.11\))
Subject: Re: [RFC,v2] scsi: scan: map PQ=1, PDT=other values to
 SCSI_SCAN_TARGET_PRESENT
From:   Zhong Li <lizhongfs@gmail.com>
In-Reply-To: <CA+PODjqrRzyJnOKoabMOV4EPByNnL1LgTi+QAKENP3NwUq5YCw@mail.gmail.com>
Date:   Thu, 12 Sep 2019 12:56:40 +0800
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org
Content-Transfer-Encoding: 7bit
Message-Id: <8A2392BA-EDD4-4F66-9F76-B43C8F6EA4FB@gmail.com>
References: <CA+PODjqrRzyJnOKoabMOV4EPByNnL1LgTi+QAKENP3NwUq5YCw@mail.gmail.com>
To:     Andrey Melnikov <temnota.am@gmail.com>
X-Mailer: Apple Mail (2.3445.104.11)
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


> On Aug 29, 2019, at 11:49 PM, Andrey Melnikov <temnota.am@gmail.com> wrote:
> 
> Hello.
> 
> This patch break exposing individual RAID disks from adaptec raid
> controller. I need access to this disc's for S.M.A.R.T monitoring.

Hello Andrey, 

Do you have any more details about how/why it is broken? 

Thanks, Zhong 

> 
> Please find other way to workaround bugs in IBM/2145 controller.

