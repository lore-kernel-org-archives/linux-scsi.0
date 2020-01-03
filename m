Return-Path: <SRS0=yTIb=2Y=vger.kernel.org=linux-scsi-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.9 required=3.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
	DKIM_VALID,DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_GIT autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id DF433C2D0C2
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jan 2020 11:33:12 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id B35CD222C4
	for <linux-scsi@archiver.kernel.org>; Fri,  3 Jan 2020 11:33:12 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=broadcom.com header.i=@broadcom.com header.b="RdEtH2qs"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727462AbgACLdM (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Fri, 3 Jan 2020 06:33:12 -0500
Received: from mail-pl1-f171.google.com ([209.85.214.171]:37044 "EHLO
        mail-pl1-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727453AbgACLdM (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Jan 2020 06:33:12 -0500
Received: by mail-pl1-f171.google.com with SMTP id c23so18972974plz.4
        for <linux-scsi@vger.kernel.org>; Fri, 03 Jan 2020 03:33:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VPlqZmArpqno7ehvVSjGIJjaqWG0B+hNfoMd54wzi7w=;
        b=RdEtH2qsXKTnaWX1+xCuzo81WSOri3Ovc2gYHAGqdl2iz68P4vc7Lvu3/TKInooXlU
         u9/u0wp7Pjhaff6toHOU+g2sHLdVVEouHwYaS391Y6XSqwbBmFIunfJOM6WLFRW/L4lw
         ufCes8hdxrekG9I/iKVhfoGUtHQ7AoTkYyLwM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=VPlqZmArpqno7ehvVSjGIJjaqWG0B+hNfoMd54wzi7w=;
        b=fZTk6Wgh3hT8+I05LrhJyDHmBNpjTPeW3zgtud50RhToy0in5cDS3fmpgszlvNq1Eg
         60gRHwCviiffnaM59OdcLJlHkRKblQlUFI7PPCSNUKXPi0PNZfPO7XgfRFg7UvpZqc8Z
         jvnj5vnHpakVr6QexgoZHUO/H7ikpZA/ZfABkCQZ6gr+AxN803fo+nnJUgPgY/AO/85f
         R84Kft2NqW0hNCYtG/PcNi8ccoudPZfJ+l91kUuggkAs0dPc6/W18q/BRLpdN2PovWbL
         R7LXFmYLtZHAzg/CCAJQQ7duCfwpCp1AcX+lCnrSsIFyyQL6Oq9/h4RKvSwzAM6JyyF8
         tPPA==
X-Gm-Message-State: APjAAAXS97H6Wi2uF9BWDicm+Kf4b+tY9vR4RRB7Xc6BIovVLn4rjX6t
        VXLxXhIBqPr6AR9SRgB7EZLYc9xrNS8ntCH+HH/uJFUtMycFsGN2EJYgMpamKLiZigDycpgHT2W
        +q8vNwTMuSf4z/eA+XaH1dpbYiZ+ZmZteUaxH7Jv13ra+/WYIjXc3hyC7DnNnPI693oyaTkTgS0
        pC4cwdIQ==
X-Google-Smtp-Source: APXvYqxGR/lErgkcOWvuFC87ydD9Y1GzAzA61xvZAiRypSAqzj9wVXqJqX3IXEZCOpi29wViToAINQ==
X-Received: by 2002:a17:90a:c389:: with SMTP id h9mr27661930pjt.128.1578051191202;
        Fri, 03 Jan 2020 03:33:11 -0800 (PST)
Received: from dhcp-10-123-20-32.dhcp.broadcom.net ([192.19.234.250])
        by smtp.gmail.com with ESMTPSA id h128sm70302144pfe.172.2020.01.03.03.33.08
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 03 Jan 2020 03:33:10 -0800 (PST)
From:   Anand Lodnoor <anand.lodnoor@broadcom.com>
To:     linux-scsi@vger.kernel.org
Cc:     kashyap.desai@broadcom.com, sumit.saxena@broadcom.com,
        kiran-kumar.kasturi@broadcom.com,
        Anand Lodnoor <anand.lodnoor@broadcom.com>
Subject: [PATCH 00/11] megaraid_sas: driver updates to 07.713.01.00-rc1
Date:   Fri,  3 Jan 2020 17:02:24 +0530
Message-Id: <1578051155-14716-1-git-send-email-anand.lodnoor@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
MIME-Version: 1.0
Content-Type: text/plain; charset=y
Content-Transfer-Encoding: 8bit
Sender: linux-scsi-owner@vger.kernel.org
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

This patchset contains few enhancements and fixes in megaraid_sas driver.

Anand Lodnoor (11):
  megaraid_sas: Add transition_to_ready retry logic in resume path
  megaraid_sas: Set no_write_same only for Virtual Disk
  megaraid_sas: Update queue_depth of SAS and NVMe devices
  megaraid_sas: Don’t kill already dead adapter
  megaraid_sas: Do not kill HBA if JBOD Seqence map or RAID map is
    disabled
  megaraid_sas: Do not set HBA Operational if FW is not in operational
    state
  megaraid_sas: Re-Define enum DCMD_RETURN_STATUS
  megaraid_sas: Do not initiate OCR if controller is not in ready state
  megaraid_sas: Return pended IOCTLs after 3 retries
  megaraid_sas: Use Block layer API to check SCSI device in-flight IO
    requests
  megaraid_sas: Update driver version to 07.713.01.00-rc1

 drivers/scsi/megaraid/megaraid_sas.h        |  17 ++--
 drivers/scsi/megaraid/megaraid_sas_base.c   |  99 ++++++++++++++------
 drivers/scsi/megaraid/megaraid_sas_fusion.c | 134 +++++++++++++++++++++-------
 drivers/scsi/megaraid/megaraid_sas_fusion.h |  18 +++-
 4 files changed, 201 insertions(+), 67 deletions(-)

-- 
1.8.3.1

