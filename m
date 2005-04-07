From: Douglas Gilbert <dougg@torque.net>
Subject: Re: proc_name in sysfs
Date: Thu, 07 Apr 2005 11:06:03 +1000
Message-ID: <4254877B.4020607@torque.net>
References: <4253CA94.8000500@bull.net> <20050406183614.GA25370@us.ibm.com>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from zorg.st.net.au ([203.16.233.9]:21676 "EHLO borg.st.net.au")
	by vger.kernel.org with ESMTP id S262364AbVDGBKD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Apr 2005 21:10:03 -0400
In-Reply-To: <20050406183614.GA25370@us.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Patrick Mansfield <patmans@us.ibm.com>
Cc: Frederic TEMPORELLI <frederic.temporelli@bull.net>, linux-scsi@vger.kernel.org

Patrick Mansfield wrote:
> On Wed, Apr 06, 2005 at 01:40:04PM +0200, Frederic TEMPORELLI wrote:
> 
> 
>>2/ now, how can we get the adapter module name from sysfs ?
> 
> 
> Why do you need it?
> 
> Anyway, try lsscsi, it walks the sysfs tree:
> 
> [elm3b79 patman]$ lsscsi  -H
> [0]    qla1280
> [1]    qla1280
> [2]    qla2xxx
> [3]    qla2xxx
> 
> Or, script it:
> 
> [elm3b79 tmp]$ more xx.sh
> #! /bin/sh
> 
> hdir=/sys/class/scsi_host
> 
> for i in ${hdir}/host*
> do
>         host_dir=$(cd ${i}/device;/bin/pwd)
>         driver_dir=$(cd ${host_dir}/../driver;/bin/pwd)
>         module=$(basename ${driver_dir})
>         # echo ${i} is in: ${host_dir}
>         echo "${i} module (driver) is: ${module}"
> done
> 
> [elm3b79 tmp]$ sh ./xx.sh
> /sys/class/scsi_host/host0 module (driver) is: qla1280
> /sys/class/scsi_host/host1 module (driver) is: qla1280
> /sys/class/scsi_host/host2 module (driver) is: qla2300
> /sys/class/scsi_host/host3 module (driver) is: qla2300

Patrick,
lsscsi currently uses proc_name so it needs to be
changed to use the above logic (if LLDs are going
to stop populating proc_name).

It has been suggested that I extend lsscsi to show
transport info (as seen from the HBA) found in the
various *_transport directories in sysfs.

Also I have been thinking about ways to list less
tha all scsi devices. For example: "lsscsi 1:0:3:0"
to look at one device and "lsscsi 1:-" for all scsi
devices hanging off host1. I'm not sure whether
"lsscsi /dev/sda" is a good idea. Any suggestions?

Doug Gilbert
