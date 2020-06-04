Return-Path: <SRS0=9nM7=7R=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E5B23C433DF
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Jun 2020 11:09:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BD0AD206A2
	for <linux-scsi@archiver.kernel.org>; Thu,  4 Jun 2020 11:09:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="DtYdwjkf"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726221AbgFDLJs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 4 Jun 2020 07:09:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726116AbgFDLJs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 4 Jun 2020 07:09:48 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01941C03E96E
        for <linux-scsi@vger.kernel.org>; Thu,  4 Jun 2020 04:09:47 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id a25so5623549ejg.5
        for <linux-scsi@vger.kernel.org>; Thu, 04 Jun 2020 04:09:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:references:in-reply-to:mime-version:thread-index:date
         :message-id:subject:to:cc;
        bh=8Nq0dyaB6V8gFTM/YIgSsevuRr16ab+DDL+OOpCw0+M=;
        b=DtYdwjkfZDm/pkt5YmTNSHJ9A4B6WzK/4f/uiufgOby6UBjgBvDnu6Ws+LL2sjfFN8
         +k2ALeYbQ/wjL2qq0DZzmSjDUVdXHzS8IZTAJmvLNW41tNvLt7rpKOJsMmewM63GET6T
         sJAzUQG0NBEPxWrkewksInmBZe/To4YReryGM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:references:in-reply-to:mime-version
         :thread-index:date:message-id:subject:to:cc;
        bh=8Nq0dyaB6V8gFTM/YIgSsevuRr16ab+DDL+OOpCw0+M=;
        b=fXJM7qR5R85pUybjXUS9C9qIOer91Kbky9i0zN2Gj3ayGOBWD8wgw7uW4IEVklNMkB
         EzybtoXtnwXKilKo+FcnSowAYYzKrg056A3lNj+wqOA44lZJpjH8kLgeFwI789LSW6qG
         lXpo42rCuZZ7JdY2uMW/7+Tpdp3zp4kHDqcq8Cl1iHTWOsjRKFsNN7eJQqwmF++elIJL
         wDYgGbNKWlGKKSiYfEnEqDBnPOBPAQ3qXkU+BH3+myUiUHukEZ8T3dXuGKK/bmuWmpGp
         RcoW435bWJnbplfzB1fWqGYgg8OIRdYutQUb7uHTx37I9Ul7d/AHvL5gkUWJqjceIfrH
         y4VQ==
X-Gm-Message-State: AOAM530A7ceEE0t9jTQz73llbW6E9EX7jIq34TnG1naDhkpJm09pzcm7
        OTBU6IHQrxRmDn2OlAa077bK5wL7m6RAOskx5oybYA==
X-Google-Smtp-Source: ABdhPJxWOzqXodtiDr7HB6vWbsh1MH6JiswGUHe7BXvqDqw/2/sI3UN28tMnHUBfoAkzlU8seWlC3OgsrQlzhpsJod8=
X-Received: by 2002:a17:907:40bf:: with SMTP id nu23mr3339170ejb.74.1591268986462;
 Thu, 04 Jun 2020 04:09:46 -0700 (PDT)
From:   Chandrakanth Patil <chandrakanth.patil@broadcom.com>
References: <1590651115-9619-1-git-send-email-newtongao@tencent.com>
 <yq17dwp9bss.fsf@ca-mkp.ca.oracle.com> 08525d33fafb0a10c427838621fb571f@mail.gmail.com
In-Reply-To: 08525d33fafb0a10c427838621fb571f@mail.gmail.com
MIME-Version: 1.0
X-Mailer: Microsoft Outlook 15.0
Thread-Index: AQJb9Wzm0098wwdcUnfhuPbO5i84ZwGnJavmp64zHeCAAWdaIA==
Date:   Thu, 4 Jun 2020 16:39:43 +0530
Message-ID: <4779a72c878774e4e3525aae8932feda@mail.gmail.com>
Subject: RE: [PATCH] scsi: megaraid_sas: fix kdump kernel boot hung caused by JBOD
To:     "Martin K. Petersen" <martin.petersen@oracle.com>,
        Kashyap Desai <kashyap.desai@broadcom.com>,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        Xiaoming Gao <newtongao@tencent.com>,
        Shivasharan Srikanteshwara 
        <shivasharan.srikanteshwara@broadcom.com>
Cc:     xiakaixu1987@gmail.com, jejb@linux.ibm.com,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

>Subject: RE: [PATCH] scsi: megaraid_sas: fix kdump kernel boot hung
caused by JBOD
>
>>Subject: Re: [PATCH] scsi: megaraid_sas: fix kdump kernel boot hung
>>caused by JBOD
>>
>>
>>> when kernel crash, and kexec into kdump kernel, megaraid_sas will
>>> hung and print follow error logs
>>>
>>> 24.1485901 sd 0:0:G:0: [sda 1 tag809 BRCfl Debug mfi stat 0x2(1, data
>>> len requested/conpleted 0X100 0/0x0)]
>>> 24.1867171 sd 0:0:G :9: [sda I tag861 BRCfl Debug mfft stat 0x2d,
>>> data len reques ted/conp1e Led 0X100 0/0x0]
>>> 24.2054191 sd 0:O:6:O: [sda 1 tag861 FAILED Result: hustbyte=DIDGK
>>> drioerbyte-DRIUCR SENSE]
>>> 24.2549711 bik_update_ request ! 1/0 error , dev sda, sector
>>> 937782912 op 0x0:(READ) flags 0x0 phys_seg 1 prio class
>>> 21.2752791 buffer_io_error 2 callbacks suppressed
>>> 21.2752731 Duffer IO error an dev sda, logical block 117212064, async
>>> page read
>>>
>>> this bug is caused by commit '59db5a931bbe73f ("scsi: megaraid_sas:
>>> Handle sequence JBOD map failure at driver level ")' and can be fixed
>>> by not set JOB when reset_devices on
>>
>>Broadcom: Please review.
>>
>>Thanks!
>>
>>--
>>Martin K. Petersen	Oracle Linux Engineering
>
>We are working on it and will update you at the earliest.
>
>Thanks,
>Chandrakanth Patil

Hi Martin, Xiaoming Gao, Kai Liu,

It is a known firmware issue and has been fixed. Please update to the
latest firmware available in the Broadcom support website.
Please let me know if you need any further information.

Thanks,
Chandrakanth Patil
