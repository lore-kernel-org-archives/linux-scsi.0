From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [RFC] Asynchronous scsi scanning
Date: Thu, 11 May 2006 13:15:40 -0500
Message-ID: <44637F4C.3070102@cs.wisc.edu>
References: <20060511143352.GI12272@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:52096 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1750701AbWEKSMU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 May 2006 14:12:20 -0400
In-Reply-To: <20060511143352.GI12272@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

Matthew Wilcox wrote:
> A customer has a machine with 162 scsi hosts, and just scanning the scsi
> busses takes over an hour.  Here's what I've come up with to reduce that.
> For drivers which call scsi_scan_host(), no changes are necessary.
> The fibrechannel and SAS drivers are going to take a bit more work,
> but I thought I'd send out the core first.  I'm not entirely happy about
> how the threads rendezvous; it'd be nice to not have to use a completion.
> 
> One user-visible change in behaviour is that after loading a driver, the
> insmod will return before discovery is finished.  Apparently Ubuntu's
> userspace already copes with this, but it's something to be aware of.
> The late_initcall takes care of this for built-in modules, but it'd be
> nice if there were an API to say "run this function before insmod exits".
> 


Instead of all the scanning from work queue and kthreads, what about
just running something from the host addition hotplug event. When a host
or target or rport or whatever we want is added, userspace gets a
hotplug event today, I thought. From that event could you just do

echo - - - > path-to-object/scan

This is basically what we do for iscsi. We can scan all hosts or
sessions in parrallel which makes startup pretty fast. The problem is of
course getting the distros to support it. I guess if they have to
support async scanning for all hosts (I think fedora and red hat does
not support this - maybe just for usb), then they could also userspace
scanning support at the same time.
