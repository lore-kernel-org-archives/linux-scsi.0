From: Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: linux kernel security issuse scsi_report_lun_scan report
Date: Fri, 20 Nov 2015 12:54:13 -0800
Message-ID: <CA+55aFxuts9UQb3XAVzq8TWQbfgBvftn_iOvo5+qb10RT65mrg@mail.gmail.com>
References: <8159e011-35a9-4952-a0ef-be4dfb13983f.chengmiao.cj@alibaba-inc.com>
	<CA+55aFyn44rDnv3E9sSg_YGfeqhExvGz8yeAANU-BVghDHRFdA@mail.gmail.com>
	<1448044014.2168.34.camel@HansenPartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-ig0-f174.google.com ([209.85.213.174]:36099 "EHLO
	mail-ig0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761028AbbKTUyO (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 20 Nov 2015 15:54:14 -0500
Received: by igcph11 with SMTP id ph11so18897705igc.1
        for <linux-scsi@vger.kernel.org>; Fri, 20 Nov 2015 12:54:13 -0800 (PST)
In-Reply-To: <1448044014.2168.34.camel@HansenPartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>

On Fri, Nov 20, 2015 at 10:26 AM, James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
>
> We can look at it, but the analysis shouldn't be correct.  This device
> is the one we first used to issue the report lun scan.  Either it's an
> existing device, or we created it specially for the purpose.  If it's an
> existing one, that put just releases our reference, but the core still
> has one  (there'd have to be a very unusual scan destroy race for the
> core to be releasing a reference to an object it was in process of
> scanning).

Side note: that whole "if it's an existing one" looks fundamentally racy.

What if two threads have that existing one, and both threads decide
"there's no device there", so they'll both decide to do that
__scsi_remove_device()?

In fact, one of the threads might have created the device, so it looks
like it's sufficient that just one thread has that
"scsi_device_lookup_by_target()" case..

I don't see any serialization around this.

Now, I do agree that it's odd that this happens during early kernel
initcalls, but the scsi layer is one of the things that uses async
stuff, so if that do_scan_async() ever ends up using the same target
twice, that would explain it. Can that happen some way?

             Linus
