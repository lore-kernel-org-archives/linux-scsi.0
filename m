From: Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH 3/6] libata: resume in the background
Date: Fri, 10 Jan 2014 19:11:20 -0800
Message-ID: <CAA9_cmd9G-Q-L_0DgoXrujABuqNifWbPsFD0YKW+Z-C6OOzGsw@mail.gmail.com>
References: <cover.1384030893.git.psusi@ubuntu.com>
	<1387236657-4852-1-git-send-email-psusi@ubuntu.com>
	<1387236657-4852-4-git-send-email-psusi@ubuntu.com>
	<CAA9_cmfzgNkep_ZBKwyvW3iUXnKyNjpbB1uGtDLonbD1wCM10g@mail.gmail.com>
	<52D0ABA3.9030502@ubuntu.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-qa0-f42.google.com ([209.85.216.42]:58425 "EHLO
	mail-qa0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752944AbaAKDLV (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 10 Jan 2014 22:11:21 -0500
In-Reply-To: <52D0ABA3.9030502@ubuntu.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Phillip Susi <psusi@ubuntu.com>
Cc: todd.e.brandt@linux.intel.com, Tejun Heo <tj@kernel.org>, "JBottomley@parallels.com" <JBottomley@parallels.com>, IDE/ATA development list <linux-ide@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

On Fri, Jan 10, 2014 at 6:25 PM, Phillip Susi <psusi@ubuntu.com> wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA512
>
> On 01/10/2014 05:26 PM, Dan Williams wrote:
>> I was going to comment that this leaves us open to a race to
>> submit new i/o before recovery starts, but scsi_schedule_eh already
>> blocks new i/o, so I think we're good.  I think it deserves a
>> comment here about why it's safe to not care.
>
> I don't follow, could you explain?

The question I have when reading "__ata_port_resume_common(ap, mesg,
&dontcare);" is what makes it safe for the port to not actually be
resumed upon return.  The answer I believe is that the host is
guaranteed to be in the SHOST_RECOVERY state upon return and no new
i/o submissions will occur until the error handler has a chance to
run.

>>> static int ata_port_resume(struct device *dev) { int rc;
>>>
>>> +       if (pm_runtime_suspended(dev)) +               return 0;
>>
>> Why?  If we dpm_resume() a port that was rpm_suspend()ed the state
>> needs to be reset to active.  I think this check also forces the
>> port to resume twice, once for system resume and again for the
>> eventual runtime_resume.
>
> It stops the first resume by returning early, so only the second one
> happens.

Got it, but it looks odd.

>
>> ...so, the pm_runtime_suspended() check should go and something
>> like this folded in:
>>
>> diff --git a/drivers/ata/libata-eh.c b/drivers/ata/libata-eh.c
>> index 92d7797223be..a6cc107c9434 100644 ---
>> a/drivers/ata/libata-eh.c +++ b/drivers/ata/libata-eh.c @@ -4143,5
>> +4143,11 @@ static void ata_eh_handle_port_resume(struct ata_port
>> *ap) ap->pm_result = NULL; } spin_unlock_irqrestore(ap->lock,
>> flags); + +       if (rc == 0) { +
>> pm_runtime_disable(dev); +
>> pm_runtime_set_active(dev); +
>> pm_runtime_enable(dev); +       } } #endif /* CONFIG_PM */
>
> Ahh, and that will stop the second resume, rather than the previous
> change to stop the first?
>
> Don't we want to stop the first rather than the second?  Otherwise if
> the port is runtime suspended at system suspend time ( maybe no drive
> connected to it? ) then there is no sense in resuming it at system
> resume time.

Hmm, if the drive disconnected during suspend I think we want to find
that out sooner rather than later.  The changelog should really read
"Don't block the resume path waiting for the disk re-establish its
link".

Given it's async do we gain that much by deferring a one time check of
the ports at resume? At the very least I think tying rpm_resume to
dpm_resume like that is an additional change to defer to a separate
patch.
