From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH v8 09/13] libsas: enforce eh strategy handlers only in eh context
Date: Tue, 6 Mar 2012 11:17:05 -0800
Message-ID: <CAA9_cmdM=mHBzXYNYvHPS4KCzvZrymjAemS+RgstyiKONeaYEg@mail.gmail.com>
References: <20120210084411.25701.94502.stgit@dwillia2-linux.jf.intel.com>
	<20120210084525.25701.51128.stgit@dwillia2-linux.jf.intel.com>
	<1330553151.8846.26.camel@dabdike>
	<CABE8wwuM1Hd9jTh+i63cZ=Fsf=c5Uwa6w0Rk+REsraxwEdZdYg@mail.gmail.com>
	<1330612151.2888.10.camel@dabdike.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:63130 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932085Ab2CFTRG convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 6 Mar 2012 14:17:06 -0500
In-Reply-To: <1330612151.2888.10.camel@dabdike.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org

On Thu, Mar 1, 2012 at 6:29 AM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
>> Hmm, what about something like:
>>
>> =A0 if (current !=3D host->ehandler) {
>> =A0 =A0 schedule_reset_to_run_in_eh_context():
>> =A0 =A0 wait_for_eh();
>> =A0 } else
>> =A0 =A0 do_reset();
>
> I think that would work for me ... as long as the wait doesn't cause
> entangled deadlocks (I can't think of any at the moment, but I'll thi=
nk
> a bit more deeply about it).

So there is a deadlock due to:

commit d7a1bb0a04ca835bffc0a91e64ab827dfba7d8f5
Author: James Smart <James.Smart@Emulex.Com>
Date:   Wed Mar 8 14:50:12 2006 -0500

    [SCSI] Block I/O while SG reset operation in progress - the midlaye=
r patch

    The scsi midlayer portion of the patch

    Signed-off-by: James Smart <James.Smart@emulex.com>
    Signed-off-by: James Bottomley <James.Bottomley@SteelEye.com>

=2E..this adds shost->tmf_in_progress to scsi_host_in_recovery(), so I
can't "wait for eh" because the exit condition for that wait is
"!scsi_host_in_recovery()".  But since sg_reset is opened O_NONBLOCK
by default and that is likely the only non-eh reason for calling the
eh_{bus|device}_reset_handler routines I'll just make this routine
asynchronously queue a reset and return.
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
