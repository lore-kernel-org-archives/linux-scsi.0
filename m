From: Mauricio Faria de Oliveira <mauricfo@linux.vnet.ibm.com>
Subject: Re: [REGRESSION] v4.11-rc3: lpfc: panic during module removal /
 shutdown
Date: Tue, 4 Apr 2017 09:07:04 -0300
Message-ID: <63afb4bb-fc5f-7e3d-45ab-0cf609e44558@linux.vnet.ibm.com>
References: <99ad422f-8233-ddac-2e69-deda4a43b3d7@ce.jp.nec.com>
 <9110d410-8522-9806-8444-44276de9af51@linux.vnet.ibm.com>
 <95631fe6-9f0a-fa88-2900-6fc54c4115bb@ce.jp.nec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-2022-jp; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0b-001b2d01.pphosted.com ([148.163.158.5]:47382 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1752545AbdDDMHp (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Tue, 4 Apr 2017 08:07:45 -0400
Received: from pps.filterd (m0098417.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v34C4AmA125407
        for <linux-scsi@vger.kernel.org>; Tue, 4 Apr 2017 08:07:44 -0400
Received: from e24smtp02.br.ibm.com (e24smtp02.br.ibm.com [32.104.18.86])
        by mx0a-001b2d01.pphosted.com with ESMTP id 29m1njtugq-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Tue, 04 Apr 2017 08:07:44 -0400
Received: from localhost
        by e24smtp02.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <mauricfo@linux.vnet.ibm.com>;
        Tue, 4 Apr 2017 09:07:42 -0300
Received: from d24av02.br.ibm.com (d24av02.br.ibm.com [9.8.31.93])
        by d24relay02.br.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id v34C7Z3x13107226
        for <linux-scsi@vger.kernel.org>; Tue, 4 Apr 2017 09:07:40 -0300
Received: from d24av02.br.ibm.com (localhost [127.0.0.1])
        by d24av02.br.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id v34C7K9X021196
        for <linux-scsi@vger.kernel.org>; Tue, 4 Apr 2017 09:07:20 -0300
In-Reply-To: <95631fe6-9f0a-fa88-2900-6fc54c4115bb@ce.jp.nec.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Junichi Nomura <j-nomura@ce.jp.nec.com>, "james.smart@broadcom.com" <james.smart@broadcom.com>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, "dick.kennedy@broadcom.com" <dick.kennedy@broadcom.com>, "anton@samba.org" <anton@samba.org>

Hi Martin and Junichi,

On 04/03/2017 11:10 PM, Junichi Nomura wrote:
> On 04/04/17 06:53, Mauricio Faria de Oliveira wrote:

>> On 03/28/2017 11:29 PM, Junichi Nomura wrote:
>>> Since commit 895427bd012c ("scsi: lpfc: NVME Initiator: Base modifications"),
>>> "rmmod lpfc" starting to cause panic or corruption due to double free.

>> Thanks for the report. Can you please check whether the patch just sent
>> ([PATCH] lpfc: fix double free of bound CQ/WQ ring pointer) resolves it?

> It works for me. Thank you!

Excellent, thanks!

Martin, can you review/consider it for 4.11-rc6, please?

> Considering future maintenance, it might be a bit fragile to just depend
> on the code comment about representing the relation between cq/wq and
> shared pring but it's maintainers' choice.

I agree -- there should be a better way of identifying a bound WQ/CQ.
Perhaps there is, but I couldn't find it currently.

For now, as far as I could grep and examine the code (detailed in commit
message), a WQ is always bound to a CQ, so to check for WQ and not free
its ring pointer seems to be sufficient (as the CQ ring pointer is freed
first).

If that changes, probably some form of flagging and/or queue type
determination would be better/necessary.

cheers,

-- 
Mauricio Faria de Oliveira
IBM Linux Technology Center
