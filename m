From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: dpt_i2o driver
Date: Tue, 2 Sep 2003 12:41:52 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <0998F43EAD645A47B3F6507196DD70EA256913@OTCEXC01>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic-mail.adaptec.com ([216.52.22.10]:44780 "EHLO
	magic.adaptec.com") by vger.kernel.org with ESMTP id S264022AbTIBQmI convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Sep 2003 12:42:08 -0400
List-Id: linux-scsi@vger.kernel.org
To: 'Christoph Hellwig' <hch@infradead.org>
Cc: Mark Haverkamp <markh@osdl.org>, linux-scsi <linux-scsi@vger.kernel.org>

'Christoph Hellwig' [mailto:hch@infradead.org] writes:
>> 	- use_new_eh_code was initialized thus because some kernels would
>> have
>> 	  the (smp) lock, but not the (up) interrupts disabled; by
>> initializing
>> 	  after the fact one got consistent io_request_lock behavior. Will
>> need
>> 	  to instrument and test the current crop of kernels I build for to
>> see
>> 	  if this issue is no longer there.
>-ENOCONTEXT.  Can you quote what this is the reply to?

Context of dropping manual initialization of use_new_eh_code and proc_d=
ir in
the detect code. The former was a result of a workaround for some erran=
t
kernel trees; the later was a `mistake' resulting from the structure me=
mber
not being present in all trees thinking that was the only reason for th=
e
use_new_eh_code's original inclusion. A hack with a penalty, will need =
to
dehack and make sure the problem is not present in modern kernels.

>> 	- I remember the author of this code going through hoops to get
>> 	  add_wait_queue to function in some of the kernels, she
>> 	  got abused by a race condition that would only go away once it
>> 	  was coded thus. I will need to revisit these bugs and make sure
>> 	  they are no longer present in the current crop of kernels.
>Sounds strange because that really is the opencoded variant of =FEhese=
=2E

Without some exhaustive research of all the past trees, I can only assu=
me
that some of the opencoded variants were flawed, or ifdef'd flawed. All=
 I
can
report accurately is the pain felt by that author . . . talk is cheap,
action on investigating current trees, and performing matrix testing to=
 see
if the issue duplicates is next.

>> 	- DPT_TARGET_BUSY is necessary to prevent the management
>> applications
>> 	  from modifying arrays that are in use. Without this, admittedly
>> . . .
>Well, this simply won't work anymore soon in mainline and thus 2.6-bas=
ed
>vendor trees.  What exactly are these apps checking for, please give
>some more context on what it is used for.

Hmmm, lets just delete this (mounted) array. I want to take this (mount=
ed)
drive to expand an array's capacity. This call is used to inform the us=
er
that the action that one is about to be asked to perform is being block=
ed
because it would cause damage to the operating system.

I had, for FreeBSD, UnixWare and Solaris had a user side check of the m=
ount
status of all the device nodes and slices associated with a storage ent=
ity.
This test would take 5 seconds to complete, worst case, before a check =
box
would respond in the GUI. The author of the Linux driver chose to add
DPT_TARGET_BUSY rather than go through all the user checks and cross ch=
ecks
and port it into the Linux world; and once done, the *instant* response=
 of
her solution put my user solution to shame (especially, if the machine =
was
under heavy load extending the user side checking).

In addition, her solution handled the case where a load test was runnin=
g on
the device node.

Open for suggestions, without a doubt! DPT_TARGET_BUSY redirecting to a=
 SCSI
subsystem busy check that meets with the communities satisfaction?

Sincerely -- Mark Salyzyn
-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
