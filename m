From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: Fw: [Bugme-new] [Bug 3651] New: dell poweredge 4600aacraidPERC 3/Di Container goes offline
Date: Tue, 23 Nov 2004 17:27:36 -0500
Message-ID: <60807403EABEB443939A5A7AA8A7458B694F38@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:41649 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S261584AbUKWW1i convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Nov 2004 17:27:38 -0500
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ryan Anderson <ryan@autoweb.net>
Cc: Andrew Morton <akpm@osdl.org>, linux-scsi@vger.kernel.org

Yes, somewhat irrelevant. The firmware engineer that made the changes
has not had recent contact with me, so I am not sure what he did when he
went to 6092.

But, the problem is still an alignment of errors causing long command
completion in the Adapter's Firmware. Turning off the read and write
cache may still have a positive effect. One of the errors I believe
should contain a hardware component (scsi, cable or drive funkiness
requiring some recovery actions delaying other command completions).

The aacraid driver is *thin* (scb comes in, translates to an io fib,
interrupt happens, return fib is translated as a return status in the
scb). All the work is in the firmware, there is no real `hacking' that
can be done, but I have tried various mitigations. One of them is to
keep the adapter quiesced from new commands until all the commands
complete before returning to the harsh reality of needing a response
within ten seconds to a test unit ready after the reset handler returns.
But that code only waits an additional 60 seconds. This code is in the
kernels.org driver.

You run the management tools, and let it inform the firmware to turn off
the cache.

Sincerely -- Mark Salyzyn

-----Original Message-----
From: Ryan Anderson [mailto:ryan@autoweb.net] 
Sent: Tuesday, November 23, 2004 5:16 PM
To: Salyzyn, Mark
Cc: Andrew Morton; linux-scsi@vger.kernel.org
Subject: RE: Fw: [Bugme-new] [Bug 3651] New: dell poweredge
4600aacraidPERC 3/Di Container goes offline

On Tue, 2004-11-23 at 17:07 -0500, Salyzyn, Mark wrote:
> Do you have the latest Firmware from Dell? Do you have the Read and
> Write Cache disabled as Dell has recommended (for pre 6091(?)
Firmware)?

The latest Dell firmware that I have seen is 6092, which would seem to
make your second question irrelevant.  Is that correct?

dmesg says this about the controller:
AAC0: kernel 2.8.4 build 6092
AAC0: monitor 2.8.4 build 6092
AAC0: bios 2.8.0 build 6092
AAC0: serial 83ac41d3fafaf001
scsi0 : percraid
  Vendor: DELL      Model: PERCRAID RAID5    Rev: V1.0
  Type:   Direct-Access                      ANSI SCSI revision: 02
  Vendor: DELL      Model: PERCRAID RAID5    Rev: V1.0
  Type:   Direct-Access                      ANSI SCSI revision: 02

> The `container going offline' is a result of the Firmware in the card
> not responding to a SCSI command within 60 seconds (the Linux SCSI
layer
> timeout). In the older firmware this would occur at the combination of
> high load, drive or scsi bus problems and the card flushing the cache.
> If the problem persists, preventing the card building up a large
amount
> of cache data may be the only way to mitigate this.

Ok, I can experiment with this.  Where should I start?  (I'm not afraid
of source-level hacking, just don't know where to start.)

> I have had others experiment with overriding the SCSI timeout (the
> Adaptec driver branch has an AAC_EXTENDED_TIMEOUT) to limited success.
> Turning off the SCSI timeout (add a scsi_del_timer as command is
issued
> to the controller, and a scsi_add_timer in the interrupt service
routine
> before completion) worked extremely well, but this makes me
> understandably nervous.

That completely disables *any* timeout, correct?
That would make me a .. bit nervous, too.

I'm going to try to build a load today that can trigger the problem.
(It's rather hard to debug when the problem is very hard to trigger -
sigh)


-- 

Ryan Anderson                
AutoWeb Communications, Inc. 
email: ryan@autoweb.net 
