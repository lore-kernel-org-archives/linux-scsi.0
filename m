From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [RFC] scsi_normalize_sense()
Date: Wed, 25 Aug 2004 11:22:43 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <412BE9E3.7050000@torque.net>
References: <41258F6A.6030606@torque.net> <Pine.LNX.4.58.0408242246270.5461@kai.makisara.local>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from borg.st.net.au ([65.23.158.22]:43923 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S269091AbUHYBXb (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Aug 2004 21:23:31 -0400
In-Reply-To: <Pine.LNX.4.58.0408242246270.5461@kai.makisara.local>
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: linux-scsi@vger.kernel.org

Kai Makisara wrote:
> On Fri, 20 Aug 2004, Douglas Gilbert wrote:
> 
> 
>>Looking around the linux SCSI subsystem the handling
>>of data in the sense buffer is haphazard. Most places
>>ignore "deferred" errors (e.g. medium error reported
>>later when write caching is on) and will break horribly
>>if they every see the newer "descriptor" format.
>>
> 
> ...
> 
>>Here is some code which I am proposing to put into
>>scsi_lib.c to facilitate cleaner handling. I have been
>>testing it out in sg3_utils-1.08 (beta) for the last
>>week.  Comments??
>>
> 
> Looks good, especially after some thinking :-) (The extra fields byte? and 
> additional_length looked useless until I thought a little further into the 
> future.)

The proposed structure is the first 8 bytes of the "descriptor"
format sense data**. The addition is to squeeze in the
response codes 0x70 and 0x71 which indicate that the given
sense buffer is in "fixed" format.

Deferred errors can be detected like this:
     if (sdesc.response_code & 1)
         process_deferred_error(...);

and "descriptor" format can be detected two ways:
     if (sdesc.response_code >= 0x72)
         ucp = scsi_sense_descriptor(,,4);
or
     if (sdesc.additional_length > 0)
         ucp = scsi_sense_descriptor(,,4);

The idea is to generalize access to sense_key,
asc and ascq (and stop using error prone array
indexing) in the presence of both fixed and
descriptor format. This covers the vast majority of
sense data processing in the scsi subsystem at
the moment. As the descriptor format becomes
more common, folks should recognise the proposed
structure.

That said SSC's FILEMARK, EOM and ILI bits are
found in the "stream commands" descriptor.

> In addition to using this basic data, the drivers have to parse the 
> descriptors.

There is such a parser in sg3_utils-1.08 (beta) on the
sg website. See sg_print_sense_descriptors() in sg_err.c
It outputs to stdout so it isn't exactly what is needed.

  Parsing the descriptors is device-specific but a library
> function to find a descriptor of certain type might be useful. The 
> prototype could be something like this:
> 
> /* Returns a pointer to the descriptor of type desc_type in descriptor 
>    format sense data or NULL if the descriptor is not found. */
> unsigned char *scsi_sense_descriptor(const unsigned char *sensep,
>                                      int sb_len, int desc_type)

This looks good for finding a specific 'desc_type'.

This approach also hints at the other approach to this
problem, namely multiple accessor functions to pick up
current/deferred, sense_key, asc and ascq.


BTW I think that the SCSI subsystem gets 32 bytes
of sense data currently. That should be ok until OSDs
arrive. They have big everythings (e.g. variable length
commands and sense descriptors).


** I resisted the temptation to memcpy the "descriptor" format
    header into the proposed structure just in case an 8 byte
    array didn't align with a structure with 8 unsigned chars in
    it.

P.S. Fixed format sense descriptors can still be used with
block devices that need 16 bytes READs and WRITEs. However
if there is a MEDIUM ERROR and the broken LBA cannot fit
in 32 bits then 0 is placed in the information field (i.e.
you don't get told the broken LBA).

Doug Gilbert

