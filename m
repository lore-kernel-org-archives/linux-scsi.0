From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] BNX2I: register given device with cnic if shost != NULL
 in ep_connect()
Date: Thu, 09 Jul 2009 12:43:29 -0500
Message-ID: <4A562C41.7040600@cs.wisc.edu>
References: <C27F8246C663564A84BB7AB343977242178EE780AB@IRVEXCHCCR01.corp.ad.broadcom.com> <1247150366.9829.458.camel@anilgv-desktop>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:40962 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752396AbZGIRnj (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 9 Jul 2009 13:43:39 -0400
In-Reply-To: <1247150366.9829.458.camel@anilgv-desktop>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anil Veerabhadrappa <anilgv@broadcom.com>
Cc: Michael Chan <mchan@broadcom.com>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "open-iscsi@googlegroups.com" <open-iscsi@googlegroups.com>

On 07/09/2009 09:39 AM, Anil Veerabhadrappa wrote:
> On Thu, 2009-07-09 at 00:15 -0700, Michael Chan wrote:
>> Mike Christie wrote:
>>> Anil Veerabhadrappa wrote:
>>>> diff --git a/drivers/scsi/bnx2i/bnx2i_iscsi.c
>>> b/drivers/scsi/bnx2i/bnx2i_iscsi.c
>>>> index f741219..98148f3 100644
>>>> --- a/drivers/scsi/bnx2i/bnx2i_iscsi.c
>>>> +++ b/drivers/scsi/bnx2i/bnx2i_iscsi.c
>>>> @@ -1653,15 +1653,18 @@ static struct iscsi_endpoint
>>> *bnx2i_ep_connect(struct Scsi_Host *shost,
>>>>      struct iscsi_endpoint *ep;
>>>>      int rc = 0;
>>>>
>>>> -   if (shost)
>>>> +   if (shost) {
>>>>              /* driver is given scsi host to work with */
>>>>              hba = iscsi_host_priv(shost);
>>>> -   else
>>>> +           /* Register the device with cnic if not already
>>> done so */
>>>> +           bnx2i_register_device(hba);
>>>> +   } else
>>>>              /*
>>>>               * check if the given destination can be reached through
>>>>               * a iscsi capable NetXtreme2 device
>>>>               */
>>>>              hba = bnx2i_check_route(dst_addr);
>>>> +
>>>>      if (!hba) {
>>>>              rc = -ENOMEM;
>>>>              goto check_busy;
>>> Do you want to do the test_bit(BNX2I_CNIC_REGISTERED,
>>> &hba->reg_with_cnic) test here instead of down below. If it
>>> failed then
>>> you might try to do a cm_create on a cnic that is not
>>> properly registered.
>>>
>> Good idea.  cm_create() will properly be ok because there is no
>> hardware interaction.  bnx2i_send_conn_ofld_req() will fail if
>> the cnic is not properly registered because there will be no call
>> backs from the hardware events.
>
> following 2 conditions needs to be satisfied to offload an iscsi
> connection,
>    1) device has to be registered with cnic
>    2) device has to support iscsi offload
>
>    bnx2i_adapter_ready() will return success only if both conditions
> (which is flagged by ADAPTER_STATE_UP bit in hba->adapter_state) are
> met. bnx2i_ep_connect() will bailout if bnx2i_adapter_ready() does not
> return correct status and this guarantees bnx2i will not make any cnic
> calls on an unregistered device.
>

Ok then. It seems fine to me.

Reviewed-by Mike Christie <michaelc@cs.wisc.edu>

One other question though. Do you need the BNX2I_CNIC_REGISTERED tst in 
ep_connect then? If not then maybe in separate patch for the next 
feature window we can clean that up.

