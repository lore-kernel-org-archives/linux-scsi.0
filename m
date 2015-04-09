From: James Smart <james.smart@emulex.com>
Subject: Re: [PATCH 15/21] lpfc: Implement support for wire-only DIF devices
Date: Thu, 9 Apr 2015 16:58:52 -0400
Message-ID: <5526E80C.5090807@emulex.com>
References: <1428095580.6933.44.camel@myfc17> <20150405160613.GA8622@infradead.org>
Reply-To: <james.smart@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge1.emulex.com ([138.239.224.99]:55767 "EHLO
	CMEXEDGE1.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756066AbbDIU7T (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 9 Apr 2015 16:59:19 -0400
In-Reply-To: <20150405160613.GA8622@infradead.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>

fyi - in the v3  of the lpfc 10.5.0.0 patches I just posted, I pulled 
the patch.  We will see what to do with it. We may come back with a set 
of generic midlayer patches.

-- james s


On 4/5/2015 12:06 PM, Christoph Hellwig wrote:
> On Fri, Apr 03, 2015 at 05:13:00PM -0400, James Smart wrote:
>> Implement support for wire-only DIF devices
>>
>> This patch adds the ability to support auto-enablement of wire-only DIF
>> (DIF is generated on TX to target, stripped on RX; OS unaware DIF in use)
>> for a select set of devices. Currently, there is only 1 device vendor
>> supported: 3PARdata. When the feature is enabled, Inquiry commands are
>> trapped, the vendor matched, and DIF enablement checked. In 3Par's case,
>> there's a vendor specific check to see if the LUN supports DIF.
>> If supported, DIF will be enabled on a per-lun basis.  The driver will
>> trap READS/WRITEs from the OS, check for LUN DIF enablement, and if set,
>> turns on write-only DIF.
> NAK. We do support proper DIF, and anyone who wants it should enable
> the real thing.
>
> And even if we would want to support a hack like this we'd do it
> genericly an not in a driver.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>

