From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: proc_name in sysfs
Date: Wed, 6 Apr 2005 11:36:14 -0700
Message-ID: <20050406183614.GA25370@us.ibm.com>
References: <4253CA94.8000500@bull.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e1.ny.us.ibm.com ([32.97.182.141]:58318 "EHLO e1.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S262279AbVDFSgW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 6 Apr 2005 14:36:22 -0400
Received: from d01relay04.pok.ibm.com (d01relay04.pok.ibm.com [9.56.227.236])
	by e1.ny.us.ibm.com (8.12.11/8.12.11) with ESMTP id j36IaMTE002797
	for <linux-scsi@vger.kernel.org>; Wed, 6 Apr 2005 14:36:22 -0400
Received: from d01av02.pok.ibm.com (d01av02.pok.ibm.com [9.56.224.216])
	by d01relay04.pok.ibm.com (8.12.10/NCO/VER6.6) with ESMTP id j36IaMZW245028
	for <linux-scsi@vger.kernel.org>; Wed, 6 Apr 2005 14:36:22 -0400
Received: from d01av02.pok.ibm.com (loopback [127.0.0.1])
	by d01av02.pok.ibm.com (8.12.11/8.12.11) with ESMTP id j36IaMc0002139
	for <linux-scsi@vger.kernel.org>; Wed, 6 Apr 2005 13:36:22 -0500
Content-Disposition: inline
In-Reply-To: <4253CA94.8000500@bull.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Frederic TEMPORELLI <frederic.temporelli@bull.net>
Cc: linux-scsi@vger.kernel.org

On Wed, Apr 06, 2005 at 01:40:04PM +0200, Frederic TEMPORELLI wrote:

> 2/ now, how can we get the adapter module name from sysfs ?

Why do you need it?

Anyway, try lsscsi, it walks the sysfs tree:

[elm3b79 patman]$ lsscsi  -H
[0]    qla1280
[1]    qla1280
[2]    qla2xxx
[3]    qla2xxx

Or, script it:

[elm3b79 tmp]$ more xx.sh
#! /bin/sh

hdir=/sys/class/scsi_host

for i in ${hdir}/host*
do
        host_dir=$(cd ${i}/device;/bin/pwd)
        driver_dir=$(cd ${host_dir}/../driver;/bin/pwd)
        module=$(basename ${driver_dir})
        # echo ${i} is in: ${host_dir}
        echo "${i} module (driver) is: ${module}"
done

[elm3b79 tmp]$ sh ./xx.sh
/sys/class/scsi_host/host0 module (driver) is: qla1280
/sys/class/scsi_host/host1 module (driver) is: qla1280
/sys/class/scsi_host/host2 module (driver) is: qla2300
/sys/class/scsi_host/host3 module (driver) is: qla2300

-- Patrick Mansfield
