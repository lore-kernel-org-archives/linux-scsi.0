Return-Path: <linux-scsi-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E305EC74A4B
	for <linux-scsi@archiver.kernel.org>; Thu,  9 Mar 2023 15:07:12 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229549AbjCIPHL (ORCPT <rfc822;linux-scsi@archiver.kernel.org>);
        Thu, 9 Mar 2023 10:07:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231658AbjCIPGg (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Mar 2023 10:06:36 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A4BEF3C16
        for <linux-scsi@vger.kernel.org>; Thu,  9 Mar 2023 07:04:22 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id j19-20020a05600c1c1300b003e9b564fae9so3821009wms.2
        for <linux-scsi@vger.kernel.org>; Thu, 09 Mar 2023 07:04:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112; t=1678374261;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :from:to:cc:subject:date:message-id:reply-to;
        bh=bJyXREDvfsLShy/edRVu813YCF9FdJmbLY4njHOgb1U=;
        b=bG/hxwE3vGhNcD9xVjMHjsxN3+PhoZzBpmk7jZ/aiRKU2wVgJnQtjZPwHpDjpNc02W
         tHCdjvX73r3pzuRajNzGgrBwhabpdQsbbbEIKGNDLtCyZIiViyyS9dgzSP7UxpKPux39
         ZztJheQKu0SJcnIMxXC797lYAlFosv4O4Z2b9qMI8eb2PWD7fUT7otOODtJKADF63Etr
         TDbcU2YCvP1WiQHWShpF3pv19xWwpqAdRY0DMRKYAAf/lRjJ2iiKPHGYwwQgP+3L2MRI
         /4rlKemrkjOqlGZyvfpSLLWm967Vmle5Zsd0oJlBtwgE1zzvQMcgEw1Xie5t3mO0UEbE
         jXLQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112; t=1678374261;
        h=content-disposition:mime-version:message-id:subject:cc:to:from:date
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=bJyXREDvfsLShy/edRVu813YCF9FdJmbLY4njHOgb1U=;
        b=zLrRtSTbHB45raSqWXOhynFKwmBrHukgIX1aXl1EHGXcnqgz/5mZNaApX9Md0mYH85
         lNdFzeyDDPASsWFtgRIdMs5K73SVeJjeIvpZ2QpTJdG6zZLS/+y075v9ORBcpHxIxzq8
         NGdvqr1Bf3xvaPNewLT7FE2mzKboWVopIhERHmoocp+pvXMYpIFhmVbmZdoeSwovMIXt
         yk4JKed2bqImmGRFKuMdkP2TLi75kzxsWql8j18mdGcBUNxVi/lQhXdUOmjMVcVTGgSZ
         hyZq7Narq7jZ3YxBZ6QyuRFpLOGHs4Gcq4GVF1LoPkuvWkiz5hY8MpZS+sNQx0hwnJ9y
         K2hA==
X-Gm-Message-State: AO0yUKUYKSFwRXQudSKC2tELXJJavYRLEM+2NgFdnPDCc3TVFyCiOPcr
        DdKNDTk6pV0DGdDnHaU6Qd0=
X-Google-Smtp-Source: AK7set+w/lHk9TkjaprLngxw/XCaamiclWXUdRW9uZgZLys4/xJzK8pm/WqcV4sDkcuYuqDsMXNi3A==
X-Received: by 2002:a05:600c:310d:b0:3eb:13d2:c32c with SMTP id g13-20020a05600c310d00b003eb13d2c32cmr19991389wmo.40.1678374261086;
        Thu, 09 Mar 2023 07:04:21 -0800 (PST)
Received: from localhost ([102.36.222.112])
        by smtp.gmail.com with ESMTPSA id 5-20020a05600c024500b003e6efc0f91csm60852wmj.42.2023.03.09.07.04.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 09 Mar 2023 07:04:20 -0800 (PST)
Date:   Thu, 9 Mar 2023 18:04:17 +0300
From:   Dan Carpenter <error27@gmail.com>
To:     ranjan.kumar@broadcom.com
Cc:     MPT-FusionLinux.pdl@broadcom.com, linux-scsi@vger.kernel.org
Subject: [bug report] scsi: mpt3sas: Reload SBR without rebooting HBA
Message-ID: <a5f6b629-a425-4b4e-b98c-6575e31749f5@kili.mountain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <linux-scsi.vger.kernel.org>
X-Mailing-List: linux-scsi@vger.kernel.org

Hello Ranjan Kumar,

The patch 2c6ebf96dfdf: "scsi: mpt3sas: Reload SBR without rebooting
HBA" from Feb 8, 2023, leads to the following Smatch static checker
warning:

	drivers/scsi/mpt3sas/mpt3sas_base.c:8071 _base_diag_reset()
	error: double unlocked '&ioc->hostdiag_unlock_mutex' (orig line 8005)

drivers/scsi/mpt3sas/mpt3sas_base.c
  7989  static int
  7990  _base_diag_reset(struct MPT3SAS_ADAPTER *ioc)
  7991  {
  7992          u32 host_diagnostic;
  7993          u32 ioc_state;
  7994          u32 count;
  7995          u32 hcb_size;
  7996  
  7997          ioc_info(ioc, "sending diag reset !!\n");
  7998  
  7999          pci_cfg_access_lock(ioc->pdev);
  8000  
  8001          drsprintk(ioc, ioc_info(ioc, "clear interrupts\n"));
  8002  
  8003          mutex_lock(&ioc->hostdiag_unlock_mutex);
  8004          if (mpt3sas_base_unlock_and_get_host_diagnostic(ioc, &host_diagnostic)) {
  8005                  mutex_unlock(&ioc->hostdiag_unlock_mutex);
                        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Unlock.

  8006                  goto out;
  8007          }
  8008  
  8009          hcb_size = ioc->base_readl(&ioc->chip->HCBSize);
  8010  
  8011          drsprintk(ioc, ioc_info(ioc, "diag reset: issued\n"));
  8012          writel(host_diagnostic | MPI2_DIAG_RESET_ADAPTER,
  8013               &ioc->chip->HostDiagnostic);
  8014  
  8015          /*This delay allows the chip PCIe hardware time to finish reset tasks*/
  8016          msleep(MPI2_HARD_RESET_PCIE_FIRST_READ_DELAY_MICRO_SEC/1000);
  8017  
  8018          /* Approximately 300 second max wait */
  8019          for (count = 0; count < (300000000 /
  8020                  MPI2_HARD_RESET_PCIE_SECOND_READ_DELAY_MICRO_SEC); count++) {
  8021  
  8022                  host_diagnostic = ioc->base_readl(&ioc->chip->HostDiagnostic);
  8023  
  8024                  if (host_diagnostic == 0xFFFFFFFF) {
  8025                          ioc_info(ioc,
  8026                              "Invalid host diagnostic register value\n");
  8027                          _base_dump_reg_set(ioc);
  8028                          goto out;
  8029                  }
  8030                  if (!(host_diagnostic & MPI2_DIAG_RESET_ADAPTER))
  8031                          break;
  8032  
  8033                  msleep(MPI2_HARD_RESET_PCIE_SECOND_READ_DELAY_MICRO_SEC / 1000);
  8034          }
  8035  
  8036          if (host_diagnostic & MPI2_DIAG_HCB_MODE) {
  8037  
  8038                  drsprintk(ioc,
  8039                            ioc_info(ioc, "restart the adapter assuming the HCB Address points to good F/W\n"));
  8040                  host_diagnostic &= ~MPI2_DIAG_BOOT_DEVICE_SELECT_MASK;
  8041                  host_diagnostic |= MPI2_DIAG_BOOT_DEVICE_SELECT_HCDW;
  8042                  writel(host_diagnostic, &ioc->chip->HostDiagnostic);
  8043  
  8044                  drsprintk(ioc, ioc_info(ioc, "re-enable the HCDW\n"));
  8045                  writel(hcb_size | MPI2_HCB_SIZE_HCB_ENABLE,
  8046                      &ioc->chip->HCBSize);
  8047          }
  8048  
  8049          drsprintk(ioc, ioc_info(ioc, "restart the adapter\n"));
  8050          writel(host_diagnostic & ~MPI2_DIAG_HOLD_IOC_RESET,
  8051              &ioc->chip->HostDiagnostic);
  8052          mpt3sas_base_lock_host_diagnostic(ioc);
  8053          mutex_unlock(&ioc->hostdiag_unlock_mutex);
  8054  
  8055          drsprintk(ioc, ioc_info(ioc, "Wait for FW to go to the READY state\n"));
  8056          ioc_state = _base_wait_on_iocstate(ioc, MPI2_IOC_STATE_READY, 20);
  8057          if (ioc_state) {
  8058                  ioc_err(ioc, "%s: failed going to ready state (ioc_state=0x%x)\n",
  8059                          __func__, ioc_state);
  8060                  _base_dump_reg_set(ioc);
  8061                  goto out;
  8062          }
  8063  
  8064          pci_cfg_access_unlock(ioc->pdev);
  8065          ioc_info(ioc, "diag reset: SUCCESS\n");
  8066          return 0;
  8067  
  8068   out:
  8069          pci_cfg_access_unlock(ioc->pdev);
  8070          ioc_err(ioc, "diag reset: FAILED\n");
  8071          mutex_unlock(&ioc->hostdiag_unlock_mutex);
                ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Double unlock.

  8072          return -EFAULT;
  8073  }

regards,
dan carpenter
