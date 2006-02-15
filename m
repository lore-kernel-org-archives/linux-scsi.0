From: Mirko Benz <mirko.benz@web.de>
Subject: Re: SATA on mptsas performance
Date: Wed, 15 Feb 2006 08:52:07 +0100
Message-ID: <43F2DDA7.7050700@web.de>
References: <F331B95B72AFFB4B87467BE1C8E9CF5F28A5FF@NAMAIL2.ad.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from 162.237.ddkom.net ([212.80.237.162]:44216 "EHLO
	cheetah.dd.xiranet.com") by vger.kernel.org with ESMTP
	id S1422666AbWBOHwk (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Feb 2006 02:52:40 -0500
In-Reply-To: <F331B95B72AFFB4B87467BE1C8E9CF5F28A5FF@NAMAIL2.ad.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric" <Eric.Moore@lsil.com>
Cc: linux-scsi@vger.kernel.org

Hello,

The SAS3442X is connected to the JBOD via a x4 SAS cable.
The JBOD has an LSI SAS Expander chip - no port multiplier.
Disks are Seagate ST3300831AS (300 GB, SATA-I, NCQ)

Does the SAS controller and the SAS expander communicate at 3 Gb when 
accessing SATA disks?
If not it should give 4 * 150 MB/s r/w throughput for this configuration.

I am testing with parallel dd invocations on the raw device e.g.:
dd if=/dev/sdb of=/dev/null bs=32k count=10000 &
...
dd if=/dev/sdl of=/dev/null bs=32k count=10000 &

I have tested with IOMETER but the results are worse.

I will test SATA II disks later. But I assume there is a scheduling 
problem (mapping 10 disks to 4 channels). The CPU load is also very high.

Disks support NCQ but it should have no effect due to sequential access 
of a single application per disk. How to switch on/off NCQ?

Regards,
Mirko

