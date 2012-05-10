From: John Adams <john.adams@avid.com>
Subject: Re: Question about seemingly extraneous i/o's
Date: Thu, 10 May 2012 19:39:58 +0000
Message-ID: <CBD190C1.114E%jadams@avid.com>
References: <20120510185614.GY11309@beardog.cce.hp.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from exprod5og109.obsmtp.com ([64.18.0.188]:48787 "HELO
	exprod5og109.obsmtp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1759234Ab2EJTqU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 10 May 2012 15:46:20 -0400
In-Reply-To: <20120510185614.GY11309@beardog.cce.hp.com>
Content-Language: en-US
Content-ID: <CF61CA4F3BCB1C458A688D3934F2A698@avid.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "scameron@beardog.cce.hp.com" <scameron@beardog.cce.hp.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Cc: "mike.miller@hp.com" <mike.miller@hp.com>


On 5/10/12 2:56 PM, "scameron@beardog.cce.hp.com"
<scameron@beardog.cce.hp.com> wrote:

>
>I have this script, which just cranks up the scsi logging level
>a bit, then writes 1 block out to a disk, sleeps a bit, then
>cranks the logging back down.  There's no other i/o going
>to the disk (not mounted, no filesystem)
>
>-----8<---- -----8<---- -----8<---- -----8<---- -----8<----
>#!/bin/sh
>
>logger 
>vvvvvv==============================================================vvvvvv
>LOGGING_LEVEL=14683648
>
>sysctl -w dev.scsi.logging_level=$LOGGING_LEVEL
>dd if=/dev/zero of=/dev/sdb count=1 bs=512 seek=5000 oflag=direct
>sleep 1
>sysctl -w dev.scsi.logging_level=0
>logger 
>^^^^^^==============================================================^^^^^^
>-----8<---- -----8<---- -----8<---- -----8<---- -----8<----
>
>
>This script produces the log below.  It does the write, as
>expected, but then it also does a test unit ready, then inquiries and a
>bunch of reads.
>
>Where are these coming from?

I had a similar question once and found that when I closed the disk
handle, udev was invoking blkid and that was generating some read noise.
blktrace was helpful there.

>

