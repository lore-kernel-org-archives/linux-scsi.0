From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: bidi support: FC transport layer...
Date: Thu, 10 Jul 2008 18:30:15 +0300
Message-ID: <48762B07.703@panasas.com>
References: <E11DE615-512A-45C0-9308-036BDA225E9D@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:20288 "EHLO
	natasha.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760233AbYGJPak (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Jul 2008 11:30:40 -0400
In-Reply-To: <E11DE615-512A-45C0-9308-036BDA225E9D@qlogic.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Seokmann Ju <seokmann.ju@qlogic.com>
Cc: linux-scsi@vger.kernel.org, Andrew Vasquez <andrew.vasquez@qlogic.com>

Seokmann Ju wrote:
> Hi,
> 
> With starting to implement FC-CT/ELS support on the qla2xxx module, I  
> would like to get some idea about the bidi-bidirectional.
Hi Dear Seokmann

Searching for "FC-CT ELS" did not produce any comprehensive results
for me. If you could send me exact pointer to the t11 paper I could
investigate it deeper.

> As I understand that the bidi is packet transporting infra-structure,  
> I think it could be good candidate for the FC specific FC-CT/ELS  
> packet delivery in between the application and the individual devices  
> given topology.
> 

bidi, as in scsi-bidirectional commands, is any scsi command (in any 
command set) where a single CDB utilizes both an in-buffer and an
out-buffer, for sending-while-receiving data to-from a target device.
The write-from-host buffers and read-to-host buffers happens concurrently
with out predetermined serialization and can in fact happen all at once.

So to answer your question: It is a must candidate for bidi, if the t11
standard states that a single CDB specifies both an out-buffer and an 
in-buffer, to complete the command.

An example of a bidi command is the XOR family of commands as defined
by SCSI for the block command set.

> As I have limited understanding about the bid, here are my questions,
> 0. would the bidi be a right choice for the FC-CT/ELS packet delivery?
Please point me to the normative documentation so I can check.

> 1. where should I get any kind of documents/briefs about the bidi?

In code and git I'm afraid. Look in git for the history of both
drivers/scsi/libiscsi.c and drivers/scsi/scsi_debug.c and see how they
are changed to receive bidirectional commands.
And also include/scsi/scsi_cmnd.h and drivers/scsi/scsi_lib.c for
these patches that introduce the bidi support, they have some explanations
and you can inspect their implementation.

> 2. which part of code that I have to walk-through for further  
> understanding about the bidi mechanism?

Best is to look in git for the relevant patches both at scsi-midlevel
and iscsi.

> 3. with the bidi, what's the application interface should look like?
> 

if you have for example:
int xxx_write(const void* out_buff, int len);
and
int xxx_read(void * in_buff, int_len);
then you might have something like
int xxx_xor(const void* out_buff, void * in_buff, int len);
which is a bidi command that writes and reads results all at once.

> I expect to have some changes/additions in the FC transport layer in  
> regards to the support and in general.
> 
> Any comment/guidance would be greatly helpful.
> 

scsi-bidirectional commands was crafted for scsi command sets that specifically
called for both in/out buffers participating in a single command. If the commands
in question are like that then this is the right tool to use.

> Thank you,
> Seokmann
> --

When you advance farther I can send you code examples of how an initiator pushes
block-requests that carry bidi payload that's the easy part. Getting your driver
to support and expect bidi commands is a bit harder. (Just a bit)

Feel free to ask any questions you have.

Cheers 
Boaz
