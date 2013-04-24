From: Douglas Gilbert <dgilbert@interlog.com>
Subject: Re: sg_ses -j shows Transport protocol: Oxc not decoded
Date: Wed, 24 Apr 2013 10:02:15 -0400
Message-ID: <5177E5E7.7040801@interlog.com>
References: <20130424090816.GA17732@onthe.net.au>
Reply-To: dgilbert@interlog.com
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp.infotech.no ([82.134.31.41]:39116 "EHLO smtp.infotech.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755701Ab3DXODX (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 24 Apr 2013 10:03:23 -0400
In-Reply-To: <20130424090816.GA17732@onthe.net.au>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Chris Dunlop <chris@onthe.net.au>
Cc: linux-scsi@vger.kernel.org

On 13-04-24 05:08 AM, Chris Dunlop wrote:
> Hi,
>
> I have 3 boxes, each with an LSI 9211-8i and a mix of LSI expanders (Supermicro
> SAS-846EL2, SAS-826EL2). For some of my expanders, 'sg_ses -j' (originally
> sg3_utils 1.33, now 1.35) is showing:
>
> Slot 24 [0,23]  Element type: Array device slot
>    ...
>    Additional Element Status:
>      Transport protocol: Oxc not decoded

According to table 477 in section 7.6.1 of spc4r36f.pdf
protocol identifier 0xc is reserved. As far as I can
see it has never been defined to a known protocol.

So either SuperMicro/LSI is getting creative or it is a case
of GIGO (garbage in, garbage out).

> ...where the slot contains a SATA device. It's always Slot 24, and other
> slots show up fine. E.g. on one of the expanders with SATA drives in
> both Slot 23 and 24:
>
> h3# sg_ses -j /dev/sg81
>    LSI       SAS2X36           0e0b
>    Primary enclosure logical identifier (hex): 500304800013453f
> ...
> Slot 23 [0,22]  Element type: Array device slot
>    Enclosure Status:
>      Predicted failure=0, Disabled=0, Swap=0, status: OK
>      OK=0, Reserved device=0, Hot spare=0, Cons check=0
>      In crit array=0, In failed array=0, Rebuild/remap=0, R/R abort=0
>      App client bypass A=0, Do not remove=0, Enc bypass A=0, Enc bypass B=0
>      Ready to insert=0, RMV=0, Ident=0, Report=0
>      App client bypass B=0, Fault sensed=0, Fault reqstd=0, Device off=0
>      Bypassed A=0, Bypassed B=0, Dev bypassed A=0, Dev bypassed B=0
>    Additional Element Status:
>      Transport protocol: SAS
>      number of phys: 1, not all phys: 0, device slot number: 22
>      phy index: 0
>        device type: no device attached
>        initiator port for:
>        target port for: SATA_device
>        attached SAS address: 0x500304800013453f
>        SAS address: 0x5003048000134522
>        phy identifier: 0x0
> Slot 24 [0,23]  Element type: Array device slot
>    Enclosure Status:
>      Predicted failure=0, Disabled=0, Swap=0, status: OK
>      OK=0, Reserved device=0, Hot spare=0, Cons check=0
>      In crit array=0, In failed array=0, Rebuild/remap=0, R/R abort=0
>      App client bypass A=0, Do not remove=0, Enc bypass A=0, Enc bypass B=0
>      Ready to insert=0, RMV=0, Ident=0, Report=0
>      App client bypass B=0, Fault sensed=0, Fault reqstd=0, Device off=0
>      Bypassed A=0, Bypassed B=0, Dev bypassed A=0, Dev bypassed B=0
>    Additional Element Status:
>      Transport protocol: Oxc not decoded
> ...
>
> This may be unrelated, but 'sg_ses -j' is also coming up with the
> following error on 3 of the 6 expanders identified as "LSI SAS2X36 0e0b"
> (this doesn't include any of the expanders with the Slot 24 problem):
>
> join_work: oi=6, ei=255 (broken_ei=0) not in join_arr

This inconsistency error supports my GIGO theory.

> The expander types are:
>
> ----------------------------------------------------------------------
> $ for h in h1 h2 h3; do echo "=== $h ==="
>    ssh $h 'lsscsi | grep enclosu'
> done
> === h1 ===
> [0:0:24:0]   enclosu LSI CORP SAS2X36          0717  -
> [0:0:27:0]   enclosu LSI      SAS2X36          0e0b  -
> [0:0:38:0]   enclosu LSI CORP SAS2X28          0717  -
> [0:0:62:0]   enclosu LSI      SAS2X36          0e0b  -
> [0:0:85:0]   enclosu LSI      SAS2X36          0e0b  -
> === h2 ===
> [0:0:25:0]   enclosu LSI CORP SAS2X36          0717  -
> [0:0:29:0]   enclosu LSI CORP SAS2X28          0717  -
> === h3 ===
> [0:0:23:0]   enclosu LSI CORP SAS2X36          0717  -
> [0:0:45:0]   enclosu LSI      SAS2X36          0e0b  -
> [0:0:57:0]   enclosu LSI CORP SAS2X28          0717  -
> [0:0:81:0]   enclosu LSI      SAS2X36          0e0b  -
> [0:0:88:0]   enclosu LSI      SAS2X36          0e0b  -
> ----------------------------------------------------------------------
>
> ...and they're daisy-chained like this:
>
> ----------------------------------------------------------------------
> for h in b2 b4 b5; do echo "=== $h ==="
>    ssh $h 'find /sys/bus/scsi/devices/host0/ -name expander\* | egrep -v "bsg|sas_(expander|device)"'
> done
> === h1 ===
> /sys/bus/scsi/devices/host0/port-0:0/expander-0:0
> /sys/bus/scsi/devices/host0/port-0:0/expander-0:0/port-0:0:0/expander-0:1
> /sys/bus/scsi/devices/host0/port-0:0/expander-0:0/port-0:0:0/expander-0:1/port-0:1:25/expander-0:4
> /sys/bus/scsi/devices/host0/port-0:1/expander-0:2
> /sys/bus/scsi/devices/host0/port-0:1/expander-0:2/port-0:2:0/expander-0:3
> === h2 ===
> /sys/bus/scsi/devices/host0/port-0:0/expander-0:0
> /sys/bus/scsi/devices/host0/port-0:1/expander-0:1
> === h3 ===
> /sys/bus/scsi/devices/host0/port-0:0/expander-0:0
> /sys/bus/scsi/devices/host0/port-0:0/expander-0:0/port-0:0:0/expander-0:1
> /sys/bus/scsi/devices/host0/port-0:1/expander-0:2
> /sys/bus/scsi/devices/host0/port-0:1/expander-0:2/port-0:2:0/expander-0:3
> /sys/bus/scsi/devices/host0/port-0:1/expander-0:2/port-0:2:0/expander-0:3/port-0:3:0/expander-0:4
> ----------------------------------------------------------------------
>
> (Sorry, I don't know how to relate the /sys/bus/scsi stuff to the scsi ids or
> /dev/sgXX.)

Best to look at the mapping to /dev/bsg device nodes in
this case.

> The errors are showing up like:
>
> ----------------------------------------------------------------------
> $ for h in h1 h2 h3; do
>    ssh $h '
>      for d in $(lsscsi -tg | awk "\$2 == \"enclosu\" { print \$5 }"); do
>        echo "=== $(hostname):$d ==="
>        sg_ses -j $d 2>&1
>      done
>    '
> done | egrep 'LSI|^=|^Slot 24|join_work|not decoded' | sed -r 's/^=/\n=/'
>
> === h1:/dev/sg24 ===
>    LSI CORP  SAS2X36           0717
> Slot 24 [0,23]  Element type: Array device slot
>
> === h1:/dev/sg27 ===
>    LSI       SAS2X36           0e0b
> Slot 24 [0,23]  Element type: Array device slot
>      Transport protocol: Oxc not decoded
>
> === h1:/dev/sg38 ===
>    LSI CORP  SAS2X28           0717
>
> === h1:/dev/sg62 ===
>    LSI       SAS2X36           0e0b
> Slot 24 [0,23]  Element type: Array device slot
>      Transport protocol: Oxc not decoded
>
> === h1:/dev/sg81 ===
> join_work: oi=6, ei=255 (broken_ei=0) not in join_arr
>    LSI       SAS2X36           0e0b
>
> === h2:/dev/sg25 ===
>    LSI CORP  SAS2X36           0717
> Slot 24 [0,23]  Element type: Array device slot
>
> === h2:/dev/sg29 ===
>    LSI CORP  SAS2X28           0717
>
> === h3:/dev/sg23 ===
>    LSI CORP  SAS2X36           0717
> Slot 24 [0,23]  Element type: Array device slot
>
> === h3:/dev/sg45 ===
> join_work: oi=6, ei=255 (broken_ei=0) not in join_arr
>    LSI       SAS2X36           0e0b
>
> === h3:/dev/sg57 ===
>    LSI CORP  SAS2X28           0717
>
> === h3:/dev/sg81 ===
>    LSI       SAS2X36           0e0b
> Slot 24 [0,23]  Element type: Array device slot
>      Transport protocol: Oxc not decoded
>
> === h3:/dev/sg88 ===
> join_work: oi=6, ei=255 (broken_ei=0) not in join_arr
>    LSI       SAS2X36           0e0b
>
> ----------------------------------------------------------------------
>
> What should I be looking at, or what info I can provide to help track down
> these issues?

I have a cheap SuperMicro disk enclosure (CSE-M35TQ) and
never could find any info on its disk management chip
(MG9072). My feeling was the MG9072 came with generic settings
that SuperMicro should have specialized for their product,
a job SuperMicro did somewhat poorly. [At least that is good
for my error checking code :-)]

Also if I put more than two disks in that enclosure, the SGPIO **
protocol seems to fall apart, leading to complete GIGO.

So, if I were you, I'd be happy with any information you can
get and not waste too much time over the rest.

sg_ses has been tested with some higher end enclosures which
are much more compliant, but many still have small quirks.

Doug Gilbert

** SAS-2 expanders tend to have integrated enclosure devices
    which communicate with enclosures via SGPIO.
