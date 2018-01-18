From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: [PATCH v2] scsi: sd: add new match array for cache_type
Date: Thu, 18 Jan 2018 08:30:13 -0800
Message-ID: <1516293013.3014.8.camel@linux.vnet.ibm.com>
References: <20180118141928.GA28320@bogon.didichuxing.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:39548 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1755383AbeARQaV (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 18 Jan 2018 11:30:21 -0500
Received: from pps.filterd (m0098421.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w0IGUAL0030563
        for <linux-scsi@vger.kernel.org>; Thu, 18 Jan 2018 11:30:20 -0500
Received: from e36.co.us.ibm.com (e36.co.us.ibm.com [32.97.110.154])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2fjvfj0qy7-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 18 Jan 2018 11:30:20 -0500
Received: from localhost
        by e36.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <jejb@linux.vnet.ibm.com>;
        Thu, 18 Jan 2018 09:30:19 -0700
In-Reply-To: <20180118141928.GA28320@bogon.didichuxing.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: weiping zhang <zhangweiping@didichuxing.com>, martin.petersen@oracle.com
Cc: linux-scsi@vger.kernel.org

On Thu, 2018-01-18 at 22:19 +0800, weiping zhang wrote:
> -	return sprintf(buf, "%s\n", sd_cache_types[ct]);
> +	return sprintf(buf, "%s\n%s\nwrite:%s, read:%s\n",
> sd_cache_types[ct],
> +			sd_wce_rcd[ct], sdkp->WCE ? "on" : "off",
> +			sdkp->RCD ? "off" : "on");

I don't think we can do this.  The output of the cache type in sysfs is
a user exported ABI.  We'd potentially break it if we add extra stuff.

James
