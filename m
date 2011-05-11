From: Andy Grover <agrover@redhat.com>
Subject: Re: rtsadmin-v1.99 BETA packages
Date: Wed, 11 May 2011 09:59:33 -0700
Message-ID: <4DCAC075.5090007@redhat.com>
References: <1304121705.14278.196.camel@haakon2.linux-iscsi.org> <1304553788.10072.241.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:31272 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753701Ab1EKR2r (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 11 May 2011 13:28:47 -0400
In-Reply-To: <1304553788.10072.241.camel@haakon2.linux-iscsi.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: nab@risingtidesystems.com
Cc: Mike Christie <michaelc@cs.wisc.edu>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, James Bottomley <James.Bottomley@suse.de>, Boaz Harrosh <openosd@gmail.com>, "Patil, Kiran" <kiran.patil@intel.com>, "Love, Robert W" <robert.w.love@intel.com>, Madhu Iyengar <madhu.iyengar@qlogic.com>, Andrew Vasquez <andrew.vasquez@qlogic.com>, Jerome Martin <jxm@risingtidesystems.com>, Marc Fleischmann <mwf@risingtidesystems.com>, FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, "J.H." <warthog9@kernel.org>, "H. Peter Anvin" <hpa@zytor.com>, Matthew Wilcox <matthew@wil.cx>, Stefan Hajnoczi <stefanha@gmail.com>, linux-iscsi-target-dev <linux-iscsi-target-dev@googlegroups.com>, linux-scsi@vger.kernel.org

[CCing lists too.]

Hi Nicholas,

Thank you to you, Jerome and RTS for this work!

The rtsadmin-frozen rpm from 04-May-2011 installed ok but didn't seem to
work quite right, but I wouldn't worry about it. I'm working on rpm
packages with proper dependencies for Fedora rawhide, hopefully they'll
be ready within a few days and I can make binary+src rpms available.

Regards -- Andy

On 05/04/2011 05:03 PM, Nicholas A. Bellinger wrote:
> On Fri, 2011-04-29 at 17:01 -0700, Nicholas A. Bellinger wrote:
>> Greetings all,
>>
>> It's my great pleasure to be able to share the initial RTSAdmin v1.99
>> BETA 64-bit userspace packages here:
>>
> 
> Hello again folks,
> 
> Just a few updates on our BETA progress in the last week.  We have
> updated the rtsadmin-v2 frozen and lio-utils packages for Debian Squeeze
> and RHEL6 64-bit userspace here:
> 
> http://www.risingtidesystems.com/rtsadmin-v1.99-BETA/
> 
> This version of lio-utils contains support for tcm_qla2xxx, ib_srpt,
> tcm_fc and loopback fabric modules with the following operations:
> 
> *) rtsadmin-v2 'saveconfig' now creates /etc/target/$FABRICNAME_start.sh
> for active tcm_qla2xxx, ib_srpt, tcm_fc and loopback configurations.
> *) 'service target start' now re-creates the fabric configfs layout
> using available /etc/target/$FABRICNAME_start.sh from currently saved
> fabrics.
> *) 'service target startbak $TIMESTAMP' now re-creates the fabric
> configfs layout via /etc/target/backup/$FABRICNAME_backup-$TIMESTAMP.sh
> from previously saved fabrics.
> *) 'service target stop' will unload the current running configuration
> for all active fabric modules and target core.
> 
> Unfortuately the frozen RPM package is currently having issues running
> with RHEL6-final, so getting up and running on RHEL6 from source takes a
> little bit of effort to manually install the python simpleparse library
> which is currently not packaged for RHEL6.  Instructions for this and
> other distros be added into the rtsadmin-v2 wiki shortly.
> 
> Also, we have setup the public rtsadmin-v2 community repository for
> configshell.git, rtslib.git and rtsadmin.git source repos for those
> interested in having a look at the code:
> 
> http://www.risingtidesystems.com/git/
> 
> Feedback is welcome, and please let us know if you have any issues
> getting setup with the v2 shell.
> 
> --nab
> 
> 
>>
>> So far this is going out to Linux/SCSI community members who are
>> currently using the target core v4.0 + fabric module logic with the
>> default set of 5 specs included in the initial BETA release.
>>
>> We have been testing the .deb builds on Debian Squeeze 64-bit and .rpm
>> builds on RHEL6 64-bit thus far.  On this kernel side, this includes
>> support for the following target core + fabric module configurations:
>>
>> Target v4.x with >= .38 based lio-core-2.6.git code:
>>
>> 	iscsi-target
>>         tcm_loop
>>         tcm_fc(openfcoe)
>>         tcm_qla2xxx
>>         ib_srpt
>>
>> Target v3.5.x out-of-tree lio-core-backports.git code
>>
>>         iscsi-target
>>         tcm_loop
>>
>> The first round of rtsadmin-v2 specific fabric module information has
>> been added into the wiki below.  This includes example usage for
>> configuring Qlogic with demo mode TPG, and IB SRPT using explict SRP
>> Initiator NodeACLs + MappedLUNs along with similar instructions for
>> Open-FCoE.org target, and TCM_Loop LLD driver.
>>
>> http://linux-iscsi.org/wiki/QLogic/rtsadmin-v2
>> http://linux-iscsi.org/wiki/SCSI_RDMA_Protocol/rtsadmin-v2
>> http://linux-iscsi.org/wiki/FCoE/rtsadmin-v2
>> http://linux-iscsi.org/wiki/Tcm_loop/rtsadmin-v2
>>
>> We will be adding more usage examples and tips+tricks into the wiki in
>> the upcoming days, but please feel free to try out the initial packages,
>> and let us know if you have any problems getting setup.  Note there are
>> a handful of items missing from these builds, most notiably being able
>> to save non iscsi-target + tcm_loop fabrics layouts across
>> init.d/target restart.  This will be addressed along with our other
>> remaining items for a follow-up release next week.
>>
>> >From there we will be ironing out remaining bugs and finishing up
>> remaining the TODO list. We intend to release the community version via
>> git source tree and announce the new develpoer and user mailing lists in
>> the upcoming weeks as we more toward a stable v2 release.
>>
>> Also, the 'collapsed tpg' feature has been included in this build based
>> on Tomo's feedback which hides the 'tpgt' by default with non iSCSI
>> fabrics.  This ends up looking like the following with 'ls . 2' (eg: to
>> limit the object output to tree_max_depth=2) with five fabric modules
>> running in mixed-mode on .38.3 code with bare-metal 5600 series
>> hardware:
>>
>> /> ls . 2
>> o-/ ...................................................................... [...]
>>   o-backstores .................................................. [2 Backstores]
>>   | o-iblock0 ............................................... [1 Storage Object]
>>   | o-iblock1 ............................................... [1 Storage Object]
>>   o-ib_srpt ........................................................ [2 Targets]
>>   | o-0x00000000000000000002c903000e8acd ............................. [enabled]
>>   | o-0x00000000000000000002c903000e8ace ............................. [enabled]
>>   o-iscsi ........................................................... [1 Target]
>>   | o-iqn.2003-01.org.linux-iscsi.tifa.x8664:sn.2e732952bb1a ........... [1 TPG]
>>   o-loopback ....................................................... [2 Targets]
>>   | o-naa.6001405c3214b06a .............................. [naa.6001405305bd4088]
>>   | o-naa.6001405d500c6966 .............................. [naa.600140589253c5ee]
>>   o-qla2xxx ........................................................ [2 Targets]
>>   | o-21:00:00:24:ff:31:4c:48 ........................................ [enabled]
>>   | o-21:00:00:24:ff:31:4c:49 ........................................ [enabled]
>>   o-tcm_fc .......................................................... [1 Target]
>>     o-20:00:00:15:17:af:5b:30 ........................................ [enabled]
>> /> 
>>
>> We are very interested to get your feedback on the v2 shell.  Please
>> have a look and let myself and Jerome know if you run into trouble
>> getting installed and running.
>>
>> --nab
>>
> 

