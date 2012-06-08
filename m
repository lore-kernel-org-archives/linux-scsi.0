From: Norman Diamond <n0diamond@yahoo.co.jp>
Subject: Re: How to detect if a libata ioctl SG_IO had an error?
Date: Fri, 8 Jun 2012 13:34:29 +0900 (JST)
Message-ID: <478845.99949.qm@web100003.mail.kks.yahoo.co.jp>
Reply-To: n0diamond@yahoo.co.jp
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from web100003.mail.kks.yahoo.co.jp ([114.111.98.177]:20280 "HELO
	web100003.mail.kks.yahoo.co.jp" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752623Ab2FHEeb convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 8 Jun 2012 00:34:31 -0400
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

I wrote:

>> My application wants to detect if an error occured, but in struct sg=
_io_hdr sg_io, sg_io.driver_status !=3D DRIVER_OK does not say if an er=
ror occured, and (sg_io.info & SG_INFO_OK_MASK) !=3D SG_INFO_OK does no=
t say if an error occured.
>>=20
>> In http://tldp.org/HOWTO/SCSI-Generic-HOWTO/x322.html:
>> "A copy of these defines can be found in sg_err.h (see the utilities=
 section):=20
>> SG_ERR_DRIVER_OK [0x00] Typically no suggestion"
>>=20
>> Where's sg_err.h?=A0 scsi.h defines DRIVER_OK but no one defines SG_=
ERR_DRIVER_OK.=A0 Anyway, the real problem is that other values besides=
 DRIVER_OK also mean driver ok.
>>=20
>> In http://tldp.org/HOWTO/SCSI-Generic-HOWTO/x364.html:
>> "SG_INFO_CHECK [0x1] something abnormal happened."
>>=20
>> Sense data is abnormal but not an error, so I don't know if an error=
 occured.

Doug Gilbert wrote:
> BTW the presence of sense data may indicate an error or it may be jus=
t informative.

Right, I got that from libata-scsi.c line 525.

>> In scsi.h:
>> 443 #define DRIVER_OK=A0 =A0 =A0=A0=A00x00=A0 =A0 /* Driver status=A0=
 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=A0=A0*/
