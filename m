From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: [PATCH] scsi: megaraid: fix ifnullfree.cocci warnings
Date: Tue, 25 Jul 2017 08:48:45 -0700
Message-ID: <1500997725.3689.14.camel@linux.vnet.ibm.com>
References: <201707252301.SY4YDAmp%fengguang.wu@intel.com>
         <20170725154005.GA50912@lkp-hsx03.lkp.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:56186 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752707AbdGYPup (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Tue, 25 Jul 2017 11:50:45 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.21/8.16.0.21) with SMTP id v6PFoeWD107457
        for <linux-scsi@vger.kernel.org>; Tue, 25 Jul 2017 11:50:45 -0400
Received: from e17.ny.us.ibm.com (e17.ny.us.ibm.com [129.33.205.207])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2bx87st89j-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 25 Jul 2017 11:49:43 -0400
Received: from localhost
        by e17.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <jejb@linux.vnet.ibm.com>;
        Tue, 25 Jul 2017 11:48:53 -0400
In-Reply-To: <20170725154005.GA50912@lkp-hsx03.lkp.intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: kbuild test robot <fengguang.wu@intel.com>, Romain Perier <romain.perier@collabora.com>
Cc: kbuild-all@01.org, "Martin K. Petersen" <martin.petersen@oracle.com>, Peter Senna Tschudin <peter.senna@collabora.com>, Kashyap Desai <kashyap.desai@broadcom.com>, Sumit Saxena <sumit.saxena@broadcom.com>, Shivasharan S <shivasharan.srikanteshwara@broadcom.com>, megaraidlinux.pdl@broadcom.com, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Tue, 2017-07-25 at 23:40 +0800, kbuild test robot wrote:
> drivers/scsi/megaraid/megaraid_sas_fusion.c:608:2-18: WARNING: NULL
> check before freeing functions like kfree, debugfs_remove,
> debugfs_remove_recursive or usb_free_urb is not needed. Maybe
> consider reorganizing relevant code to avoid passing NULL values.
> drivers/scsi/megaraid/megaraid_sas_fusion.c:629:2-18: WARNING: NULL
> check before freeing functions like kfree, debugfs_remove,
> debugfs_remove_recursive or usb_free_urb is not needed. Maybe
> consider reorganizing relevant code to avoid passing NULL values.
> 
>  NULL check before some freeing functions is not needed.

Hey, guys, we yelled at Markus Elfring for sending hundreds of patches
like this.  The reason then was too much code churn for too little
value: the if() might be unnecessary but it really doesn't cost very
much in terms of execution time, so the code churn disadvantage greatly
 outweighs any benefits.

The reason hasn't changed, so please stop this otherwise you're going
to turn the very valuable 0day test infrastructure into a thousand
patch spambot.

James
