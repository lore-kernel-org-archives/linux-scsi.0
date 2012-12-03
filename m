From: Ewan Milne <emilne@redhat.com>
Subject: Re: Slow writes to SAS drives on LSI mpt2sas HBA
Date: Mon, 03 Dec 2012 17:06:40 -0500
Message-ID: <1354572400.4420.66.camel@localhost.localdomain>
References: <536E46D8-A041-4860-A922-21305CAF5321@gmail.com>
Reply-To: emilne@redhat.com
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:25820 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751085Ab2LCWGm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 3 Dec 2012 17:06:42 -0500
In-Reply-To: <536E46D8-A041-4860-A922-21305CAF5321@gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Gregory Haskins <gregory.haskins@gmail.com>
Cc: linux-scsi@vger.kernel.org

On Mon, 2012-12-03 at 14:48 -0500, Gregory Haskins wrote:
> Hello, 
> 
> I am experiencing a significant performance issue in write thoughput with SAS devices connected via an LSI 9207-8e (LSISAS2308 based) HBA.  SATA devices plugged into the same rig appear to be ok.  I first noticed this in kernel v3.0.13, but I confirmed the problem exists even in 3.7.0-rc7. 
> 
> I have gathered numerous tables of data and graphs, but have boiled the problem down such that it can be easily reproduced with dd. 
> 
> In this example: The "SATA" drive is a 3Gbps 7200rpm 640GB WD model WD6400AAKS-4, mounted to /mnt/sata.  The "SAS" is a 6Gbps 7200rpm 3TB WD model WD3001FYYG-01SL3, mounted to /mnt/sas. 
> 
> Under normal operation, the SATA drive is capable of about 5MB/s - 115MB/s, and the SAS drive is about 5MB/s - 165MB/s.  However, what I am seeing is that small block sizes are about 122KB/s, and it peaks out at about 70MB/s.  For example: 
> 
> lse2:/home/ghaskins # uname -a 
> Linux lse2 3.7.0-rc7-0.27-default+ #1 SMP Mon Dec 3 08:47:39 EST 2012 x86_64 x86_64 x86_64 GNU/Linux 
> lse2:/home/ghaskins # dd oflag=direct if=/dev/zero of=/mnt/sas/test.dat bs=1k count=1M 
> ^C7566+0 records in 
> 7566+0 records out 
> 7747584 bytes (7.7 MB) copied, 63.5934 s, 122 kB/s

It sounds like your drive write cache is disabled, 7200RPM is 120
revolutions/sec, and you are getting 7747584 / 1024 / 63.59 = ~119 IO/s
I believe the write cache is enabled by default on SATA drives, which
would explain the difference.

> 
> lse2:/home/ghaskins # dd oflag=direct if=/dev/zero of=/mnt/sata/test.dat bs=1k count=1M 
> ^C109381+0 records in 
> 109381+0 records out 
> 112006144 bytes (112 MB) copied, 21.7539 s, 5.1 MB/s 
> 
> lse2:/home/ghaskins # dd oflag=direct if=/dev/zero of=/mnt/sata/test.dat bs=1M count=1k 
> 1024+0 records in 
> 1024+0 records out 
> 1073741824 bytes (1.1 GB) copied, 9.31733 s, 115 MB/s 
> lse2:/home/ghaskins # dd oflag=direct if=/dev/zero of=/mnt/sas/test.dat bs=1M count=1k 
> 1024+0 records in 
> 1024+0 records out 
> 1073741824 bytes (1.1 GB) copied, 14.6696 s, 73.2 MB/s 
> 
> Note that this setup has been tested under the LSI driver on Windows7 to rule out any issues with the hardware, and both SATA and SAS drives appear to operate normally.  My current guess is that the linux driver is not queuing commands properly, but this is not confirmed.  Has anyone else seen this? 
> 
> -Greg --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html


