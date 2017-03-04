From: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Subject: Re: [PATCH v3 01/16] lpfc: Correct WQ creation for pagesize
Date: Fri, 3 Mar 2017 22:43:16 -0300
Message-ID: <6a197069-2f10-6df1-4cf1-1a62808c8903@linux.vnet.ibm.com>
References: <58a0d919.08BhoypOnvRSLIqV%jsmart2021@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:60781 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752012AbdCDDj2 (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 3 Mar 2017 22:39:28 -0500
Received: from pps.filterd (m0098420.ppops.net [127.0.0.1])
        by mx0b-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v241hi5j008379
        for <linux-scsi@vger.kernel.org>; Fri, 3 Mar 2017 20:43:55 -0500
Received: from e24smtp02.br.ibm.com (e24smtp02.br.ibm.com [32.104.18.86])
        by mx0b-001b2d01.pphosted.com with ESMTP id 28yb05mu6n-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Fri, 03 Mar 2017 20:43:55 -0500
Received: from localhost
        by e24smtp02.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <mauricfo@linux.vnet.ibm.com>;
        Fri, 3 Mar 2017 22:43:53 -0300
Received: from d24relay02.br.ibm.com (d24relay02.br.ibm.com [9.18.232.42])
        by d24dlp02.br.ibm.com (Postfix) with ESMTP id C85EE1DC0054
        for <linux-scsi@vger.kernel.org>; Fri,  3 Mar 2017 20:43:51 -0500 (EST)
Received: from d24av02.br.ibm.com (d24av02.br.ibm.com [9.8.31.93])
        by d24relay02.br.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id v241hjU234275532
        for <linux-scsi@vger.kernel.org>; Fri, 3 Mar 2017 22:43:50 -0300
Received: from d24av02.br.ibm.com (localhost [127.0.0.1])
        by d24av02.br.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id v241hTPh003716
        for <linux-scsi@vger.kernel.org>; Fri, 3 Mar 2017 22:43:30 -0300
In-Reply-To: <58a0d919.08BhoypOnvRSLIqV%jsmart2021@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <jsmart2021@gmail.com>, linux-scsi@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-nvme@lists.infradead.org, sagi@grimberg.me

Hi Martin and James,

On 02/12/2017 07:52 PM, James Smart wrote:
> Correct WQ creation for pagesize

Reviewed-by: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>


Please flag this patch for stable.

This patch resolves a serious problem on IBM Power systems at least.

An (apparently constant) series of invalid iotags cause a series of
SCSI command aborts that escalates into host reset, which fails too, 
bringing the adapter offline.

And it takes forever to boot, as udev waits on the initial SCSI I/O.

Thank you.


[   17.044690] lpfc 0000:01:00.1: 1:0372 iotag x0 is out off range: max 
iotag (x840)
...
[  723.680700] lpfc 0000:01:00.1: 1:(0):0714 SCSI layer issued Bus Reset 
Data: x2003
[  723.680873] lpfc 0000:01:00.1: 1:(0):3172 SCSI layer issued Host 
Reset Data:
[  724.052506] lpfc 0000:01:00.1: 1:0383 Error -5 during scsi sgl post 
operation
[  724.052701] lpfc 0000:01:00.1: 1:(0):3323 Failed host reset, bring it 
offline


-- 
Mauricio Faria de Oliveira
IBM Linux Technology Center