>> 444=20
>> 445 /*
>> 446=A0 *=A0 These indicate the error that occurred, and what is avai=
lable.
>> 447=A0 */
>> 448=20
>> 449 #define DRIVER_BUSY=A0 =A0 =A0 =A0=A0=A00x01
>> 450 #define DRIVER_SOFT=A0 =A0 =A0 =A0=A0=A00x02
>> 451 #define DRIVER_MEDIA=A0 =A0 =A0 =A0 0x03
>> 452 #define DRIVER_ERROR=A0 =A0 =A0 =A0 0x04
>> 453=20
>> 454 #define DRIVER_INVALID=A0 =A0 =A0 0x05
>> 455 #define DRIVER_TIMEOUT=A0 =A0 =A0 0x06
>> 456 #define DRIVER_HARD=A0 =A0 =A0 =A0=A0=A00x07
>> 457 #define DRIVER_SENSE=A0 =A0 =A0 =A0 0x08
>>=20
>> Is DRIVER_SENSE a bitwise value that can be or'ed with other values?
>>=20
>> In libata-scsi.c
>> 523=A0 =A0 =A0 =A0=A0=A0if (driver_byte(cmd_result) =3D=3D DRIVER_SE=
NSE) {/* sense data available */
>> 524=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=A0=A0u8 *desc =3D sensebuf + 8;
>> 525=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=A0=A0cmd_result &=3D ~(0xFF<<24);=
 /* DRIVER_SENSE is not an error */
>>=20
>> Line 523 does not test driver_byte(cmd_result) & DRIVER_SENSE.=A0 It=
 looks like DRIVER_SENSE is a value all by itself, not bitwise.
>>=20
>> In sc.c:
>> 463=A0 =A0 =A0 =A0=A0=A0if ((CHECK_CONDITION & hp->masked_status) ||
>> 464=A0 =A0 =A0 =A0 =A0 =A0=A0=A0(DRIVER_SENSE & hp->driver_status))
>>=20
>> Line 464 does not test DRIVER_SENSE =3D=3D hp->driver_status.=A0 It =
looks like DRIVER_SENSE is bitwise, not a value all by itself.
>>=20
>> I sense inconsistency.

The inconsistency looks like a bug.

=46or the time being I will treat DRIVER_OK as requiring further invest=
igation because other components might or might not be OK, DRIVER_SENSE=
 (as a value not a bit) as requiring investigation of sense data, and a=
nything else as an error.

>> In sc.c:
>> 546=A0 =A0 =A0 =A0=A0=A0if (hp->masked_status || hp->host_status || =
hp->driver_status)
>> 547=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=A0=A0hp->info |=3D SG_INFO_CHECK;
>>=20
>> So even though DRIVER_SENSE is not an error, the SG_INFO_CHECK bit g=
ets set.=A0 (The info field is undoubtedly bitwise.)

So I pretty much have to ignore SG_INFO_CHECK because further details h=
ave to be investigated regardless.

>> How can I really test if an error occured?

Doug Gilbert gave some hints.  I'm still not sure of the answer, but I =
am sure that I found another libata bug, described later in this messag=
e.

>> A bit more here.
>>=20
>> In scsi.h:
>> 217 /*
>> 218=A0 *=A0 SCSI Architecture Model (SAM) Status codes. Taken from S=
AM-3 draft
>> 219=A0 *=A0 T10/1561-D Revision 4 Draft dated 7th November 2002.
>> 220=A0 */
>> 221 #define SAM_STAT_GOOD=A0 =A0 =A0 =A0 =A0 =A0 0x00
>> 222 #define SAM_STAT_CHECK_CONDITION 0x02
>> 223 #define SAM_STAT_CONDITION_MET=A0=A0=A00x04
>> 224 #define SAM_STAT_BUSY=A0 =A0 =A0 =A0 =A0 =A0 0x08
>> 225 #define SAM_STAT_INTERMEDIATE=A0 =A0 0x10
>> 226 #define SAM_STAT_INTERMEDIATE_CONDITION_MET 0x14
>> 227 #define SAM_STAT_RESERVATION_CONFLICT 0x18
>> 228 #define SAM_STAT_COMMAND_TERMINATED 0x22=A0 =A0 =A0 =A0 /* obsol=
ete in SAM-3 */
>> 229 #define SAM_STAT_TASK_SET_FULL=A0=A0=A00x28
>> 230 #define SAM_STAT_ACA_ACTIVE=A0 =A0 =A0 0x30
>> 231 #define SAM_STAT_TASK_ABORTED=A0 =A0 0x40
>>=20
>> Is SAM_STAT_CHECK_CONDITION a bitwise value?=A0 It looks like the an=
swer is mostly no.=A0 Some of them could be, but not consistently.=A0 D=
id the T10 committee say if these are bitwise?
>>=20
>> In scsi.h:
>> 256 /*
>> 257=A0 *=A0 Status codes. These are deprecated as they are shifted 1=
 bit right
>> 258=A0 *=A0 from those found in the SCSI standards. This causes conf=
usion for
>> 259=A0 *=A0 applications that are ported to several OSes. Prefer SAM=
 Status codes
>> 260=A0 *=A0 above.
>> 261=A0 */
>> 262=20
>> 263 #define GOOD=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=A0=A00x00
>> 264 #define CHECK_CONDITION=A0 =A0 =A0 0x01
>>=20
>> In sg.c:
>> 533=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=A0=A0if ((CHECK_CONDITION & hp->m=
asked_status) ||
>> 534=A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0 =A0=A0=A0(DRIVER_SENSE & hp->=
driver_status)) {
>>=20
>> Why doesn't sg use SAM Status codes?

Hmm, as far as I can tell today, sg DOES SOMETIMES use SAM Status codes=
 but SOMETIMES NOT.

>> Meanwhile, is CHECK_CONDITION a bitwise value?=A0 It looks like the =
answer is mostly no, for the same reason as SAM_STAT_CHECK_CONDITION.=A0=
 These bitwise tests look like bugs.

Still looks like a bug.  I think those values are not supposed to be bi=
twise.

Now for today's discovery.

When the SG_IO ioctl times out, libata sets the ABRT bit but not the ER=
R bit in the sense data.  I was checking the ERR bit which was 0, and t=
hen going off on a wild goose chase trying to find what level SCSI driv=
er reported the timeout error.  There was none.  It's all in the ABRT b=
it.  This looks like a bug in libata.

The ATA and SAT standards seem to make it pretty clear that if the ERR =
bit isn't set then the driver (or my application) should ignore the ABR=
T bit.  But when using libata I have to ignore the ERR bit and look at =
the ABRT bit.  This looks like a bug.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
