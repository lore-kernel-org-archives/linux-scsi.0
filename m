From: Seokmann Ju <seokmann.ju@qlogic.com>
Subject: Re: bidi support: FC transport layer...
Date: Thu, 10 Jul 2008 09:36:13 -0700
Message-ID: <4414E10D-6015-4768-BD97-D4A51E439573@qlogic.com>
References: <E11DE615-512A-45C0-9308-036BDA225E9D@qlogic.com> <48762B07.703@panasas.com>
Mime-Version: 1.0 (Apple Message framework v924)
Content-Type: text/plain; charset=US-ASCII; format=flowed; delsp=yes
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from avexch2.qlogic.com ([198.70.193.116]:53049 "EHLO
	avexch2.qlogic.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758503AbYGJQgT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 Jul 2008 12:36:19 -0400
In-Reply-To: <48762B07.703@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Boaz Harrosh <bharrosh@panasas.com>
Cc: linux-scsi@vger.kernel.org, Andrew Vasquez <andrew.vasquez@qlogic.com>


On Jul 10, 2008, at 8:30 AM, Boaz Harrosh wrote:

> Seokmann Ju wrote:
>> Hi,
>>
>> With starting to implement FC-CT/ELS support on the qla2xxx module, I
>> would like to get some idea about the bidi-bidirectional.
> Hi Dear Seokmann
>
> Searching for "FC-CT ELS" did not produce any comprehensive results
> for me. If you could send me exact pointer to the t11 paper I could
> investigate it deeper.
Hello Boaz,

First of all, I should express thanks for your comments on the  
questions.

Here is the link for ElS,
http://www.t11.org/index.html
If you search 'Extended Link Service', you may find details about it.

Basically, the FC-CT and ELS are FC specific frames and their usage for
management and control of Fibre Channel systems.
>
>
>> As I understand that the bidi is packet transporting infra-structure,
>> I think it could be good candidate for the FC specific FC-CT/ELS
>> packet delivery in between the application and the individual devices
>> given topology.
>>
>
> bidi, as in scsi-bidirectional commands, is any scsi command (in any
> command set) where a single CDB utilizes both an in-buffer and an
> out-buffer, for sending-while-receiving data to-from a target device.
> The write-from-host buffers and read-to-host buffers happens  
> concurrently
> with out predetermined serialization and can in fact happen all at  
> once.
Great, thanks for the key of the concept.
>
>
> So to answer your question: It is a must candidate for bidi, if the  
> t11
> standard states that a single CDB specifies both an out-buffer and an
> in-buffer, to complete the command.
FC-CT and ELS are FC specifics.
So, as far as I understood, the idea is to control and manage the  
given FC layout via those frames without having any subsystem  
interventions.
One of the goal of the implementation is to provide pipe line in  
between the application and the target devices under the given layout.
Is the bidi tightly coupled with the SCSI CDB, or it can transport any  
packet regardless its contents?

>
>
> An example of a bidi command is the XOR family of commands as defined
> by SCSI for the block command set.
>
>> As I have limited understanding about the bid, here are my questions,
>> 0. would the bidi be a right choice for the FC-CT/ELS packet  
>> delivery?
> Please point me to the normative documentation so I can check.
>
>> 1. where should I get any kind of documents/briefs about the bidi?
>
> In code and git I'm afraid. Look in git for the history of both
> drivers/scsi/libiscsi.c and drivers/scsi/scsi_debug.c and see how they
> are changed to receive bidirectional commands.
> And also include/scsi/scsi_cmnd.h and drivers/scsi/scsi_lib.c for
> these patches that introduce the bidi support, they have some  
> explanations
> and you can inspect their implementation.
Great, I will walk-through the files.
I've seen some of your emails which describing the idea of the bidi  
patches.
If you have any other, would be helpful, too.

>
>
>> 2. which part of code that I have to walk-through for further
>> understanding about the bidi mechanism?
>
> Best is to look in git for the relevant patches both at scsi-midlevel
> and iscsi.
>
>> 3. with the bidi, what's the application interface should look like?
>>
>
> if you have for example:
> int xxx_write(const void* out_buff, int len);
> and
> int xxx_read(void * in_buff, int_len);
> then you might have something like
> int xxx_xor(const void* out_buff, void * in_buff, int len);
> which is a bidi command that writes and reads results all at once.
Thanks.
One of the sample file that I've looked at was: expander_conf.c which  
shows how to handle SAS SMP packet.

>
>
>> I expect to have some changes/additions in the FC transport layer in
>> regards to the support and in general.
>>
>> Any comment/guidance would be greatly helpful.
>>
>
> scsi-bidirectional commands was crafted for scsi command sets that  
> specifically
> called for both in/out buffers participating in a single command. If  
> the commands
> in question are like that then this is the right tool to use.
>
>> Thank you,
>> Seokmann
>> --
>
> When you advance farther I can send you code examples of how an  
> initiator pushes
> block-requests that carry bidi payload that's the easy part. Getting  
> your driver
> to support and expect bidi commands is a bit harder. (Just a bit)
>
> Feel free to ask any questions you have.
Thanks again, I will get to you as I move forward.

Seokmann
>
>
> Cheers
> Boaz

