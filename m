From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: linux kernel security issuse scsi_report_lun_scan report
Date: Fri, 20 Nov 2015 12:57:16 -0800
Message-ID: <1448053036.2168.46.camel@HansenPartnership.com>
References: <8159e011-35a9-4952-a0ef-be4dfb13983f.chengmiao.cj@alibaba-inc.com>
	 <CA+55aFyn44rDnv3E9sSg_YGfeqhExvGz8yeAANU-BVghDHRFdA@mail.gmail.com>
	 <1448044014.2168.34.camel@HansenPartnership.com>
	 <CA+55aFxuts9UQb3XAVzq8TWQbfgBvftn_iOvo5+qb10RT65mrg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:42610 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758806AbbKTU5S (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Fri, 20 Nov 2015 15:57:18 -0500
In-Reply-To: <CA+55aFxuts9UQb3XAVzq8TWQbfgBvftn_iOvo5+qb10RT65mrg@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-scsi <linux-scsi@vger.kernel.org>, Greg Kroah-Hartman <gregkh@linuxfoundation.org>

On Fri, 2015-11-20 at 12:54 -0800, Linus Torvalds wrote:
> On Fri, Nov 20, 2015 at 10:26 AM, James Bottomley
> <James.Bottomley@hansenpartnership.com> wrote:
> >
> > We can look at it, but the analysis shouldn't be correct.  This device
> > is the one we first used to issue the report lun scan.  Either it's an
> > existing device, or we created it specially for the purpose.  If it's an
> > existing one, that put just releases our reference, but the core still
> > has one  (there'd have to be a very unusual scan destroy race for the
> > core to be releasing a reference to an object it was in process of
> > scanning).
> 
> Side note: that whole "if it's an existing one" looks fundamentally racy.
> 
> What if two threads have that existing one, and both threads decide
> "there's no device there", so they'll both decide to do that
> __scsi_remove_device()?

It's done under the scan mutex, so there can only be one thread in that
code at once.

James


> In fact, one of the threads might have created the device, so it looks
> like it's sufficient that just one thread has that
> "scsi_device_lookup_by_target()" case..
> 
> I don't see any serialization around this.
> 
> Now, I do agree that it's odd that this happens during early kernel
> initcalls, but the scsi layer is one of the things that uses async
> stuff, so if that do_scan_async() ever ends up using the same target
> twice, that would explain it. Can that happen some way?
> 
>              Linus
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 



