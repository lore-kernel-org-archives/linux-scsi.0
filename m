From: "Satyam Sharma" <satyam.sharma@gmail.com>
Subject: Re: Asynchronous scsi scanning
Date: Fri, 18 May 2007 00:17:40 +0530
Message-ID: <a781481a0705171147s1ef5c205y8873d0bfa201f928@mail.gmail.com>
References: <a781481a0705141741u4c2f442dk76c68f757cadc38d@mail.gmail.com>
	 <20070515120228.GI10562@parisc-linux.org>
	 <4649E03A.1090004@simon.arlott.org.uk>
	 <20070515172905.GJ10562@parisc-linux.org>
	 <a781481a0705151627n18d3be55t6b77885fd7775ffd@mail.gmail.com>
	 <20070516025121.GK10562@parisc-linux.org>
	 <a781481a0705171013j7ddc48edxfb4bdba515a3f53c@mail.gmail.com>
	 <20070517172023.GL10562@parisc-linux.org>
	 <a781481a0705171041y3c3b7fe1m2aa6a8805807942c@mail.gmail.com>
	 <20070517182414.GA12170@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.227]:20584 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755752AbXEQSrm (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 17 May 2007 14:47:42 -0400
Received: by wr-out-0506.google.com with SMTP id 76so723535wra
        for <linux-scsi@vger.kernel.org>; Thu, 17 May 2007 11:47:41 -0700 (PDT)
In-Reply-To: <20070517182414.GA12170@infradead.org>
Content-Disposition: inline
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>, Benjamin LaHaise <bcrl@kvack.org>, Matthew Wilcox <matthew@wil.cx>, Simon Arlott <simon@fire.lp0.eu>, James Bottomley <james.bottomley@steeleye.com>, Dave Jones <davej@redhat.com>, Linux Kernel Mailing List <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, kernel-packagers@vger.kernel.org, "Robert P. J. Day" <rpjday@mindspring.com>

Hi Christoph,

On 5/17/07, Christoph Hellwig <hch@infradead.org> wrote:
> On Thu, May 17, 2007 at 11:11:10PM +0530, Satyam Sharma wrote:
> > Another command to /proc/scsi/scsi isn't a bad thought at all, considering
>
> Yes it is.  /proc/scsi/scsi is a horrible interface and deprecated since
> the start of the 2.6 series.

What I have in mind is actually this: We implement commands to
trigger the scsi_complete_async_scans() using *both* the
(legacy, agreed) /proc/scsi/scsi interface _and_ using a sysfs
attribute for this (either in /sys/module/scsi_mod/parameter/, using
a module_param_call as Roland suggested, or, create a new
/sys/module/scsi_mod/<whatever>/wait_..., whatever is appropriate).

/proc/scsi/scsi is now deprecated _because_ the sysfs alternative
became available, after all (we couldn't pull functionality /
interfaces previously exposed to userspace from under them
without giving equivalent alternatives anyway).

However, Ben does have a point that we shouldn't force those
using SCSI (and wishing to use the new async scanning
feature) to depend on and use sysfs too, so those like him could
use /proc/scsi/scsi. The idea is that with time sysfs gets its act
together and thus becomes standard enough on all Linux boxen
(much like /proc is today), and those like Ben could later switch
to that.
