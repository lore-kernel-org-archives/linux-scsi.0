From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: Fw: [Bugme-new] [Bug 3651] New: dell poweredge 4600 aacraidPERC 3/Di Container goes offline
Date: Tue, 23 Nov 2004 17:07:51 -0500
Message-ID: <60807403EABEB443939A5A7AA8A7458B694F1B@otce2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:53926 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S261505AbUKWWHy convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Nov 2004 17:07:54 -0500
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Ryan Anderson <ryan@autoweb.net>, Andrew Morton <akpm@osdl.org>
Cc: linux-scsi@vger.kernel.org

Do you have the latest Firmware from Dell? Do you have the Read and
Write Cache disabled as Dell has recommended (for pre 6091(?) Firmware)?

The `container going offline' is a result of the Firmware in the card
not responding to a SCSI command within 60 seconds (the Linux SCSI layer
timeout). In the older firmware this would occur at the combination of
high load, drive or scsi bus problems and the card flushing the cache.
If the problem persists, preventing the card building up a large amount
of cache data may be the only way to mitigate this.

I have had others experiment with overriding the SCSI timeout (the
Adaptec driver branch has an AAC_EXTENDED_TIMEOUT) to limited success.
Turning off the SCSI timeout (add a scsi_del_timer as command is issued
to the controller, and a scsi_add_timer in the interrupt service routine
before completion) worked extremely well, but this makes me
understandably nervous.

Sincerely -- Mark Salyzyn

-----Original Message-----
From: linux-scsi-owner@vger.kernel.org
[mailto:linux-scsi-owner@vger.kernel.org] On Behalf Of Ryan Anderson
Sent: Tuesday, November 23, 2004 4:42 PM
To: Andrew Morton
Cc: linux-scsi@vger.kernel.org
Subject: Re: Fw: [Bugme-new] [Bug 3651] New: dell poweredge 4600
aacraidPERC 3/Di Container goes offline

On Thu, 2004-10-28 at 00:53 -0700, Andrew Morton wrote:
> Subject: [Bugme-new] [Bug 3651] New: dell poweredge 4600 aacraid PERC
3/Di Container goes offline
> 
> 
> http://bugme.osdl.org/show_bug.cgi?id=3651
> 
>            Summary: dell poweredge 4600 aacraid PERC 3/Di Container
goes
>                     offline
>     Kernel Version: 2.6.10-rc1, 2.6.9, 2.6.8, 2.6.7, 2.6.6
>             Status: NEW
>           Severity: high
>              Owner: andmike@us.ibm.com
>          Submitter: oliver.polterauer@ewave.at
>                 CC: oliver.polterauer@ewave.at

Is there any update on this problem?
To reiterate my particular hardware involved that can trigger this
problem:

Dell 2650, Dual 2.4Ghz Xeon processors (hyperthreading no, though the
problem occured in 2.4.20 without hyperthreading disabled via "noht")

4 GB of ram
Only load is PostgreSQL related (i.e, network queries, plus twice daily
dumps of the database to a NFS store, and a rsync back to the server for
a second copy)

Under load, I repeatedly saw containers go offline.

Dell's recommended hardware diagnostics do not turn up anything (at
all!)

The harddrive are Fujitsu drives, so the Seagate Firmware issue should
not affect them.

I have since taken this server out of production.  Unfortunately, this
makes the error much harder to trigger (i.e, I have failed so far to
trigger it, even with multiple bonnie++ runs)

Suggestions, diagnostics, etc, would be greatly appreciated.


-- 

Ryan Anderson                
AutoWeb Communications, Inc. 
email: ryan@autoweb.net 
