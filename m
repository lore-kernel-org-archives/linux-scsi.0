From: Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [PATCH] scsi: storvsc: Fix scsi_cmd error assignments in
 storvsc_handle_error
Date: Tue, 19 Dec 2017 10:37:10 -0800
Message-ID: <20171219103710.2251e259@xeon-e3>
References: <1513708368-25951-1-git-send-email-cavery@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-pl0-f41.google.com ([209.85.160.41]:36616 "EHLO
        mail-pl0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750798AbdLSShN (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 19 Dec 2017 13:37:13 -0500
Received: by mail-pl0-f41.google.com with SMTP id b12so7481787plm.3
        for <linux-scsi@vger.kernel.org>; Tue, 19 Dec 2017 10:37:13 -0800 (PST)
In-Reply-To: <1513708368-25951-1-git-send-email-cavery@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Cathy Avery <cavery@redhat.com>
Cc: kys@microsoft.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, sthemmin@microsoft.com, linux-scsi@vger.kernel.org, haiyangz@microsoft.com, linux-kernel@vger.kernel.org, devel@linuxdriverproject.org

On Tue, 19 Dec 2017 13:32:48 -0500
Cathy Avery <cavery@redhat.com> wrote:

> When an I/O is returned with an srb_status of SRB_STATUS_INVALID_LUN
> which has zero good_bytes it must be assigned an error. Otherwise
> the I/O will be continuously requeued and will cause a deadlock in the
> case where disks are being hot added and removed. sd_probe_async will
> wait forever for its I/O to complete while holding scsi_sd_probe_domain.
> 
> Also returning the default error of DID_TARGET_FAILURE causes
> multipath to not retry the I/O resulting in applications receiving I/O
> errors before a failover can occur.
> 
> Signed-off-by: Cathy Avery <cavery@redhat.com>
> Signed-off-by: Long Li <longli@microsoft.com>

When working on the DVD probe issue I saw that error handling was
problematic. Thanks for fixing.

Reviewed-by: Stephen Hemminger <stephen@networkplumber.org>
