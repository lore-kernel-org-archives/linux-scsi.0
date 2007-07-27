From: "Moore, Eric" <Eric.Moore@lsi.com>
Subject: RE: [PATCH 0/5] mpt fusion: Add logging support
Date: Fri, 27 Jul 2007 16:16:41 -0600
Message-ID: <664A4EBB07F29743873A87CF62C26D708B3D56@NAMAIL4.ad.lsil.com>
References: <1185553272.3655.22.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:48936 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760252AbXG0WQs convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Jul 2007 18:16:48 -0400
Content-class: urn:content-classes:message
In-Reply-To: <1185553272.3655.22.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>, "Prakash, Sathya" <Sathya.Prakash@lsi.com>
Cc: linux-scsi@vger.kernel.org

On Friday, July 27, 2007 10:21 AM, wrote: 
> 
> The way your module parameter works is slightly counter intuitive.  On
> all our other drivers, you can write a value into 
> 
> /sys/module/<module>/parameters/<debug parameter>
> 
> And have it acted on immediately.  In yours, it seems only to work
> before the host is probed (because after that, the value in the ioc
> structure is what's used).

not true,  the debug parameter can be configured prior to the host being
probed.    We have a command line option called mpt_debug_level, that
can set the debug level from mptbase.ko.  That way you can enable
certain debug during probe time prior to the loading of
mptsas/mptfc/mptspi. Once those upper drivers are loaded, you can toggle
off and on the debug via the shost_attrib. This is explained in
mptdebug.h.

> 
> The other question is are you really sure you actually want per host
> debugging?  is the added flexibility in being able to turn it 
> on and off
> per host worth the problems of explaining to the users where 
> to find the
> parameter?  I've got to bet that 95% of the installations only have a
> single fusion card anyway.  would it not be simpler just to have a
> global module parameter that can be set and acted on from 
> /sys/modules?
> 

I like having the added flexibility, and potential customers may agree.
Our driver stack support multiple bus protocols, unlike other vendors,
and some customers may ship fibre, sas, and spi in a single systems..
For my personal use, I like being able to have per host debugging, as I
have multiple cards in my systems.    There are several cases I've
debugged two controller case, when boot OS is on one controller, and the
debug efforts on another, in that case I only want to concern myself
with the debug in question, not boot OS.  The method of debug usesage is
in mptdebug.h, so I would think people would look there, and figure it
out.  I also have a script below that sets all the host debug sas chips.
Does this sound reasonable? If not, let me know.


---[Cut below]---
#!/bin/bash
#set -x
if (( $# != 1 )); then
	echo -e \\n"useage: set_debug_level <level>"
	echo -e \\n
	exit 1
fi

scsi_host="/sys/class/scsi_host"
cd ${scsi_host}
subfolders=`ls -1`
for i in ${subfolders};  do
	cd ${i}
	if [ `cat proc_name` != "mptsas" ]; then
		cd ${scsi_host}
		continue;
	fi;
	echo $1 > debug_level
	debug_level=`cat debug_level`
	echo for ${i} debug_level=$debug_level
	cd ${scsi_host}
done;
---[Cut above]---
