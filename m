Return-Path: <SRS0=+N3d=7S=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 44628C433E0
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Jun 2020 15:30:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 1DC0A206DB
	for <linux-scsi@archiver.kernel.org>; Fri,  5 Jun 2020 15:30:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="X4EKdamM"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727863AbgFEPai (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 5 Jun 2020 11:30:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726539AbgFEPah (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 5 Jun 2020 11:30:37 -0400
Received: from mail-ed1-x541.google.com (mail-ed1-x541.google.com [IPv6:2a00:1450:4864:20::541])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18C97C08C5C2
        for <linux-scsi@vger.kernel.org>; Fri,  5 Jun 2020 08:30:37 -0700 (PDT)
Received: by mail-ed1-x541.google.com with SMTP id l1so7777679ede.11
        for <linux-scsi@vger.kernel.org>; Fri, 05 Jun 2020 08:30:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:references:in-reply-to:mime-version:thread-index:date
         :message-id:subject:to:cc;
        bh=kvw05eX12Yh5FgPlRgUSXlHOGxXXNOE9RCalQGq26Xo=;
        b=X4EKdamMjiSiB2U3W8O5PY6qGT/gQ3iDtOq81oo4CwFUfUs4QtVFNAIgUhQIez2JvK
         RD0pzFl//irlgsZeeSP74HYMXDs1vDpoaB+QCypLSWwheaLyS9SoUVYBdUffe8ZpnFm8
         DWSAEQXMks9fdXHdJu3fgbIwLiNOtJChxYCKk=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:references:in-reply-to:mime-version
         :thread-index:date:message-id:subject:to:cc;
        bh=kvw05eX12Yh5FgPlRgUSXlHOGxXXNOE9RCalQGq26Xo=;
        b=cjF9H9C+WMNmn+BW3jot+e4i5WmcCvMu0crDbPQ/rSVRGaSmu5XwHckoV/sSZsCdkI
         7OARRIWZg/GwtyvwBexm4BnndUW9LYxHlVhTA7bDjb7W0RwChydLtLN440GQ3/qrUnvS
         0KbmmHU6EcVC8W93KIAokKXAp6OkexPSuy/MktTZ+bZ/0hoLx9oUdwR1lquMjvSe0nPY
         8GnnB9/DDzJTiHxMcAlbseJ+QlUwNMQjSgB2nfER8v3i+pTNalLqTFMJXv4tU0OoBWuO
         gkVgKOatA3KcN2Xzis5Ar5SbdeZsMSmE/yA8m5rkymutGzzpz1iWcDh21MiSEm6rPAZm
         gXSw==
X-Gm-Message-State: AOAM531PShqS6eoWGcHnHj02pEwhPW4iVHjI9qW6WLXpw6jFsTfWo2wO
        +hBvsQDapYZCRUc8npvjybIonAF83PKWVzUe9hXyHg==
X-Google-Smtp-Source: ABdhPJzysky/6m/7l4XT3DGaswXSvfsR/17IejP2A8NgogK397u5AbKSPlAhBht80tUh9/J3O0fP7nqA+lWIyObcMo0=
X-Received: by 2002:a50:f9cc:: with SMTP id a12mr9988020edq.227.1591371035564;
 Fri, 05 Jun 2020 08:30:35 -0700 (PDT)
From:   Chandrakanth Patil <chandrakanth.patil@broadcom.com>
References: <1590651115-9619-1-git-send-email-newtongao@tencent.com>
 <yq17dwp9bss.fsf@ca-mkp.ca.oracle.com> <4779a72c878774e4e3525aae8932feda@mail.gmail.com>
 <20200604155009.63mhbsoaoq6yra77@suse.com> <4285a7ff366d7f5cfb5cae582dadf878@mail.gmail.com>
 <20200605043846.f3ciid3xpvdgumh6@suse.com>
In-Reply-To: <20200605043846.f3ciid3xpvdgumh6@suse.com>
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQJb9Wzm0098wwdcUnfhuPbO5i84ZwGnJavmAYBmkM8CEG/qNQHLP1nqAXBxbNenexM2cA==
Date:   Fri, 5 Jun 2020 21:00:32 +0530
Message-ID: <599e459f0a657fed8a262a34f43b035c@mail.gmail.com>
Subject: RE: [PATCH] scsi: megaraid_sas: fix kdump kernel boot hung caused by JBOD
To:     Kai Liu <kai.liu@suse.com>
Cc:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Xiaoming Gao <newtongao@tencent.com>,
        Shivasharan Srikanteshwara 
        <shivasharan.srikanteshwara@broadcom.com>, xiakaixu1987@gmail.com,
        jejb@linux.ibm.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>Subject: Re: [PATCH] scsi: megaraid_sas: fix kdump kernel boot hung caused
>by JBOD
>
>On 2020/06/05 Fri 01:05, Chandrakanth Patil wrote:
>>
>>Hi Kai Liu,
>>
>>Gen3 (Invader) and Gen3.5 (Ventura/Aero) generations of controllers are
>>affected.
>
>Hi Chandrakanth,
>
>My card is not one of these but it's also problematic:
>
># lspci -nn|grep 3408
>02:00.0 RAID bus controller [0104]: Broadcom / LSI MegaRAID Tri-Mode
>SAS3408
>[1000:0017] (rev 01)
>
>According to megaraid_sas.h it's Tomcat:
>
>#define PCI_DEVICE_ID_LSI_TOMCAT                    0x0017
>
>According to product information on broadcom.com the card model is 9440-8i.
>So I tried to
>upgrade to the latest firmware version
>51.13.0-3223 but I got these error:
>
># ./storcli64 /c0 download file=9440-8i_nopad.rom Download Completed.
>Flashing image to adapter...
>CLI Version = 007.1316.0000.0000 Mar 12, 2020 Operating system = Linux
>5.3.18-
>0.g6748ac9-default Controller = 0 Status = Failure Description = image
>corrupted
>
>I tried few more versions from broadcom website, they all failed with the
>same "image
>corrupted" error.
>
>Here is the controller information:
>
># ./storcli64 /c0 show
>Generating detailed summary of the adapter, it may take a while to
>complete.
>
>CLI Version = 007.1316.0000.0000 Mar 12, 2020 Operating system = Linux
>5.3.18-
>0.g6748ac9-default Controller = 0 Status = Success Description = None
>
>Product Name = SAS3408
>Serial Number = 033FAT10K8000236
>SAS Address =  57c1cf15516f4000
>PCI Address = 00:02:00:00
>System Time = 06/05/2020 12:36:59
>Mfg. Date = 00/00/00
>Controller Time = 06/05/2020 04:36:58
>FW Package Build = 50.6.3-0109
>BIOS Version = 7.06.02.2_0x07060502
>FW Version = 5.060.01-2262
>Driver Name = megaraid_sas
>Driver Version = 07.713.01.00-rc1
>Vendor Id = 0x1000
>Device Id = 0x17
>SubVendor Id = 0x19E5
>SubDevice Id = 0xD213
>Host Interface = PCI-E
>Device Interface = SAS-12G
>Bus Number = 2
>Device Number = 0
>Function Number = 0
>Domain ID = 0
>Drive Groups = 3
>
>
>Thanks,
>Kai Liu

Hi Kai Liu,

Tomcat (Device ID: 0017) belongs to Gen3.5 controllers (Ventura family of
controllers). So this issue is applicable.
As this is an OEM specific firmware, Please contact Broadcom support team in
order get the correct firmware image.

-Chandrakanth Patil
