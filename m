From: James Bottomley <jejb@linux.vnet.ibm.com>
Subject: Re: [PATCH] scsi: handle ABORTED_COMMAND on Fujitsu ETERNUS
Date: Thu, 18 Jan 2018 06:24:15 -0800
Message-ID: <1516285455.3014.2.camel@linux.vnet.ibm.com>
References: <20180115201852.15152-1-mwilck@suse.com>
         <yq1efmpt3hs.fsf@oracle.com> <1516174344.3303.1.camel@suse.com>
         <yq1shb3ring.fsf@oracle.com> <00bbbaed-215a-4af9-1576-1c25008d0e23@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:34150 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1756382AbeAROYY (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 18 Jan 2018 09:24:24 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.22/8.16.0.22) with SMTP id w0IEO5kI038359
        for <linux-scsi@vger.kernel.org>; Thu, 18 Jan 2018 09:24:23 -0500
Received: from e12.ny.us.ibm.com (e12.ny.us.ibm.com [129.33.205.202])
        by mx0b-001b2d01.pphosted.com with ESMTP id 2fjujqdq15-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 18 Jan 2018 09:24:22 -0500
Received: from localhost
        by e12.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <jejb@linux.vnet.ibm.com>;
        Thu, 18 Jan 2018 09:24:20 -0500
In-Reply-To: <00bbbaed-215a-4af9-1576-1c25008d0e23@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, "Martin K. Petersen" <martin.petersen@oracle.com>, Martin Wilck <mwilck@suse.com>
Cc: linux-scsi@vger.kernel.org, saito.kazuya@jp.fujitsu.com

On Thu, 2018-01-18 at 11:17 +0100, Hannes Reinecke wrote:
> On 01/18/2018 03:43 AM, Martin K. Petersen wrote:
> > 
> > 
> > Martin,
> > 
> > > 
> > > You'd like to spend a precious BLIST bit for this single device
> > > which uses vendor-specific ASC/Q?
> > 
> > I really don't want string comparisons in the regular code paths.
> > Also not a fan of vendor-specific ASCs. But if you must use them,
> > please add a flag and trigger on that.
> > 
> > Since this is a bit of an unusual check condition combo, we could
> > entertain whether we should simply always ADD_TO_MLQUEUE on
> > 0xb/0xc1/0x1. I wonder what would break?
> > 
> That's the usual problem I have with vendor-specific sense codes.
> In general the risk is quite low of different vendors actually using
> the same code; I guess we can get away with just adding a debug
> message here and enable it without any vendor check.
> Then we can reconsider the whole thing once we notice several vendors
> using the same sense codes.

Murphy's law says that if we rely on Vendors to chose non-overlapping
numbers we'll end up with a clash fairly quickly ...

Can't we find a way of doing this in the device_handler?  That way we
can use vendor specific codes only when we know who the vendor is?

James
