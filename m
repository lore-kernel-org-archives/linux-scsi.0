From: "Guilherme G. Piccoli" <gpiccoli@linux.vnet.ibm.com>
Subject: Re: [PATCH] mpt3sas: Force request partial completion alignment
Date: Mon, 23 Jan 2017 11:00:48 -0200
Message-ID: <5885FE80.1030306@linux.vnet.ibm.com>
References: <1482929480-16688-1-git-send-email-gpiccoli@linux.vnet.ibm.com>
 <CAK=zhgoFH+G-m=VXNAe+ORKUZKJ0e3OY3SvB96_6wS+tB_CQHw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:54835 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1750718AbdAWNBF (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Mon, 23 Jan 2017 08:01:05 -0500
Received: from pps.filterd (m0098394.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v0NCwYI3079592
        for <linux-scsi@vger.kernel.org>; Mon, 23 Jan 2017 08:01:04 -0500
Received: from e24smtp04.br.ibm.com (e24smtp04.br.ibm.com [32.104.18.25])
        by mx0a-001b2d01.pphosted.com with ESMTP id 285ewmrgpn-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Mon, 23 Jan 2017 08:01:04 -0500
Received: from localhost
        by e24smtp04.br.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <gpiccoli@linux.vnet.ibm.com>;
        Mon, 23 Jan 2017 11:01:01 -0200
Received: from d24relay01.br.ibm.com (d24relay01.br.ibm.com [9.8.31.16])
        by d24dlp01.br.ibm.com (Postfix) with ESMTP id CF186352005F
        for <linux-scsi@vger.kernel.org>; Mon, 23 Jan 2017 08:00:26 -0500 (EST)
Received: from d24av05.br.ibm.com (d24av05.br.ibm.com [9.18.232.44])
        by d24relay01.br.ibm.com (8.14.9/8.14.9/NCO v10.0) with ESMTP id v0ND0wwF5128274
        for <linux-scsi@vger.kernel.org>; Mon, 23 Jan 2017 11:00:58 -0200
Received: from d24av05.br.ibm.com (localhost [127.0.0.1])
        by d24av05.br.ibm.com (8.14.4/8.14.4/NCO v10.0 AVout) with ESMTP id v0ND0wZh010954
        for <linux-scsi@vger.kernel.org>; Mon, 23 Jan 2017 11:00:58 -0200
In-Reply-To: <CAK=zhgoFH+G-m=VXNAe+ORKUZKJ0e3OY3SvB96_6wS+tB_CQHw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sreekanth Reddy <sreekanth.reddy@broadcom.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, PDL-MPT-FUSIONLINUX <MPT-FusionLinux.pdl@broadcom.com>, Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra Basappa <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, Brian King <brking@linux.vnet.ibm.com>, mauricfo@linux.vnet.ibm.com, linuxram@us.ibm.com

On 01/23/2017 07:05 AM, Sreekanth Reddy wrote:
> On Wed, Dec 28, 2016 at 6:21 PM, Guilherme G. Piccoli
> <gpiccoli@linux.vnet.ibm.com> wrote:
>> From: Ram Pai <linuxram@us.ibm.com>
>>
>> The firmware or device, possibly under a heavy I/O load, can return
>> on a partial unaligned boundary. Scsi-ml expects these requests to be
>> completed on an alignment boundary. Scsi-ml blindly requeues the I/O
>> without checking the alignment boundary of the I/O request for the
>> remaining bytes. This leads to errors, since devices cannot perform
>> non-aligned read/write operations.
>>
>> This patch fixes the issue in the driver. It aligns unaligned
>> completions of FS requests, by truncating them to the nearest
>> alignment boundary.
>>
>> Reported-by: Mauricio Faria De Oliveira <mauricfo@linux.vnet.ibm.com>
>> Signed-off-by: Guilherme G. Piccoli <gpiccoli@linux.vnet.ibm.com>
>> Signed-off-by: Ram Pai <linuxram@us.ibm.com>
>> ---
>>  drivers/scsi/mpt3sas/mpt3sas_scsih.c | 16 ++++++++++++++++
>>  1 file changed, 16 insertions(+)
>>
>> diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
>> index b5c966e..55332a3 100644
>> --- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
>> +++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
>> @@ -4644,6 +4644,8 @@ _scsih_io_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
>>         struct MPT3SAS_DEVICE *sas_device_priv_data;
>>         u32 response_code = 0;
>>         unsigned long flags;
>> +       unsigned int sector_sz;
>> +       struct request *req;
>>
>>         mpi_reply = mpt3sas_base_get_reply_virt_addr(ioc, reply);
>>         scmd = _scsih_scsi_lookup_get_clear(ioc, smid);
>> @@ -4703,6 +4705,20 @@ _scsih_io_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
>>         }
>>
>>         xfer_cnt = le32_to_cpu(mpi_reply->TransferCount);
>> +
>> +       /* In case of bogus fw or device, we could end up having
>> +        * unaligned partial completion. We can force alignment here,
>> +        * then scsi-ml does not need to handle this misbehavior.
>> +        */
>> +       sector_sz = scmd->device->sector_size;
>> +       req = scmd->request;
>> +       if (unlikely(sector_sz && req && (req->cmd_type == REQ_TYPE_FS) &&
>> +                   (xfer_cnt % sector_sz))) {
>> +               sdev_printk(KERN_INFO, scmd->device,
>> +                           "unaligned partial completion avoided\n");
> 
> [Sreekanth] Patch looks good. But can we print xfer_cnt & sector_sz
> values along with above print.
> 
> Also if it is generic drive issue, then can we move this work around
> to SCSI Mid Layer?
> 

Thank you! I'll send a v2 including your suggestion.
Regarding a fix in scsi-ml, we tried already:
https://lkml.org/lkml/2016/12/19/591

Reception wasn't in favor of the patch; they suggested we patch the
driver instead, then we sent the current change only for mpt3sas.

Thanks,


Guilherme

>> +               xfer_cnt = (xfer_cnt / sector_sz) * sector_sz;
>> +       }
>> +
>>         scsi_set_resid(scmd, scsi_bufflen(scmd) - xfer_cnt);
>>         if (ioc_status & MPI2_IOCSTATUS_FLAG_LOG_INFO_AVAILABLE)
>>                 log_info =  le32_to_cpu(mpi_reply->IOCLogInfo);
>> --
>> 2.1.0
>>
> 

