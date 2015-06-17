From: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Subject: Re: [PATCH 02/20] [SCSI] mpt3sas: Get IOC_FACTS information using
 handshake protocol only after HBA card gets into READY or Operational state.
Date: Wed, 17 Jun 2015 14:38:44 +0530
Message-ID: <CAK=zhgruSPM5VKemaQ0D=jPOVUr5xNMqhSHmA-hUbJECbZspjA@mail.gmail.com>
References: <1434102153-38581-1-git-send-email-Sreekanth.Reddy@avagotech.com>
	<1434102153-38581-3-git-send-email-Sreekanth.Reddy@avagotech.com>
	<558047E7.6000901@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wg0-f43.google.com ([74.125.82.43]:33372 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750941AbbFQJIq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Jun 2015 05:08:46 -0400
Received: by wgez8 with SMTP id z8so31231243wge.0
        for <linux-scsi@vger.kernel.org>; Wed, 17 Jun 2015 02:08:45 -0700 (PDT)
In-Reply-To: <558047E7.6000901@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Tomas Henzl <thenzl@redhat.com>
Cc: "jejb@kernel.org" <jejb@kernel.org>, Christoph Hellwig <hch@infradead.org>, "Martin K. Petersen" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "James E.J. Bottomley" <JBottomley@parallels.com>, Sathya Prakash <Sathya.Prakash@avagotech.com>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>

On Tue, Jun 16, 2015 at 9:29 PM, Tomas Henzl <thenzl@redhat.com> wrote:
> On 06/12/2015 11:42 AM, Sreekanth Reddy wrote:
>> Driver initialization fails if driver tries to send IOC facts request message when the IOC is in reset or in a fault state.
>>
>> This patch will make sure that
>>  1.Driver to send IOC facts request message only if HBA is in operational or ready state.
>>  2.If IOC is in fault state, a diagnostic reset would be issued.
>>  3.If IOC is in reset state then driver will wait for 10 seconds to exit out of reset state.
>>    If the HBA continues to be in reset state, then the HBA wouldn't be claimed by the driver.
>>
>> Signed-off-by: Sreekanth Reddy <Sreekanth.Reddy@avagotech.com>
>> ---
>>  drivers/scsi/mpt3sas/mpt3sas_base.c | 65 +++++++++++++++++++++++++++++++++++++
>>  1 file changed, 65 insertions(+)
>>
>> diff --git a/drivers/scsi/mpt3sas/mpt3sas_base.c b/drivers/scsi/mpt3sas/mpt3sas_base.c
>> index c13a365..ce57320 100644
>> --- a/drivers/scsi/mpt3sas/mpt3sas_base.c
>> +++ b/drivers/scsi/mpt3sas/mpt3sas_base.c
>> @@ -3169,6 +3169,9 @@ _base_wait_on_iocstate(struct MPT3SAS_ADAPTER *ioc, u32 ioc_state, int timeout,
>>   * Notes: MPI2_HIS_IOC2SYS_DB_STATUS - set to one when IOC writes to doorbell.
>>   */
>>  static int
>> +_base_diag_reset(struct MPT3SAS_ADAPTER *ioc, int sleep_flag);
>> +
>> +static int
>>  _base_wait_for_doorbell_int(struct MPT3SAS_ADAPTER *ioc, int timeout,
>>       int sleep_flag)
>>  {
>> @@ -3711,6 +3714,61 @@ _base_get_port_facts(struct MPT3SAS_ADAPTER *ioc, int port, int sleep_flag)
>>  }
>>
>>  /**
>> + * _base_wait_for_iocstate - Wait until the card is in READY or OPERATIONAL
>> + * @ioc: per adapter object
>> + * @timeout:
>> + * @sleep_flag: CAN_SLEEP or NO_SLEEP
>> + *
>> + * Returns 0 for success, non-zero for failure.
>> + */
>> +static int
>> +_base_wait_for_iocstate(struct MPT3SAS_ADAPTER *ioc, int timeout,
>> +     int sleep_flag)
>> +{
>> +     u32 ioc_state;
>> +     int rc;
>> +
>> +     dinitprintk(ioc, printk(MPT3SAS_FMT "%s\n", ioc->name,
>> +         __func__));
>> +
>> +     if (ioc->pci_error_recovery)
>> +             return 0;
> Hi Sreekanth, isn't that^ an error condition - 'return -EFAULT;'
> would be better?
> Tomas

Accepted. I will post the next version of this patch with this change.

Thanks,
Sreekanth
>> +
>> +     ioc_state = mpt3sas_base_get_iocstate(ioc, 0);
>> +     dhsprintk(ioc, printk(MPT3SAS_FMT "%s: ioc_state(0x%08x)\n",
>> +         ioc->name, __func__, ioc_state));
>> +
>> +     if (((ioc_state & MPI2_IOC_STATE_MASK) == MPI2_IOC_STATE_READY) ||
>> +         (ioc_state & MPI2_IOC_STATE_MASK) == MPI2_IOC_STATE_OPERATIONAL)
>> +             return 0;
>> +
>> +     if (ioc_state & MPI2_DOORBELL_USED) {
>> +             dhsprintk(ioc, printk(MPT3SAS_FMT
>> +                 "unexpected doorbell active!\n", ioc->name));
>> +             goto issue_diag_reset;
>> +     }
>> +
>> +     if ((ioc_state & MPI2_IOC_STATE_MASK) == MPI2_IOC_STATE_FAULT) {
>> +             mpt3sas_base_fault_info(ioc, ioc_state &
>> +                 MPI2_DOORBELL_DATA_MASK);
>> +             goto issue_diag_reset;
>> +     }
>> +
>> +     ioc_state = _base_wait_on_iocstate(ioc, MPI2_IOC_STATE_READY,
>> +         timeout, sleep_flag);
>> +     if (ioc_state) {
>> +             dfailprintk(ioc, printk(MPT3SAS_FMT
>> +                 "%s: failed going to ready state (ioc_state=0x%x)\n",
>> +                 ioc->name, __func__, ioc_state));
>> +             return -EFAULT;
>> +     }
>> +
>> + issue_diag_reset:
>> +     rc = _base_diag_reset(ioc, sleep_flag);
>> +     return rc;
>> +}
>> +
>> +/**
>>   * _base_get_ioc_facts - obtain ioc facts reply and save in ioc
>>   * @ioc: per adapter object
>>   * @sleep_flag: CAN_SLEEP or NO_SLEEP
>> @@ -3728,6 +3786,13 @@ _base_get_ioc_facts(struct MPT3SAS_ADAPTER *ioc, int sleep_flag)
>>       dinitprintk(ioc, pr_info(MPT3SAS_FMT "%s\n", ioc->name,
>>           __func__));
>>
>> +     r = _base_wait_for_iocstate(ioc, 10, sleep_flag);
>> +     if (r) {
>> +             dfailprintk(ioc, printk(MPT3SAS_FMT
>> +                 "%s: failed getting to correct state\n",
>> +                 ioc->name, __func__));
>> +             return r;
>> +     }
>>       mpi_reply_sz = sizeof(Mpi2IOCFactsReply_t);
>>       mpi_request_sz = sizeof(Mpi2IOCFactsRequest_t);
>>       memset(&mpi_request, 0, mpi_request_sz);
>>
>



-- 

Regards,
Sreekanth
