From: Sagi Grimberg <sagig@dev.mellanox.co.il>
Subject: Re: iSCSI Expected Data Transfer Length for T10-PI
Date: Mon, 26 May 2014 00:04:34 +0300
Message-ID: <53825AE2.5020800@dev.mellanox.co.il>
References: <53820C9B.3090003@dev.mellanox.co.il> <AD52A8E9-F044-4E3A-A842-D53BF06C8CF1@infinidat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <AD52A8E9-F044-4E3A-A842-D53BF06C8CF1@infinidat.com>
Sender: target-devel-owner@vger.kernel.org
To: Julian Satran <julians@infinidat.com>
Cc: "martin.petersen@oracle.com" <martin.petersen@oracle.com>, Mike Christie <michaelc@cs.wisc.edu>, "Nicholas A. Bellinger" <nab@linux-iscsi.org>, linux-scsi <linux-scsi@vger.kernel.org>, target-devel <target-devel@vger.kernel.org>, Oren Duer <oren@mellanox.com>, "james.smart@emulex.com" <james.smart@emulex.com>, Or Gerlitz <ogerlitz@mellanox.com>, "cbm@chadalapaka.com" <cbm@chadalapaka.com>, "meth@il.ibm.com" <meth@il.ibm.com>, "david.black@emc.com" <david.black@emc.com>
List-Id: linux-scsi@vger.kernel.org

On 5/25/2014 10:39 PM, Julian Satran wrote:
Hi Julian,

> I have some trouble parsing you English/Question.

I'll try to clarify.

>   I think the intent of SCSI PI was that wherever the PI exist it should be checked end-to-end and it may be checked in between.
> A storage client (server) will have the PI appended in the memory when writing and reading and checking it. As the values are standardized storage may also check it both when reading and when writing but it should not change it.

All true.

>   If by implicit you mean inclusive I assume iSCSI Expected data transfer length will take whatever is in the cdb.
> Block transfer devices will likely add the PI length to the pure data length - i.e. inclusive.

My intention was that there is no explicit indication in the CDB that X 
additional PI bytes should be transferred,
it is implied that each block is appended with 8 bytes of PI.

For example:
Say we have an iSCSI target exposing a LUN which is formatted with PI. 
The iSCSI initiator supports PI transfer as well.
What do you expect iSCSI.ExpectedDataTransferLength field to be in the 
case of a single 512B block SCSI READ?  512?  520?
My understanding is that you think it should be the number of pure data 
bytes (i.e. 512).

As I mentioned, FC's fc_dl for example, was updated to be the *total* 
number of bytes (data + PI) in the SCSI operation (i.e. will be 520 in 
the above example).
virtio_scsi header was updated to additionally specify the number of IN 
PI bytes and the number of OUT PI bytes involved.

What I understood from the spec, is that 
iSCSI.ExpectedDataTransferLength corresponds to the number of
*data* bytes involved in this SCSI operation. That's why I kept 
iSCSI.ExpectedDataTransferLength to be
the number of pure data bytes.

So I guess I'm basically asking is, should iSCSI header include the 
number of PI bytes that should be transferred over the
wire as well?

Hope things are clearer,
Sagi.
