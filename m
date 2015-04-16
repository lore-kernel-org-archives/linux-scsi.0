From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: [RFC] Simlify dif_verify routines and fixup fileio protection
 information code.
Date: Thu, 16 Apr 2015 18:58:38 +0300
Message-ID: <552FDC2E.7020203@dev.mellanox.co.il>
References: <1428945575-30839-1-git-send-email-sagig@mellanox.com>	<CAC5umygZ_qCu0x3RfTQs21R1Poa6A10FkhmGak7ccc2HvY4ROQ@mail.gmail.com>	<552D4C7B.9000402@dev.mellanox.co.il>	<CAC5umyj9FsnumRhvNrzqE=Rtpy3O32SBw43ZP9M8H5B3htbRpw@mail.gmail.com>	<552E384F.3030203@dev.mellanox.co.il>	<CAC5umygGG4BTs0u35eVi6dLhoDuDshGNPsQaWq2kO5YexWDP+Q@mail.gmail.com>	<552E76D1.7040204@dev.mellanox.co.il>	<552E7ED6.4080304@dev.mellanox.co.il>	<yq1egnl4bjm.fsf@sermon.lab.mkp.net>	<552F7840.2080804@dev.mellanox.co.il> <CAC5umygHt_LHyCWEhg9whhe7PfQBy=Y9uXbKAE6+1EL7MEzmrg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-wi0-f179.google.com ([209.85.212.179]:34401 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752891AbbDPP6m (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 16 Apr 2015 11:58:42 -0400
Received: by widjs5 with SMTP id js5so14928938wid.1
        for <linux-scsi@vger.kernel.org>; Thu, 16 Apr 2015 08:58:40 -0700 (PDT)
In-Reply-To: <CAC5umygHt_LHyCWEhg9whhe7PfQBy=Y9uXbKAE6+1EL7MEzmrg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Akinobu Mita <akinobu.mita@gmail.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, target-devel@vger.kernel.org, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>

On 4/16/2015 4:46 PM, Akinobu Mita wrote:
> 2015-04-16 17:52 GMT+09:00 Sagi Grimberg <sagig@dev.mellanox.co.il>:
>> On 4/15/2015 7:10 PM, Martin K. Petersen wrote:
>>>>>>>>
>>>>>>>> "Sagi" == Sagi Grimberg <sagig@dev.mellanox.co.il> writes:
>>>
>>>
>>>>>> By the commit 436f4a0a ("loopback: Add fabric_prot_type attribute
>>>>>> support"), When WRITE_SAME command with WRPROTECT=0 is executed,
>>>>>> sbc_dif_generate() is called but cmd->t_prot_sg is NULL as block
>>>>>> layer didn't allocate it for WRITE_SAME.
>>>
>>>
>>> Sagi> Actually this is a bug. Why didn't the initiator allocate
>>> Sagi> integrity meta-data for WRITE_SAME? Looking at the code it looks
>>> Sagi> like it should.
>>>
>>> We don't issue WRITE SAME with PI so there is no prot SGL.
>>>
>>
>> Is there a specific reason why we don't?
>
> It is not only for the WRITE SAME requests from block device but
> also for READ/WRITE with PROTECT=0 requests by SG_IO.
>

This is specific to loopback which is using target_submit_cmd_map_sgls()
Other fabrics would allocate sgls per IO and the core would allocate
protection SGLs as well.

> So isn't is appropreate to allocate prot SGL in
> target_write_prot_action() (and mark se_cmd->se_cmd_flags to release
> it at deallocation time)?
>

I'd say that given this is specific to loopback, than tcm_loop needs
to be fixed... But specifically for WRITE_SAME, I'd be careful with
allocating a single 8 byte protection buffer because as Martin said,
unlike the data block, the protection field may change from sector to
sector (ref_tag in Type 1).

So allocating a single 8 byte buf will take it's toll in the backend
(iblock backend would need to allocate all the protection information
and add it to the bio anyway, file/rd will need to do multiple writes).

It might be better that for the special WRITE_SAME case, allocate 8 *
sectors sgl and set it up (incrementing ref_tag for type 1). This way,
the backend code can stay the same (other than opening write_same with
PI in iblock).

Sagi.
