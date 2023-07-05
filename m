Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 87BC3EB64DA
	for <linux-scsi@archiver.kernel.org>; Wed,  5 Jul 2023 14:33:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232350AbjGEOdY (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Wed, 5 Jul 2023 10:33:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43840 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232332AbjGEOdT (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Jul 2023 10:33:19 -0400
Received: from us-smtp-delivery-124.mimecast.com (us-smtp-delivery-124.mimecast.com [170.10.133.124])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E29AD10D5
        for <linux-scsi@vger.kernel.org>; Wed,  5 Jul 2023 07:32:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1688567550;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=FrDW3FvXxO43Yo+LpdBvy45NnDg2y1LTlrt8vexkZfI=;
        b=LoaXbM3+Ick6L1lWse7KOz0CuoM+GblyRoB0qI+HVExh+ILPeUYIsxFF/c0xwlO6Xw4Vyi
        HLDfKqgo6SGwipzqfspfSQDIJXif5/QMZwv+BxRWaFyMhlOqAV1b4eQIN3SLkxpplMVeHo
        zj1NBh+XYXAZI1ZeM+j4QFpGtV7cwDc=
Received: from mail-oi1-f197.google.com (mail-oi1-f197.google.com
 [209.85.167.197]) by relay.mimecast.com with ESMTP with STARTTLS
 (version=TLSv1.3, cipher=TLS_AES_256_GCM_SHA384) id
 us-mta-550-Mb6iGY8VOqy36dSTdcKRGQ-1; Wed, 05 Jul 2023 10:32:29 -0400
X-MC-Unique: Mb6iGY8VOqy36dSTdcKRGQ-1
Received: by mail-oi1-f197.google.com with SMTP id 5614622812f47-39edcb52625so5975151b6e.3
        for <linux-scsi@vger.kernel.org>; Wed, 05 Jul 2023 07:32:28 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1688567547; x=1691159547;
        h=mime-version:user-agent:content-transfer-encoding:references
         :in-reply-to:date:cc:to:from:subject:message-id:x-gm-message-state
         :from:to:cc:subject:date:message-id:reply-to;
        bh=FrDW3FvXxO43Yo+LpdBvy45NnDg2y1LTlrt8vexkZfI=;
        b=ldqwS8cavX16jhTwGtfXWU2QQVL6N8vtoylw4/EaBK+oMkhCl/4vI5G4uzjouNtmDS
         xaOciFxNAGAtJxpIHFRmOgj+cN05SFq2XQIEKxJJLnA/mhQbXMNl2bDCR0LGjpC3p7Pr
         rJ99lS1o42s7be2+fKzQn8ghETWrcX1FtlYlRxqFV3fNaSd2K7dVLwe/z6xVI1K9EES7
         ky72PkQiy/AQTeZ2p7wR2wIDOZxSU7wYJyiAMt5vUYGoBhADKZD4+5+/HFx9K9g3kWca
         1s5MMaj87aTeWctoAAL7ZpUSQf589fM7NoR6w0MGj/CMKIVfjVGoacE/e9M2x0CjyrpA
         6fxQ==
X-Gm-Message-State: ABy/qLaDE9PC6E//JQ0MCHOdquJf2ztdfGrf7w11qkrVDEsnYIZR8Fmm
        yODob6HarsGLJ2BUipWh1sRtQiHD9/t6Sllbk+bDJYy9M4OBfxy7VsZsryxj/mKQkKceZE3jAPS
        CQ8GhZVSpSYrsOfMnj0HKfg==
X-Received: by 2002:a05:6358:614d:b0:134:fdfc:4319 with SMTP id 13-20020a056358614d00b00134fdfc4319mr9810406rwt.20.1688567547478;
        Wed, 05 Jul 2023 07:32:27 -0700 (PDT)
X-Google-Smtp-Source: APBJJlGzUGAKG/6tRM2MKYnWVk5HWYKe2HUGrmjZ2lr16rPJhV3/ZTaeZ6D9NovuGdoSgAdfat24bA==
X-Received: by 2002:a05:6358:614d:b0:134:fdfc:4319 with SMTP id 13-20020a056358614d00b00134fdfc4319mr9810379rwt.20.1688567547153;
        Wed, 05 Jul 2023 07:32:27 -0700 (PDT)
Received: from ?IPv6:2600:6c64:4e7f:603b:7f10:16a0:5672:9abf? ([2600:6c64:4e7f:603b:7f10:16a0:5672:9abf])
        by smtp.gmail.com with ESMTPSA id h4-20020a0cf8c4000000b0062ff0dd0332sm8036650qvo.38.2023.07.05.07.32.26
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 05 Jul 2023 07:32:26 -0700 (PDT)
Message-ID: <92beb7aa971b2fb600e4d47158b66bfe660d3c89.camel@redhat.com>
Subject: Re: [PATCH v2] scsi: bnx2fc: Remove a duplicate assignment in two
 functions
From:   Laurence Oberman <loberman@redhat.com>
To:     Minjie Du <duminjie@vivo.com>, Markus.Elfring@web.de,
        Saurav Kashyap <skashyap@marvell.com>,
        Javed Hasan <jhasan@marvell.com>,
        "supporter:BROADCOM BNX2FC 10 GIGABIT FCOE DRIVER" 
        <GR-QLogic-Storage-Upstream@marvell.com>,
        "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        "open list:BROADCOM BNX2FC 10 GIGABIT FCOE DRIVER" 
        <linux-scsi@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Cc:     opensource.kernel@vivo.com
Date:   Wed, 05 Jul 2023 10:32:25 -0400
In-Reply-To: <20230705115236.16571-1-duminjie@vivo.com>
References: <20230705115236.16571-1-duminjie@vivo.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
User-Agent: Evolution 3.46.4 (3.46.4-1.fc37) 
MIME-Version: 1.0
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

T24gV2VkLCAyMDIzLTA3LTA1IGF0IDE5OjUyICswODAwLCBNaW5qaWUgRHUgd3JvdGU6Cj4gRGVs
ZXRlIGEgZHVwbGljYXRlIHN0YXRlbWVudCBmcm9tIHRoZXNlIGZ1bmN0aW9uIGltcGxlbWVudGF0
aW9ucy4KPiAKPiBTaWduZWQtb2ZmLWJ5OiBNaW5qaWUgRHUgPGR1bWluamllQHZpdm8uY29tPgo+
IC0tLQo+IMKgZHJpdmVycy9zY3NpL2JueDJmYy9ibngyZmNfaHdpLmMgfCAzIC0tLQo+IMKgMSBm
aWxlIGNoYW5nZWQsIDMgZGVsZXRpb25zKC0pCj4gCj4gZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2Nz
aS9ibngyZmMvYm54MmZjX2h3aS5jCj4gYi9kcml2ZXJzL3Njc2kvYm54MmZjL2JueDJmY19od2ku
Ywo+IGluZGV4IDc3NjU0NDM4NS4uMDQ3NGZlODhhIDEwMDY0NAo+IC0tLSBhL2RyaXZlcnMvc2Nz
aS9ibngyZmMvYm54MmZjX2h3aS5jCj4gKysrIGIvZHJpdmVycy9zY3NpL2JueDJmYy9ibngyZmNf
aHdpLmMKPiBAQCAtMTUyMSw4ICsxNTIxLDYgQEAgdm9pZCBibngyZmNfaW5pdF9zZXFfY2xlYW51
cF90YXNrKHN0cnVjdAo+IGJueDJmY19jbWQgKnNlcV9jbG5wX3JlcSwKPiDCoMKgwqDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgRkNPRV9U
Q0VfVFhfV1JfUlhfUkRfQ09OU1RfQ0xBU1NfVFlQRQo+IF9TSElGVDsKPiDCoMKgwqDCoMKgwqDC
oMKgdGFzay0+cnh3cl90eHJkLmNvbnN0X2N0eC5pbml0X2ZsYWdzID0gY29udGV4dF9pZCA8PAo+
IMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqBGQ09FX1RDRV9SWF9XUl9UWF9SRF9DT05TVF9DSURfU0hJRlQ7Cj4gLcKgwqDCoMKg
wqDCoMKgdGFzay0+cnh3cl90eHJkLmNvbnN0X2N0eC5pbml0X2ZsYWdzID0gY29udGV4dF9pZCA8
PAo+IC3CoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoEZDT0VfVENFX1JYX1dSX1RYX1JEX0NPTlNUX0NJRF9TSElGVDsKPiDCoAo+IMKg
wqDCoMKgwqDCoMKgwqB0YXNrLT50eHdyX3J4cmQudW5pb25fY3R4LmNsZWFudXAuY3R4LmNsZWFu
ZWRfdGFza19pZCA9Cj4gb3JpZ194aWQ7Cj4gwqAKPiBAQCAtMTc2Myw3ICsxNzYxLDYgQEAgdm9p
ZCBibngyZmNfaW5pdF90YXNrKHN0cnVjdCBibngyZmNfY21kCj4gKmlvX3JlcSwKPiDCoMKgwqDC
oMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
RkNPRV9UQVNLX0RFVl9UWVBFX1RBUEUgPDwKPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgRkNPRV9UQ0VfVFhfV1JfUlhfUkRf
Q09OU1RfREVWX1RZUEVfUwo+IEhJRlQ7Cj4gwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqBpb19yZXEtPnJlY19yZXRyeSA9IDA7Cj4gLcKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDC
oGlvX3JlcS0+cmVjX3JldHJ5ID0gMDsKPiDCoMKgwqDCoMKgwqDCoMKgfSBlbHNlCj4gwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqB0YXNrLT50eHdyX3J4cmQuY29uc3RfY3R4LmluaXRf
ZmxhZ3MgfD0KPiDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKgwqDCoMKg
wqDCoMKgwqDCoMKgwqDCoMKgRkNPRV9UQVNLX0RFVl9UWVBFX0RJU0sgPDwKCkxvb2tzIGdvb2Qg
dG8gbWU6CgpSZXZpZXdlZC1ieTogTGF1cmVuY2UgT2Jlcm1hbiA8bG9iZXJtYW5AcmVkaGF0LmNv
bT4KCgo=

