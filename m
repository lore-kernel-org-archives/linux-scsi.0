From: George Kadianakis <desnacked@gmail.com>
Subject: Re: [PATCH 1/1] SCSI: lpfc, restore MSI-X/MSI support
Date: Thu, 14 Jan 2010 19:26:17 +0200
Message-ID: <87aawga98m.fsf@gmail.com>
References: <87r5pta66n.fsf@gmail.com> <4B4F4E55.4030206@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ew0-f209.google.com ([209.85.219.209]:45539 "EHLO
	mail-ew0-f209.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411Ab0ANR1P (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 14 Jan 2010 12:27:15 -0500
Received: by ewy1 with SMTP id 1so7038ewy.28
        for <linux-scsi@vger.kernel.org>; Thu, 14 Jan 2010 09:27:10 -0800 (PST)
In-Reply-To: <4B4F4E55.4030206@emulex.com> (James Smart's message of "Thu, 14
	Jan 2010 12:03:17 -0500")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <james.smart@emulex.com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

James Smart <james.smart@emulex.com> writes:

> The short response:
> Acked-by: James Smart  <james.smart@emulex.com>
>
>
> Background:
> Nothing Broke. This was intended.
>
> We had originally enabled MSI-X by default, but in qualification
> within the last 12 months, we encountered a major catch-22:
>
> There were at least 4 platforms, from 2 major OEMs, that :
> - Say they support MSI-X - platform routines work and act as if they do.
> - We enable it, generate a test interrupt to check they really do
> deliver it, and it works.
> - But shortly after attachment, the system hangs or loses interrupts,
> resulting in a bad system behavior.
>
> Given the distro's picking up the 2.6.32 kernel, we had to stick with
> a default of MSI-X off, with user-enabled MSI-X as these platforms
> couldn't get fixed.
>
> However, we're also now encountering platforms that require MSI-X and
> never INTx, so we must change. It's desired also for also for
> performance reasons.
>
> So - now (2.6.33) is the right time to re-enable MSI-X by default.
>
>
> -- james s
>

So I see! Thanks for the clarification.
It was just that your commit's description didn't mention the
interrupt method change at all (and I also couldn't find any
information on the internet), and I thought it was accidental.

Anyway, all in all, I think that the correct course of action here is
to have MSI-X as the default (for the reasons you described) and users
with defective systems can enable INTx manually.
