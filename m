From: "Styner, Douglas W" <douglas.w.styner@intel.com>
Subject: RE: [PATCH] qla2xxx: Fix a regression due to refactoring in
 interrupt handler code
Date: Wed, 29 Apr 2009 11:04:43 -0700
Message-ID: <D7C42C27E6CB1E4D8CBDF2F81EA92A260345A643F9@azsmsx501.amr.corp.intel.com>
References: <D7C42C27E6CB1E4D8CBDF2F81EA92A2603459F44B4@azsmsx501.amr.corp.intel.com>
 <C61D3444.E384%anirban.chakraborty@qlogic.com>
 <D7C42C27E6CB1E4D8CBDF2F81EA92A260345A63FE0@azsmsx501.amr.corp.intel.com>
 <C03D50D6-2441-4AE3-9AD2-24037612BF1C@qlogic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mga01.intel.com ([192.55.52.88]:36241 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753510AbZD2SEr convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 29 Apr 2009 14:04:47 -0400
In-Reply-To: <C03D50D6-2441-4AE3-9AD2-24037612BF1C@qlogic.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Anirban Chakraborty <anirban.chakraborty@qlogic.com>
Cc: "andi@firstfloor.org" <andi@firstfloor.org>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Linux Driver <Linux-Driver@qlogic.com>, "Ma, Chinang" <chinang.ma@intel.com>, "Wilcox, Matthew R" <matthew.r.wilcox@intel.com>, "willy@linux.intel.com" <willy@linux.intel.com>, "Tripathi, Sharad C" <sharad.c.tripathi@intel.com>

Anirban Chakraborty <anirban.chakraborty@qlogic.com> writes 
> Is it possible to find out if the zio mode is turned on. If not, could you > please turn it on and let us know the numbers? You can turn it on by doing > following:
> echo "1" > /sys/class/scsi_host/host<>/zio
We explicit set zio to 1, zio_timer to 200 and qdepth to 48.

> Also, can you let me know the oprofile setup and the tool you used?
Oprofile collection:
chrt -p 48 $$
export PATH=/usr/local/bin:/sbin:$PATH
opcontrol --init
opcontrol --vmlinux=/usr/src/linux-`uname -r`/vmlinux
opcontrol -e=CPU_CLK_UNHALTED:80000
opcontrol --start-daemon
sleep 5
opcontrol --start
sleep 60
opcontrol --stop
opcontrol --save=$1
opcontrol --deinit

We used vtune to compare to oprofile.

