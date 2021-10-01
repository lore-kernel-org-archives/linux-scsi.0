Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0E42BC4332F
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Oct 2021 17:40:28 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E45CC61ABE
	for <linux-scsi@archiver.kernel.org>; Fri,  1 Oct 2021 17:40:27 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355348AbhJARmL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 1 Oct 2021 13:42:11 -0400
Received: from mail-pf1-f171.google.com ([209.85.210.171]:43655 "EHLO
        mail-pf1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229632AbhJARmK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Oct 2021 13:42:10 -0400
Received: by mail-pf1-f171.google.com with SMTP id 187so4159281pfc.10;
        Fri, 01 Oct 2021 10:40:26 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Klo/AK1qPnu25VUQLxQ3XFtBKTNjbNeMN76P/55SWkE=;
        b=2Y8XnJinEfOC1OfvFfLM8/59EI7eHFi3DpdKM4jfHs5txz+nz1wBa9MqavmXF+aKvL
         WbFVRbwtsItImQzrNZ1nLIZOBOf1xkr/W2G6jbG1/CcuOkiQVCXNHZaM06hBls85xTRO
         w8nPmdJCvPkAZVa91HdXAxp91Movyk37cgSDySYJNpdu628GaBgERekxwzIwMGRgsGtW
         6IE2QHwtGNDQzX+RW/iTA2RiedvGCX6BX0CflEFrWw6NJMOnuV5NZnPNdJs1ERF2b+Ws
         kICSMGbDodp5Lu+lhl4SjALJ8X5R6mKxCZI8ohxHmgOzXPoFDKtkDfTJ25YCxo2FJGVU
         f/mQ==
X-Gm-Message-State: AOAM532ZW5GURetOiF9InA4tST56O/eVNni8nAyClXmS2j0mnOfJRREN
        UW/jdFwSbgiaQl9QALSr2KY=
X-Google-Smtp-Source: ABdhPJwAQYznZlerGKXQISzRhZecfWoUKK1+pnGNVBwYHZP1WsaMo57IZzoLhTwc9sFwei3wEdbA4Q==
X-Received: by 2002:a63:6981:: with SMTP id e123mr10729139pgc.419.1633110025906;
        Fri, 01 Oct 2021 10:40:25 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:82b7:f0a2:c63d:c44e])
        by smtp.gmail.com with ESMTPSA id t6sm7020570pfh.63.2021.10.01.10.40.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 01 Oct 2021 10:40:25 -0700 (PDT)
Subject: Re: [PATCH 2/2] scsi: ufs: Stop clearing unit attentions
To:     dgilbert@interlog.com, Adrian Hunter <adrian.hunter@intel.com>,
        Jaegeuk Kim <jaegeuk@kernel.org>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, martin.petersen@oracle.com
Cc:     Bart Van Assche <bvanassche@google.com>
References: <20210930195237.1521436-1-jaegeuk@kernel.org>
 <20210930195237.1521436-2-jaegeuk@kernel.org>
 <12ba3462-ac6b-ef35-4b5e-e0de6086ab51@intel.com>
 <f2436720-16d5-58da-abcc-20fa1ed01fb9@intel.com>
 <5e087a0f-7ae0-41d1-c1f1-e5cc0ad2d38f@acm.org>
 <f4f81b75-9b0b-7734-ebfa-14bd1b935c54@interlog.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <07821a06-0b51-8f11-868c-913726ee393a@acm.org>
Date:   Fri, 1 Oct 2021 10:40:24 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <f4f81b75-9b0b-7734-ebfa-14bd1b935c54@interlog.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/1/21 10:21 AM, Douglas Gilbert wrote:
> On 2021-10-01 12:59 p.m., Bart Van Assche wrote:
>> On 9/30/21 11:52 PM, Adrian Hunter wrote:
>>> Finally, there is another thing to change.  The reason
>>> ufshcd_suspend_prepare() does a runtime resume of sdev_rpmb is because the
>>> UAC clear would wait for an async runtime resume, which will never happen
>>> during system suspend because the PM workqueue gets frozen.  So with the
>>> removal of UAC clear, ufshcd_suspend_prepare() and ufshcd_resume_complete()
>>> should be updated also, to leave rpmb alone.
> 
> Somewhat related ...
> 
> Since there was some confusion among the members of T10 of what precisely
> the RPM bit meant, in SPC-6 revision (draft), a new "HOT PLUGGABLE" two
> bit field was introduced into the standard INQUIRY response:
> 
>                  Table 151 — HOT PLUGGABLE field
> 
> Code   Description
> 00b    No information is provided regarding whether SCSI target device is hot
>         pluggable.
> 01b    The SCSI target device is designed to be removed from a SCSI domain as
>         a single object (i.e., concurrent removal of the SCSI target ports,
>         logical units, and all other objects contained in that SCSI target
>         device (see SAM-6)) while that SCSI domain continues to operate for
>         all other SCSI target devices, if any, in that SCSI domain.
> 10b    The SCSI target device is not designed to be removed from a SCSI
>         domain while that SCSI domain continues to operate.
> 11b    Reserved
> 
> That field is bits 5 and 4 of byte 1 of the response.
> 
> Perhaps we should be adding provision for this new field.

Hi Doug,

It is not clear to me how hot-plugging is related to UFS devices? I am not aware
of any support for hot-plugging in the UFS driver. RPMB = Replay Protected Memory
Block. The definition of RPMB according to Wikipedia is "a means for a system to
store data to the specific memory area in an authenticated and replay protected
manner, and can only be read and written via successfully authenticated read and
write accesses". It is not clear to me how hot-plugging and RPMB are related? What
am I missing?

Thanks,

Bart.

