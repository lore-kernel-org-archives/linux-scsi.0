From: "Caspar Smit" <c.smit@truebit.nl>
Subject: Re: MVSAS maxing out bandwidth at 2.5 Gbps
Date: Wed, 20 Jan 2010 14:38:36 +0100 (CET)
Message-ID: <31303.87.210.74.220.1263994716.squirrel@ketsers.dhs.org>
References: <333bc7e11001200520g6094e974jfa93656371a2feb3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 80-69-81-65.colo.transip.net ([80.69.81.65]:41197 "EHLO
	ns1.emsolutions.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753113Ab0ATNii (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 20 Jan 2010 08:38:38 -0500
In-Reply-To: <333bc7e11001200520g6094e974jfa93656371a2feb3@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Audio Haven <audiohaven@gmail.com>
Cc: linux-scsi@vger.kernel.org

Hi,

You say you stress tested this setup.
Can you tell me your experiences with hotplugging in combination with SATA
disks (which you are using). I seem to keep getting kernel panics when
hotplugging SATA disks with the same controller, kernel and patches you
mention.

I mentioned this (with several others in this mailinglist) some time ago
but no reaction since.

Kind regards,
Caspar Smit


> I have 8 Western Digital WD15EADS 1.5T green drives in a software
> raid6 6+2 config using 1024K chunk size.
> They are connected to a SuperMicro SASLP-MV8 card sitting in the 16x
> PCI-E slot of an old but stable Asus K8N4E-Deluxe board.
>
> Every single drive appears to read at >90Mbyte/sec:
> hdparm -t /dev/sdb
>  Timing buffered disk reads:  282 MB in  3.02 seconds =  93.49 MB/sec
>
> But when I try to hdparm -t /dev/md2, I max out at around 180Mbyte/sec
> and the read seems to be nicely distributed across all drives
> according to iostat -k :
>
> avg-cpu:  %user   %nice %system %iowait  %steal   %idle
>            5.00    0.00   95.00    0.00    0.00    0.00
>
> Device:            tps    kB_read/s    kB_wrtn/s    kB_read    kB_wrtn
> sda               0.00         0.00         0.00          0          0
> sdb             115.00     23552.00         0.00      23552          0
> sdc             110.00     22528.00         0.00      22528          0
> sdd             115.00     23552.00         0.00      23552          0
> sde             115.00     23552.00         0.00      23552          0
> sdf             113.00     23040.00         0.00      23040          0
> sdg             112.00     23040.00         0.00      23040          0
> sdh             119.00     24324.00         0.00      24324          0
> sdi             121.00     24576.00         0.00      24576          0
> md2           47783.00    191132.00         0.00     191132          0
>
> sda is my boot drive connected to the onboard nforce, not part of the
> raidset
>
> When loading the mvsas module, it seems the bandwith is limited:
> mvsas 0000:01:00.0: mvsas: PCI-E x4, Bandwidth Usage: 2.5 Gbps
>
> which seems strange as it should be able to do 250Mbyte/sec per lane,
> so 4 lanes should amount to 1 Gbyte / sec even for the oldest PCI-E
> v1.x standard.
>
> My system is Fedora 12  x86_64 using a custom 2.6.32.3 kernel with the
> following patches from Andy Yan:
>
> [PATCH 6/7]MVSAS: Enhanced hot plug handling
> [PATCH 5/7]MVSAS:Optimization for DMA buffer
> [PATCH 4/7]MVSAS:Make code more flexibe for different chip model.
> [PATCH 3/7]MVSAS: bug fix with big endian
> [PATCH 2/7]MVSAS:add supporting MSI feature
> [PATCH 1/7]MVSAS: Update chip initialization
>
> I did not use [PATCH 7/7]
>
> I can report these patches solved all of my raid6 stability issues
> (drives kicking out of the raid, /proc/mdstat not reporting faults,
> xfs corruption) and have been running stable for the past 3 weeks with
> all sorts of stress testing.
>
> Am I missing something with regards to tuning to get the full
> bandwidth out of this marvell controller ?
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>

