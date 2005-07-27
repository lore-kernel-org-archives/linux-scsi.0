From: Bodo Stroesser <bstroesser@fujitsu-siemens.com>
Subject: Re: lpfc: System freezing if fiber is broken
Date: Wed, 27 Jul 2005 15:45:41 +0200
Message-ID: <42E79005.3020108@fujitsu-siemens.com>
References: <42E679A2.1060408@fujitsu-siemens.com> <20050726184800.GA19810@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from dgate1.fujitsu-siemens.com ([217.115.66.35]:20786 "EHLO
	dgate1.fujitsu-siemens.com") by vger.kernel.org with ESMTP
	id S262244AbVG0Npx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 27 Jul 2005 09:45:53 -0400
In-Reply-To: <20050726184800.GA19810@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: James.Smart@Emulex.Com, linux-scsi@vger.kernel.org

Mike Anderson wrote:
> Bodo Stroesser [bstroesser@fujitsu-siemens.com] wrote:
> 
>>Hi James,
>>
>>disrupting a working FC connection makes my i386 SMP server
>>(2.6.12.2) freeze just one or two seconds after this.
>>I'm normally using lpfc_nodev_tmo = 1. When I change this to the
>>default value of 35, the system stalls about 36 seconds after
>>disruption. So I guess, the problem is caused by nodev_tmo
>>expiring.
>>I activated the nmi_watchdog, but no output.
>>
>>What can I do to analyze this problem?
> 
> 
> Does changing the timeout for a scsi device also alter the problem. In the
> past people have seen issues of the nodev_tmo expiring near the scsi
> timeout. This past cases lead to devices being offlined, but may this
> could be causing a different symptom on your system.
The amount of time between cutting the connection and the system freezing
is nearly the same as lpfc_nodev_tmo. Using the default nodev_tmo of 35 seconds
results in about 36 seconds, while setting nodev_tmo to 1 results in
2 seconds. As the devices on the Fibre Channel are tapedrives scsi timeout is
900 seconds.
There are 8 tests running that write 8 tape-LUNs at the same SCSI target.
If the connection is broken, some of the tests immediately receive a bad
result for write(), some keep waiting for a result.

Meanwhile I also did some tests with timeout set to 5 and nodev_tmo to 35
(The test I'm running doesn't fail with that small timeout). Those tests, that
do not receive a bad result, stay waiting for result even after 5 second timeout
is expired. In most cases, the system doesn't freeze after nodev_tmo with this test.
But about 5 seconds after plugging FC cable again, it freezes.

> You can change the timeout for the device by echoing a higher value into
> /sys/bus/scsi/devices/${nexus}/timeout.
> 
> Is this a full system freeze or only the controlling console?
Full freeze, no more replies via console or network.

> 
> -andmike
> --
> Michael Anderson
> andmike@us.ibm.com
