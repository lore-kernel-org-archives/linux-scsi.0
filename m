From: Brian King <brking@us.ibm.com>
Subject: Re: [RFC] IBM Power RAID driver (ipr)
Date: Tue, 20 Jan 2004 13:13:38 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <400D7DE2.2080402@us.ibm.com>
References: <40085EDA.4010802@us.ibm.com> <20040119183400.A4182@infradead.org> <400C3E70.9040702@us.ibm.com> <20040120133858.A15671@infradead.org> <400D5A28.1000301@us.ibm.com> <20040120180151.A18616@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e6.ny.us.ibm.com ([32.97.182.106]:26074 "EHLO e6.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S265734AbUATTOF (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 20 Jan 2004 14:14:05 -0500
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org

Christoph Hellwig wrote
>>Ok, but I will still need that interface to send commands directed to=
=20
>>the adapter.
>=20
>=20
> commands as in scsi commands or as in internal commands?

Internal commands. As you look through the driver, they will look very=20
similar, as the interface to the adapter maps to scsi pretty close. I=20
could use the mid-layer for these commands, but I would need some way t=
o=20
send them when the adapter is self blocked and would probably need to=20
call scsi_add_host before the adapter is functional so I could send the=
=20
adapter initialization sequence.


>>>>Build a command in DMA'able host memory (struct ipr_ioarcb), write =
the=20
>>>>PCI address to a register on the adapter, the adapter DMAs down the=
=20
>>>>control block, executes the command, writes the=20
>>>>ipr_ioarcb.host_response_handle in the command control block to the=
 host=20
>>>>request/response queue in host memory, and signals an interrupt.
>>>>
>>>>Does that help at all?
>>>
>>>What's the relation of all these command lists to that?
>>
>>Sorry, I guess I'm missing something here. Are you saying a LLD=20
>>shouldn't need to maintain of queue of its command blocks (like my=20
>>pending_q and free_q)?
>=20
>=20
> Unless you allocate the blocks in ->queuecommand (like most modern dr=
ivers
> do) you'll need some form of freelist of course.  What you shouldn't =
need i=DF
> the pendig_q as the midlayer already keeps track of pending commands.
> This of course only works if you actually do send all commands via th=
e
> midlayer (which you should).

The reason I have a pending_q is so that when I reset the adapter=20
without the mid-layer knowing about it, I need to fail back any=20
outstanding ops so they get retried as appropriate. I suppose a way=20
around this would be a mid-layer interface that an LLD could call which=
=20
would cause a host reset. Then the midlayer could drive the reset and=20
take care of doing the right thing with any outstanding ops.


--=20
Brian King
eServer Storage I/O
IBM Linux Technology Center

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
