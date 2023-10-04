Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 010ECE8FDCC
	for <linux-scsi@archiver.kernel.org>; Wed,  4 Oct 2023 06:38:22 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232734AbjJDGiY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 4 Oct 2023 02:38:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241399AbjJDGiX (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Oct 2023 02:38:23 -0400
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D1FD120
        for <linux-scsi@vger.kernel.org>; Tue,  3 Oct 2023 23:38:05 -0700 (PDT)
Received: by mail-lj1-x229.google.com with SMTP id 38308e7fff4ca-2bffa8578feso20154921fa.2
        for <linux-scsi@vger.kernel.org>; Tue, 03 Oct 2023 23:38:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20230601; t=1696401483; x=1697006283; darn=vger.kernel.org;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=eOJx+H1H2eQIUUKPhGEI4mBNNDbxIWiRZ/E3j6WDqrk=;
        b=fJXx8B9FrA/EiE8Ia3sHjTD+26t6Q31GuFSpStYL3CpAHCTrp0tHu4vHWDP9NeSlvm
         Z3KhQJ+ut6GGUCWN1mUuHlBdv/zWxel5mUxJuKo62msjRUH9S45EeTIYj3BtsnHWiIHR
         UsuKq1KyXMd4th3aqk6Oav9CS9tqLFcFCnkbTf7rKpN7OK7mT8yG9qfl71FbQaJTvJE9
         1o5xrwQFS6GW9Rd4GiUbtMlEhjAXhdeWVYhT8XlB2RW16R3GJ9R9Kd4v//eCLQ+cIgBe
         UASGmZPyVJ70BxeUIP/MEQyOIpE524LgruQK6XELnMQB32eVGW/vxJ1pGUKzfEZZQMs6
         WPHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20230601; t=1696401483; x=1697006283;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=eOJx+H1H2eQIUUKPhGEI4mBNNDbxIWiRZ/E3j6WDqrk=;
        b=hBF9LlVXgXZ/1SwEdOIZMo0a7R3eaoycQxXIJbKxcrxmpoI050ZisxoudpLT/OVpw3
         69xn0xxqVC7k2VKrzLRH7EOjpFbFArW5xBpftnMfiuK51/upO6EndtIW6eh68E6xXB8m
         Sw5KEGZaE0X74/jozRYnh2+CDdpAllQYym6wBurvhdH+yJubv1xvA96G/gJYQzDWQ+EA
         eLDnuPCYqu6EQwGeA4ukzdFjS70YeUTLLkVNQCxLx4zCqIAwbXtv7agLYQ/pJz2HEq5s
         sg4ipCqoCTS56PTJtu37ex/Zjpy5e1jikR/Mulc8G3P4ofO5r/S4B/+S9Q9c2TR4AS2m
         AO4g==
X-Gm-Message-State: AOJu0Yy0WhuAGDsxx501mSPoU7sOYwzsJfJbcJmcOTZ/NfcgUKMij/AW
        VYer9Pp9Vq4072qb3nUo75WaYLZL8nT5gIXqBw==
X-Google-Smtp-Source: AGHT+IH2rF1H3sCtyzo1RkT1zubW/4tZ4l6ZuAUULlwrtkHa0e5Isl4qNXiWmy7mZuY/p7Ip2JDcZ4N+kPtWQ2r7lro=
X-Received: by 2002:a2e:8895:0:b0:2c2:bdc2:af77 with SMTP id
 k21-20020a2e8895000000b002c2bdc2af77mr1153824lji.33.1696401482561; Tue, 03
 Oct 2023 23:38:02 -0700 (PDT)
MIME-Version: 1.0
References: <20231004062454.29165-1-peter.wang@mediatek.com>
In-Reply-To: <20231004062454.29165-1-peter.wang@mediatek.com>
From:   Stanley Chu <chu.stanley@gmail.com>
Date:   Wed, 4 Oct 2023 14:37:50 +0800
Message-ID: <CAGaU9a_nv2-k93wBjs_LDfLEXd14L8LagNTqFsmmT+0AH4qE8Q@mail.gmail.com>
Subject: Re: [PATCH v1] ufs: core: remove dev cmd clock scaling busy
To:     peter.wang@mediatek.com
Cc:     stanley.chu@mediatek.com, linux-scsi@vger.kernel.org,
        martin.petersen@oracle.com, avri.altman@wdc.com,
        alim.akhtar@samsung.com, jejb@linux.ibm.com,
        wsd_upstream@mediatek.com, linux-mediatek@lists.infradead.org,
        chun-hung.wu@mediatek.com, alice.chao@mediatek.com,
        cc.chou@mediatek.com, chaotian.jing@mediatek.com,
        jiajie.hao@mediatek.com, powen.kao@mediatek.com,
        qilin.tan@mediatek.com, lin.gui@mediatek.com,
        tun-yu.yu@mediatek.com, eddie.huang@mediatek.com,
        naomi.chu@mediatek.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

On Wed, Oct 4, 2023 at 2:25=E2=80=AFPM <peter.wang@mediatek.com> wrote:
>
> From: Peter Wang <peter.wang@mediatek.com>
>
> If dev command timeout, clk_scaling.active_reqs is not decrease
> and cause clock scaling framework abnormal. But it is complicated to
> handle different dev command timeout case in legacy mode or mcq mode.
> Besides, dev cmd is rare used and busy time is short.
> So remove clock scaling busy window for dev cmd is properly.
> Same as uic or tm cmd which doesn't update busy window too.
>
> Signed-off-by: Peter Wang <peter.wang@mediatek.com>

It makes sense to me since clock scaling is aimed at balancing
performance and power consumption for different workloads, which
should be data workloads rather than device commands.

Reviewed-by: Stanley Chu <stanley.chu@mediatek.com>
