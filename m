Return-Path: <SRS0=EpTV=6W=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54358C38A2A
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 08:53:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 29AEA208D6
	for <linux-scsi@archiver.kernel.org>; Fri,  8 May 2020 08:53:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="eiN+CXN1"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726025AbgEHIxs (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 8 May 2020 04:53:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725784AbgEHIxs (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 8 May 2020 04:53:48 -0400
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F54AC05BD43
        for <linux-scsi@vger.kernel.org>; Fri,  8 May 2020 01:53:48 -0700 (PDT)
Received: by mail-pg1-x543.google.com with SMTP id l12so570432pgr.10
        for <linux-scsi@vger.kernel.org>; Fri, 08 May 2020 01:53:48 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=Sa7keAbjonPPlNedeu/K6UjwhQkst6LKZUXA12ievDU=;
        b=eiN+CXN1ZFdWMKYi6xIQa1lSN34IstDeEBlMHHW7+Bvn4PvhP9ieNhIGZc2/SaIBYg
         P+XgHv/TTEnHQ4Zyr8XGMMs8xD687Df2QK6x1E6eUUXAcUa/wPh9Bc1kGfLXzqqMx0Po
         XPGEWmo27Z29MuF37K3kfsxuk11iBWRK5dNoI=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=Sa7keAbjonPPlNedeu/K6UjwhQkst6LKZUXA12ievDU=;
        b=iXp3B7xwkb6cTylEFkZKzxcaKkaDWUXQKyXFSLvjJ82iEbmshvVHBERzhmGyulX3mg
         wVDxQPpNXPw3cYvNB2LY966C2o8BrmtWUKzPI4/OOSxfh57B5tuq/AIbPT9Dlo6pS2q8
         ywdom7fNTu4G8EzyM5jgNxKd7st/Ccr9K7h/8UBw5+OsOn4aIKsG3AFEwa052ysYMh3N
         A4kUpLx+jpH7ANP5pA+cynFpCdFgsmZqj7xY3/inaH/zoe5y//puh2oeDp+CviXi0vtM
         O5Mbgufh1+nlchO/G5yFuxnAS0le90SIcbFFk59AGp4uaS1zEOBkmKxrTYYOGg8DDdEC
         oFYg==
X-Gm-Message-State: AGi0PubThng0LbeAonyr8GrK6e5iKEI14hhllvAQTcbzXzwbexFkCYix
        ewGTBjPS9FEd55O0/8AsGTiCFQYa9KRtIqydsEwvzbGIQ1/y6hecC7a22cC9kCqLYGYOqyinjM1
        6S5c7CC7BCgAWuTBPz+r5bklqYU9fFqsjeuHViFipj7SqEO/nJWMVDvySKg0Iu3o2aK1iae9S59
        dFi0bPB6sYuDqT
X-Google-Smtp-Source: APiQypIrgJDDCMjfTdYR8FKzN2gSN5/iBPxFlj9kheZVNkNyu+6jVv8vQOCfPXiYSWvYMZxATcMUyg==
X-Received: by 2002:a63:1c50:: with SMTP id c16mr1244086pgm.255.1588928027421;
        Fri, 08 May 2020 01:53:47 -0700 (PDT)
Received: from it_dev_server1.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id j7sm1091287pfi.160.2020.05.08.01.53.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 08 May 2020 01:53:46 -0700 (PDT)
From:   Chandrakanth Patil <chandrakanth.patil@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        kiran-kumar.kasturi@broadcom.com, sankar.patra@broadcom.com,
        sasikumar.pc@broadcom.com, shivasharan.srikanteshwara@broadcom.com,
        anand.lodnoor@broadcom.com,
        Chandrakanth Patil <chandrakanth.patil@broadcom.com>
Subject: [PATCH 0/5] megaraid_sas: driver updates for 07.714.04.00-rc1
Date:   Fri,  8 May 2020 14:23:36 +0530
Message-Id: <20200508085336.23522-1-chandrakanth.patil@broadcom.com>
X-Mailer: git-send-email 2.9.5
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patchset contains few critical driver fixes.

Chandrakanth Patil (5):
  megaraid_sas: Limit device qd to controller qd when device qd is
    greater than controller qd
  megaraid_sas: Remove IO buffer hole detection logic
  megaraid_sas: Replace undefined MFI_BIG_ENDIAN macro with
    __BIG_ENDIAN_BITFIELD macro
  megaraid_sas: TM command refire leads to controller firmware crash
  megaraid_sas: Update driver version to 07.714.04.00-rc1

 drivers/scsi/megaraid/megaraid_sas.h        |  8 ++--
 drivers/scsi/megaraid/megaraid_sas_base.c   |  5 +--
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 65 +++--------------------------
 drivers/scsi/megaraid/megaraid_sas_fusion.h |  6 +--
 4 files changed, 15 insertions(+), 69 deletions(-)

-- 
2.9.5

