From: Tony Battersby <tonyb@cybernetics.com>
Subject: Re: [PATCH] [RFC] sd: make error handling more robust
Date: Fri, 01 Feb 2008 10:46:46 -0500
Message-ID: <47A33EE6.5080100@cybernetics.com>
References: <387599.14710.qm@web31814.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from host64.cybernetics.com ([70.169.137.4]:4065 "EHLO
	mail.cybernetics.com" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1754425AbYBAPql (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 1 Feb 2008 10:46:41 -0500
In-Reply-To: <387599.14710.qm@web31814.mail.mud.yahoo.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: ltuikov@yahoo.com
Cc: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org

Luben Tuikov wrote:
> This is due to the fact that the LU/LLDD returned
> sense data with VALID = 1, and so Bad LBA is assumed
> correct.  This is as per spec. At this moment given
> the situation you describe it seems that the LU/LLDD
> is behaving out of spec.
>
>   
I agree that my RAID (an external SCSI RAID connected via LSI Ultra320
HBA) is out-of-spec.  It should set VALID = 0 if the sense information
bytes are invalid.  I also agree that my patch is geared toward making
the kernel more robust when faced with out-of-spec devices.

> As to sanity checking, given the inequality above,
> and your peculiar target/LLDD returning broken
> sense data, a sanity check would be the following:
>
>    if (bad_lba < start_lba)
>          goto out;
>
> Added immediately before the computation of
> good_bytes.
>
>   
I agree that the simple check that you suggest would handle the
particular case of my out-of-spec RAID.  However, since we are
sanity-checking bad_lba, why not also add a check for the upper bound
too, in case there are other disks that are out-of-spec in a different
way?  I want to guarantee that sd_done() always returns a valid
good_bytes value regardless of what the sense data contains.

>> The following code in sd_done doesn't seem right to me:
>>
>>        if (driver_byte(result) != DRIVER_SENSE &&
>>            (!sense_valid || sense_deferred))
>>                 goto out;
>>
>> It would make more sense to use || rather than &&
>> for this test.
>>     
>
> That's very easy to verify. Simply negate the
> test and see if what you get makes sense. Case
> in point:
>
> Negate original:
>     if (driver_byte(result) == DRIVER_SENSE ||
>         (sense_valid && !sense_defered))
>             Inspect sense.
>
> Negate your proposed change "&&" -> "||":
>     if (driver_byte(result) == DRIVER_SENSE &&
>          (sense_valid && !sense_deferred))
>                 Inspect sense.
>
> The reason to use the former, rather the latter,
> is that LLDDs don't always set the driver_byte
> in the result, and may only set the status byte.
> E.g. to indicate CHECK CONDITION and then using
> scsi_command_normalize_sense() to find out if
> sense data is present.
>
>   
(Note: I edited the logic tests in the quote above.)

Here is the problem I see with the original: suppose the driver did
retrieve the sense data and set driver_byte(result) to DRIVER_SENSE, but
the sense data is invalid (corrupted on the wire, garbled by PCI,
etc.).  Then scsi_command_normalize_sense() will return sense_valid =
0.  In that case, the original code will check the invalid sense data
instead of bailing out (driver_byte(result) == DRIVER_SENSE, sense_valid
== 0, sense_deferred == 0).  Since scsi_command_normalize_sense()
memsets the scsi_sense_hdr to 0, this error will be treated like
SENSE_NO_SENSE, and sd_done will return good_bytes = xfer_size.

If LLDDs don't always set the driver byte, and we can't trust that
"driver_byte(result) & DRIVER_SENSE" is set if sense data was retrieved,
then I think the correct thing to do is to drop the check for it
entirely.  So we would have:

	if (result) {
		sense_valid = scsi_command_normalize_sense(SCpnt, &sshdr);
		if (sense_valid)
			sense_deferred = scsi_sense_is_deferred(&sshdr);
	}
	...
	if (!sense_valid || sense_deferred)
		goto out;



>> Finally, for the case of RECOVERED_ERROR/NO_SENSE, this
>> patch adds a
>> check of the data transfer residual before assuming that
>> the command
>> completed successfully.
>>     
>
> You cannot do this for NO SENSE SK.  You can do
> that for RECOVERED ERROR SK. The way to do this
> is to move "case RECOVERED_ERROR:" just above
> "case HARDWARE_ERROR:".
>
>   
I think you may have misunderstood what I wrote.  I am checking the
"data transfer residual", which is set by the LLDD to indicate how much
data was actually transferred over the wire to or from the device.  It
has nothing to do with sense data.  The data transfer residual (if
supported by the LLDD) should always be valid for any sense key, and
even also for commands that complete successfully.  For example, on a
command that is supposed to write 128 KB, if the LLDD reports that it
only transferred 64 KB to the drive, and the drive returns CHECK
CONDITION, RECOVERED ERROR with VALID = 0, then we know that the drive
could not have written more than 64 KB, since the LLDD never sent it all
the data.

The only reason not to use the data transfer residual is if you are
worried that there are LLDDs that don't calculate it correctly.  I can
vouch for a few LLDDs (aic7xxx, sym53c8xx, mptspi, mptfc, qla2xxx, and
iscsi_tcp).  I intentionally designed my patch to use the data transfer
residual conservatively in case a LLDD got it wrong, so I am not too
worried about it.

Also, I disagree about treating recovered error like hardware/medium
error.  Recovered error is supposed to mean "the last command completed
successfully, with some recovery action performed by the device
server".  The other errors mean that the command didn't complete
successfully.  If VALID=1, then the sense information bytes indicate
"the unsigned logical block address associated with the sense key".  So
for hardware/medium error, the sense info might indicate the bad LBA,
but for recovered error, the sense info might indicate the recovered
LBA.  So I think that it would be a mistake to treat them the same.

>    Luben
>   

Thanks for your comments.

Tony Battersby
Cybernetics

