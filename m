From: Thomas Glanzmann <thomas@glanzmann.de>
Subject: Re: xcopy testing with ddpt
Date: Mon, 7 Oct 2013 06:03:28 +0200
Message-ID: <20131007040328.GA1439@glanzmann.de>
References: <20131003160033.GC5273@glanzmann.de>
 <524DA6EC.6000900@interlog.com>
 <20131005182206.GA9781@glanzmann.de>
 <5250E0D6.8000404@interlog.com>
 <20131006090005.GB12340@glanzmann.de>
 <52519FA8.9050905@interlog.com>
 <20131006184355.GC27090@glanzmann.de>
 <5251D179.8020405@interlog.com>
 <20131006213213.GA30637@glanzmann.de>
 <5251EAF3.8090500@interlog.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <target-devel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <5251EAF3.8090500@interlog.com>
Sender: target-devel-owner@vger.kernel.org
To: Douglas Gilbert <dgilbert@interlog.com>
Cc: "Nicholas A. Bellinger" <nab@linux-iscsi.org>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

Hello Doug,

* Douglas Gilbert <dgilbert@interlog.com> [2013-10-07 00:58]:
> Great, another one working.

yes. :-)

> So this saniq/HP/lefthand system does not support fetching
> the xcopy operating parameters, which will cause sg_xcopy
> and ddpt to give up. These could be defaulted to something
> sane and then use those default values to attempt the
> command that actually does the work:  EXTENDED_COPY(LID1).
> Googled around and couldn't find any workflow for this (for
> the saniq product). Do you have any technical documentation
> for this product that might throw some light on this?

I don't have any technical documentation describing EXTENDED_COPY.
However I know that it works with ESX server. So what I did is sniffing
the SCSI commands. Find the pcap here:

https://thomas.glanzmann.de/tmp/xcopy.pcap.bz2 (920K)
https://thomas.glanzmann.de/tmp/onexcopy.pcap (4K)

Hopefully that helps you figure out what is going on. My first though
was that we were doing the 100 MB in 4 chunks. That means approx 25 MB
per chunk (not precisely). However maybe that is to much for the SAN/IQ.
Maybe we should go easy on it and try 4 MB or 16 MB chunks. I have
configured the ESX to 16 MB chunks (the maximum ESX supports) using the
following command:

esxcfg-advcfg -s 16384 /DataMover/MaxHWTransferSize

If you want access to the system using ssh, let me know.

> Good. Now sg_xcopy and ddpt (my versions) output debug lines
> like this:
>      /dev/sdh: LEFTHAND  iSCSIDisk         a500  [pdt=0, 3pc=1]

perfect.

> >  Unit serial number: ca7e1e04bb286ee443fe05e985a11d240000000000000019

> Interesting serial number :-)

no idea how they calculate it.

> BTW list_id=0 has a special meaning in some context
> (buried deep in T10 documents: spc4r36j.pdf). That is
> probably why Hannes Reinecke defaulted that list_id to
> 1. I could understand the target XCOPY implementation
> only accepting one xcopy sequence at a time, but why
> restrict it to list_id=0 ? A question for NaB ...

Nab, do you have any input for us?

Quick wrap up what we did so far: Doug asked me to test ddpt and
sg_xcopy of sg3-utils beta on your target. After setting the list_id=0
both tools work out of the box. The test setup is:

        - 2 100 MB LUNs
        - Createing a filesystem on the first and copy some date on it
        - Use

                ddpt if=/dev/sg3 iflag=xcopy list_id=0 of=/dev/sg4 bs=512
                sg_xcopy if=/dev/sdc of=/dev/sdd list_id=0

        to copy the data from LUN 1 to LUN 2. And do a md5sum to verify
        that the user data are exactly the same.

Cheers,
        Thomas
