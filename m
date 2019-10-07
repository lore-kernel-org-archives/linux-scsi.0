Return-Path: <SRS0=5MTk=YA=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 67584ECE58C
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Oct 2019 20:30:29 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3BEFD206C0
	for <linux-scsi@archiver.kernel.org>; Mon,  7 Oct 2019 20:30:29 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=ucr.edu header.i=@ucr.edu header.b="WWGo+CM4"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729263AbfJGUa2 (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Mon, 7 Oct 2019 16:30:28 -0400
Received: from mx5.ucr.edu ([138.23.62.67]:17712 "EHLO mx5.ucr.edu"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728187AbfJGUa2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 7 Oct 2019 16:30:28 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=ucr.edu; i=@ucr.edu; q=dns/txt; s=selector3;
  t=1570480228; x=1602016228;
  h=mime-version:from:date:message-id:subject:to;
  bh=WZdJ9Jb3KxHxJBtuOx83LGJHR6vLyDJ32s1vBewrsBg=;
  b=WWGo+CM4vfnuTk0B5szLoqUln+tUpUnnZKybn22mIhwPe2dONQ9ObaIJ
   WvjASTLCKXi4iLu507nyvcymtUaYiBeDPuRpGFLlrvSZTH+Nn2mGgVeFY
   /ly3dusgt76rdRcYrpFobzhf/x/n36JhnYwiempEdgQfwAdpF5TZakSFj
   WH54EL1LLE7dXrOiv1IiHTTrJly1amPesLHdHI7eWPC97jmi5vursD95Y
   ExjrbYJndllojIIszVND/7THkukXVP3uYU8+13tZ2A4+nOqozgDuOJtrk
   Z1vM70fsE1JlPjs3jqyu6krfP7M4iBby18AicbSVzaUk28+IKhlFVyLBG
   w==;
IronPort-SDR: cBNz2IZfeyAn8qyJn6AFcwb7/9xz9kg8gOVM1kry1MXblsyBayMS6EvT0jYHdbDvOK0C09Fqmi
 0RwDh+b7+mGjVUJMOX/jdlPEyTNK/CNbCKNRnkOciMqbwOF/6uuNcG9J3ySscczvnmfYfL7pLP
 XrpajRwcbx318WfMmsEh9kp/aqt+pzjJN0euQC3acYub7AkcDMMEoGPsrdFtP2j41WnDxOBT1T
 Bz/G48rLXLYR6FAJj1xwb+NQXIqymbfWZZQNk6weYvb5OUkwXdps0ejofTDzBORVzy6KdPi30k
 ZXo=
IronPort-PHdr: =?us-ascii?q?9a23=3Alvj5GRwIplLmHGzXCy+O+j09IxM/srCxBDY+r6?=
 =?us-ascii?q?Qd2u8VIJqq85mqBkHD//Il1AaPAdyAra8bwLON7OjJYi8p2d65qncMcZhBBV?=
 =?us-ascii?q?cuqP49uEgeOvODElDxN/XwbiY3T4xoXV5h+GynYwAOQJ6tL1LdrWev4jEMBx?=
 =?us-ascii?q?7xKRR6JvjvGo7Vks+7y/2+94fcbglVijexe7N/IRe5oQnMuMQbg5ZpJ7osxB?=
 =?us-ascii?q?fOvnZGYfldy3lyJVKUkRb858Ow84Bm/i9Npf8v9NNOXLvjcaggQrNWEDopM2?=
 =?us-ascii?q?Yu5M32rhbDVheA5mEdUmoNjBVFBRXO4QzgUZfwtiv6sfd92DWfMMbrQ704RS?=
 =?us-ascii?q?iu4qF2QxLzliwJKyA2/33WisxojaJUvhShpwBkw4XJZI2ZLedycr/Bcd8fQ2?=
 =?us-ascii?q?dKQ8RfWDFbAo6kYIQBD+QPM+VFoYfju1QDtge+CRW2Ce/z1jNEmn370Ksn2O?=
 =?us-ascii?q?ohCwHG2wkgEsoMv3TVrdT1NLoSUeeox6bLzTXMdfJW0ir65YnIcxEhoeuDXb?=
 =?us-ascii?q?NsfcbNx0QiDB7FgUmKqYD/ITyay/kNvnGd4uF9Vuyvk3Yqpx9trjWr3MshiY?=
 =?us-ascii?q?nEipgIxl3F9yh12oc4KNm+RUVme9CrCoFQuDufN4ZuR8MiRHxntzgix70dvJ?=
 =?us-ascii?q?67YDAKyJM6xx7Dc/CHc5aH4hbkVOuJJDd3nnNleLamixa2/0is1/TwVse13V?=
 =?us-ascii?q?tOtCZFnd7MtncC1xzX9MeLUOdy/kCk2TqX1gDT7P9LIVwsmKbFN5IsxqQ8m5?=
 =?us-ascii?q?kTvEjZAyP7mUf7gLWXe0gg4uSo7v7oYrTipp+SLY90jQT+P7wum82+AeQ3KA?=
 =?us-ascii?q?kOU3SH9emyz7Dj4FH2QK9QgvIoj6bZrYjWJd4Hqa6hHw9VzoEj5g67Dzen1t?=
 =?us-ascii?q?QYgHYGIEteeB2blIjpOkrDIO73DfihmVSgijRryO7cPr3nHJrNKmLPkLD7fb?=
 =?us-ascii?q?ZyuAZgz19579la6okcJ/cjZrrZXVPts9ncAw5ze1i2zuTtINF80J4OH2OFB+?=
 =?us-ascii?q?mSN6aE9RfCw+s1P+iKLKxT8A7wN/U//PPoxzdtnFYHYaivm4MadH2iBflgC0?=
 =?us-ascii?q?KDaHHoj5EKFmJc+kI6Ter3mBiZWiVST2i9Urh65TwhDo+iS4DZScTlhL2HwT?=
 =?us-ascii?q?f+HZBMYG1CIk6DHG2udIieXfoILiWILYspuTwJU7ewVsca0heh/Fvx0L1hIc?=
 =?us-ascii?q?Lf4WsFvoil2dRosambpxEz5CFyR/2c2mfFG3N0n3IVQSYe17s5vEdnjFqPzP?=
 =?us-ascii?q?4rreZfEIli5uFJTwByB57VzqQuGsLyUwOZJoyhVV28BNiqHGdiHZoK39YSbh?=
 =?us-ascii?q?MlSJ2ZhRfZ0n/vWudNmg=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2EVAwBhn5tdh0WnVdFmDoYghE2OYIU?=
 =?us-ascii?q?XAYZ3hVmBGIMRhyMBCAEBAQ4vAQGHHyM4EwIDCQEBBQEBAQEBBQQBAQIQAQE?=
 =?us-ascii?q?BCA0JCCmFQII6KQGDVRF8DwImAiQSAQUBIgE0gwCCCwWiYIEDPIsmgTKIYAE?=
 =?us-ascii?q?JDYFIEnoojA6CF4ERg1CHUYJYBIE4AQEBlSyWVAEGAoIQFIxUiEQbgioBlxQ?=
 =?us-ascii?q?tjX+ZSw8jgUaBezMaJX8GZ4FPTxAUgWmNcVskkhwBAQ?=
X-IPAS-Result: =?us-ascii?q?A2EVAwBhn5tdh0WnVdFmDoYghE2OYIUXAYZ3hVmBGIMRh?=
 =?us-ascii?q?yMBCAEBAQ4vAQGHHyM4EwIDCQEBBQEBAQEBBQQBAQIQAQEBCA0JCCmFQII6K?=
 =?us-ascii?q?QGDVRF8DwImAiQSAQUBIgE0gwCCCwWiYIEDPIsmgTKIYAEJDYFIEnoojA6CF?=
 =?us-ascii?q?4ERg1CHUYJYBIE4AQEBlSyWVAEGAoIQFIxUiEQbgioBlxQtjX+ZSw8jgUaBe?=
 =?us-ascii?q?zMaJX8GZ4FPTxAUgWmNcVskkhwBAQ?=
X-IronPort-AV: E=Sophos;i="5.67,269,1566889200"; 
   d="scan'208";a="81214984"
Received: from mail-lf1-f69.google.com ([209.85.167.69])
  by smtpmx5.ucr.edu with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 07 Oct 2019 13:30:19 -0700
Received: by mail-lf1-f69.google.com with SMTP id w22so1689268lfe.2
        for <linux-scsi@vger.kernel.org>; Mon, 07 Oct 2019 13:30:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:from:date:message-id:subject:to;
        bh=55dhnuYmVazkQySeH4LJMqj3qTpKbtoaQ6fsEhqhvMQ=;
        b=nVjae/CLrz72dS8+CY0vb9U0DtuNnIKd1JpD7pJtCfTA62oOZgUbpWfYPBHheijx/x
         GWRKJgnPW1T4PPQzZpVOX1QpTOW9Et3xL94rqDpncxZF9QzyggLvA+S4QXRw+2rFVbQv
         1qR1n07BYSX8sXHaC0WLBwIbwHHSKBi9iv4OfLvefQb2OZ592dMhQGOaTibt8fOnb32i
         9rWTTQzRouRKDGMEokX7hfRTQbpl9033miLIlkd0T7dTQG2R2Ih0yPXkRhwc0mmTNA3c
         79k26hK308LKYU30gDVAnGxQDzV4hdqx9c7xwKdwFayQZCJdAeqjDrGxqO8OohiMtrl8
         hoBA==
X-Gm-Message-State: APjAAAV7YlKoMU/nobuX4tCHASF/6UQIAFUgoWL/Nx2igF8vYWdxhql1
        oue+JsXo2ulYiRw+Wld0qu1BMmX8vDgnSaTkzwUU01yEqtuQWz+Rfgxgsw5uo2QerIBlNpiM3sV
        +keLjChPwPtgZN8XGuYt9zWIH8PHOW9JL3F+FckY=
X-Received: by 2002:a05:651c:283:: with SMTP id b3mr20056079ljo.25.1570480216576;
        Mon, 07 Oct 2019 13:30:16 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwIiP41LU5FNlyZ0Inupz9ufcy5XrKk05nCT7f8X0nvzNx8eHN+9iP6ewKceRhfBV9vtdcEMIXfJaE/0NI2aEs=
X-Received: by 2002:a05:651c:283:: with SMTP id b3mr20056069ljo.25.1570480216371;
 Mon, 07 Oct 2019 13:30:16 -0700 (PDT)
MIME-Version: 1.0
From:   Yizhuo Zhai <yzhai003@ucr.edu>
Date:   Mon, 7 Oct 2019 13:30:59 -0700
Message-ID: <CABvMjLSoa6WfdmvwCCPgAUtc1ZmQ8+14xrDnz5Q8MrpFstMDsg@mail.gmail.com>
Subject: Potential NULL pointer deference in scsi: scsi_transport_spi
To:     "James E.J. Bottomley" <jejb@linux.ibm.com>,
        "Martin K. Petersen" <martin.petersen@oracle.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Chengyu Song <csong@cs.ucr.edu>,
        Zhiyun Qian <zhiyunq@cs.ucr.edu>
Content-Type: text/plain; charset="UTF-8"
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hi All:

drivers/scsi/scsi_transport_spi.c:

Inside function store_spi_transport_period(), dev_to_shost()
could return NULL, however, the return value shost is not
checked and get used. This could potentially be unsafe.

-- 
Kind Regards,

Yizhuo Zhai

Computer Science, Graduate Student
University of California, Riverside
