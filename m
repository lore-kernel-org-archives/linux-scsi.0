From: Tomasz Chmielewski <mangoo@wpkg.org>
Subject: Re: [Scst-devel] [ANNOUNCE]: Comparison of features sets between
 	different SCSI targets (SCST, STGT, IET, LIO)
Date: Mon, 06 Apr 2009 12:29:52 +0200
Message-ID: <49D9D9A0.40106@wpkg.org>
References: <49D7AD54.4060408@vlnb.net> <49D7B122.50103@wpkg.org> <e2e108260904050429lcd1870ag6656f36a170ccab3@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx03.syneticon.net ([78.111.66.105]:46270 "EHLO
	mx03.syneticon.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754751AbZDFK37 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 6 Apr 2009 06:29:59 -0400
In-Reply-To: <e2e108260904050429lcd1870ag6656f36a170ccab3@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@gmail.com>
Cc: Vladislav Bolkhovitin <vst@vlnb.net>, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, iscsitarget-devel@lists.sourceforge.net, James Bottomley <James.Bottomley@hansenpartnership.com>, scst-devel <scst-devel@lists.sourceforge.net>, stgt@vger.kernel.org

Bart Van Assche schrieb:

> Hello Tomasz,
> 
> It would be great if you could publish the details of your setup and
> the tests you have run, such that we are able to reproduce the tests
> and analyze the results further.

Here it is.

The target is running Debian Lenny 64bit userspace on an Intel Celeron 2.93GHz CPU, 2 GB RAM.

Initiator is running Debian Etch 64 bit userspace, open-iscsi 2.0-869, Intel Xeon 3050/2.13GHz, 8 GB RAM.


Each test was repeated 6 times, "sync" was made and caches were dropped on both sides before each test was started.

dd parameters were like below, so 6.6 GB of data was read each time:

dd if=/dev/sdag of=/dev/null bs=64k count=100000


Data was read from two block devices:
- /dev/md0, which is RAID-1 on two ST31500341AS 1.5 TB drives
- encrypted dm-crypt device which is on top of /dev/md0

Encrypted device was created with the following additional options passed to cryptsetup
(it provides the most performance on systems where CPU is a bottleneck, but with decreased
security when compared to default options):

-c aes-ecb-plain -s 128


Generally, CPU on the target was a bottleneck, so I also tested the load on target.


md0, crypt columns - averages from dd
us, sy, id, wa - averages from vmstat


1. Disk speeds on the target

Raw performance: 102.17 MB/s
Raw performance (encrypted):  50.21 MB/s


2. Read-ahead on the initiator: 256 (default); md0, crypt - MB/s

                           md0   us  sy  id  wa  | crypt   us  sy  id  wa  
STGT                      50.63   4% 45% 18% 33% | 32.52    3% 62% 16% 19%
SCST (debug + no patches) 43.75   0% 26% 30% 44% | 42.05    0% 84%  1% 15%
SCST (fullperf + patches) 45.18   0% 25% 33% 42% | 44.12    0% 81%  2% 17%


3. Read-ahead on the initiator: 16384; md0, crypt - MB/s

                           md0   us  sy  id  wa  | crypt   us  sy  id  wa  
STGT                      56.43   3% 55%  2% 40% | 46.90    3% 90%  3%  4%
SCST (debug + no patches) 73.85   0% 58%  1% 41% | 42.70    0% 85%  0% 15%
SCST (fullperf + patches) 76.27   0% 63%  1% 36% | 42.52    0% 85%  0% 15%



-- 
Tomasz Chmielewski
http://wpkg.org
