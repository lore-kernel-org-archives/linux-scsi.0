From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH RESEND] aacraid: Fix 2T+ drives on SmartIOC-2000
Date: Fri, 15 Sep 2017 21:10:34 -0400
Message-ID: <yq1d16rtpmd.fsf@oracle.com>
References: <20170915170428.15237-1-david.carroll@microsemi.com>
        <20170915180115.GB24045@infradead.org>
        <423FD6710FB8FB4F8728F93591889F9A5B8BDE73@avsrvexchmbx1.microsemi.net>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:50000 "EHLO
        aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751200AbdIPBLQ (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>); Fri, 15 Sep 2017 21:11:16 -0400
In-Reply-To: <423FD6710FB8FB4F8728F93591889F9A5B8BDE73@avsrvexchmbx1.microsemi.net>
        (Dave Carroll's message of "Fri, 15 Sep 2017 23:37:23 +0000")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Dave Carroll <david.carroll@microsemi.com>
Cc: Christoph Hellwig <hch@infradead.org>, "Martin K . Petersen" <martin.petersen@oracle.com>, James Bottomley <jejb@linux.vnet.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>, dl-esc-Aacraid Linux Driver <aacraid@microsemi.com>, Scott Benesh <scott.benesh@microsemi.com>, Brian King <brking@linux.vnet.ibm.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>


Dave,

> Hi Christoph,
>
>> > +             if ((le32_to_cpu(dresp->status) == ST_OK) &&
>> > +                     (le32_to_cpu(dresp->mnt[0].vol) != CT_NONE)) {
>> > +                     _aac_probe_container2(context, fibptr);
>> > +                     return;
>> 
>>                 if (dresp->status == cpu_to_le32(ST_OK) &&
>>                     dresp->mnt[0].vol != cpu_to_le32(CT_NONE)) {
>> 
>
> I've contemplated this all day, and it looked like sematics, but I
> assume you were Indicating that the cpu_to_le32() of a constant is a
> compiler issue, vs le32_to_cpu() is a runtime issue. If so, thanks! If
> not could you elaborate ...

FWIW, I applied your patch as-is for consistency with the rest of the
driver. I do prefer Christoph's version, though, but that can be a
follow-on patch.

-- 
Martin K. Petersen	Oracle Linux Engineering
