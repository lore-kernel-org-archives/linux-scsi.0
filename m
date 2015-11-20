From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: linux kernel security issuse scsi_report_lun_scan report
Date: Fri, 20 Nov 2015 10:26:54 -0800
Message-ID: <1448044014.2168.34.camel@HansenPartnership.com>
References: <8159e011-35a9-4952-a0ef-be4dfb13983f.chengmiao.cj@alibaba-inc.com>
	 <CA+55aFyn44rDnv3E9sSg_YGfeqhExvGz8yeAANU-BVghDHRFdA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:41926 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161765AbbKTS05 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Nov 2015 13:26:57 -0500
In-Reply-To: <CA+55aFyn44rDnv3E9sSg_YGfeqhExvGz8yeAANU-BVghDHRFdA@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>

On Fri, 2015-11-20 at 10:14 -0800, Linus Torvalds wrote:
> [ I don't know if the original reporter ended up actually sending this
> to the scsi list like Greg asked, so I'll forward it myself just in
> case ]

No, this is the first time we've seen this.

> There seems to be a very old use-after-free in the scsi code (git
> blame says the lines around this area are from 2005 and 2008) that
> kasan reports.
> 
> I've tried to clean up the formatting in the email a bit, but the
> executive summary seems to be that this:
> 
> drivers/scsi/scsi_scan.c, around line 1459:
> 
>         scsi_device_put(sdev);
>         if (scsi_device_created(sdev))
> 
> is just wrong, because the "scsi_device_put()" may be freeing the
> sdev, so then doing "scsi_device_created(sdev)" after it is bogus.

We can look at it, but the analysis shouldn't be correct.  This device
is the one we first used to issue the report lun scan.  Either it's an
existing device, or we created it specially for the purpose.  If it's an
existing one, that put just releases our reference, but the core still
has one  (there'd have to be a very unusual scan destroy race for the
core to be releasing a reference to an object it was in process of
scanning).  If we create it, then it releases our reference taken in
line 1331 but it's also not a final put because alloc has to be paired
with remove.  However, it should also be harmless to move the put to
after the if() clause ... can we ask the reporter to check if that's the
fix?

James


