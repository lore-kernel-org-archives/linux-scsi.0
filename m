From: Douglas Gilbert <dougg@torque.net>
Subject: Re: sysfs support for sg
Date: Thu, 08 Jan 2004 11:50:03 +1000
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <3FFCB74B.9090102@torque.net>
References: <20040107223341.GA23799@suse.de> <20040107224028.GA24290@suse.de>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------080800000602080808000907"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from bunyip.cc.uq.edu.au ([130.102.2.1]:26634 "EHLO
	bunyip.cc.uq.edu.au") by vger.kernel.org with ESMTP id S263062AbUAHBwI
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 Jan 2004 20:52:08 -0500
In-Reply-To: <20040107224028.GA24290@suse.de>
List-Id: linux-scsi@vger.kernel.org
To: Olaf Hering <olh@suse.de>
Cc: linux-scsi@vger.kernel.org, patmans@ibm.com

This is a multi-part message in MIME format.
--------------080800000602080808000907
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit

Olaf Hering wrote:
>  On Wed, Jan 07, Olaf Hering wrote:
> 
> 
>>Hello,
>>
>>are there any plans to add sysfs support to the sg driver?
>>I see no 'dev' nodes for it.
>>Can stuff like 'sg_start /dev/sg2 0' be done in another way?
> 
> 
> I missed the /sys/block/sda/device/generic symlink. But still, no dev
> node. Is that supposed to work that way?

Olaf,
lk 2.6.0-rc1 has added sysfs support for sg with
/sys/cdev/major/sg<n> . In that directory
is a symlink to the corresponding SCSI device. When that symlink
is followed the target directory has a symlink called 'generic'
back to /sys/cdev/major/sg<n>. The st driver has similar cdev
bidirectional mapping (and hopefully osst will soon follow).

An example is attached. [BTW 'getcwd' returns the "true" path
as described in "man 3 getcwd".]

The "cdev" changes in the sg and st drivers allow more than
256 devices to be handled. The sg driver limits the number
of devices to 8192. I believe sd is still limited to
128 devices and I not sure about the device limits of sr.

Currently the sg driver lacks driver parameter support within sysfs
(e.g. 'allow_dio' as found in the /proc/scsi/sg directory).
Interestingly the st and osst drivers have /sys/bus/scsi/drivers/st
and osst directories (sd and st drivers also get directories if
their drivers are loaded). It is useful to be able to access
ULDs _prior_ to any (scsi) devices being attached which is not
possible under lk 2.4 .

I have been looking at the lsscsi program again which has been
dormant for 6 months. A symlink that I miss is from a scsi host
(enumerated in the /sys/class/scsi_host directory) to the
driver (and its name) that controls it.


BTW Is there a definitive libsysfs site anywhere? I noticed that
scsi_id provided in the "extras" directory of udev-009 doesn't
build with the libsysfs provided by udev-009.

Doug Gilbert




--------------080800000602080808000907
Content-Type: text/plain;
 name="sg_sysfs.txt"
Content-Transfer-Encoding: base64
Content-Disposition: inline;
 filename="sg_sysfs.txt"

IyBjZCAvc3lzL2NkZXYvbWFqb3Ivc2cwCiMgbHMKZGV2aWNlCiMgdHJlZQouCmAtLSBkZXZp
Y2UgLT4gLi4vLi4vLi4vZGV2aWNlcy9wY2kwMDAwOjAwLzAwMDA6MDA6MGUuMC9ob3N0MC8w
OjA6MTowCgoxIGRpcmVjdG9yeSwgMCBmaWxlcwojIGNkIGRldmljZS8KIyBscwpibG9jayAg
IGRldGFjaF9zdGF0ZSAgICBnZW5lcmljICBvbmxpbmUgIHF1ZXVlX2RlcHRoICByZXYgICAg
ICAgICB0eXBlCmRlbGV0ZSAgZGV2aWNlX2Jsb2NrZWQgIG1vZGVsICAgIHBvd2VyICAgcmVz
Y2FuICAgICAgIHNjc2lfbGV2ZWwgIHZlbmRvcgojIGNkIGdlbmVyaWMvCiMgZ2V0Y3dkCi9z
eXMvY2Rldi9tYWpvci9zZzAK
--------------080800000602080808000907--

