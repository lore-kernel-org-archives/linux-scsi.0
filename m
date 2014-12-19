From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: [PATCH 0/2] target: Fixes for AllRegistrants reservation
 handling
Date: Thu, 18 Dec 2014 17:06:19 -0800
Message-ID: <1418951179.4830.6.camel@haakon3.risingtidesystems.com>
References: <20141218145401.GD2476@iliastsi-m.arr>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20141218145401.GD2476@iliastsi-m.arr>
Sender: target-devel-owner@vger.kernel.org
To: Ilias Tsitsimpis <iliastsi@arrikto.com>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, James Bottomley <James.Bottomley@HansenPartnership.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2014-12-18 at 16:54 +0200, Ilias Tsitsimpis wrote:
> On Tue, Dec 16, 2014 at 12:09AM, Nicholas A. Bellinger wrote:
> > From: Nicholas Bellinger <nab@linux-iscsi.org>
> > 
> > Hi all,
> > 
> > This series addresses two issues raised recently by Ilias wrt
> > AllRegistrants reservation handling in target code that does not
> > adhere to SPC-4 specification requirements.
> > 
> > This first is a informational change to PR-IN READ_FULL_STATUS,
> > that when an AllRegistrants reservation is in place, all active
> > registrations should be setting R_HOLDER=1 within their respective
> > descriptors.
> > 
> > The second is a functional change to PR-OUT REGISTER w/ SARK=0
> > operation, to avoid dropping the AllRegistrants reservation until
> > the last registered I_T nexus has been released.  It also ensures
> > that the correct reservation type + scope is retained when the
> > new reservation is set within __core_scsi3_complete_pro_release()
> > for this AllRegistrants special case.
> > 
> > Also, thanks to James for the extra SPC-4 clarifications.
> > 
> > Please review.
> 
> Hi Nicholas,
> 
> Thanks for the quick fix. These patches address the two issues that I
> raised in my previous email but they don't seem to fix all the problems
> with AllRegistrants reservation handling in target code. Please see my
> example below.
> 

<SNIP>

> Now let's try to get a persistent reservation with the same type from
> node2. SPC4r17 (par. 5.7.9 Reserving) states that:
> 
>     If the device server receives a PERSISTENT RESERVE OUT command with
>     RESERVE service action where the TYPE field and the SCOPE field
>     contain the same values as the existing type and scope from a
>     persistent reservation holder, it shall not make any change to the
>     existing persistent reservation and shall complete the command with
>     GOOD status.
> 
> Node2 *is* a persistent reservation holder based on the wording of
> SPC4r17 (par. 5.7.10 Persistent reservation holder).
> But instead:
> 
>     root@node2:~# sg_persist --out --reserve -T 8 --param-rk 0x2 /dev/sdc
>       LIO-ORG   FILEIO            4.0
>       Peripheral device type: disk
>     persistent reserve out: scsi status: Reservation Conflict
>     PR out: command failed
> 
> and on the target machine I get:
> 
>     [95713.681066] SPC-3 PR: Attempted RESERVE from [iSCSI]:
>     iqn.1993-08.org.debian:01:node2 while reservation already held by
>     [iSCSI]: iqn.1993-08.org.debian:01:node1, returning
>     RESERVATION_CONFLICT
> 
> If I try the same from node1, the target completes the command with GOOD
> status.
> 
> 
> It is clear that the target code still considers node1 as the (only)
> reservation holder and only *reports* node2 as being a reservation
> holder.

That is a very small change.  Sending out a patch for this now.

> 
> I believe we should fix the above errors by changing the
> 'pr_res_holder' inside the 't10_reservation' struct to be a list of
> holders rather than trying to handle this implicitly. Having a single
> holder in the code seems prone to more errors similar to this one.
> 

Not exactly, changing all existing code for ALLREG related special cases
really isn't worth the extra pain here.  I'd much rather identify any
remaining ALLREG specific issues, and address them individually.

Thanks Ilias!

--nab
