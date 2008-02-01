From: Luben Tuikov <ltuikov@yahoo.com>
Subject: Re: [PATCH] [RFC] sd: make error handling more robust
Date: Thu, 31 Jan 2008 17:24:54 -0800 (PST)
Message-ID: <387599.14710.qm@web31814.mail.mud.yahoo.com>
Reply-To: ltuikov@yahoo.com
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="0-60358531-1201829094=:14710"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web31814.mail.mud.yahoo.com ([68.142.206.167]:34522 "HELO
	web31814.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753696AbYBABbf (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 31 Jan 2008 20:31:35 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>, linux-scsi@vger.kernel.org, Tony Battersby <tonyb@cybernetics.com>

--0-60358531-1201829094=:14710
Content-Type: text/plain; charset=us-ascii

--- On Thu, 1/31/08, Tony Battersby <tonyb@cybernetics.com> wrote:

> From: Tony Battersby <tonyb@cybernetics.com>
> Subject: [PATCH] [RFC] sd: make error handling more robust
> To: "James Bottomley" <James.Bottomley@HansenPartnership.com>, "Luben Tuikov" <ltuikov@yahoo.com>, linux-scsi@vger.kernel.org
> Date: Thursday, January 31, 2008, 1:31 PM
> I have a RAID that returns a medium error on a read command.
>  The
> "information bytes valid" bit is set in the sense
> data, but the
> information bytes are zero:
> 
> CDB: 28 00 02 B0 62 00 00 00 02 00
> Status:	02 (CHECK CONDITION)
> Sense data:
> F0 00 03 00 | 00 00 00 0A | 00 00 00 00 | 00 00 00 00
> 00 00

This indicates either a problem with the target
or the LLDD. VALID should be 0 if the bad LBA is
invalid.  Now since VALID is 1, bad LBA is considered
valid, with value of 0.

Bad LBA is always greater than or equal to start LBA,
i.e.:
    Bad LBA >= Start LBA.
The opposite is an impossibility since reading off
the end of the "platter" doesn't wrap around through
LBA 0 (which would be crazy).

By having VALID = 1 and Bad LBA = 0, and I'm assuming
Start LBA > 0 (from the situation you describe),
then good bytes is non-sensical.  This is NOT due
to the way sd_done() behaves, but due to the invalid/
broken sense data returned/emulated by the LU/LLDD.

> For HARDWARE_ERROR/MEDIUM_ERROR, sd_done assumes that the
> sense
> information bytes contain the sector in error without
> sanity-checking
> the value, so it ends up returning a completely bogus
> good_bytes value
> greater than xfer_size.

This is due to the fact that the LU/LLDD returned
sense data with VALID = 1, and so Bad LBA is assumed
correct.  This is as per spec. At this moment given
the situation you describe it seems that the LU/LLDD
is behaving out of spec.

As to sanity checking, given the inequality above,
and your peculiar target/LLDD returning broken
sense data, a sanity check would be the following:

   if (bad_lba < start_lba)
         goto out;

Added immediately before the computation of
good_bytes.

> This in turn causes the medium
> error to be
> ignored and corrupt data to be returned to the user
> application.  This
> problem was introduced by the patch "[SCSI]
> sd/scsi_lib simplify
> sd_rw_intr and scsi_io_completion" in 2.6.18-rc1; with
> kernels 2.6.17
> and before, the application correctly gets an I/O error
> instead.  This
> patch fixes this particular problem by checking that
> bad_lba falls
> within a sensible range before using it.
> 
> For a read command that returns
> HARDWARE_ERROR/MEDIUM_ERROR, I also
> added the ability to calculate the amount of good data
> returned using
> the data transfer residual if set by the LLDD.  If the both
> the sense
> information bytes and the data transfer residual are valid,
> then they
> are used to sanity-check each other.
> 
> The following code in sd_done doesn't seem right to me:
> 
>        if (driver_byte(result) != DRIVER_SENSE &&
>            (!sense_valid || sense_deferred))
>                 goto out;
> 
> It would make more sense to use || rather than &&
> for this test.

That's very easy to verify. Simply negate the
test and see if what you get makes sense. Case
in point:

Negate original:
    if (driver_byte(result) == DRIVER_SENSE ||
        (sense_valid && sense_defered))
            Inspect sense.

Negate your proposed change "&&" -> "||":
    if (driver_byte(result) == DRIVER_SENSE &&
         (sense_valid || sense_deferred))
                Inspect sense.

The reason to use the former, rather the latter,
is that LLDDs don't always set the driver_byte
in the result, and may only set the status byte.
E.g. to indicate CHECK CONDITION and then using
scsi_command_normalize_sense() to find out if
sense data is present.

>  Even
> better, this patch moves the check up higher so that the
> sense buffer
> isn't even accessed unless driver_byte(result) &
> DRIVER_SENSE.
> 
> Finally, for the case of RECOVERED_ERROR/NO_SENSE, this
> patch adds a
> check of the data transfer residual before assuming that
> the command
> completed successfully.

You cannot do this for NO SENSE SK.  You can do
that for RECOVERED ERROR SK. The way to do this
is to move "case RECOVERED_ERROR:" just above
"case HARDWARE_ERROR:".

> I would like comments on the following:
> 
> sd_done doesn't check the data transfer residual for
> commands that
> complete successfully.  In the unlikely case that the drive
> returns good
> status without transferring all the data (due to a SCSI bus
> problem or
> disk firmware bug), the error won't be detected.  I
> figured that it was
> more likely for a LLDD to set resid incorrectly than for
> this unlikely
> problem to happen, so I didn't add a check for it. 
> Agreed?
> 
> Is the new is_sd_cmnd_read_or_write() function necessary? 
> The original
> code appears to use blk_fs_request(SCpnt->request) to
> determine if a
> command is read or write.  Should I drop
> is_sd_cmnd_read_or_write() and
> use blk_fs_request() instead, or it it OK like this?
> 
> Does anyone object to the new data transfer residual checks
> for
> non-read/write commands that return
> RECOVERED_ERROR/NO_SENSE?  Should I
> just drop this part of the patch for simplicity?

It seems to me, your patch is really debugging
a misbehaved device server at the RAID device
(or misbehaved LLDD).

Try the attached patch and see what you get.

   Luben

--0-60358531-1201829094=:14710
Content-Type: text/plain; name=UNKNOWN_PARAMETER_VALUE
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="=?utf-8?q?sd.patch.txt?="

ZGlmZiAtLWdpdCBhL2RyaXZlcnMvc2NzaS9zZC5jIGIvZHJpdmVycy9zY3Np
L3NkLmMKaW5kZXggYTY5YjE1NS4uMzgzYTNhOCAxMDA2NDQKLS0tIGEvZHJp
dmVycy9zY3NpL3NkLmMKKysrIGIvZHJpdmVycy9zY3NpL3NkLmMKQEAgLTkz
NCw2ICs5MzQsMTAgQEAgc3RhdGljIGludCBzZF9kb25lKHN0cnVjdCBzY3Np
X2NtbmQgKlNDcG50KQogCQlnb3RvIG91dDsKIAogCXN3aXRjaCAoc3NoZHIu
c2Vuc2Vfa2V5KSB7CisJY2FzZSBSRUNPVkVSRURfRVJST1I6CisJCXNjc2lf
cHJpbnRfc2Vuc2UoInNkIiwgU0NwbnQpOworCQlTQ3BudC0+cmVzdWx0ID0g
MDsKKwkJLyogZmFsbHRocm91Z2ggKi8KIAljYXNlIEhBUkRXQVJFX0VSUk9S
OgogCWNhc2UgTUVESVVNX0VSUk9SOgogCQlpZiAoIWJsa19mc19yZXF1ZXN0
KFNDcG50LT5yZXF1ZXN0KSkKQEAgLTk2OCwxNCArOTcyLDE0IEBAIHN0YXRp
YyBpbnQgc2RfZG9uZShzdHJ1Y3Qgc2NzaV9jbW5kICpTQ3BudCkKIAkJLyog
VGhpcyBjb21wdXRhdGlvbiBzaG91bGQgYWx3YXlzIGJlIGRvbmUgaW4gdGVy
bXMgb2YKIAkJICogdGhlIHJlc29sdXRpb24gb2YgdGhlIGRldmljZSdzIG1l
ZGl1bS4KIAkJICovCisJCWlmIChiYWRfbGJhIDwgc3RhcnRfbGJhKQorCQkJ
Z290byBvdXQ7CiAJCWdvb2RfYnl0ZXMgPSAoYmFkX2xiYSAtIHN0YXJ0X2xi
YSkqU0NwbnQtPmRldmljZS0+c2VjdG9yX3NpemU7CiAJCWJyZWFrOwotCWNh
c2UgUkVDT1ZFUkVEX0VSUk9SOgogCWNhc2UgTk9fU0VOU0U6CiAJCS8qIElu
Zm9ybSB0aGUgdXNlciwgYnV0IG1ha2Ugc3VyZSB0aGF0IGl0J3Mgbm90IHRy
ZWF0ZWQKIAkJICogYXMgYSBoYXJkIGVycm9yLgogCQkgKi8KLQkJc2NzaV9w
cmludF9zZW5zZSgic2QiLCBTQ3BudCk7CiAJCVNDcG50LT5yZXN1bHQgPSAw
OwogCQltZW1zZXQoU0NwbnQtPnNlbnNlX2J1ZmZlciwgMCwgU0NTSV9TRU5T
RV9CVUZGRVJTSVpFKTsKIAkJZ29vZF9ieXRlcyA9IHhmZXJfc2l6ZTsK

--0-60358531-1201829094=:14710--
