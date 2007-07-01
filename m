From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 3/3] Farther clean up of stex.c driver
Date: Sun, 01 Jul 2007 16:55:59 +0300
Message-ID: <4687B26F.2050108@panasas.com>
References: <B70A50D07063384EB9BCE3330D18414F03601207@nonameb.ptu.promise.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-e.panasas.com ([65.194.124.178]:55231 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753243AbXGAN4R (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Sun, 1 Jul 2007 09:56:17 -0400
In-Reply-To: <B70A50D07063384EB9BCE3330D18414F03601207@nonameb.ptu.promise.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ed Lin <ed.lin@promise.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Cc: g.liakhovetski@gmx.de, linux-scsi@vger.kernel.org, James Bottomley <James.Bottomley@SteelEye.com>

Ed Lin wrote:
> 
>>>>
>>> The software allocates a big enough buffer(so don't worry about this),
>>> and it trims the data size based on returned length. So it needs the
>>> actual data length.

This sounds like a security breach to me. An untrusted user-mode
with knowledge of such hardware in the machine can gain access to kernel
through the wrong( cracker-right) sized request.

>> What's the software? I mean that who trims the data size based on
>> returned length?
>>
> 
> The management software provided by Promise.
> 

I had a deeper look into this, and I am totally confused.
The code in question at stex.c::stex_ys_commands() is called
at softirq from stex_mu_intr(). It will than immediately go 
on to eventually call cmd->scsi_done(cmd);
Now what is the upper layer that calls this command??!

There can be 3 possibilities that I know. From unlikely to likely order:
1. REQ_TYPE_FS command which is not possible because I don't know
   of any one that can issue. a ccb->cmd->cmnd[0] == MGT_CMD
   as an REQ_TYPE_FS. And anyway if bufflen is truncated like that
   a REQ_TYPE_FS command will retry the command until complete.

2. REQ_TYPE_BLOCK_PC through sg, bsg or others at which truncating
   a command like that will leak BIOs when trying to release the 
   command, since scsi-ml relies on bufflen in the call to 
   end_that_request_first.

3. A special upper layer that overrides the done functions at 
   scsi_cmnd or request levels and interprets the return info
   and/or frees buffers. If this is the case, can such a driver
   use a reserved member of scsi_cmnd like the fields in 
   struct scsi_pointer or something hanging on host_scribble?
   Than later return to user-mode what it used to return before
   but leave bufflen alone?

Setting of bufflen like that in a driver sounds like a highway
rubbery to me. Please stop that Hack. Now!

>>> So this length fix is necessary if software doesn't
>>> change policy. The whole thing is guaranteed by both software and
>>> firmware, software will do a check, firmware will do a check, 
>>> so a check in driver is not necessary.


As I said. I'm sure we can change upper layer polices to not
break user-mode but to also not touch a delicate and private member
of scsi-ml. It limits the scsi-ml ability to change and evolve.
The most I can do for now is declare this driver broken once 
scsi_sgtable goes in because I sure am not going to do:
ccb->cmd->sg_table->length = le32_to_cpu(*(__le32 *)&resp->variable[0]);
(Do we need an explanation why this is plain broken, leaking code)

If you point me to the upper layer driver used, I can see if I can change it
in a way that will not touch bufflen.

Another thing I do not understand is where in the SCSI standard
such an operation is defined. because if it is a standard SCSI
command or extended or vendor-specific command than, current code
is not built to cope with such scenario. How would one defined
it? a "truncated read"?

Boaz Harrosh

