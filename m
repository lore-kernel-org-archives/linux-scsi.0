From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 13/16] libosd: SCSI/OSD Sense decoding support
Date: Thu, 29 Jan 2009 18:33:53 +0200
Message-ID: <4981DA71.9060306@panasas.com>
References: <497C7B33.4080105@panasas.com>	 <1232896516-19829-1-git-send-email-bharrosh@panasas.com>	 <1233160379.3236.52.camel@localhost.localdomain>	 <498182A8.4020003@panasas.com> <1233241258.3257.10.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([66.104.249.162]:14398 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752386AbZA2Qd7 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 29 Jan 2009 11:33:59 -0500
In-Reply-To: <1233241258.3257.10.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-scsi <linux-scsi@vger.kernel.org>, open-osd ml <osd-dev@open-osd.org>

James Bottomley wrote:
> On Thu, 2009-01-29 at 12:19 +0200, Boaz Harrosh wrote:
>> James Bottomley wrote:
>>> On Sun, 2009-01-25 at 17:15 +0200, Boaz Harrosh wrote:
>>>>  
>>>> +# CONFIG_SCSI_OSD_DPRINT_SENSE =
>>>> +#	0 - no print of errors
>>>> +#	1 - print errors
>>>> +#	2 - errors + warrnings
>>>> +ccflags-y += -DCONFIG_SCSI_OSD_DPRINT_SENSE=1
>>> Why are these all defines not Kconfig variables?
>>>
>> They are a "Kconfig variables". What you see above is a section of the 
>> Kbuild file that's for the out-of-tree compilation. [ifneq ($(OSD_INC),)]
>> For the out-of-tree compilation the Kbuild file defines everything as
>> configured in.
> 
> OK, let me rephrase the question "what's a file designed for out of tree
> compiles doing in-tree?".
> 

Sorry for not explaining better.
The Kbuild file is an in-tree file for sure. It is what builds the
drivers/scsi/osd directory. (The Makefile in that subdir is only for
out-of-tree and is not included in the patchset)

Now places in the source-code and in Kbuild itself depend on Kconfig
doing it's thing. But when the same-exact source is compiled out-of-tree,
possibly against a Kernel that does not have OSD at all, the Kconfigure
is emulated (above).

I have chosen to do that rather then keep two sets of files like other
projects do. Because I have one master git-tree. The in-tree has the
out-of-tree git as a remote. With an automatic script I rebase the out-of-tree
patches onto the relevant in-tree branch. This way I have only one master
repository.

All this is done by a small ifneq(,)/endif in Kbuild file. The rest is
totally transparent to source-code or otherwise.

Please let me keep it. If not I will need to patch Kbuild from out-of-tree
branches which is also in the in-tree branches. This will make it hard to
maintain in future versions without causing merge conflicts. I would like to
keep all individual files identical in the two views and keep the difference
in separate files.

Thanks in advance

>> <snip>
>> diff --git a/include/scsi/osd_sense.h b/include/scsi/osd_sense.h
>>>> new file mode 100644
>>>> index 0000000..ff9b33c
>>>> --- /dev/null
>>>> +++ b/include/scsi/osd_sense.h
>>>> @@ -0,0 +1,260 @@
>>>> +/*
>>>> + * osd_sense.h - OSD Related sense handling definitions.
>>>> + *
>>>> + * Copyright (C) 2008 Panasas Inc.  All rights reserved.
>>>> + *
>>>> + * Authors:
>>>> + *   Boaz Harrosh <bharrosh@panasas.com>
>>>> + *   Benny Halevy <bhalevy@panasas.com>
>>>> + *
>>>> + * This program is free software; you can redistribute it and/or modify
>>>> + * it under the terms of the GNU General Public License version 2
>>>> + *
>>>> + * This file contains types and constants that are defined by the protocol
>>>> + * Note: All names and symbols are taken from the OSD standard's text.
>>>> + */
>>>> +#ifndef __OSD_SENSE_H__
>>>> +#define __OSD_SENSE_H__
>>>>
>> <snip>
>>>> +	scsi_sense_Reserved_first		= 0x0A,
>>>> +	scsi_sense_Reserved_last		= 0x7F,
>>>> +	scsi_sense_Vendor_specific_first	= 0x80,
>>>> +	scsi_sense_Vendor_specific_last		= 0xFF,
>>>> +};
>>>> +
>>>> +struct scsi_sense_descriptor { /* for picking into desc type */
>>>> +	u8	descriptor_type; /* one of enum scsi_descriptor_types */
>>>> +	u8	additional_length; /* n - 1 */
>>>> +	u8	data[];
>>>> +} __packed;
>>> Why is it necessary to do a complete duplication of all the sense header
>>> handling and print out in include/scsi/scsi_eh.h and
>>> drivers/scsi/constants.c ... can't these two frameworks be integrated?
>>>
>> I have tried. 
>> Some of this stuff is new and exclusive to OSD so the file is needed.
>> The rest is buried in constants.c while I need them in an header file.
>> If it is accepted by you to take some of constants.c and put them in an
>> header then, sure I can do that. Refactor some of above stuff and constants.c
>> stuff into an scsi_sense.h file and use them at both places.
>> (I will send an RFC after things settle a bit)
> 
> That's what I'd prefer to see, yes.  The linux tradition is that if a
> particular piece of code, which was designed for use in X could be used
> in Y, we don't duplicate it for Y, we redesign it so it can be used in
> both X and Y ... that's how we keep the kernel clean and neat.   Of
> course, if you're really lucky, the X user already figured out a more
> generic framework and it's a simple matter to reuse it.  I'm afraid it's
> a bit more work in this case.
> 

Yes, it's more work. And I don't yet have a clear picture on how to do it
in a way that does not inject pointless code to the regular case where OSD
is not used. Let me think about it for a small while. I promise to get to it
ASAP.

>> Other then that, the source of the osd_req_decode_sense() is totally new to
>> osd. An osd target returns very detailed, variable length, sense information
>> that denotes exactly what field of the CDB and/or buffer-data failed it's checks
>> as well as details on other failures and conditions. Also later we will support
>> security signatures of sense data.
> 
> But this is all just an extension of the basic SAM defined sense format.
> 

Well yes and no - 
Other then in OSD, nowhere in scsi is there a variable length of sense information.
That is: in osd you can return an array of bad attributes or an array of bad objects.
Also there are OSD specific extensions that are defined in the osd T10 document only.
I will try to divide the common work from the OSD extensions and submit the common
part to generic layer but in a way that could be reused by both.

Please note that I'm not the first offender. There are other error handlers that
duplicate some of what is done here for their specific transports / command-sets.

> James
> 
> 

Thanks
Boaz
