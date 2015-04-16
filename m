From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: Re: [RFC] Simlify dif_verify routines and fixup fileio protection
 information code.
Date: Thu, 16 Apr 2015 22:46:15 +0900
Message-ID: <CAC5umygHt_LHyCWEhg9whhe7PfQBy=Y9uXbKAE6+1EL7MEzmrg@mail.gmail.com>
References: <1428945575-30839-1-git-send-email-sagig@mellanox.com>
	<CAC5umygZ_qCu0x3RfTQs21R1Poa6A10FkhmGak7ccc2HvY4ROQ@mail.gmail.com>
	<552D4C7B.9000402@dev.mellanox.co.il>
	<CAC5umyj9FsnumRhvNrzqE=Rtpy3O32SBw43ZP9M8H5B3htbRpw@mail.gmail.com>
	<552E384F.3030203@dev.mellanox.co.il>
	<CAC5umygGG4BTs0u35eVi6dLhoDuDshGNPsQaWq2kO5YexWDP+Q@mail.gmail.com>
	<552E76D1.7040204@dev.mellanox.co.il>
	<552E7ED6.4080304@dev.mellanox.co.il>
	<yq1egnl4bjm.fsf@sermon.lab.mkp.net>
	<552F7840.2080804@dev.mellanox.co.il>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <552F7840.2080804@dev.mellanox.co.il>
Sender: target-devel-owner@vger.kernel.org
To: Sagi Grimberg <sagig@dev.mellanox.co.il>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, target-devel@vger.kernel.org, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Christoph Hellwig <hch@lst.de>
List-Id: linux-scsi@vger.kernel.org

2015-04-16 17:52 GMT+09:00 Sagi Grimberg <sagig@dev.mellanox.co.il>:
> On 4/15/2015 7:10 PM, Martin K. Petersen wrote:
>>>>>>>
>>>>>>> "Sagi" == Sagi Grimberg <sagig@dev.mellanox.co.il> writes:
>>
>>
>>>>> By the commit 436f4a0a ("loopback: Add fabric_prot_type attribute
>>>>> support"), When WRITE_SAME command with WRPROTECT=0 is executed,
>>>>> sbc_dif_generate() is called but cmd->t_prot_sg is NULL as block
>>>>> layer didn't allocate it for WRITE_SAME.
>>
>>
>> Sagi> Actually this is a bug. Why didn't the initiator allocate
>> Sagi> integrity meta-data for WRITE_SAME? Looking at the code it looks
>> Sagi> like it should.
>>
>> We don't issue WRITE SAME with PI so there is no prot SGL.
>>
>
> Is there a specific reason why we don't?

It is not only for the WRITE SAME requests from block device but
also for READ/WRITE with PROTECT=0 requests by SG_IO.

So isn't is appropreate to allocate prot SGL in
target_write_prot_action() (and mark se_cmd->se_cmd_flags to release
it at deallocation time)?
