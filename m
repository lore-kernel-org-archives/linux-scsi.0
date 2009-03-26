From: Thomas Mueller <thomas@chaschperli.ch>
Subject: Re: aacraid: SCSI bus appears hung
Date: Thu, 26 Mar 2009 11:56:30 +0000 (UTC)
Message-ID: <gqfqhe$7ib$1@ger.gmane.org>
References: <gq09cm$abq$2@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:41877 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751304AbZCZL4q (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 26 Mar 2009 07:56:46 -0400
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1LmoCQ-0000oa-Ky
	for linux-scsi@vger.kernel.org; Thu, 26 Mar 2009 11:56:42 +0000
Received: from 77-58-236-135.dclient.hispeed.ch ([77.58.236.135])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Thu, 26 Mar 2009 11:56:42 +0000
Received: from thomas by 77-58-236-135.dclient.hispeed.ch with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-scsi@vger.kernel.org>; Thu, 26 Mar 2009 11:56:42 +0000
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On Fri, 20 Mar 2009 14:31:50 +0000, Thomas Mueller wrote:

> hi
> 
> this is on debian etch with kernel 2.6.26 (backports.org) and aacraid
> 1.1-5[2456]-ms. the adapter is an adaptec 5805 (rebranded as Supermicro
> AOC-USAS-S8iR, f/w 15758), 4+1 WD VelociRaptor 300GB disks, RAID10.
> 
> the disks aren't very good. about every 2 months the background
> consistency check detects defectiv blocks on some disks. the hotspare
> disk takes

already the next drive found badblocks and triggerd the problem. in the 
meantime i've enabled rsyslog to send its messages to another host. some 
lines seems to have not hit the log the last time, espacially the AAC and 
AAC0 lines:

[1220327.335481] aacraid: Host adapter abort request (0,0,0,0)
[1220327.335481] aacraid: Host adapter abort request (0,0,0,0)
[1220327.335481] aacraid: Host adapter abort request (0,0,0,0)
[1220327.335481] aacraid: Host adapter abort request (0,0,0,0)
[1220327.335481] aacraid: Host adapter abort request (0,0,0,0)
[1220327.335481] aacraid: Host adapter abort request (0,0,0,0)
[1220327.339490] aacraid: Host adapter abort request (0,0,0,0)
[1220327.339520] aacraid: Host adapter abort request (0,0,0,0)
[1220327.339550] aacraid: Host adapter abort request (0,0,0,0)
[1220327.339578] aacraid: Host adapter abort request (0,0,0,0)
[1220327.339608] aacraid: Host adapter abort request (0,0,0,0)
[1220327.339635] aacraid: Host adapter abort request (0,0,0,0)
[1220327.339662] aacraid: Host adapter abort request (0,0,0,0)
[1220327.339693] aacraid: Host adapter abort request (0,0,0,0)
[1220327.339720] aacraid: Host adapter abort request (0,0,0,0)
[1220327.339751] aacraid: Host adapter abort request (0,0,0,0)
[1220327.339781] aacraid: Host adapter abort request (0,0,0,0)
[1220327.339872] aacraid: Host adapter reset request. SCSI hang ?
[1220327.339907] AAC: Host adapter BLINK LED 0xf3
[1220327.339963] AAC0: adapter kernel panic'd f3.



so this means the adapter "reboots" because of an "kernel panic" on the 
adapter itself?

- Thomas

