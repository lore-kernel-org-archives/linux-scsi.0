From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: Re: crash in pscsi_get_device_type
Date: Wed, 04 Mar 2015 19:56:53 -0800
Message-ID: <1425527813.925.7.camel@haakon3.risingtidesystems.com>
References: <20150226092604.GA1119@aepfle.de>
	 <1425037939.30824.89.camel@haakon3.risingtidesystems.com>
	 <20150304150004.GA22266@aepfle.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail.linux-iscsi.org ([67.23.28.174]:48380 "EHLO
	linux-iscsi.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751086AbbCED4y (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 4 Mar 2015 22:56:54 -0500
In-Reply-To: <20150304150004.GA22266@aepfle.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Olaf Hering <olaf@aepfle.de>
Cc: target-devel@vger.kernel.org, linux-scsi@vger.kernel.org

On Wed, 2015-03-04 at 16:00 +0100, Olaf Hering wrote:
> On Fri, Feb 27, Nicholas A. Bellinger wrote:
> 
> > On Thu, 2015-02-26 at 10:26 +0100, Olaf Hering wrote:
> 
> > > [  145.661468] IP: [<ffffffffa024f17b>] pscsi_get_device_type+0xb/0x20 [target_core_pscsi]
> > Looks like a PSCSI specific NULL pointer dereference when reading the
> > dev_type attribute if a backend device was not able to be successfully
> > configured -> enabled.
> > 
> > Here's a quick patch to address this case.  Please confirm on your end.
> 
> Unfortunately I can not reproduce it anymore. Maybe it depends on the .config?
> 

So the way to reproduce is to read the scsi_lu/dev_type configfs
attribute when a PSCSI backend device has not yet been configured ->
enabled.  Eg:

root@scsi-mq:/usr/src/target-pending.git# modprobe target_core_mod
root@scsi-mq:/usr/src/target-pending.git# mkdir -p /sys/kernel/config/target/core/pscsi_0/foo/
root@scsi-mq:/usr/src/target-pending.git# cat /sys/kernel/config/target/core/pscsi_0/foo/statistics/scsi_lu/dev_type 
Killed

I've confirmed the previous patch addresses this case, which now returns
TYPE_NO_LUN. (0x7f)

root@scsi-mq:/usr/src/target-pending.git# modprobe target_core_mod
root@scsi-mq:/usr/src/target-pending.git# mkdir -p /sys/kernel/config/target/core/pscsi_0/foo
root@scsi-mq:/usr/src/target-pending.git# cat /sys/kernel/config/target/core/pscsi_0/foo/statistics/scsi_lu/dev_type 
127

Queuing up this patch to target-pending/master now, and including a CC'
to stable as well.

Thank you,

--nab

