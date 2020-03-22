Return-Path: <SRS0=LJp0=5H=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A74C7C1975A
	for <linux-scsi@archiver.kernel.org>; Sun, 22 Mar 2020 23:11:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 6F9F620735
	for <linux-scsi@archiver.kernel.org>; Sun, 22 Mar 2020 23:11:03 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="SHQHsJ8R"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726902AbgCVXLD (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sun, 22 Mar 2020 19:11:03 -0400
Received: from mail-wm1-f53.google.com ([209.85.128.53]:50964 "EHLO
        mail-wm1-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726836AbgCVXLC (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sun, 22 Mar 2020 19:11:02 -0400
Received: by mail-wm1-f53.google.com with SMTP id d198so6945022wmd.0
        for <linux-scsi@vger.kernel.org>; Sun, 22 Mar 2020 16:11:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=z7pCsIxCBdB1QFSpfFfdQ1qoXuD1qR/D6u5nqtAJ/SI=;
        b=SHQHsJ8REhiuNfYc4fzpciaDR+pkaPN2B1lLZxxUBfMAAkmxwppIC2n1CUvrIzq7ED
         2vqnitN+rsJBpoDVM/M5zMPAQQ+hekh48uH366ef1PbhkgDbhxWvqYyNDejW+HE5+veO
         oF81u25Ewd/Cr5j15WTEOhvi2Eh0sYKM76g4SEg791orYCw14uQonmT8KQGm8LWQgulQ
         FM1BrbfLusabY2jaPVSLtEXO0ioBt9+EviL/HheR9QpXStRt/Cqjdin8bguZOHifd7y4
         KxAN2nZ3i6Bo4nH8ybZ3aLRBRCLjcw0kaKcT381whVtMJ2GT4OqLyFsb8dnwq09XRhhC
         wuGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=z7pCsIxCBdB1QFSpfFfdQ1qoXuD1qR/D6u5nqtAJ/SI=;
        b=a3p+90Yqr61SW79tben7pEjbyI29WTP9BQ4HvqHULLi6s0qLNT0E1CnEd+lNCAl1yb
         GmQ949okbIBHT7ccVoJ2sQUe1aqLp/FQ4YPe0rzoxb5WVF8Q1AwnkLXPiOBifR+1hmY6
         LgtjiqPGicHFM9rVrin9k2RAxWBO3EI53eNINrx/1G7NlcE4CVHW49fUTM4eueutRps9
         zUDFk1/CdTJQGJi5V6kwcgK0dmHiz74S97I6pE920EGS3ks02XhNwsFEQfargnvbzMLH
         0rZ8DrlVm/4G+xoSyR7DouBZQZmPMNAabiQzZfZHUPtsbNmtR77VBb71sIv7mGWTw2+A
         Z0Cg==
X-Gm-Message-State: ANhLgQ01kPBNnuIsjzNJfZNLxYL2qSykleJrKBvWkrHiaO9Ni3e2PJPB
        1ffbfL2ZqiNamQOCpep42kSF1ki7
X-Google-Smtp-Source: ADFU+vt8GaYoV62NqDI5nWwjdrbC8BzP7K3WGeboyW91wKiC0R9uDnjbiLQlVO4TLig8jb0UVw3Dfw==
X-Received: by 2002:a1c:4b04:: with SMTP id y4mr10950964wma.28.1584918659841;
        Sun, 22 Mar 2020 16:10:59 -0700 (PDT)
Received: from ?IPv6:2001:871:25b:80aa:d968:6ff0:1ba6:31eb? (dynamic-2jo7hd4gpbva0jmajv-pd01.res.v6.highway.a1.net. [2001:871:25b:80aa:d968:6ff0:1ba6:31eb])
        by smtp.gmail.com with ESMTPSA id 61sm22422979wrn.82.2020.03.22.16.10.58
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 22 Mar 2020 16:10:59 -0700 (PDT)
Subject: Re: Invalid optimal transfer size 33553920 accepted when
 physical_block_size 512
To:     "Martin K. Petersen" <martin.petersen@oracle.com>
Cc:     linux-scsi@vger.kernel.org
References: <33fb522e-4f61-1b76-914f-c9e6a3553c9b@gmail.com>
 <yq1o8sowfzn.fsf@oracle.com> <accd7d25-ee35-11b9-e49b-76e20d9550f2@gmail.com>
 <yq1pnd4tbxm.fsf@oracle.com> <1eb896cd-2be1-4225-88d8-5ee590fe063b@gmail.com>
 <yq1eetkrtf6.fsf@oracle.com> <58904bc3-4186-7f9c-dc3c-707aa3d92bfb@gmail.com>
 <46035460-9d63-2a9a-d37b-514640f8732f@gmail.com> <yq14kugrou0.fsf@oracle.com>
From:   Bernhard Sulzer <micraft.b@gmail.com>
Message-ID: <77e39365-d124-4dac-b4bf-17c5190f62cf@gmail.com>
Date:   Mon, 23 Mar 2020 00:10:58 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <yq14kugrou0.fsf@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

> Do the reported values change if you do the following a while after you
> plugged the drive in?
>
> # lsblk -t
> # echo 1 > /sys/block/sdc/device/rescan
> # sleep 10
> # lsblk -t

I cant say they do, as far as I could observe:

# lsblk /dev/sdc -t; echo 1 | tee /sys/block/sdc/device/rescan; sleep 
10; lsblk /dev/sdc -t
NAME ALIGNMENT MIN-IO   OPT-IO PHY-SEC LOG-SEC ROTA SCHED RQ-SIZE  RA WSAME
sdc          0   4096 33553920    4096     512    1 mq-deadline      60 
128   32M
1
NAME ALIGNMENT MIN-IO   OPT-IO PHY-SEC LOG-SEC ROTA SCHED RQ-SIZE  RA WSAME
sdc          0   4096 33553920    4096     512    1 mq-deadline      60 
128   32M


