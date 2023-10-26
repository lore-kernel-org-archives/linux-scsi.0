Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 1DC22C25B48
	for <linux-scsi@archiver.kernel.org>; Thu, 26 Oct 2023 21:36:19 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232068AbjJZVgT (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 26 Oct 2023 17:36:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230225AbjJZVgS (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Oct 2023 17:36:18 -0400
Received: from mail-pl1-f178.google.com (mail-pl1-f178.google.com [209.85.214.178])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A0402C1;
        Thu, 26 Oct 2023 14:36:16 -0700 (PDT)
Received: by mail-pl1-f178.google.com with SMTP id d9443c01a7336-1c9e95aa02dso10422665ad.0;
        Thu, 26 Oct 2023 14:36:16 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1698356176; x=1698960976;
        h=content-transfer-encoding:in-reply-to:from:references:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=M/ZjH9kWcN3uICpZxglOI/sR+MzCl1VnUaAV6WJoWeo=;
        b=fYxRStmR1WhOLcD3aLGc/Yy7r0s0cOIBVO+icM5pRF9MV2IIhKBZhcaEU9LakYf+Um
         ixuN3Y4oQeleq0Y0M8q4Ry5OIV5c+5RSUJUGtOpZkvvweVgzVPHjvHGRD/pY9N67V9Ym
         3YF7wCnIWCPhEH8rKfl1MUcicRZDf8IVjvTssEV4z/OHgPXQVB3Cd/l5xQBZNSlx87n3
         OOONyGhnkLLwWsaAH/g+0UtBtrvBlNJDSei5WtTrHL6bWtcuvj7H7rweGFMMosHWd8Vm
         tlVu4sEqIfWfwGo9/TOnuVbbfzr2nX0SJy3l+0G0EZNBoP7xzuidFxWqY+yBEqEepS16
         LPAQ==
X-Gm-Message-State: AOJu0YzkpgAnzC+HeLm35a1FJMe4yu0Bj+tOCU1o+DmKubH2xdSrtTCy
        gFx5QkW5sYfGEb/teDNml/0=
X-Google-Smtp-Source: AGHT+IHIgh1o48kV+ZrPWZxdiCqpRiLQZ7rrEpAmUvOf6UosavfhvbaQ/aT9/8UuZZQTHiLkU6hFjg==
X-Received: by 2002:a17:902:d50b:b0:1c8:75d9:f7dc with SMTP id b11-20020a170902d50b00b001c875d9f7dcmr4926978plg.28.1698356175879;
        Thu, 26 Oct 2023 14:36:15 -0700 (PDT)
Received: from ?IPV6:2620:15c:211:201:de84:df0e:e310:eaf1? ([2620:15c:211:201:de84:df0e:e310:eaf1])
        by smtp.gmail.com with ESMTPSA id ju19-20020a170903429300b001bf52834696sm134506plb.207.2023.10.26.14.36.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 26 Oct 2023 14:36:15 -0700 (PDT)
Message-ID: <23f25e02-a451-4ad4-bb04-e3449a1e6dea@acm.org>
Date:   Thu, 26 Oct 2023 14:36:13 -0700
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: [PATCH] scsi: sd: Introduce manage_shutdown device flag
Content-Language: en-US
To:     James Bottomley <James.Bottomley@HansenPartnership.com>,
        Damien Le Moal <dlemoal@kernel.org>,
        "Martin K . Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
References: <20231025070117.464903-1-dlemoal@kernel.org>
 <39fef5f8e090d50eb22d73d6bb39b21edf62b565.camel@HansenPartnership.com>
 <bf780d7a-30f3-4744-adde-73b4c2723d6b@kernel.org>
 <c3dfca871ddddfeef004fdb74432630a148300f2.camel@HansenPartnership.com>
From:   Bart Van Assche <bvanassche@acm.org>
In-Reply-To: <c3dfca871ddddfeef004fdb74432630a148300f2.camel@HansenPartnership.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 10/26/23 05:01, James Bottomley wrote:
> Heh, well, I was going to say we should still point to the doc, but I
> simply can't find it, so the above is perhaps the best we can do,
> thanks!

I think this should be documented in the Documentation/power directory.
After having taken another look at that directory, I see that there
is only detailed documentation and no overview documentation. Maybe I
overlooked something but I couldn't find an explanation of the system
suspend/resume nor of the runtime power management concepts in that
directory. My understanding is that system suspend/resume is about
system-wide power state changes (hibernation and suspend-to-RAM) and
also that runtime power management is about changing the power state of
a single device or bus if no activity has happened within a certain
time.

Bart.

