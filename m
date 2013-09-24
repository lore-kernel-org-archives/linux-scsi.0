From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: SCSI's heuristics for enabling WRITE SAME still need work [was:
 dm mpath: disable WRITE SAME if it fails]
Date: Tue, 24 Sep 2013 06:25:39 -0700
Message-ID: <1380029139.2171.2.camel@dabdike.int.hansenpartnership.com>
References: <20130919161043.GA27081@redhat.com>
	 <20130920212142.GA17898@redhat.com> <yq1eh8jf8wq.fsf@sermon.lab.mkp.net>
	 <52415D50.508@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bedivere.hansenpartnership.com ([66.63.167.143]:43324 "EHLO
	bedivere.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750830Ab3IXNZm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 24 Sep 2013 09:25:42 -0400
In-Reply-To: <52415D50.508@redhat.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Paolo Bonzini <pbonzini@redhat.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, dm-devel@redhat.com, linux-scsi@vger.kernel.org

On Tue, 2013-09-24 at 11:37 +0200, Paolo Bonzini wrote:
> Il 21/09/2013 00:03, Martin K. Petersen ha scritto:
> > 
> > The major headache here of course is that WRITE SAME is inherently
> > destructive. We can't just fire off one during discovery and see if it
> > works. For WRITE you can issue a command with a transfer length of 0 to
> > see if things work. But unfortunately for WRITE SAME a transfer length
> > of zero means "wipe the entire device". Yikes!
> 
> What about WRITE SAME with an out-of-range lba?  Or lba equal to the
> size of the disk and #blocks equal to zero.

That's inviting undefined behaviour in a data destructive command ...
not something we really want to do.

James


