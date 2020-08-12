Return-Path: <SRS0=c2qj=BW=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.1 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id CA058C433E1
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Aug 2020 07:35:46 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A966020771
	for <linux-scsi@archiver.kernel.org>; Wed, 12 Aug 2020 07:35:46 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=linaro.org header.i=@linaro.org header.b="D1jFIJxP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726517AbgHLHfn (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 12 Aug 2020 03:35:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726479AbgHLHfm (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 12 Aug 2020 03:35:42 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1D8CC061788
        for <linux-scsi@vger.kernel.org>; Wed, 12 Aug 2020 00:35:41 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id d190so903427wmd.4
        for <linux-scsi@vger.kernel.org>; Wed, 12 Aug 2020 00:35:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=XfihqZsdjcdv5tVC7wFsr1o1gj8RLJpLWlctKxN00t8=;
        b=D1jFIJxPQA80z4Eomgeer1iZdbOW9i+Hnn/nDZS6eevvWKao7/cwonferaNNU0lDOn
         R2PlHUawpbNnQy2lpSfhVmDKCpV5+3ZZrjVrht4ftusjDyemANZuF8poyrzzDdkZlrTP
         NZWxV8t02OVEbriVK59+v/oTltvWcdYasg/x6cSmxX27Wg20UEftg5v0pjztSMFzgZdh
         1a4OACCvYZAA6lgr4+CZ7aADb2ZEqDAMxLN4T6H+YvD3OwPPhY5yrXswYmBip4mAW08o
         s32CNccl/Xgg1SNdFl8S9DlNGqKtX+ZK0qkzi6pf7thn24wUWViiOHhaojWLqpgSqA6A
         oj9g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=XfihqZsdjcdv5tVC7wFsr1o1gj8RLJpLWlctKxN00t8=;
        b=Ej2rEJoFv/kgTQ62dCDT80xMQdaAx3yH+3ve2YS/rfBdfiF9XMqRKy7Jy4p5FvOdSY
         QgPCU6oIolKIQyYV3OJTWIE07PluXdUSWHJlU5cXYUu8YM479SAOdrErnKTlCpLPVwSS
         oypmdSVqWFptG0W45bGq1l2ZdrIRkSOgEGB0tVDuJVQpeK35r7TCxrEBFuS4c9qkBMHw
         k7rUWLER/U2xg13Jgyz0LUBKAxMdR3wyBL6vFcWXHsw3gNzB0jV7JNjyb5hATerETC0i
         sCoP5HPbNVCQdroKtvvdgH+Fr2LoMhzqwQotScf4WiD1Hf0IyzxtfAVAloKI+XRlth7K
         tH2A==
X-Gm-Message-State: AOAM533ZDLCqtpIoYOcFoQi17EtZTCxJYH2NyNfITxTjjpHluh9H3tfu
        By6+t2w3ypAdi1mZRFfuZJfQ86EiTSUFE6EDDjv6Qw==
X-Google-Smtp-Source: ABdhPJzBNC/YM9uamzZ0gfpPsY6JeU/UxZmU8cQyqqtnB+YoX60CEAXzfjO07RBy0Wno5duRrD7MVej1m1/TUxoj2w8=
X-Received: by 2002:a05:600c:2209:: with SMTP id z9mr7122422wml.70.1597217740367;
 Wed, 12 Aug 2020 00:35:40 -0700 (PDT)
MIME-Version: 1.0
References: <20190320094918.20234-1-rnayak@codeaurora.org> <20190320094918.20234-4-rnayak@codeaurora.org>
 <CALAqxLV2TBk9ScUM6MeJMCkL8kJnCihjQ7ac5fLzcqOg1rREVQ@mail.gmail.com>
 <CALAqxLWg3jJKJFLnnne-mrQEnH=m7R_9azCGaGnEmFYR4EMh=A@mail.gmail.com> <ec5eeb21-48e4-5dcc-583a-ac9419659e44@codeaurora.org>
