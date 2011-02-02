From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [v2 PATCH 4/5] bnx2fc: Broadcom FCoE Offload driver submission
 - part 2
Date: Wed, 02 Feb 2011 03:24:14 -0600
Message-ID: <4D4922BE.40907@cs.wisc.edu>
References: <1293170555.4676.574.camel@ltsjc-bprakash2.corp.ad.broadcom.com> <4D316634.5030300@cs.wisc.edu> <1295311066.3536.105.camel@ltsjc-bprakash2.corp.ad.broadcom.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:40718 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751723Ab1BBJY0 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 2 Feb 2011 04:24:26 -0500
In-Reply-To: <1295311066.3536.105.camel@ltsjc-bprakash2.corp.ad.broadcom.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bhanu Gollapudi <bprakash@broadcom.com>
Cc: "devel@open-fcoe.org" <devel@open-fcoe.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Michael Chan <mchan@broadcom.com>

On 01/17/2011 06:37 PM, Bhanu Gollapudi wrote:
>>
>> Are you sending a abort when a lun or target reset has been successfully
>> completed? Does your hw need the reset? SCSI spec wise the lun or target
>> reset will take care of the scsi commands on its side, so there is no
>> need to send an abort.
>
> It is better to send ABTS on all the outstanding IOs after issuing
> lun/target reset.  targets may take care of scsi commands on its side.
> But the commands on the flight may have to be aborted. This is as per
> the FCP-4 spec in "Table 8 - Clearing effects of initiator FCP-Port
> actions" :-
> "Exchanges are cleared internally within the target FCP_Port, but open
> FCP Sequences shall be individually aborted by the initiator FCP_Port
> using ABTS-LS that also has the effect of aborting the associated FCP
> Exchange. See 12.3."

Ughh. I must have misread that before. I think libfc is broken then.



>>
>>> +}
>>> +
>>> +static int bnx2fc_map_sg(struct bnx2fc_cmd *io_req)
>>> +{
>>> +     struct bnx2fc_hba *hba = io_req->port->hba;
>>> +     struct scsi_cmnd *sc = io_req->sc_cmd;
>>> +     struct fcoe_bd_ctx *bd = io_req->bd_tbl->bd_tbl;
>>> +     struct scatterlist *sg;
>>> +     int byte_count = 0;
>>> +     int sg_count = 0;
>>> +     int bd_count = 0;
>>> +     int sg_frags;
>>> +     unsigned int sg_len;
>>> +     u64 addr;
>>> +     int i;
>>> +
>>> +     sg = scsi_sglist(sc);
>>> +     sg_count = pci_map_sg(hba->pcidev, sg, scsi_sg_count(sc),
>>> +                           sc->sc_data_direction);
>>
>>
>> I think you could also use scsi_dma_map instead.
>>
>> And if not I think we are supposed to be using the dma functions instead
>> of the pci ones.
>
> OK. I can use dma_map_sg() intead. But this function inturn calls
> pci_map_sg(). Is there any reason why we cannot directly call it?
>

People like abstractions. I guess we are trying to move to the dma 
functions. If you had some other bus then the dma wrappers would hide that.


>
>>
>>
>>
>>> +
>>> +static int bnx2fc_post_io_req(struct bnx2fc_rport *tgt,
>>> +                            struct bnx2fc_cmd *io_req)
>>> +{
>>
>>
>>> +
>>> +     /* Time IO req */
>>> +     bnx2fc_cmd_timer_set(io_req, BNX2FC_IO_TIMEOUT);
>>
>> Hard coding this does not seem right becuase the scsi cmnd timer can be
>> set through sysfs. It could be set lower than this which makes it
>> useless. I think libfc is dropping their similar timer like this and
>> just relying on the scsi_cmnd timer now (I think they just do the rec
>> but not the abort now).
>
> if it is a lower value, eh_abort_handler() code kicks in. Default scsi
> cmd timer is 60 secs, which may be too long to wait to sends an ABTS.


Do not work around scsi-ml and the classes. If really useful it seems 
this should be in libfc or the fc class so all drivers do the same thing 
if capable.

Also if the abort fails you still have to wait for the scsi eh to run.

And if the the scsi timer is too long why don't you just set it lower?

Also, it is 30 secs by default in the kernel, but some distro's have 
udev's that set it to 60.
