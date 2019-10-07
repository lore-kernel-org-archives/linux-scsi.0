Return-Path: <SRS0=5MTk=YA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 06839ECE58E
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Oct 2019 20:34:18 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D2FA22133F
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Oct 2019 20:34:17 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=ucr.edu header.i=@ucr.edu header.b="qCdQ129n"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729302AbfJGUeR (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Oct 2019 16:34:17 -0400
Received: from mx3.ucr.edu ([138.23.248.64]:17036 "EHLO mx3.ucr.edu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728723AbfJGUeQ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 7 Oct 2019 16:34:16 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=ucr.edu; i=@ucr.edu; q=dns/txt; s=selector3;
  t=1570480456; x=1602016456;
  h=mime-version:from:date:message-id:subject:to;
  bh=lP0s6TrPhUPnA9k0J9KDX5uHH6OZht5S6Chm9LUAoQI=;
  b=qCdQ129nI+01Zh50fkTWiQ1W0Uj4O3Mhh0S8NGqNkAeScm+vVcaKaXH8
   7vw9KdP8mWrHchHuYIf9ZAL6dfIAE4VFqMAyq4Rf6dJxT+BpKhYopYxPT
   +p/Ck8ZQ6c+IFq2O5vd7Pq7fn2nXExdkOzX9qhsL4tGEEnATPhw1RgVEX
   UfQ4SX3Ugd9MA1Ab3fwK/QKlMixcA2kPcopN5vLJztriEm1UeO/cjt4EA
   ELi7aU2jGF60GwahzudBkaXJGJ4ZSxHQd7B23fz/Dz+UXPdWp2THQrWin
   fRIZpkEt7+X11/O3dy1iJM3LRXSrQFmTxpp2XxryXdF14TRQ5zo45AqFR
   Q==;
IronPort-SDR: FeLPt+7PIRtJgHYGfiE2epKWvLT7Fb6PbB52j4hBqqP7AU/QROzuSDdcFWtRR5cOmG0ioMf/iR
 iERc8i84Bi98EQjCjGdwY4GnZyG23fT4s5xVi92CnerXh9QjXJi9/l+Qh9AC4AHZZHjiMQsXlK
 0s7FCerx3LrKVMfUkqZi4vi44l4UskYVIAebIHtOG0HwmWWcZNjUw+bDj9GQ6uG+wW8jJrWb5x
 VXud/9166hBdT+eyDdjj16QkEVpN99NJI+zkREhlw5+THkzwSRTI9L+SgzfyrmNcx4Cx1fITsD
 Vpc=
IronPort-PHdr: =?us-ascii?q?9a23=3Ay0I7MhwbHjxE+KPXCy+O+j09IxM/srCxBDY+r6?=
 =?us-ascii?q?Qd2u8VIJqq85mqBkHD//Il1AaPAdyAra8bwLON4+jJYi8p2d65qncMcZhBBV?=
 =?us-ascii?q?cuqP49uEgeOvODElDxN/XwbiY3T4xoXV5h+GynYwAOQJ6tL1LdrWev4jEMBx?=
 =?us-ascii?q?7xKRR6JvjvGo7Vks+7y/2+94fcbglVijexe7N/IRe5oQnMuMQbgpZpJ7osxB?=
 =?us-ascii?q?fOvnZGYfldy3lyJVKUkRb858Ow84Bm/i9Npf8v9NNOXLvjcaggQrNWEDopM2?=
 =?us-ascii?q?Yu5M32rhbDVheA5mEdUmoNjBVFBRXO4QzgUZfwtiv6sfd92DWfMMbrQ704RS?=
 =?us-ascii?q?iu4qF2QxLzliwJKyA2/33WisxojaJUvhShpwBkw4XJZI2ZLedycr/Bcd8fQ2?=
 =?us-ascii?q?dKQ8RfWDFbAo6kYIQBD+QPM+VFoYfju1QDtge+CRW2Ce/z1jNEmn370Ksn2O?=
 =?us-ascii?q?ohCwHG2wkgEsoMv3TVrdT1NLoSUeeox6bLzTXMdfJW0ir65YnIcxEhoeuDXb?=
 =?us-ascii?q?NsfcbNx0QiDB7FgUmKqYD/ITyay/kNvnGd4uF9Vuyvk3Yqpx9trjWr3MshiY?=
 =?us-ascii?q?nEipgIxl3F9yh12oQ4KcO+RUVme9CrCoFQuDufN4ZuR8MiRHxntzgix70dvJ?=
 =?us-ascii?q?67YDAKyJM6xx7Dc/CHc5aH4hbkVOuJJDd3nnNleLamixa2/0is1/TwVse23V?=
 =?us-ascii?q?pUtCZFnd7MtncC1xzX9MeLUOdy/kCk2TqX1gDT7P9LIVwsmKbFN5IsxqQ8m5?=
 =?us-ascii?q?kTvEjZAyP7mUf7gLWUe0k64uSo7v7oYrTipp+SLY90jQT+P7wum82+AeQ3KA?=
 =?us-ascii?q?kOU3SH9emyz7Dj4FH2QK9QgvIoj6bZrYjWJd4Hqa6hHw9VzoEj5g67Dzen1t?=
 =?us-ascii?q?QYgHYGIEteeB2blIjpOkrDIO73DfihmVSgijRryO7cPr3nHJrNKmLPkLD7fb?=
 =?us-ascii?q?ZyuAZgz19579la6okcJ/cjZrrZXVPts9ncAw5ze1i2zuTtINF80J4OH2OFB+?=
 =?us-ascii?q?mSN6aE9RfCw+s1P+iKLKxT8A7wN/U//PPoxzdtnFYHYaivm4MadH2iBflgC0?=
 =?us-ascii?q?KDaHHoj5EKFmJc+kI6Ter3mBiZWiVST2i9Urh65TwhDo+iS4DZScTlhL2HwT?=
 =?us-ascii?q?f+HZBMYG1CIk6DHG2udIieXfoILiWILYspoDwFRKWnA7Yg3Bfm4B36yqt6KP?=
 =?us-ascii?q?P88TZeqJn5ktV5+ruX3Toy+Dp7HtnV6GaLQCkglXgPQTAe17s5vEdnjFqPzP?=
 =?us-ascii?q?4rreZfEIli5uFJTwByB57VzqQuGsLyUwOZJoyhVV28BNiqHGdiHZoK39YSbh?=
 =?us-ascii?q?MlSJ2ZhRfZ0n/vWudNmg=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2EVAwCUoJtdh0inVdFmDoYghE2OYIU?=
 =?us-ascii?q?XAYZ3hVmBGIo0AQgBAQEOLwEBhx8jOBMCAwkBAQUBAQEBAQUEAQECEAEBAQg?=
 =?us-ascii?q?NCQgphUCCOikBg1URfA8CJgIkEgEFASIBNIMAgguiYIEDPIsmgTKIYwEJDYF?=
 =?us-ascii?q?IEnoojA6CF4ERgmSIPYJYBIE4AQEBlSyWVAEGAoIQFIxUiEQbgioBlxSOLJl?=
 =?us-ascii?q?LDyOBRoF7MxolfwZngU9PEBSBaY1xWySSHAEB?=
X-IPAS-Result: =?us-ascii?q?A2EVAwCUoJtdh0inVdFmDoYghE2OYIUXAYZ3hVmBGIo0A?=
 =?us-ascii?q?QgBAQEOLwEBhx8jOBMCAwkBAQUBAQEBAQUEAQECEAEBAQgNCQgphUCCOikBg?=
 =?us-ascii?q?1URfA8CJgIkEgEFASIBNIMAgguiYIEDPIsmgTKIYwEJDYFIEnoojA6CF4ERg?=
 =?us-ascii?q?mSIPYJYBIE4AQEBlSyWVAEGAoIQFIxUiEQbgioBlxSOLJlLDyOBRoF7Mxolf?=
 =?us-ascii?q?wZngU9PEBSBaY1xWySSHAEB?=
X-IronPort-AV: E=Sophos;i="5.67,269,1566889200"; 
   d="scan'208";a="85811839"
Received: from mail-lf1-f72.google.com ([209.85.167.72])
  by smtp3.ucr.edu with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 07 Oct 2019 13:34:15 -0700
Received: by mail-lf1-f72.google.com with SMTP id r3so1697540lfn.13
        for <linux-scsi@vger.kernel.org>; Mon, 07 Oct 2019 13:34:15 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=VjVPBctNPhqavgf2eBQ5U1+nPWLcTDRc47SNVp//OKQ=;
        b=AWjhgoCpBYpID9Hon0Joo5BbKQvhULkUS06kZ/zh179YZlZU/iDiaYge/tmoIcj1Ih
         MsIdNPG5I6DXaFMRdAOZtR03Q4xnmZ8cqx1a7Rg5EWv6+J2loFhI2pSrKGs1FgqGCcZP
         ZERiKOz/o6o5AVs6u6MhxsOSdzCKLLSQiAzHFujfAvkdwWNVsQ2j65rMjsBAQ4dW4ixX
         DmsHMeVluXkaBrz/QNEPuCPZJk4WCdyUa+URKgy4t6/jfQJdb9bZvVoWeaNbBVoWJ5hl
         WctpQXqH74pK7Zfthp+/N3KRalJckpy/gDEtvkfbHfY2YKggSUYh6ciOZrKliX62o5YL
         cwCA==
X-Gm-Message-State: APjAAAVmX/3HXzRTzsRPOhNkuEQA1j3qwV3hIYR23UZBQTBGYUVyYTHe
        YM/ybpJMstI+gvYeL6swIMh7jaXc9RDASzpnlDMfIjZJFe+OBzwgKcWjRocaQSpNT8ViVJuq3t2
        n/130b5GQD449MoWd3evQYlvcHdMzr/E7Acvqzao=
X-Received: by 2002:a2e:7611:: with SMTP id r17mr15058310ljc.133.1570480453184;
        Mon, 07 Oct 2019 13:34:13 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwE73u+4iftMlE/s9XRgsWcovJSqjKS0oeZU9K2kgJOCIbYMoFo5zj1EXxuEGUsA9dh9d9KBp39RyTjGkAFTPY=
X-Received: by 2002:a2e:7611:: with SMTP id r17mr15058301ljc.133.1570480453012;
 Mon, 07 Oct 2019 13:34:13 -0700 (PDT)
MIME-Version: 1.0
From:   Yizhuo Zhai <yzhai003@ucr.edu>
Date:   Mon, 7 Oct 2019 13:34:56 -0700
Message-ID: <CABvMjLR+oYb_kaK5zUHhVhcB7a8vRj=ZJrRWahCFi9B5_YCsqQ@mail.gmail.com>
Subject: Potential NULL pointer deference in scsi
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zhiyun Qian <zhiyunq@cs.ucr.edu>,
        Chengyu Song <csong@cs.ucr.edu>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi All:

drivers/scsi/scsi.c:

Inside function __starget_for_each_device(), dev_to_shost()
could return NULL,however, the return value shost is not
checked and get used. This could potentially be unsafe.

-- 
Kind Regards,

Yizhuo Zhai

Computer Science, Graduate Student
University of California, Riverside
