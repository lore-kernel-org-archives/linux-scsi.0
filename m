From: Kashyap Desai <kashyap.desai@broadcom.com>
Subject: RE: [PATCH 13/14] megaraid_sas: NVME passthru command support
Date: Tue, 9 Jan 2018 22:07:28 +0530
Message-ID: <35aabb7a8b8ffed4040c5ac01c01fb0a@mail.gmail.com>
References: <1515159339-26790-1-git-send-email-shivasharan.srikanteshwara@broadcom.com>
 <20180108100531.GA6967@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-io0-f175.google.com ([209.85.223.175]:36439 "EHLO
        mail-io0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S934405AbeAIQha (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 9 Jan 2018 11:37:30 -0500
Received: by mail-io0-f175.google.com with SMTP id i143so19187967ioa.3
        for <linux-scsi@vger.kernel.org>; Tue, 09 Jan 2018 08:37:30 -0800 (PST)
In-Reply-To: <20180108100531.GA6967@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Shivasharan Srikanteshwara <shivasharan.srikanteshwara@broadcom.com>
Cc: linux-scsi@vger.kernel.org, Sumit Saxena <sumit.saxena@broadcom.com>, linux-nvme@lists.infradead.org, Peter Rivera <peter.rivera@broadcom.com>

Chris -

Overall NVME support behind MR controller is really a SCSI device. On top
of that, for MegaRaid, NVME device can be part of Virtual Disk and those
drive will not be exposed to the driver. User application may like to talk
to hidden NVME devices (part of VDs). This patch will extend the existing
interface for megaraid product in the same way it is currently supported
for other protocols like SMP, SATA pass-through.

Example - Current smartmon is using megaraid.h (MFI headers) to send SATA
pass-through.

https://github.com/mirror/smartmontools/blob/master/megaraid.h

Any open source application is aware of above interface can extend the
similar support for NVME drives. I agree that current nvme-cli type
interface is not going to be supported using this method.  In current
patch, driver processing is very limited since most of the work is handled
in application + FW.

NVME behind MR controller is not really NVME device to the operating
system at block layer. Considering this, do you agree or still foresee any
issues ?

Kashyap

-----Original Message-----
From: Christoph Hellwig [mailto:hch@infradead.org]
Sent: Monday, January 8, 2018 3:36 PM
To: Shivasharan S
Cc: linux-scsi@vger.kernel.org; sumit.saxena@broadcom.com;
linux-nvme@lists.infradead.org; kashyap.desai@broadcom.com
Subject: Re: [PATCH 13/14] megaraid_sas: NVME passthru command support

NAK.  Please implement the same ioctl interfaces as the nvme driver
instead of inventing your own incomaptible one.
