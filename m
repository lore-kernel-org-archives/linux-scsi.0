Return-Path: <SRS0=m3i9=XZ=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	INCLUDES_PATCH,MAILING_LIST_MULTI,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5CA52C32792
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Sep 2019 15:54:50 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 359F5215EA
	for <linux-scsi@archiver.kernel.org>; Mon, 30 Sep 2019 15:54:50 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732054AbfI3Pyt (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 30 Sep 2019 11:54:49 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:46347 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727767AbfI3Pyt (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Sep 2019 11:54:49 -0400
Received: by mail-pf1-f193.google.com with SMTP id q5so5833928pfg.13
        for <linux-scsi@vger.kernel.org>; Mon, 30 Sep 2019 08:54:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=6nnaWrahrv8pf6cPwJuOdVrLFporIeXFZUzopL7VFsU=;
        b=URvdZM1vMa8cH3euHLPHicpaMr9ZKVAwWFXd2Xww3rFK301BlFViLowO8lj50w/6UN
         B1m2l13Fr5tGjjMccddar6ynW7dsZM99bGDfOTUSs5W7qH016tkN5dQToWcZQkSMYLlc
         lXkMFcAXooM/yaCsh4eImt/z0+8wB4lXZplDK8pYiYhVENdxRbEzO5ggVGIEO1V0sZzw
         sDz9M+lMGyxIdhv4PwNI5lIlthqoYmzuW2mxvZLIWnY7OqoaFUXYjXQQQPN0ULfL4Qoh
         SmKSvrcznyKXM7p914gPpXahRUsVsOYxviKgYVzfT6CXzNxHi9iM5T0JF7pE3Cp7eh4E
         smmw==
X-Gm-Message-State: APjAAAUBJRrq1nnyqg7NBF7tCblzcfxsDehQqJD8ObJTI9A0uDayM2GW
        u8MN0rfcOLpyvJIb3feYSzfFKMWD
X-Google-Smtp-Source: APXvYqxIJ7G2ql3nGeebJlgh4sFb7Ls+rTKxvRFYwzz/tQZS2Y5rIYcYigXUQRDTX28arsLJCdWktQ==
X-Received: by 2002:a63:1a4e:: with SMTP id a14mr24998402pgm.376.1569858888430;
        Mon, 30 Sep 2019 08:54:48 -0700 (PDT)
Received: from desktop-bart.svl.corp.google.com ([2620:15c:2cd:202:4308:52a3:24b6:2c60])
        by smtp.gmail.com with ESMTPSA id q88sm17865465pjq.9.2019.09.30.08.54.47
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 30 Sep 2019 08:54:47 -0700 (PDT)
Subject: Re: [PATCH v2 02/14] qla2xxx: Fix unbound sleep in fcport delete
 path.
To:     Himanshu Madhani <hmadhani@marvell.com>,
        James.Bottomley@HansenPartnership.com, martin.petersen@oracle.com
Cc:     linux-scsi@vger.kernel.org
References: <20190912180918.6436-1-hmadhani@marvell.com>
 <20190912180918.6436-3-hmadhani@marvell.com>
From:   Bart Van Assche <bvanassche@acm.org>
Message-ID: <53960c89-b77b-2a35-7644-9dd83244249c@acm.org>
Date:   Mon, 30 Sep 2019 08:54:46 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190912180918.6436-3-hmadhani@marvell.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On 9/12/19 11:09 AM, Himanshu Madhani wrote:
> From: Quinn Tran <qutran@marvell.com>
> 
> There are instances, though rare, where a LOGO request
> cannot be sent out and the thread in free session done
> can wait indefinitely. Fix this by putting an upper
> bound to sleep.
> 
> Signed-off-by: Quinn Tran <qutran@marvell.com>
> Signed-off-by: Himanshu Madhani <hmadhani@marvell.com>
> ---
>   drivers/scsi/qla2xxx/qla_target.c | 4 ++++
>   1 file changed, 4 insertions(+)
> 
> diff --git a/drivers/scsi/qla2xxx/qla_target.c b/drivers/scsi/qla2xxx/qla_target.c
> index 0ffda6171614..b58ecd2d7fb6 100644
> --- a/drivers/scsi/qla2xxx/qla_target.c
> +++ b/drivers/scsi/qla2xxx/qla_target.c
> @@ -1020,6 +1020,7 @@ void qlt_free_session_done(struct work_struct *work)
>   
>   	if (logout_started) {
>   		bool traced = false;
> +		u16 cnt = 0;
>   
>   		while (!READ_ONCE(sess->logout_completed)) {
>   			if (!traced) {
> @@ -1029,6 +1030,9 @@ void qlt_free_session_done(struct work_struct *work)
>   				traced = true;
>   			}
>   			msleep(100);
> +			cnt++;
> +			if (cnt > 200)
> +				break;
>   		}
>   
>   		ql_dbg(ql_dbg_disc, vha, 0xf087,
> 

Hi Himanshu,

Is qla2x00_async_iocb_timeout() called if no response is received for a 
LOGO request? If so, has it been considered to modify that function 
instead of qlt_free_session_done()?

Thanks,

Bart.
