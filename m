Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9D451C433F5
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Sep 2021 16:34:48 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 74A2760EE2
	for <linux-scsi@archiver.kernel.org>; Mon, 27 Sep 2021 16:34:48 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235338AbhI0QgZ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 27 Sep 2021 12:36:25 -0400
Received: from mail-pj1-f52.google.com ([209.85.216.52]:50862 "EHLO
        mail-pj1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232125AbhI0QgK (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Sep 2021 12:36:10 -0400
Received: by mail-pj1-f52.google.com with SMTP id k23so12868685pji.0
        for <linux-scsi@vger.kernel.org>; Mon, 27 Sep 2021 09:34:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ztbs+C5K/jxFsIvpmS6R9Zp77YfNkkd2BFyMVNWzvW0=;
        b=UuABvqr5xxzgs+bzFuyqU51P8Bw4Z8US626BfEpvl6OJhTGp+zkXnrE5PyL0foTVhN
         sDwlGJCw4XrD9aNaPZV3pZMAlvEEV4i8H1QmnFUEGLCLKqDT1XavFDZ3voOfYOHYVCIZ
         EZ73oVmLfx8zlFn1DML55qW9QjZq2M8OMgY/yRpxnCgRIA0ejbOikH8ZZfqD0wFKlTZw
         pjHd3gkPamwLAs+PXzJWyR7PmEfSIZDU2UcleWM4N4H2HAb0zRiBIPWaRAw8dlTzAmAl
         zrnQNptw6Fq0KSpE+L7oIXQgDxZ4J+88M4xkaUUyAsGD7FP1bSWQGQo4KqnBGg3jbS3U
         ES9w==
X-Gm-Message-State: AOAM532WPybHs4qEclx/ZTWdTKsqylniUrlPeAZdNeT9YP6BavggIRRR
        vA5HonDRi6N62va8GO84bUo=
X-Google-Smtp-Source: ABdhPJz/oyx6+i3BWZARFgiRCM+CIu4RdLYjooCUeHIgb3xD6fAqFR2kgopVRnuJ2TNOCc18RbPTyQ==
X-Received: by 2002:a17:90a:1f4a:: with SMTP id y10mr893388pjy.225.1632760471944;
        Mon, 27 Sep 2021 09:34:31 -0700 (PDT)
Received: from bvanassche-linux.mtv.corp.google.com ([2620:15c:211:201:eed8:744a:6ba3:d1b])
        by smtp.gmail.com with ESMTPSA id x5sm11388989pfq.136.2021.09.27.09.34.30
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 27 Sep 2021 09:34:31 -0700 (PDT)
Subject: Re: About ufshcd_err_handling_unprepare
To:     Kiwoong Kim <kwmad.kim@samsung.com>, linux-scsi@vger.kernel.org,
        alim.akhtar@samsung.com, avri.altman@wdc.com, jejb@linux.ibm.com,
        martin.petersen@oracle.com, beanhuo@micron.com,
        cang@codeaurora.org, adrian.hunter@intel.com, sc.suh@samsung.com,
        hy50.seo@samsung.com, sh425.lee@samsung.com,
        bhoon95.kim@samsung.com
References: <CGME20210927073953epcas2p26eeb9e4fbb86bb54d7dd73acc5beb28a@epcas2p2.samsung.com>
 <005701d7b372$dc01ad20$94050760$@samsung.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <28332c27-c5d0-b309-db15-b83bf57b3dfd@acm.org>
Date:   Mon, 27 Sep 2021 09:34:29 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.13.0
MIME-Version: 1.0
In-Reply-To: <005701d7b372$dc01ad20$94050760$@samsung.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/27/21 12:39 AM, Kiwoong Kim wrote:
> I have one question about ufshcd_clear_ua_wluns in ufshcd_err_handling_unprepare.
> You probably know a scsi command (request sense) is issued in there to clear UAC for W-LUs.
> 
> Let's think about a situation that a read command is timed-out.
> And then scmd_eh_abort_handler is called, shost's state is transitioned to SHOST_RECOVERY and scsi_sh is waken up.
> If this is the case that the scsi_eh goes up to eh_host_reset_handler,
> ufshcd_eh_host_reset_handler queues ufshcd_err_handler and waits for its completion.
> And this function can call ufshcd_err_handling_unprepare at the end.
> 
> But I think, at this time, the scsi command, i.e. request sense, could not be dispatched because of the shost's state.
> Is it needed to be fixed or did I miss something?

Hi Kiwoong,

Please help with reviewing this patch series since this series should resolve the
issue described above:

https://lore.kernel.org/linux-scsi/20210922093842.18025-1-adrian.hunter@intel.com/

Thanks,

Bart.
