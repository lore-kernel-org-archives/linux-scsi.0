Return-Path: <linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.6 required=3.0 tests=BAYES_00,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 01636C433E0
	for <linux-scsi@archiver.kernel.org>; Sat,  9 Jan 2021 12:30:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id C1A78235DD
	for <linux-scsi@archiver.kernel.org>; Sat,  9 Jan 2021 12:30:25 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726357AbhAIMaJ (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Sat, 9 Jan 2021 07:30:09 -0500
Received: from esa.microchip.iphmx.com ([68.232.153.233]:45867 "EHLO
        esa.microchip.iphmx.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725983AbhAIMaJ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Sat, 9 Jan 2021 07:30:09 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=microchip.com; i=@microchip.com; q=dns/txt; s=mchp;
  t=1610195409; x=1641731409;
  h=from:to:cc:subject:date:message-id:mime-version;
  bh=KQ7yH6uBhBUlG4QrD5c7DuEAUfG8RnkAfQpr0H13bWE=;
  b=ZJ4tVhxELFsubbhyVq0+dKc4mq8RZRs3z6mlj15nmTx4bqjq4h8M43tQ
   jdUchETmm3IzQerVPErV7lM1BSzmqKwLnoKkLFeCb6huKriPzJzGPNTfn
   Y4kkckwSUZMPqHsj6wRdcdKwghpQarp5QMASMMGO4dh8jDGbcqEIEoyxz
   pV+qYbTlVQ5R5aQItzq/ar8QUZ/4sgImJg6gA8mTRUtnVUkD3qC4u224t
   M1I37Bh3dyWIFQ/XOZQrjuBDasoZFTPDXqQMuM5J5fMS6+OWccDEvuPEj
   uKYU/6hPeQpPtT1xITcKO7chMjsuFSgUqHhCvnraPyKSQM+sm0QrEkpXX
   A==;
IronPort-SDR: TgyXwAOWYG0DbhR36GNEI0E+I/VFlIFEShaZbWT9umCPlZMPpXlMLlywb3VWhBoYy1xu/uHHG4
 hPcoYZCmHxr8QYcjnfU360iYdqYDXhwLr3oEA3YjtsCAfVIhBhBqdfeEQphb5Ajys1Fk/HnHxS
 up4QWH2+w8HX7cfRnZ4APviLiAyAQ7Zek+is8I4dmL65NW6xVTEs11mVdduPSeTfMMCUa2CLiw
 7ln/QTVc6mkiqlcaSP3BhTAt/7WtASi6o52HoxH7kiBEy4pW3yaUNJKLl5/13HBd9Gr+3re00y
 h5A=
X-IronPort-AV: E=Sophos;i="5.79,333,1602572400"; 
   d="scan'208";a="105371467"
Received: from smtpout.microchip.com (HELO email.microchip.com) ([198.175.253.82])
  by esa3.microchip.iphmx.com with ESMTP/TLS/AES256-SHA256; 09 Jan 2021 05:28:53 -0700
Received: from chn-vm-ex03.mchp-main.com (10.10.85.151) by
 chn-vm-ex01.mchp-main.com (10.10.85.143) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1979.3; Sat, 9 Jan 2021 05:28:53 -0700
Received: from localhost (10.10.115.15) by chn-vm-ex03.mchp-main.com
 (10.10.85.151) with Microsoft SMTP Server id 15.1.1979.3 via Frontend
 Transport; Sat, 9 Jan 2021 05:28:53 -0700
From:   Viswas G <Viswas.G@microchip.com>
To:     <linux-scsi@vger.kernel.org>
CC:     <Vasanthalakshmi.Tharmarajan@microchip.com>,
        <Viswas.G@microchip.com>, <Ruksar.devadi@microchip.com>,
        <yuuzheng@google.com>, <vishakhavc@google.com>, <radha@google.com>,
        <akshatzen@google.com>, <bjashnani@google.com>,
        <jinpu.wang@cloud.ionos.com>
Subject: [PATCH v2 0/8] pm80xx updates.
Date:   Sat, 9 Jan 2021 18:08:41 +0530
Message-ID: <20210109123849.17098-1-Viswas.G@microchip.com>
X-Mailer: git-send-email 2.16.3
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patch set include some bug fixes and enhancements for pm80xx driver.

Changes from v1:
	Corrected email id.

Bhavesh Jashnani (1):
  pm80xx: Simultaneous poll for all FW readiness.

Vishakha Channapattan (2):
  pm80xx: Log SATA IOMB completion status on failure.
  pm80xx: Add sysfs attribute for ioc health

Viswas G (1):
  pm80xx: fix driver fatal dump failure.

akshatzen (4):
  pm80xx: No busywait in MPI init check
  pm80xx: check fatal error
  pm80xx: check main config table address
  pm80xx: fix missing tag_free in NVMD DATA req

 drivers/scsi/pm8001/pm8001_ctl.c  |  42 ++++++++
 drivers/scsi/pm8001/pm8001_hwi.c  |  15 ++-
 drivers/scsi/pm8001/pm8001_init.c |  11 ++-
 drivers/scsi/pm8001/pm8001_sas.c  |   9 ++
 drivers/scsi/pm8001/pm8001_sas.h  |   2 +
 drivers/scsi/pm8001/pm80xx_hwi.c  | 202 ++++++++++++++++++++++++--------------
 drivers/scsi/pm8001/pm80xx_hwi.h  |  17 +++-
 7 files changed, 216 insertions(+), 82 deletions(-)

-- 
2.16.3

