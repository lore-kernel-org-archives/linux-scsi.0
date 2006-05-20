From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [RFC] printks in print_inquiry
Date: Sat, 20 May 2006 08:19:58 -0600
Message-ID: <20060520141958.GE2826@parisc-linux.org>
References: <20060511150015.GJ12272@parisc-linux.org> <20060512170854.GA11215@us.ibm.com> <20060513050059.GR12272@parisc-linux.org> <20060518183652.GM1604@parisc-linux.org> <20060518200957.GA29200@us.ibm.com> <20060519190848.GA2826@parisc-linux.org> <446E1FDE.1080404@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:24783 "EHLO
	palinux.external.hp.com") by vger.kernel.org with ESMTP
	id S964858AbWETOUC (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 20 May 2006 10:20:02 -0400
Content-Disposition: inline
In-Reply-To: <446E1FDE.1080404@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Smart <James.Smart@Emulex.Com>
Cc: Patrick Mansfield <patmans@us.ibm.com>, linux-scsi@vger.kernel.org

On Fri, May 19, 2006 at 03:43:26PM -0400, James Smart wrote:
> Matthew Wilcox wrote:
> >scsi: 2:0:1:0 Device: HP 18.2G ATLAS10K3_18_SCA HP05 ANSI 02
> >scsi: 4:0:2:0 Device: HP       DVD-ROM 305      1.01 ANSI 02
> >
> >If we really wanted to be smart, we could even do:
> >
> >scsi: 2:0:1:0 Direct-Access      HP 18.2G ATLAS10K3_18_SCA HP05 ANSI 02
> >scsi: 4:0:2:0 CD-ROM             HP       DVD-ROM 305      1.01 ANSI 02
> 
> I wouldn't bother with the device type, unless you are reporting it as the
> byte0 contents (eg. PQ bits and dev type). I would like to see the PQ bits.
> I also expect the class driver to typically bind to the device right after
> this, so I'll get the sd or st lines which will further reflect device type.

Ah, well, that's no longer true with the async scanning patches.  They
work by scanning all the luns first, then going back and adding the luns
to sysfs.  I did this to preserve drive naming.  There were some other
options I considered, but this was the simplest way of doing things.

Looking at the device type stuff, I feel the urge to change the
interface to it -- no longer export the array directly, but change
it to a function which returns a string.  That way we can pass in
inquiry byte 0 and have it return an appropriate string based on PQ and
PQT.

> >I'm still in two minds about even reporting the ANSI version.  Is there
> >ever a time when having that information would be useful to debug a
> >problem *and* we don't have access to that (eg through sysfs)?
> 
> It makes a difference if debugging a scan issue. I would think it's useful
> to see what Lun 0 has as it drives other scanning.

Certainly -- but don't we get sysfs access to debug this kind of problem?
Or do people sometimes have this problem and can't find their root
device as a consequence?
