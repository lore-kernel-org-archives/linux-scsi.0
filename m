From: "Guilherme G. Piccoli" <gpiccoli@linux.vnet.ibm.com>
Subject: Re: [PATCH] lpfc: Fix NULL pointer dereference during PCI error
 recovery
Date: Thu, 18 May 2017 10:35:28 -0300
Message-ID: <fdb11722-529b-3bd5-64f0-581fb6a3d536@linux.vnet.ibm.com>
References: <20170517220217.28337-1-gpiccoli@linux.vnet.ibm.com>
 <yq1y3tv6mmn.fsf@oracle.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:38439 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1755189AbdERNfp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 18 May 2017 09:35:45 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v4IDYhua027035
        for <linux-scsi@vger.kernel.org>; Thu, 18 May 2017 09:35:44 -0400
Received: from e24smtp01.br.ibm.com (e24smtp01.br.ibm.com [32.104.18.85])
        by mx0a-001b2d01.pphosted.com with ESMTP id 2ahbjf3hwe-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 18 May 2017 09:35:44 -0400
Received: from localhost
        by e24smtp01.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <gpiccoli@linux.vnet.ibm.com>;
        Thu, 18 May 2017 10:35:40 -0300
Received: from d24av05.br.ibm.com (d24av05.br.ibm.com [9.18.232.44])
        by d24relay04.br.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id v4IDZcEx50397206
        for <linux-scsi@vger.kernel.org>; Thu, 18 May 2017 10:35:38 -0300
Received: from d24av05.br.ibm.com (localhost [127.0.0.1])
        by d24av05.br.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id v4IDZdq0008673
        for <linux-scsi@vger.kernel.org>; Thu, 18 May 2017 10:35:39 -0300
In-Reply-To: <yq1y3tv6mmn.fsf@oracle.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org, raphasil@linux.vnet.ibm.com, james.smart@broadcom.com, dick.kennedy@broadcom.com, jsmart2021@gmail.com

On 05/17/2017 09:21 PM, Martin K. Petersen wrote:
> 
> Guilherme,
> 
>> Recent commit on patchset "lpfc updates for 11.2.0.14" fixed an issue
>> about dereferencing a NULL pointer on port reset. The specific commit,
>> named "lpfc: Fix system crash when port is reset.", is missing a check
>> against NULL pointer on lpfc_els_flush_cmd() though.
>>
>> Since we destroy the queues on adapter resets, like in PCI error
>> recovery path, we need the validation present on this patch in order
>> to avoid a NULL pointer dereference when trying to flush commands of
>> ELS wq, after it has been destroyed (which would lead to a kernel
>> oops).
> 
> Applied to 4.12/scsi-fixes. Thank you!
> 

Thanks Martin!
