From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: [PATCH v4 2/3] ses: use scsi_is_sas_rphy instead of
 is_sas_attached
Date: Thu, 18 Aug 2016 08:41:51 -0700
Message-ID: <1471534911.2389.25.camel@linux.vnet.ibm.com>
References: <cover.1471426748.git.jthumshirn@suse.de>
         <34f1f359e3a7c5ca573c3ca52b110c13666fc22e.1471426748.git.jthumshirn@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:34720 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752752AbcHSA4U (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 18 Aug 2016 20:56:20 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u7IFd3Lu082445
        for <linux-scsi@vger.kernel.org>; Thu, 18 Aug 2016 11:42:03 -0400
Received: from e33.co.us.ibm.com (e33.co.us.ibm.com [32.97.110.151])
        by mx0a-001b2d01.pphosted.com with ESMTP id 24wbwy5wj1-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 18 Aug 2016 11:42:03 -0400
Received: from localhost
        by e33.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <jejb@linux.vnet.ibm.com>;
        Thu, 18 Aug 2016 09:42:01 -0600
In-Reply-To: <34f1f359e3a7c5ca573c3ca52b110c13666fc22e.1471426748.git.jthumshirn@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>, "Martin K . Petersen" <martin.petersen@oracle.com>
Cc: Hannes Reinecke <hare@suse.de>, Linux Kernel Mailinglist <linux-kernel@vger.kernel.org>, Linux SCSI Mailinglist <linux-scsi@vger.kernel.org>, stable@vger.kernel.org, #@suse.de, v4.5+@suse.de

On Wed, 2016-08-17 at 11:46 +0200, Johannes Thumshirn wrote:
> Use scsi_is_sas_rphy() instead of is_sas_attached() to decide whether
> we should obtain the SAS address from a scsi device or not. This will
> prevent us from tripping on the BUG_ON() in sas_sdev_to_rdev() if the
> rphy isn't attached to the SAS transport class, like it is with 
> hpsa's logical devices.

For the entire series:

Reviewed-by: James E.J. Bottomley <jejb@linux.vnet.ibm.com>

> Fixes: 3f8d6f2a0 ('ses: fix discovery of SATA devices in SAS
> enclosures')
> Cc: stable@vger.kernel.org # v4.5+

Except that we can't tag this for stable because without 1/3 it will
induce a compile failure within stable.  This means you're going to
have to do the stable process manually and submit both patches to
stable and explain the dependency, once they're upstream.

James

