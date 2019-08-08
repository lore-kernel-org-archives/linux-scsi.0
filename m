Return-Path: <SRS0=AwsL=WE=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 39196C433FF
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Aug 2019 17:27:00 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0B4602089E
	for <linux-scsi@archiver.kernel.org>; Thu,  8 Aug 2019 17:27:00 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="Ymr7/4FN"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404258AbfHHR07 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 8 Aug 2019 13:26:59 -0400
Received: from mail-qk1-f182.google.com ([209.85.222.182]:34994 "EHLO
        mail-qk1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728020AbfHHR07 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Aug 2019 13:26:59 -0400
Received: by mail-qk1-f182.google.com with SMTP id r21so69516096qke.2
        for <linux-scsi@vger.kernel.org>; Thu, 08 Aug 2019 10:26:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:references:in-reply-to:mime-version:thread-index:date
         :message-id:subject:to:cc;
        bh=PJEP7gEb1ir827/sFAdb/9iaLt0vvpBXTOPy5U52QpY=;
        b=Ymr7/4FN7IS6Uiy4y7B9nufR8EOKd0LFps5RujX6jqtAMtsrXjXcD/a1BK4nBK/qAP
         ST9FeRfNKUmjVjeucDS5dxL4OgOr8oUVLDGoit8DbYXKzgbXRMR6GbwX5+0d1VnuPVMK
         zPIC+48WLANAqQ9XKJ4ndvBghWMugxAWY/EmM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:references:in-reply-to:mime-version
         :thread-index:date:message-id:subject:to:cc;
        bh=PJEP7gEb1ir827/sFAdb/9iaLt0vvpBXTOPy5U52QpY=;
        b=Y5E9GFIYHjrIgkjkMJt8PxT0tcnIQM1egluZz5uBzBksRLc3xPQqHWcpGvpzyfLO/G
         ZdKsBGADAcT6S6nAsqautk2CoaL5Cn7rxxbQ7TwClTnhAzx0rtYsFxqlVM5KkLMsPPjE
         JHX1E4aWBYSOMwkWLhAVUGLLp+URT7ENKZDXnATc3aeUrhipjN2X4oHUdoO3A6vkLHhq
         hPr6cyZBVHtbq9qH40GOB1iCWl53K5vS4rdxOPcMZwT4Tzk07+wq5OQ5+8c+xLgp/UtP
         pTIfUbmmDbminzCeqDoBuCg5Ky0w3nKVUcGOQ61bjmzuAxQiwv/EzyCRreB4ndwGiiRE
         Bw6Q==
X-Gm-Message-State: APjAAAVh089rHcWicCJYqFcla2D9J6z8FHxRfhPvA7BOxmM9nMCOIN+7
        b7/XK+WH464qV62yMhaHlntSwU5ooci980G0JDoWdw==
X-Google-Smtp-Source: APXvYqyih0kPBD1dhOUgNQ+IIiF0gTjskfkI6JPxyvlxt6FEQp2hZHEO6mG/I7/0l6AX5I1YjoJLer3uHY30JiPqOhA=
X-Received: by 2002:a37:a48e:: with SMTP id n136mr14853725qke.223.1565285218410;
 Thu, 08 Aug 2019 10:26:58 -0700 (PDT)
From:   Chandrakanth Patil <chandrakanth.patil@broadcom.com>
References: <20190726073214.23820-1-chandrakanth.patil@broadcom.com> <yq1zhkke9c8.fsf@oracle.com>
In-Reply-To: <yq1zhkke9c8.fsf@oracle.com>
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQJOpmXLT9cDiysBe+k0Ph7wC/nHkgLLBRGXpehppdA=
Date:   Thu, 8 Aug 2019 22:56:56 +0530
Message-ID: <06139ab3efab799a9d3148b1f04847b0@mail.gmail.com>
Subject: RE: [PATCH] megaraid_sas: change sdev queue depth max vs optimal
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Kiran Kumar Kasturi <kiran-kumar.kasturi@broadcom.com>,
        Sankar Patra <sankar.patra@broadcom.com>,
        Sasikumar PC <sasikumar.pc@broadcom.com>,
        Shivasharan Srikanteshwara 
        <shivasharan.srikanteshwara@broadcom.com>,
        Anand Lodnoor <anand.lodnoor@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Martin,

The firmware provided queue depth provides optimum performance in most of
the cases/workloads. And this patch provides the option to the user to go
with max queue_depth or with optimum queue_depth.

-Chandrakanth

-----Original Message-----
From: Martin K. Petersen [mailto:martin.petersen@oracle.com]
Sent: Thursday, August 8, 2019 6:56 AM
To: Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Cc: linux-scsi@vger.kernel.org; kashyap.desai@broadcom.com;
sumit.saxena@broadcom.com; kiran-kumar.kasturi@broadcom.com;
sankar.patra@broadcom.com; sasikumar.pc@broadcom.com;
shivasharan.srikanteshwara@broadcom.com; anand.lodnoor@broadcom.com
Subject: Re: [PATCH] megaraid_sas: change sdev queue depth max vs optimal


Chandrakanth,

> This patch provides the module parameter and sysfs interface to switch
> between the firmware provided (optimal) queue depth and controller
> queue depth (can_queue).

This smells a bit like a don't-be-broken flag.

Why isn't the firmware-provided value optimal?

-- 
Martin K. Petersen	Oracle Linux Engineering
