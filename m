From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [ANNOUNCE]: Broadcom (Emulex) FC Target driver - efct
Date: Thu, 02 Mar 2017 12:08:45 -0800
Message-ID: <1488485325.5580.9.camel@haakon3.risingtidesystems.com>
References: <ced2ff0a-05ee-b85e-b41a-f912cab9e267@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:48188 "EHLO
        linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750736AbdCBUJo (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Thu, 2 Mar 2017 15:09:44 -0500
In-Reply-To: <ced2ff0a-05ee-b85e-b41a-f912cab9e267@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: jsmart2021@gmail.com
Cc: Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>, Sebastian Herbszt <herbszt@gmx.de>

Hi James & Co,

Adding target-devel and Sebastian CC'

On Mon, 2017-02-27 at 15:28 -0800, James Smart wrote:
> I'd like to announce the availability of the Broadcom (Emulex) FC Target 
> driver - efct.
> This driver has been part of the Emulex OneCore Storage SDK tool kit for 
> Emulex
> SLI-4 adapters. The SLI-4 adapters support 16Gb/s and higher adapters. 
> Although this
> kit has supported FCoE in the past, it is currently limited to FC support.
> 
> This driver provides the following:
> - Target mode operation:
>    - Functional with LIO-based interfaces

Glad to see the upstream push for this after all these years.  :)

>    - Extensive use of hw offloads such as auto-xfer_rdy, auto-rsp, cmd 
> cpu spreading
>    - High login mode - thousands of logins
>    - T-10 DIF/PI support  (inline and separate)
>    - NPIV support
> - Concurrent Initiator support if needed
> - Discovery engine has F_Port and fabric services emulation.
> - Extended mgmt interfaces:
>    - firmware dump api, including dump to host memory for faster dumps
>    - Healthcheck operations and watchdogs
> - Extended driver behaviors such as:
>    - polled mode operation
>    - multi-queue: cpu, roundrobin, or priority  (but not tied  to scsi-mq)
>    - long chained sgl's
>    - extensive internal logging and statistics
>    - Tuning parameters on modes and resource allocation to different 
> features
> 
> Broadcom is looking to upstream this driver and would like review and 
> feedback.
> The driver may be found at the following git repository:
>      git@gitlab.com:jsmart/efct-Emulex_FC_Target.git
> 

Can we get the patch series posted to linux-scsi and target-devel to
start giving some initial feedback..?

> 
> Some of the key questions we have are with lpfc :
> 1) Coexistence vs integration
> Currently, the efct driver maps to a different set of PCI ids than lpfc.
> It's very clear there's an overlap with lpfc, both on SLI-4 hw as well 
> as initiator support.
> Although target mode support can be simplistically added to lpfc, what 
> we've found is
> that doing so means a lot of tradeoffs. Some of the target mode 
> features, when enabled,
> impact the initiator support and how it would operate.
> 

I don't really have much preference either way.  

> 2) SLI-3 support
> lpfc provides SLI-3 support so that all FC adapters are supported, 
> including the older ones.
> The form of the driver, based on its history, is SLI-3 with SLI-3 
> adapted to SLI-4 at the point
> it hits the hardware. efct does not support SLI-3.

AFAIK I think Sebastian was using SLI-3, so he might have some comments
here.

Since he's been the main person using the original tcm_lpfc code from
way back when, maybe it would be a good idea to send him a couple of
SLI-4 HBAs to help with the upstreaming of efct..?

> 
> 3) complexity of configuration knobs caused by the kitchen-sink of 
> features in lpfc ?
> we are pushing the limit on needing per-instance attributes rather than 
> global module
> parameters.

This is exactly what
/sys/kernel/config/target/efct/$WWPN/tpgt_1/attribute/ is intended for.
