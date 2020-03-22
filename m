Return-Path: <SRS0=LJp0=5H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E0FD1C1975A
	for <linux-scsi@archiver.kernel.org>; Sun, 22 Mar 2020 21:53:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9C6662072E
	for <linux-scsi@archiver.kernel.org>; Sun, 22 Mar 2020 21:53:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="D3sktdfb"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726809AbgCVVxQ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 22 Mar 2020 17:53:16 -0400
Received: from mail-wr1-f51.google.com ([209.85.221.51]:42564 "EHLO
        mail-wr1-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726785AbgCVVxP (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Mar 2020 17:53:15 -0400
Received: by mail-wr1-f51.google.com with SMTP id h15so2362567wrx.9
        for <linux-scsi@vger.kernel.org>; Sun, 22 Mar 2020 14:53:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=er1hYzIQoLiFr6VXqEn7qS5Vkw74an+oS9j7+rEDk9E=;
        b=D3sktdfb8JWwncjnsi9eh8gmHLNbWnnc7MlgZiAnUTPTVnrWIqhodfV5eCZ/aLR7/q
         0xIKlC06LtkU9kKrkHi15Xzdg4tL2i8qpi4GmMvE/0EE7MMy9vbX5xWCAPxv8tI8ZpOn
         tqUmFhV/0dCOVIfqySQxjjyX6B0Z7tlXNS8pbzxE8QnylHwKyLgTodp6y3ZPdwKQWxZe
         vTc3B6L3iUPfW+Ji2eqZOOwkr35gDoi0ApD5R6migvaIwrF6EpzOI1S0njn5VlZANZUS
         AHwZQXVhRJ1Ia2GkJxNmuxb6vzn7mAwrDmfpFAyZOcJpAF63lzpSRjg2YoXCOMwhgWJw
         tABw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=er1hYzIQoLiFr6VXqEn7qS5Vkw74an+oS9j7+rEDk9E=;
        b=ssxsIm04HlAh8N/xBk4GjXX5ig53V42OR25hpuDSXKGtnG/ZbtxkJfIIBIeUZOFfqO
         6epzTZ897ErVJsyqnRuv/isfHKY4/UuyjJA1nXqYpMp+pl/3WiKvjd2v5pjpulPRYctS
         bqMrHr5HNAmPWZxuP3dH8m2vvit5xSgUFzy/vpVq6jmEW4taZkk3FRrfXp0a3wiMIgR3
         UPRivPgNSwT2qxnhL4tN4TSi24onV8fRIrKwiUi1AohrFgsDrG3HAH+OcDrDpwpxACWo
         ZvbPU0YWPpeEkZvBO+WlbnEMgHH46eCscjiQKoF7xy/Ht/IivC4GiEKFbsP/hI2gCZ0K
         9P6g==
X-Gm-Message-State: ANhLgQ0MQUn4vAFkcnu3uwPE0jecsnk98RMG0biVSuURRIO3FNyDB+Wk
        6fbAcz/oYyKAEhkZNVrRVFQZr99A
X-Google-Smtp-Source: ADFU+vsKTiGxHVzron91TQ1V4mcIvtQyVTVvfltvrS8AvMJ8/fnasV4o6JIqpWJMNVl0iiEOBCxGpQ==
X-Received: by 2002:a5d:4e05:: with SMTP id p5mr25777016wrt.59.1584913993331;
        Sun, 22 Mar 2020 14:53:13 -0700 (PDT)
Received: from ?IPv6:2001:871:25b:80aa:d968:6ff0:1ba6:31eb? (dynamic-2jo7hd4gpbva0jmajv-pd01.res.v6.highway.a1.net. [2001:871:25b:80aa:d968:6ff0:1ba6:31eb])
        by smtp.gmail.com with ESMTPSA id k5sm18427970wmj.18.2020.03.22.14.53.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Mar 2020 14:53:12 -0700 (PDT)
Subject: Re: Invalid optimal transfer size 33553920 accepted when
 physical_block_size 512
From:   Bernhard Sulzer <micraft.b@gmail.com>
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org
References: <33fb522e-4f61-1b76-914f-c9e6a3553c9b@gmail.com>
 <yq1o8sowfzn.fsf@oracle.com> <accd7d25-ee35-11b9-e49b-76e20d9550f2@gmail.com>
 <yq1pnd4tbxm.fsf@oracle.com> <1eb896cd-2be1-4225-88d8-5ee590fe063b@gmail.com>
 <yq1eetkrtf6.fsf@oracle.com> <58904bc3-4186-7f9c-dc3c-707aa3d92bfb@gmail.com>
Message-ID: <46035460-9d63-2a9a-d37b-514640f8732f@gmail.com>
Date:   Sun, 22 Mar 2020 22:53:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <58904bc3-4186-7f9c-dc3c-707aa3d92bfb@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org


>> I sent a patch that I would like you to test. It adds some additional
>> sanity checking to the block limits handling. Given the VPD output you
>> sent earlier, I am hoping it will work around the issue.
>
> Currently compiling...

With the patch applied, the situation looks unchanged. I did gain a line 
for preferred minimum though.

[   92.984044] usbcore: registered new interface driver usb-storage
[   92.990020] scsi host6: uas
[   92.990113] usbcore: registered new interface driver uas
[   92.990480] scsi 6:0:0:0: Direct-Access     Seagate Backup+ Hub BK   
D781 PQ: 0 ANSI: 6
[   92.991014] sd 6:0:0:0: Attached scsi generic sg3 type 0
[   92.991203] sd 6:0:0:0: [sdc] Spinning up disk...
[   93.029139] usb 2-2-port2: Cannot enable. Maybe the USB cable is bad?
[   94.012043] ............ready
[  105.159757] sd 6:0:0:0: [sdc] 15628053167 512-byte logical blocks: 
(8.00 TB/7.28 TiB)
[  105.196980] sd 6:0:0:0: [sdc] Write Protect is off
[  105.196986] sd 6:0:0:0: [sdc] Mode Sense: 4f 00 00 00
[  105.197182] sd 6:0:0:0: [sdc] Write cache: enabled, read cache: 
enabled, doesn't support DPO or FUA
[  105.197403] sd 6:0:0:0: [sdc] Preferred minimum I/O size 512 bytes
[  105.197407] sd 6:0:0:0: [sdc] Optimal transfer size 33553920 bytes
[  105.240714] sd 6:0:0:0: [sdc] Attached SCSI disk

Does this help?

