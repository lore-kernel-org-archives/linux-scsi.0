From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: [PATCH] serialize bus scanning
Date: Thu, 11 Sep 2003 13:34:19 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030911133419.A10316@beaverton.ibm.com>
References: <20030825122416.GE15506@lst.de> <20030827202908.GB7852@krispykreme> <20030827203544.GA27020@lst.de> <20030910075741.GC1532@krispykreme>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="tsOsTdHNUZQcU9Ye"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e5.ny.us.ibm.com ([32.97.182.105]:50335 "EHLO e5.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S261498AbTIKUe4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 11 Sep 2003 16:34:56 -0400
Content-Disposition: inline
In-Reply-To: <20030910075741.GC1532@krispykreme>; from anton@samba.org on Wed, Sep 10, 2003 at 05:57:42PM +1000
List-Id: linux-scsi@vger.kernel.org
To: Anton Blanchard <anton@samba.org>
Cc: Christoph Hellwig <hch@lst.de>, James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org


--tsOsTdHNUZQcU9Ye
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Wed, Sep 10, 2003 at 05:57:42PM +1000, Anton Blanchard wrote:
> 
> How does this look? This restores the ability to do parallel scsi scan
> via sysfs.
> 

The patch looks fine to me, I hope James will apply it.

I think we might still have to allow only a scan or delete (per host), and
not both in parallel - it looks like we could have some races otherwise,
I'm not sure though (mainly where the driver model points to the parent
device). Maybe a get of the host device during scanning is enough.

I tested it out, and ran some timings pre and post-patch, mainly out of
curiousity.

I have:

[root@elm3b79 root]# ls -1d /sysfs/bus/scsi/devices/[01]* | wc
      6       6     192
[root@elm3b79 root]# ls -1d /sysfs/bus/scsi/devices/[2-5]* | wc
    288     288    9428

Really 72 separate LUNs attached to qlogic 2310 (FCP) host adapters (hosts
2-5), each with four paths. 40 disk drives (10 on a loop per enclosure),
plus 32 LUNs connected to a disk array. All attached to a 1Gb switch.

I ran a simple script (attached) to scan via sysfs in parallel. Of course
without the patch scanning is serialized.

System is a 8 cpu (two node) NUMAQ.

--------------------------------------------
Before the patch:

Rescanning the four qlogic adapters without finding any new devices,
seemed to vary up to about 34 seconds:

[root@elm3b79 root]# time ./scanall.sh > xx

real    0m31.947s
user    0m0.007s
sys     0m0.113s

Rescan in parallel re-discovering all devices:

[root@elm3b79 root]# time ./scanall.sh  > xx

real    0m34.189s
user    0m0.009s
sys     0m0.615s

--------------------------------------------
With the patch:

Generally went from 34 seconds down to 9.

Rescanning the four qlogic adapters without finding any new devices:

[root@elm3b79 root]# time ./scanall.sh > xx

real    0m8.057s
user    0m0.007s
sys     0m0.120s

Rescan in parallel re-discovering all devices:

[root@elm3b79 root]# time ./scanall.sh > xx

real    0m9.608s
user    0m0.008s
sys     0m0.783s

-----------------------------------------------------------

Also: time to sequentially remove all devices (on host 2-5, patch does not
matter but I find this interesting):

time ./delall.sh > xx

real    0m7.276s
user    0m0.823s
sys     0m3.106s

And time to remove in parallel

[root@elm3b79 root]# time ./delall.sh > xx 
real    0m4.586s
user    0m1.336s
sys     0m7.204s

-- Patrick Mansfield

--tsOsTdHNUZQcU9Ye
Content-Type: application/x-sh
Content-Disposition: attachment; filename="scanall.sh"

#! /bin/sh

SYSFS=/sysfs
# SCANUM="${SYSFS}/class/scsi_host/*/scan"
SCANUM="${SYSFS}/class/scsi_host/host[2-5]/scan"
# SCANUM="${SYSFS}/class/scsi_host/host?/scan"

for S in ${SCANUM}
do
	(
	echo ${S}
	echo "- - -" > ${S}
	) &
done

wait

--tsOsTdHNUZQcU9Ye
Content-Type: application/x-sh
Content-Disposition: attachment; filename="delall.sh"

#! /bin/sh

SYSFS=/sysfs
DEVS=
DEVS="${SYSFS}/bus/scsi/devices/[2-5]*"
# SCANUM="${SYSFS}/class/scsi_host/host?/scan"

for D in ${DEVS}
do
	(
	ls ${D}/delete
	echo foo > ${D}/delete
	) &
done

wait

--tsOsTdHNUZQcU9Ye--
