From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: Kernel Level Generic Target Mode control path
Date: Thu, 28 Aug 2008 13:00:59 -0500
Message-ID: <1219946459.3378.2.camel@localhost.localdomain>
References: <48ADC53B.6090501@vlnb.net>  <48ADFAB7.5010201@cs.wisc.edu>
	 <1219701570.13470.156.camel@haakon2.linux-iscsi.org>
	 <48B59556.7050108@vlnb.net>
	 <1219875219.13470.380.camel@haakon2.linux-iscsi.org>
	 <48B6E5C8.2000306@vlnb.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:44934 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754878AbYH1SBB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 28 Aug 2008 14:01:01 -0400
In-Reply-To: <48B6E5C8.2000306@vlnb.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Vladislav Bolkhovitin <vst@vlnb.net>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, Mike Christie <michaelc@cs.wisc.edu>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, scst-devel <scst-devel@lists.sourceforge.net>, linux-scsi@vger.kernel.org, Bart Van Assche <bart.vanassche@gmail.com>, Greg KH <greg@kroah.com>

On Thu, 2008-08-28 at 21:52 +0400, Vladislav Bolkhovitin wrote:
> >> So, I believe, a configuration interface should be rather /proc or /sys 
> >> interface based. I don't think we should care much about backward 
> >> compatibility with tgtadm, because the existing interface doesn't reach 
> >> the state of being widely used.
> > 
> > I would definately vote against proc here for the fancy stuff I
> > mentioned above.  I have experience enabled core-iscsi to use sysfs for
> > RO data, but nothing along the lines of what would be required for a
> > generic target mode RW control path.  Does anyone with sysfs experience
> > have any comments on thing..?
> 
> Sysfs as well as configfs have one big disadvantage. They limit each 
> file to only 4KB. This would force us for to create a subdirectory for 
> each device and for each connected initiator. I don't like seeing 
> thousands subdirectories. Additionally, such layout is a lot less 
> convenient for parsing for the high level configuration tool, which 
> needs to find out the difference between the current configuration and 
> content of the corresponding config file.

That's because each of those interfaces is designed around one value per
file.

> Currently, with procfs SCST can list in /proc/scst/sessions virtually 
> unlimited amount of connected initiators in a simple for parsing manner. 
> It was done using seq interface well and simply. Neither sysfs, nor 
> configfs support seq interface. This would introduce significant effort 
> in both kernel and user spaces.
> 
> Debugfs supports seq interface, but, because of the name, I doubt we can 
> use it ;)
> 
> Thus, looks like we'd better stay with /proc. After all, networking and 
> VM widely use /proc for internal configuration. Why SCSI target is worse?

I wouldn't do that.  /proc has been deprecated for several years for
large config interfaces (indeed it's trying to be scaled back only to
deal with processes).  Nothing with a huge /proc interface would pass a
review for 2.6 nowadays.

James


