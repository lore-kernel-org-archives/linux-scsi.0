From: James Smart <jsmart2021@gmail.com>
Subject: [ANNOUNCE]: Broadcom (Emulex) FC Target driver - efct
Date: Mon, 27 Feb 2017 15:28:41 -0800
Message-ID: <ced2ff0a-05ee-b85e-b41a-f912cab9e267@gmail.com>
Reply-To: jsmart2021@gmail.com
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:36195 "EHLO
        mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751338AbdB0X2v (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Feb 2017 18:28:51 -0500
Received: by mail-wm0-f50.google.com with SMTP id v77so72673803wmv.1
        for <linux-scsi@vger.kernel.org>; Mon, 27 Feb 2017 15:28:50 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>

I'd like to announce the availability of the Broadcom (Emulex) FC Target 
driver - efct.
This driver has been part of the Emulex OneCore Storage SDK tool kit for 
Emulex
SLI-4 adapters. The SLI-4 adapters support 16Gb/s and higher adapters. 
Although this
kit has supported FCoE in the past, it is currently limited to FC support.

This driver provides the following:
- Target mode operation:
   - Functional with LIO-based interfaces
   - Extensive use of hw offloads such as auto-xfer_rdy, auto-rsp, cmd 
cpu spreading
   - High login mode - thousands of logins
   - T-10 DIF/PI support  (inline and separate)
   - NPIV support
- Concurrent Initiator support if needed
- Discovery engine has F_Port and fabric services emulation.
- Extended mgmt interfaces:
   - firmware dump api, including dump to host memory for faster dumps
   - Healthcheck operations and watchdogs
- Extended driver behaviors such as:
   - polled mode operation
   - multi-queue: cpu, roundrobin, or priority  (but not tied  to scsi-mq)
   - long chained sgl's
   - extensive internal logging and statistics
   - Tuning parameters on modes and resource allocation to different 
features

Broadcom is looking to upstream this driver and would like review and 
feedback.
The driver may be found at the following git repository:
     git@gitlab.com:jsmart/efct-Emulex_FC_Target.git


Some of the key questions we have are with lpfc :
1) Coexistence vs integration
Currently, the efct driver maps to a different set of PCI ids than lpfc.
It's very clear there's an overlap with lpfc, both on SLI-4 hw as well 
as initiator support.
Although target mode support can be simplistically added to lpfc, what 
we've found is
that doing so means a lot of tradeoffs. Some of the target mode 
features, when enabled,
impact the initiator support and how it would operate.

2) SLI-3 support
lpfc provides SLI-3 support so that all FC adapters are supported, 
including the older ones.
The form of the driver, based on its history, is SLI-3 with SLI-3 
adapted to SLI-4 at the point
it hits the hardware. efct does not support SLI-3.

3) complexity of configuration knobs caused by the kitchen-sink of 
features in lpfc ?
we are pushing the limit on needing per-instance attributes rather than 
global module
parameters.

-- james