In-Reply-To: <ec5eeb21-48e4-5dcc-583a-ac9419659e44@codeaurora.org>
From:   Amit Pundir <amit.pundir@linaro.org>
Date:   Wed, 12 Aug 2020 13:05:04 +0530
Message-ID: <CAMi1Hd1O+3bjQN6c9WQr+t0YXGBAukfFzJWtkgXDp1Zcir-0-w@mail.gmail.com>
Subject: Re: [RFC v2 03/11] tty: serial: qcom_geni_serial: Use OPP API to set
 clk/perf state
To:     Rajendra Nayak <rnayak@codeaurora.org>
Cc:     John Stultz <john.stultz@linaro.org>,
        lkml <linux-kernel@vger.kernel.org>,
        Ulf Hansson <ulf.hansson@linaro.org>,
        linux-scsi@vger.kernel.org,
        Linux PM list <linux-pm@vger.kernel.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Doug Anderson <dianders@chromium.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        linux-spi@vger.kernel.org, linux-serial@vger.kernel.org,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Stephen Boyd <swboyd@chromium.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi Rajendra,

On Wed, 12 Aug 2020 at 11:18, Rajendra Nayak <rnayak@codeaurora.org> wrote:
>
>
> On 8/12/2020 7:03 AM, John Stultz wrote:
> > On Tue, Aug 11, 2020 at 4:11 PM John Stultz <john.stultz@linaro.org> wrote:
> >>
> >> On Wed, Mar 20, 2019 at 2:49 AM Rajendra Nayak <rnayak@codeaurora.org> wrote:
> >>>
> >>> geni serial needs to express a perforamnce state requirement on CX
> >>> depending on the frequency of the clock rates. Use OPP table from
> >>> DT to register with OPP framework and use dev_pm_opp_set_rate() to
> >>> set the clk/perf state.
> >>>
> >>> Signed-off-by: Rajendra Nayak <rnayak@codeaurora.org>
> >>> Signed-off-by: Stephen Boyd <swboyd@chromium.org>
> >>> ---
> >>>   drivers/tty/serial/qcom_geni_serial.c | 15 +++++++++++++--
> >>>   1 file changed, 13 insertions(+), 2 deletions(-)
> >>>
> >>
> >> Hey,
> >>    I just wanted to follow up on this patch, as I've bisected it
> >> (a5819b548af0) down as having broken qca bluetooth on the Dragonboard
> >> 845c.
> >>
> >> I haven't yet had time to debug it yet, but wanted to raise the issue
> >> in case anyone else has seen similar trouble.
> >
> > So I dug in a bit further, and this chunk seems to be causing the issue:
> >> @@ -961,7 +963,7 @@ static void qcom_geni_serial_set_termios(struct uart_port *uport,
> >>                  goto out_restart_rx;
> >>
> >>          uport->uartclk = clk_rate;
> >> -       clk_set_rate(port->se.clk, clk_rate);
> >> +       dev_pm_opp_set_rate(port->dev, clk_rate);
> >>          ser_clk_cfg = SER_CLK_EN;
> >>          ser_clk_cfg |= clk_div << CLK_DIV_SHFT;
> >>
> >
> >
> > With that applied, I see the following errors in dmesg and bluetooth
> > fails to function:
> > [    4.763467] qcom_geni_serial 898000.serial: dev_pm_opp_set_rate:
> > failed to find OPP for freq 102400000 (-34)
> > [    4.773493] qcom_geni_serial 898000.serial: dev_pm_opp_set_rate:
> > failed to find OPP for freq 102400000 (-34)
> >
> > With just that chunk reverted on linus/HEAD, bluetooth seems to work ok.
>
> This seems like the same issue that was also reported on venus [1] because the
> clock frequency tables apparently don;t exactly match the achievable clock
> frequencies (which we also used to construct the OPP tables)
>
> Can you try updating the OPP table for QUP to have 102400000 instead of the
> current 100000000 and see if that fixes it?

That worked. Thanks.

Should this change be common to base sdm845.dtsi or platform specific dts?
For what it's worth, we see this BT breakage on PocoF1 phone too.

Regards,
Amit Pundir


>
> [1] https://lkml.org/lkml/2020/7/27/507
>
> >
> > thanks
> > -john
> >
>
> --
> QUALCOMM INDIA, on behalf of Qualcomm Innovation Center, Inc. is a member
> of Code Aurora Forum, hosted by The Linux Foundation
