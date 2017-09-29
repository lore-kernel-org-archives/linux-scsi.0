From: Martin Wilck <mwilck@suse.com>
Subject: Re: [PATCH] scsi: sd: Do not override max_sectors_kb sysfs setting
Date: Fri, 29 Sep 2017 14:26:31 +0200
Message-ID: <1506687991.20850.7.camel@suse.com>
References: <150309002518.8999.15900049133748830764.stgit@brunhilda>
         <20170928013859.1214-1-martin.petersen@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from victor.provo.novell.com ([137.65.250.26]:58534 "EHLO
        prv3-mh.provo.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751176AbdI2M0i (ORCPT
        <rfc822;groupwise-linux-scsi@vger.kernel.org:0:0>);
        Fri, 29 Sep 2017 08:26:38 -0400
In-Reply-To: <20170928013859.1214-1-martin.petersen@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org
Cc: don.brace@microsemi.com

On Wed, 2017-09-27 at 21:38 -0400, Martin K. Petersen wrote:
> A user may lower the max_sectors_kb setting in sysfs to accommodate
> certain workloads. Previously we would always set the max I/O size to
> either the block layer default or the optional preferred I/O size
> reported by the device.
> 
> Keep the current heuristics for the initial setting of
> max_sectors_kb.
> For subsequent invocations, only update the current queue limit if it
> exceeds the capabilities of the hardware.
> 
> Reported-by: Don Brace <don.brace@microsemi.com>
> Signed-off-by: Martin K. Petersen <martin.petersen@oracle.com>
 
This looks good to me. I agree that it's superior to the original
suggestion, because it sets the soft limit to the hard limit when the
device is scanned for the first time.

Regards
Martin

-- 
Dr. Martin Wilck <mwilck@suse.com>, Tel. +49 (0)911 74053 2107
SUSE Linux GmbH, GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
