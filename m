From: Duane Grigsby <duane.grigsby@qlogic.com>
Subject: Re: [Scst-devel] New qla2x00tgt Driver Question
Date: Wed, 3 Dec 2014 23:38:17 +0000
Message-ID: <2D7BBED629475F4BAA85CF6AB9702F1301088065E1@AVMB1.qlogic.org>
References: <duane.grigsby@qlogic.com>
 <201412032046.sB3Kkx7l028625@wind.enjellic.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_000_2D7BBED629475F4BAA85CF6AB9702F1301088065E1AVMB1qlogicor_"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:3314 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751382AbaLCXiU (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Dec 2014 18:38:20 -0500
Received: from pps.filterd (m0045602.ppops.net [127.0.0.1])
	by mx0a-0016ce01.pphosted.com (8.14.5/8.14.5) with SMTP id sB3NYTJR005448
	for <linux-scsi@vger.kernel.org>; Wed, 3 Dec 2014 15:38:20 -0800
Received: from avcashub1.qlogic.com (avcashub3.qlogic.com [198.70.193.117])
	by mx0a-0016ce01.pphosted.com with ESMTP id 1r19p5tkh8-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 03 Dec 2014 15:38:19 -0800
In-Reply-To: <201412032046.sB3Kkx7l028625@wind.enjellic.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "greg@enjellic.com" <greg@enjellic.com>, Marc Smith <marc.smith@mcc.edu>, scst-devel <scst-devel@lists.sourceforge.net>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

--_000_2D7BBED629475F4BAA85CF6AB9702F1301088065E1AVMB1qlogicor_
Content-Type: text/plain; charset="Windows-1252"
Content-ID: <2B9A6F54CD684E47B01E686172999A88@qlogic.com>
Content-Transfer-Encoding: quoted-printable

Hi Greg,
I looked at your logs and also reviewed the PLOGI handling in
Trunk-SCST.15. We found a issue with PLOGI/PRLI cleanup handling that I=B9m
addressing. Whatever fixes will get pushed upstream with the qla2xxx and
scst-qla2xxx.git.

=8Bduane

On 12/3/14, 12:46 PM, "Dr. Greg Wettstein" <greg@wind.enjellic.com> wrote:

>On Nov 30,  4:00pm, Duane Grigsby wrote:
>} Subject: Re: [Scst-devel] New qla2x00tgt Driver Question
>
>Hi, Ihope the week is going well for everyone.
>
>I've significantly cut information out of this in order to simplify
>the mail.
>
>Duane, I had forwarded logs from previous testing to you on Monday and
>hadn't received any response, I wanted to make sure you had received
>that mail.
>
>Secondly, Vlad, we have been running additional testing for the last
>two days and we have logs from the SCST core which I am including
>below which suggests that the SCST core target code excessively stalls
>or mishandles an ABORT while processing a NEXUS_LOSS_SESS TMF.
>Regardless of your feelings about the target driver code in the kernel
>we need to make sure there is not some subtle regression in the core
>SCST code paths during TMF processing.
>
>To NAB and company, regardless of your feelings about the SCST target
>core if there are issues with the in-kernel Qlogic target driver we
>are running your code so if there are issues it affects your stack as
>well.
>
>> Yes, it may be related. It has to do with receiving a PLOGI from an
>> initiator with the same port_id, but a different WWPN. Can you send me
>> your complete driver log?
>>
>> Hi Greg, Yes, I think there may be a issue there, but let me look at
>> your logs.
>
>Since we need to get to the bottom of this we've spent the week
>putting the testing harnesses back in place so we can feed
>reproducible data back to the lists and to Qlogic.  We just completed
>the first run of tests which we have thoroughly documented so that we
>know exactly what went into producing these issues.
>
>These tests are run in a multi-datacenter/multi-hop Cisco Nexus FCOE
>fabric.  Some of this may be related to that environment and if that
>is the case we will figure out how to engage further on that front but
>we need to fully understand if the behavior we are seeing out of the
>Qlogic target driver is anomalous.
>
>All testing is being done against a 3.10.57 Linux kernel with a
>handful of patches backported to the Qlogic target driver from later
>kernels.  The target server is running SCST 3.0.x with a Qlogic
>QLE-8362 CNA.  The backing storage is a 30 gigabyte RAM based block
>device using our HPD driver.  We will post a complete kernel diff to
>our FTP server so the kernel can be reproduced.  The target server is
>attached to a Nexus 7009 storage VDC.
>
>The first round of testing was from a Linux 3.10.55 initiator using a
>QLE-2462 HBA.  That initiator is attached to a Nexus 5596 which is
>upstreamed into a Nexus 7010 storage VDC.  That storage VDC has a 20
>GBPS dual-interface ISL to the Nexus 7009 VDC in the second
>data-center.
>
>The Qlogic driver was loaded as a module, along with the target
>interface driver, into the kernel which had SCST statically built into
>it.  The Qlogic driver command line which was used is as follows:
>
>ql2xextended_error_logging=3D0x00003000
>
>The driver was loaded and the SCST storage stack was configured with
>the virtual fibre-channel interface to the target disabled.  After the
>storage stack was completely configured and target mode enabled on the
>interface the switch interface to the target was enabled.
>
>The following is the output from the Qlogic target driver as it
>processed the fabric events which were generated by its entry into the
>fabric:
>
>--------------------------------------------------------------------------
>-
>Dec  2 03:13:53 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83b:9:
>qla_target(0): Async LOOP_UP occurred (m[0]=3D8011, m[1]=3D13, m[2]=3D44ef=
,
>m[3]=3D0)
>Dec  2 03:13:53 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-505f:9:
>Link is operational (10 Gbps).
>Dec  2 03:13:53 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9:
>qla_target(0): Port update async event 0x8014 occurred: updating the
>ports database (m[0]=3D8014, m[1]=3Dffff, m[2]=3D6, m[3]=3D0)
>Dec  2 03:13:53 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9:
>qla_target(0): Port update async event 0x8014 occurred: updating the
>ports database (m[0]=3D8014, m[1]=3Dffff, m[2]=3D6, m[3]=3D0)<4>qla2xxx
>[0000:02:00.3]-f826:9: qla_target(0): Port ID: 0x0e:fc:ff ELS opcode: 0x03
>Dec  2 03:13:53 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9:
>qla_target(0): Port update async event 0x8014 occurred: updating the
>ports database (m[0]=3D8014, m[1]=3D0, m[2]=3D4, m[3]=3D600)
>Dec  2 03:13:53 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83e:9:
>Async MB 2: Got PLOGI Complete
>Dec  2 03:13:53 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9:
>qla_target(0): Port update async event 0x8014 occurred: updating the
>ports database (m[0]=3D8014, m[1]=3D0, m[2]=3D4, m[3]=3D600)
>Dec  2 03:13:53 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83e:9:
>Async MB 2: Got PLOGI Complete
>Dec  2 03:13:53 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f826:9:
>qla_target(0): Port ID: 0x71:fc:ff ELS opcode: 0x03
>Dec  2 03:13:53 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f826:9:
>qla_target(0): Port ID: 0x45:fc:ff ELS opcode: 0x03
>Dec  2 03:13:53 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f826:9:
>qla_target(0): Port ID: 0x0e:fc:ff ELS opcode: 0x20
>Dec  2 03:13:53 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9:
>qla_target(0): Port update async event 0x8014 occurred: updating the
>ports database (m[0]=3D8014, m[1]=3D1, m[2]=3D4, m[3]=3D600)
>Dec  2 03:13:53 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83e:9:
>Async MB 2: Got PLOGI Complete
>Dec  2 03:13:53 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9:
>qla_target(0): Port update async event 0x8014 occurred: updating the
>ports database (m[0]=3D8014, m[1]=3D1, m[2]=3D4, m[3]=3D600)
>Dec  2 03:13:53 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83e:9:
>Async MB 2: Got PLOGI Complete
>Dec  2 03:13:53 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9:
>qla_target(0): Port update async event 0x8014 occurred: updating the
>ports database (m[0]=3D8014, m[1]=3D2, m[2]=3D4, m[3]=3D600)
>Dec  2 03:13:53 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83e:9:
>Async MB 2: Got PLOGI Complete
>Dec  2 03:13:53 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9:
>qla_target(0): Port update async event 0x8014 occurred: updating the
>ports database (m[0]=3D8014, m[1]=3D2, m[2]=3D4, m[3]=3D600)
>Dec  2 03:13:53 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83e:9:
>Async MB 2: Got PLOGI Complete
>Dec  2 03:13:53 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9:
>qla_target(0): Port update async event 0x8014 occurred: updating the
>ports database (m[0]=3D8014, m[1]=3D0, m[2]=3D4, m[3]=3Da00)
>Dec  2 03:13:53 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83e:9:
>Async MB 2: Got PLOGI Complete
>Dec  2 03:13:53 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9:
>qla_target(0): Port update async event 0x8014 occurred: updating the
>ports database (m[0]=3D8014, m[1]=3D0, m[2]=3D4, m[3]=3Da00)
>Dec  2 03:13:53 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83e:9:
>Async MB 2: Got PLOGI Complete
>Dec  2 03:13:53 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f826:9:
>qla_target(0): Port ID: 0x71:fc:ff ELS opcode: 0x20
>Dec  2 03:13:53 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f826:9:
>qla_target(0): Port ID: 0x45:fc:ff ELS opcode: 0x20
>Dec  2 03:13:53 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f826:9:
>qla_target(0): Port ID: 0x0e:fc:ff ELS opcode: 0x21
>Dec  2 03:13:53 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9:
>qla_target(0): Port update async event 0x8014 occurred: updating the
>ports database (m[0]=3D8014, m[1]=3D1, m[2]=3D4, m[3]=3Da00)
>Dec  2 03:13:53 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83e:9:
>Async MB 2: Got PLOGI Complete
>Dec  2 03:13:53 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9:
>qla_target(0): Port update async event 0x8014 occurred: updating the
>ports database (m[0]=3D8014, m[1]=3D1, m[2]=3D4, m[3]=3Da00)
>Dec  2 03:13:53 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83e:9:
>Async MB 2: Got PLOGI Complete
>Dec  2 03:13:53 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f826:9:
>qla_target(0): Port ID: 0x71:fc:ff ELS opcode: 0x21
>Dec  2 03:13:53 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9:
>qla_target(0): Port update async event 0x8014 occurred: updating the
>ports database (m[0]=3D8014, m[1]=3D2, m[2]=3D4, m[3]=3Da00)
>Dec  2 03:13:53 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83e:9:
>Async MB 2: Got PLOGI Complete
>Dec  2 03:13:53 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9:
>qla_target(0): Port update async event 0x8014 occurred: updating the
>ports database (m[0]=3D8014, m[1]=3D2, m[2]=3D4, m[3]=3Da00)
>Dec  2 03:13:53 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83e:9:
>Async MB 2: Got PLOGI Complete
>Dec  2 03:13:53 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f826:9:
>qla_target(0): Port ID: 0x45:fc:ff ELS opcode: 0x21
>Dec  2 03:13:53 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9:
>qla_target(0): Port update async event 0x8014 occurred: updating the
>ports database (m[0]=3D8014, m[1]=3D0, m[2]=3D7, m[3]=3Db00)
>Dec  2 03:13:53 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83f:9:
>Async MB 2: Port Logged Out
>Dec  2 03:13:53 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9:
>qla_target(0): Port update async event 0x8014 occurred: updating the
>ports database (m[0]=3D8014, m[1]=3D0, m[2]=3D7, m[3]=3Db00)
>Dec  2 03:13:53 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83f:9:
>Async MB 2: Port Logged Out
>Dec  2 03:13:53 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9:
>qla_target(0): Port update async event 0x8014 occurred: updating the
>ports database (m[0]=3D8014, m[1]=3D1, m[2]=3D7, m[3]=3Db00)
>Dec  2 03:13:53 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83f:9:
>Async MB 2: Port Logged Out
>Dec  2 03:13:53 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9:
>qla_target(0): Port update async event 0x8014 occurred: updating the
>ports database (m[0]=3D8014, m[1]=3D1, m[2]=3D7, m[3]=3Db00)
>Dec  2 03:13:53 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83f:9:
>Async MB 2: Port Logged Out
>Dec  2 03:13:53 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f826:9:
>qla_target(0): Port ID: 0x0e:fc:ff ELS opcode: 0x05
>Dec  2 03:13:54 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f826:9:
>qla_target(0): Port ID: 0x71:fc:ff ELS opcode: 0x05
>Dec  2 03:13:54 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f826:9:
>qla_target(0): Port ID: 0x0e:fc:ff ELS opcode: 0x03
>Dec  2 03:13:54 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f826:9:
>qla_target(0): Port ID: 0x71:fc:ff ELS opcode: 0x03
>Dec  2 03:13:54 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9:
>qla_target(0): Port update async event 0x8014 occurred: updating the
>ports database (m[0]=3D8014, m[1]=3D1, m[2]=3D4, m[3]=3D600)
>Dec  2 03:13:54 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83e:9:
>Async MB 2: Got PLOGI Complete
>Dec  2 03:13:54 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9:
>qla_target(0): Port update async event 0x8014 occurred: updating the
>ports database (m[0]=3D8014, m[1]=3D1, m[2]=3D4, m[3]=3D600)
>Dec  2 03:13:54 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83e:9:
>Async MB 2: Got PLOGI Complete
>Dec  2 03:13:54 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f826:9:
>qla_target(0): Port ID: 0x71:fc:ff ELS opcode: 0x20
>Dec  2 03:13:54 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f826:9:
>qla_target(0): Port ID: 0x45:fc:ff ELS opcode: 0x05
>Dec  2 03:13:54 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f826:9:
>qla_target(0): Port ID: 0x0e:fc:ff ELS opcode: 0x20
>Dec  2 03:13:54 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9:
>qla_target(0): Port update async event 0x8014 occurred: updating the
>ports database (m[0]=3D8014, m[1]=3D2, m[2]=3D7, m[3]=3Db00)
>Dec  2 03:13:54 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83f:9:
>Async MB 2: Port Logged Out
>Dec  2 03:13:54 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9:
>qla_target(0): Port update async event 0x8014 occurred: updating the
>ports database (m[0]=3D8014, m[1]=3D2, m[2]=3D7, m[3]=3Db00)
>Dec  2 03:13:54 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83f:9:
>Async MB 2: Port Logged Out
>Dec  2 03:13:54 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9:
>qla_target(0): Port update async event 0x8014 occurred: updating the
>ports database (m[0]=3D8014, m[1]=3D0, m[2]=3D4, m[3]=3D600)
>Dec  2 03:13:54 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83e:9:
>Async MB 2: Got PLOGI Complete
>Dec  2 03:13:54 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9:
>qla_target(0): Port update async event 0x8014 occurred: updating the
>ports database (m[0]=3D8014, m[1]=3D0, m[2]=3D4, m[3]=3D600)
>Dec  2 03:13:54 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83e:9:
>Async MB 2: Got PLOGI Complete
>Dec  2 03:13:54 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f826:9:
>qla_target(0): Port ID: 0x45:fc:ff ELS opcode: 0x03
>Dec  2 03:13:54 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9:
>qla_target(0): Port update async event 0x8014 occurred: updating the
>ports database (m[0]=3D8014, m[1]=3D1, m[2]=3D4, m[3]=3Da00)
>Dec  2 03:13:54 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83e:9:
>Async MB 2: Got PLOGI Complete
>Dec  2 03:13:54 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9:
>qla_target(0): Port update async event 0x8014 occurred: updating the
>ports database (m[0]=3D8014, m[1]=3D1, m[2]=3D4, m[3]=3Da00)
>Dec  2 03:13:54 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83e:9:
>Async MB 2: Got PLOGI Complete
>Dec  2 03:13:54 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f826:9:
>qla_target(0): Port ID: 0x71:fc:ff ELS opcode: 0x21
>Dec  2 03:13:54 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9:
>qla_target(0): Port update async event 0x8014 occurred: updating the
>ports database (m[0]=3D8014, m[1]=3D0, m[2]=3D4, m[3]=3Da00)
>Dec  2 03:13:54 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83e:9:
>Async MB 2: Got PLOGI Complete
>Dec  2 03:13:54 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9:
>qla_target(0): Port update async event 0x8014 occurred: updating the
>ports database (m[0]=3D8014, m[1]=3D0, m[2]=3D4, m[3]=3Da00)
>Dec  2 03:13:54 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83e:9:
>Async MB 2: Got PLOGI Complete
>Dec  2 03:13:54 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f826:9:
>qla_target(0): Port ID: 0x0e:fc:ff ELS opcode: 0x21
>Dec  2 03:13:54 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f826:9:
>qla_target(0): Port ID: 0x45:fc:ff ELS opcode: 0x20
>Dec  2 03:13:54 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9:
>qla_target(0): Port update async event 0x8014 occurred: updating the
>ports database (m[0]=3D8014, m[1]=3D2, m[2]=3D4, m[3]=3D600)
>Dec  2 03:13:54 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83e:9:
>Async MB 2: Got PLOGI Complete
>Dec  2 03:13:54 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9:
>qla_target(0): Port update async event 0x8014 occurred: updating the
>ports database (m[0]=3D8014, m[1]=3D2, m[2]=3D4, m[3]=3D600)
>Dec  2 03:13:54 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83e:9:
>Async MB 2: Got PLOGI Complete
>Dec  2 03:13:54 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9:
>qla_target(0): Port update async event 0x8014 occurred: updating the
>ports database (m[0]=3D8014, m[1]=3D1, m[2]=3D7, m[3]=3Db00)
>Dec  2 03:13:54 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83f:9:
>Async MB 2: Port Logged Out
>Dec  2 03:13:54 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9:
>qla_target(0): Port update async event 0x8014 occurred: updating the
>ports database (m[0]=3D8014, m[1]=3D1, m[2]=3D7, m[3]=3Db00)
>Dec  2 03:13:54 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83f:9:
>Async MB 2: Port Logged Out
>Dec  2 03:13:54 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9:
>qla_target(0): Port update async event 0x8014 occurred: updating the
>ports database (m[0]=3D8014, m[1]=3D2, m[2]=3D4, m[3]=3Da00)
>Dec  2 03:13:54 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83e:9:
>Async MB 2: Got PLOGI Complete
>Dec  2 03:13:54 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9:
>qla_target(0): Port update async event 0x8014 occurred: updating the
>ports database (m[0]=3D8014, m[1]=3D2, m[2]=3D4, m[3]=3Da00)
>Dec  2 03:13:54 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83e:9:
>Async MB 2: Got PLOGI Complete
>Dec  2 03:13:54 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f826:9:
>qla_target(0): Port ID: 0x71:fc:ff ELS opcode: 0x05
>Dec  2 03:13:54 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f826:9:
>qla_target(0): Port ID: 0x45:fc:ff ELS opcode: 0x21
>Dec  2 03:13:54 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9:
>qla_target(0): Port update async event 0x8014 occurred: updating the
>ports database (m[0]=3D8014, m[1]=3D0, m[2]=3D7, m[3]=3Db00)
>Dec  2 03:13:54 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83f:9:
>Async MB 2: Port Logged Out
>Dec  2 03:13:54 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9:
>qla_target(0): Port update async event 0x8014 occurred: updating the
>ports database (m[0]=3D8014, m[1]=3D0, m[2]=3D7, m[3]=3Db00)
>Dec  2 03:13:54 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83f:9:
>Async MB 2: Port Logged Out
>Dec  2 03:13:54 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f826:9:
>qla_target(0): Port ID: 0x0e:fc:ff ELS opcode: 0x05
>Dec  2 03:13:54 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9:
>qla_target(0): Port update async event 0x8014 occurred: updating the
>ports database (m[0]=3D8014, m[1]=3D2, m[2]=3D7, m[3]=3Db00)
>Dec  2 03:13:54 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83f:9:
>Async MB 2: Port Logged Out
>Dec  2 03:13:54 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9:
>qla_target(0): Port update async event 0x8014 occurred: updating the
>ports database (m[0]=3D8014, m[1]=3D2, m[2]=3D7, m[3]=3Db00)
>Dec  2 03:13:54 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83f:9:
>Async MB 2: Port Logged Out
>Dec  2 03:13:54 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f826:9:
>qla_target(0): Port ID: 0x45:fc:ff ELS opcode: 0x05
>Dec  2 03:13:54 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f806:9:
>Adding sess ffff88081a962d80 to tgt ffff880819f53c00 via
>->check_initiator_node_acl()
>Dec  2 03:13:54 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f84b:9:
>qla_target(0): session for wwn 21:01:00:e0:8b:a6:d1:9f (loop_id 3, s_id
>45:2:0, confirmed completion not supported) added
>Dec  2 03:13:54 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f806:9:
>Adding sess ffff88081a962180 to tgt ffff880819f53c00 via
>->check_initiator_node_acl()
>Dec  2 03:13:54 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f84b:9:
>qla_target(0): session for wwn 21:00:00:0e:1e:31:83:5f (loop_id 4, s_id
>e:0:0, confirmed completion not supported) added
>Dec  2 03:13:54 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f826:9:
>qla_target(0): Port ID: 0x71:fc:ff ELS opcode: 0x03
>Dec  2 03:13:54 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f826:9:
>qla_target(0): Port ID: 0x45:fc:ff ELS opcode: 0x03
>Dec  2 03:13:54 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f826:9:
>qla_target(0): Port ID: 0x0e:fc:ff ELS opcode: 0x03
>Dec  2 03:13:54 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9:
>qla_target(0): Port update async event 0x8014 occurred: updating the
>ports database (m[0]=3D8014, m[1]=3D1, m[2]=3D4, m[3]=3D600)
>Dec  2 03:13:54 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83e:9:
>Async MB 2: Got PLOGI Complete
>Dec  2 03:13:54 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9:
>qla_target(0): Port update async event 0x8014 occurred: updating the
>ports database (m[0]=3D8014, m[1]=3D1, m[2]=3D4, m[3]=3D600)
>Dec  2 03:13:54 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83e:9:
>Async MB 2: Got PLOGI Complete
>Dec  2 03:13:54 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f826:9:
>qla_target(0): Port ID: 0x71:fc:ff ELS opcode: 0x20
>Dec  2 03:13:54 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9:
>qla_target(0): Port update async event 0x8014 occurred: updating the
>ports database (m[0]=3D8014, m[1]=3D2, m[2]=3D4, m[3]=3D600)
>Dec  2 03:13:54 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83e:9:
>Async MB 2: Got PLOGI Complete
>Dec  2 03:13:54 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9:
>qla_target(0): Port update async event 0x8014 occurred: updating the
>ports database (m[0]=3D8014, m[1]=3D2, m[2]=3D4, m[3]=3D600)
>Dec  2 03:13:54 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83e:9:
>Async MB 2: Got PLOGI Complete
>Dec  2 03:13:54 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f826:9:
>qla_target(0): Port ID: 0x45:fc:ff ELS opcode: 0x20
>Dec  2 03:13:54 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9:
>qla_target(0): Port update async event 0x8014 occurred: updating the
>ports database (m[0]=3D8014, m[1]=3D0, m[2]=3D4, m[3]=3D600)
>Dec  2 03:13:54 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83e:9:
>Async MB 2: Got PLOGI Complete
>Dec  2 03:13:54 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9:
>qla_target(0): Port update async event 0x8014 occurred: updating the
>ports database (m[0]=3D8014, m[1]=3D0, m[2]=3D4, m[3]=3D600)
>Dec  2 03:13:54 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83e:9:
>Async MB 2: Got PLOGI Complete
>Dec  2 03:13:54 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9:
>qla_target(0): Port update async event 0x8014 occurred: updating the
>ports database (m[0]=3D8014, m[1]=3D1, m[2]=3D4, m[3]=3Da00)
>Dec  2 03:13:54 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83e:9:
>Async MB 2: Got PLOGI Complete
>Dec  2 03:13:54 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9:
>qla_target(0): Port update async event 0x8014 occurred: updating the
>ports database (m[0]=3D8014, m[1]=3D1, m[2]=3D4, m[3]=3Da00)
>Dec  2 03:13:54 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83e:9:
>Async MB 2: Got PLOGI Complete
>Dec  2 03:13:54 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f826:9:
>qla_target(0): Port ID: 0x0e:fc:ff ELS opcode: 0x20
>Dec  2 03:13:54 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f826:9:
>qla_target(0): Port ID: 0x71:fc:ff ELS opcode: 0x21
>Dec  2 03:13:54 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9:
>qla_target(0): Port update async event 0x8014 occurred: updating the
>ports database (m[0]=3D8014, m[1]=3D2, m[2]=3D4, m[3]=3Da00)
>Dec  2 03:13:54 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83e:9:
>Async MB 2: Got PLOGI Complete
>Dec  2 03:13:54 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9:
>qla_target(0): Port update async event 0x8014 occurred: updating the
>ports database (m[0]=3D8014, m[1]=3D2, m[2]=3D4, m[3]=3Da00)
>Dec  2 03:13:54 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83e:9:
>Async MB 2: Got PLOGI Complete
>Dec  2 03:13:54 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f826:9:
>qla_target(0): Port ID: 0x45:fc:ff ELS opcode: 0x21
>Dec  2 03:13:54 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9:
>qla_target(0): Port update async event 0x8014 occurred: updating the
>ports database (m[0]=3D8014, m[1]=3D0, m[2]=3D4, m[3]=3Da00)
>Dec  2 03:13:54 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83e:9:
>Async MB 2: Got PLOGI Complete
>Dec  2 03:13:54 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9:
>qla_target(0): Port update async event 0x8014 occurred: updating the
>ports database (m[0]=3D8014, m[1]=3D0, m[2]=3D4, m[3]=3Da00)
>Dec  2 03:13:54 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83e:9:
>Async MB 2: Got PLOGI Complete
>Dec  2 03:13:54 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f826:9:
>qla_target(0): Port ID: 0x0e:fc:ff ELS opcode: 0x21
>Dec  2 03:13:54 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9:
>qla_target(0): Port update async event 0x8014 occurred: updating the
>ports database (m[0]=3D8014, m[1]=3D1, m[2]=3D7, m[3]=3Db00)
>Dec  2 03:13:54 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83f:9:
>Async MB 2: Port Logged Out
>Dec  2 03:13:54 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9:
>qla_target(0): Port update async event 0x8014 occurred: updating the
>ports database (m[0]=3D8014, m[1]=3D1, m[2]=3D7, m[3]=3Db00)
>Dec  2 03:13:54 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83f:9:
>Async MB 2: Port Logged Out
>Dec  2 03:13:54 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f826:9:
>qla_target(0): Port ID: 0x71:fc:ff ELS opcode: 0x05
>Dec  2 03:13:54 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9:
>qla_target(0): Port update async event 0x8014 occurred: updating the
>ports database (m[0]=3D8014, m[1]=3D2, m[2]=3D7, m[3]=3Db00)
>Dec  2 03:13:54 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83f:9:
>Async MB 2: Port Logged Out
>Dec  2 03:13:54 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9:
>qla_target(0): Port update async event 0x8014 occurred: updating the
>ports database (m[0]=3D8014, m[1]=3D2, m[2]=3D7, m[3]=3Db00)
>Dec  2 03:13:54 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83f:9:
>Async MB 2: Port Logged Out
>Dec  2 03:13:54 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f826:9:
>qla_target(0): Port ID: 0x45:fc:ff ELS opcode: 0x05
>Dec  2 03:13:54 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9:
>qla_target(0): Port update async event 0x8014 occurred: updating the
>ports database (m[0]=3D8014, m[1]=3D0, m[2]=3D7, m[3]=3Db00)
>Dec  2 03:13:54 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83f:9:
>Async MB 2: Port Logged Out
>Dec  2 03:13:54 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9:
>qla_target(0): Port update async event 0x8014 occurred: updating the
>ports database (m[0]=3D8014, m[1]=3D0, m[2]=3D7, m[3]=3Db00)
>Dec  2 03:13:54 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83f:9:
>Async MB 2: Port Logged Out
>Dec  2 03:13:54 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f826:9:
>qla_target(0): Port ID: 0x0e:fc:ff ELS opcode: 0x05
>Dec  2 03:13:56 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f826:9:
>qla_target(0): Port ID: 0x00:02:45 ELS opcode: 0x03
>Dec  2 03:13:56 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-10807:9:
>qla_target(0): Doing NEXUS_LOSS_SESS
>Dec  2 03:13:56 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f813:9: TM
>response mcmd (ffff88101a6c61a8) status 0x0 state 0x1
>Dec  2 03:13:56 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9:
>qla_target(0): Port update async event 0x8014 occurred: updating the
>ports database (m[0]=3D8014, m[1]=3D3, m[2]=3D4, m[3]=3D600)
>Dec  2 03:13:56 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83e:9:
>Async MB 2: Got PLOGI Complete
>Dec  2 03:13:56 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9:
>qla_target(0): Port update async event 0x8014 occurred: updating the
>ports database (m[0]=3D8014, m[1]=3D3, m[2]=3D4, m[3]=3D600)
>Dec  2 03:13:56 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83e:9:
>Async MB 2: Got PLOGI Complete
>Dec  2 03:13:56 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f826:9:
>qla_target(0): Port ID: 0x00:02:45 ELS opcode: 0x20
>Dec  2 03:13:56 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-10807:9:
>qla_target(0): Doing NEXUS_LOSS_SESS
>Dec  2 03:13:57 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f813:9: TM
>response mcmd (ffff88101a6c61a8) status 0x0 state 0x1
>Dec  2 03:13:57 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f826:9:
>qla_target(0): Port ID: 0x00:00:0e ELS opcode: 0x03
>Dec  2 03:13:57 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-10807:9:
>qla_target(0): Doing NEXUS_LOSS_SESS
>Dec  2 03:13:57 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f813:9: TM
>response mcmd (ffff88101a6c61a8) status 0x0 state 0x1
>Dec  2 03:13:57 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9:
>qla_target(0): Port update async event 0x8014 occurred: updating the
>ports database (m[0]=3D8014, m[1]=3D4, m[2]=3D4, m[3]=3D600)
>Dec  2 03:13:57 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83e:9:
>Async MB 2: Got PLOGI Complete
>Dec  2 03:13:57 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9:
>qla_target(0): Port update async event 0x8014 occurred: updating the
>ports database (m[0]=3D8014, m[1]=3D4, m[2]=3D4, m[3]=3D600)
>Dec  2 03:13:57 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83e:9:
>Async MB 2: Got PLOGI Complete
>Dec  2 03:13:57 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f826:9:
>qla_target(0): Port ID: 0x00:00:0e ELS opcode: 0x20
>Dec  2 03:13:57 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-10807:9:
>qla_target(0): Doing NEXUS_LOSS_SESS
>Dec  2 03:13:57 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f813:9: TM
>response mcmd (ffff88101a6c61a8) status 0x0 state 0x1
>Dec  2 03:13:57 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f826:9:
>qla_target(0): Port ID: 0x00:02:45 ELS opcode: 0x52
>--------------------------------------------------------------------------
>-
>
>While this is the raw data the the important thing to highlight is the
>following extract from this log:
>
>--------------------------------------------------------------------------
>-
>0x0e:fc:ff ELS opcode: 0x03
>0x71:fc:ff ELS opcode: 0x03
>0x45:fc:ff ELS opcode: 0x03
>0x0e:fc:ff ELS opcode: 0x20
>0x71:fc:ff ELS opcode: 0x20
>0x45:fc:ff ELS opcode: 0x20
>0x0e:fc:ff ELS opcode: 0x21
>0x71:fc:ff ELS opcode: 0x21
>0x45:fc:ff ELS opcode: 0x21
>0x0e:fc:ff ELS opcode: 0x05
>0x71:fc:ff ELS opcode: 0x05
>0x0e:fc:ff ELS opcode: 0x03
>0x71:fc:ff ELS opcode: 0x03
>0x71:fc:ff ELS opcode: 0x20
>0x45:fc:ff ELS opcode: 0x05
>0x0e:fc:ff ELS opcode: 0x20
>0x45:fc:ff ELS opcode: 0x03
>0x71:fc:ff ELS opcode: 0x21
>0x0e:fc:ff ELS opcode: 0x21
>0x45:fc:ff ELS opcode: 0x20
>0x71:fc:ff ELS opcode: 0x05
>0x45:fc:ff ELS opcode: 0x21
>0x0e:fc:ff ELS opcode: 0x05
>0x45:fc:ff ELS opcode: 0x05
>0x71:fc:ff ELS opcode: 0x03
>0x45:fc:ff ELS opcode: 0x03
>0x0e:fc:ff ELS opcode: 0x03
>0x71:fc:ff ELS opcode: 0x20
>0x45:fc:ff ELS opcode: 0x20
>0x0e:fc:ff ELS opcode: 0x20
>0x71:fc:ff ELS opcode: 0x21
>0x45:fc:ff ELS opcode: 0x21
>0x0e:fc:ff ELS opcode: 0x21
>0x71:fc:ff ELS opcode: 0x05
>0x45:fc:ff ELS opcode: 0x05
>0x0e:fc:ff ELS opcode: 0x05
>--------------------------------------------------------------------------
>-
>
>Which are the domain/switch specific fibre-channel name servers (FCNS)
>which engaged the target with extended link service requests.  There
>are a total of three distinct FCNS instances which issued these and
>they are the three Nexus 55xx switches in the fabric.
>
>It is currently unclear to us why these independent FCNS directory
>servers are engaging with the target.  Our understanding of
>fibre-channel is that an endpoint is responsible for negotiating a
>port login (PLOGI) with the nameserver running on the switch which has
>been elected the principal of the fabric (PS) at the 'well-known'
>FCID/address of 0xff:ff:fc.
>
>Also of note from the the logs was the following:
>
>Dec  2 03:13:54 fc-rp1-targ10-s kernel: [1982]:
>sqa_qla2xxx_check_initiator_node_acl:626:sqatgt(9/0): Registering
>initiator: pwwn=3D21:01:00:e0:8b:a6:d1:9f, fcid=3D0x450200, loop=3D0x0003
>
>Which was the initiator registering with the target.  As we have noted
>previously it is our belief that the card is maintaing loop id's of 0,
>1 and 2 for the three FCNS nameservers.
>
>If this is expected behavior it us unclear to us why the storage VDC's
>on the Nexus 7009 and 7010 are not issueing asynchronous transactions
>against the target port since they are independent domains on the
>fabric as well.
>
>We had previously noted that during subsequent NEXUS_LOSS_SESS events
>that these FCNS instances would issue asynchronous events against the
>target.  Marc's logs confirmed this as well.
>
>Since there is the issue that this may be secondary to the target port
>having initial visibility as an initiator on the fabric before
>transitioning to an FCP class of target we had strictly controlled the
>visibility of the target.  We used the sg_reset command to issue an
>adapater reset against the block device which was presented to the
>initiator to see if we could reproduce this behavior.  The initiator
>adapater request was logged as follows:
>
>--------------------------------------------------------------------------
>-
>Dec  2 03:35:40 fc-iacc1-prox2-s kernel: qla2xxx [0000:0d:00.1]-8018:3:
>ADAPTER RESET ISSUED nexus=3D3:3:0.
>Dec  2 03:35:40 fc-iacc1-prox2-s kernel: qla2xxx [0000:0d:00.1]-00af:3:
>Performing ISP error recovery - ha=3Dffff880255184000.
>Dec  2 03:35:41 fc-iacc1-prox2-s kernel: qla2xxx [0000:0d:00.1]-505f:3:
>Link is operational (4 Gbps).
>Dec  2 03:35:42 fc-iacc1-prox2-s kernel: qla2xxx [0000:0d:00.1]-8017:3:
>ADAPTER RESET SUCCEEDED nexus=3D3:3:0.
>--------------------------------------------------------------------------
>-
>
>Which presented to the target as follows:
>
>--------------------------------------------------------------------------
>-
>Dec  2 03:35:40 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83c:9:
>qla_target(0): Async event 0x8015 occurred (m[0]=3D8015, m[1]=3D45, m[2]=
=3D200,
>m[3]=3D0)
>Dec  2 03:35:42 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f808:9:=20
>qla_tgt_fc_port_deleted ffff88081a962d80<4>qla2xxx [0000:02:00.3]-f826:9:=
=20
>qla_target(0): Port ID: 0x00:02:45 ELS opcode: 0x03
>Dec  2 03:35:42 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9:=20
>qla_target(0): Port update async event 0x8014 occurred: updating the=20
>ports database (m[0]=3D8014, m[1]=3D3, m[2]=3D4, m[3]=3D600)
>Dec  2 03:35:42 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83e:9:=20
>Async MB 2: Got PLOGI Complete
>Dec  2 03:35:42 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9:=20
>qla_target(0): Port update async event 0x8014 occurred: updating the=20
>ports database (m[0]=3D8014, m[1]=3D3, m[2]=3D4, m[3]=3D600)
>Dec  2 03:35:42 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83e:9:=20
>Async MB 2: Got PLOGI Complete
>Dec  2 03:35:42 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f826:9:=20
>qla_target(0): Port ID: 0x00:02:45 ELS opcode: 0x20
>Dec  2 03:35:42 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f826:9:=20
>qla_target(0): Port ID: 0x00:02:45 ELS opcode: 0x52
>Dec  2 03:35:52 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f822:9:=20
>qla_target(0): Unable to find wwn login (s_id 45:2:0), trying to create=20
>it manually
>Dec  2 03:35:52 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f841:9:=20
>loop_id 3
>Dec  2 03:36:10 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f805:9:=20
>Double sess ffff88081a962d80 found (s_id 45:0:2, loop_id 3), updating to=20
>d_id 45:0:2, loop_id 3 rport-9:0-0: blocked FC remote port time out:=20
>removing rport
>--------------------------------------------------------------------------
>-
>
>Of interest in the log above is the apparent indication by the target
>driver that it cannot locate the login for the initiator which had
>generated the TMF.
>
>We then ran our standard I/O interruption test in which we use an FIO
>script to generate four separate classes of I/O which are run
>sequentially against the block device.  This test loops continously
>until stopped.
>
>While that I/O test was running we run a script which randomly selects
>either a device, lun, bus or adapter reset and issues it against the
>block device which the test is being run against.
>
>This test, on a fibre-channel initiator, typically runs a small number
>of cycles and then experiences an error during the process of an
>adapter reset sequence.  The log from the initiator seed is as
>follows:
>
>--------------------------------------------------------------------------
>-
>Dec  2 14:06:02 fc-iacc1-prox2-s kernel: qla2xxx [0000:0d:00.1]-8018:3:=20
>ADAPTER RESET ISSUED nexus=3D3:3:0.
>Dec  2 14:06:02 fc-iacc1-prox2-s kernel: qla2xxx [0000:0d:00.1]-00af:3:=20
>Performing ISP error recovery - ha=3Dffff880255184000.
>Dec  2 14:06:04 fc-iacc1-prox2-s kernel: qla2xxx [0000:0d:00.1]-505f:3:=20
>Link is operational (4 Gbps).
>Dec  2 14:06:05 fc-iacc1-prox2-s kernel: qla2xxx [0000:0d:00.1]-8017:3:=20
>ADAPTER RESET SUCCEEDED nexus=3D3:3:0.
>Dec  2 14:06:32 fc-iacc1-prox2-s kernel:  rport-3:0-13: blocked FC remote=
=20
>port time out: removing target and saving binding
>Dec  2 14:06:32 fc-iacc1-prox2-s kernel:  rport-3:0-13: blocked FC remote=
=20
>port time out: removing target and saving binding
>Dec  2 14:06:32 fc-iacc1-prox2-s kernel: sd 3:0:3:0: rejecting I/O to=20
>offline device
>--------------------------------------------------------------------------
>-
>
>Which is documented on the target as follows:
>
>--------------------------------------------------------------------------
>-
>MESSAGES:
>Dec  2 14:06:06 fc-rp1-targ10-s kernel: [0]:=20
>sqa_qla2xxx_handle_tmr:497:sqatgt(9/0): NEXUS_LOSS_SESS received.
>Dec  2 14:06:06 fc-rp1-targ10-s kernel: [0]: scst:=20
>scst_rx_mgmt_fn:6701:TM fn 6 (mcmd ffff88081b39e070, initiator=20
>21:01:00:e0:8b:a6:d1:9f, target 21:00:00:0e:1e:15:19:f1)
>Dec  2 14:06:06 fc-rp1-targ10-s kernel: [0]:=20
>scst_rx_mgmt_fn:6713:sess=3Dffff880899878000, tag_set 0, tag 0, lun_set 1,=
=20
>lun=3D0, cmd_sn_set 0, cmd_sn 0, priv ffff88101a6c6590
>Dec  2 14:06:06 fc-rp1-targ10-s kernel: [0]:=20
>scst_post_rx_mgmt_cmd:6629:Adding mgmt cmd ffff88081b39e070 to active=20
>mgmt cmd list
>Dec  2 14:06:06 fc-rp1-targ10-s kernel: [1669]:=20
>scst_tm_thread:6514:Deleting mgmt cmd ffff88081b39e070 from active cmd=20
>list
>Dec  2 14:06:06 fc-rp1-targ10-s kernel: [1669]:=20
>scst_abort_all_nexus_loss_sess:6023:Nexus loss or UNREG SESS for sess=20
>ffff880899878000 (mcmd ffff88081b39e070)
>Dec  2 14:06:06 fc-rp1-targ10-s kernel: [1669]: scst:=20
>scst_abort_cmd:5266:Aborting cmd ffff880899830780 (tag 1222816, op=20
>WRITE(10))
>Dec  2 14:06:06 fc-rp1-targ10-s kernel: [1669]: scst:=20
>scst_abort_cmd:5379:cmd ffff880899830780 (tag 1222816, sn 4294967276)=20
>being executed/xmitted (state 118, op WRITE(10), proc time 3 sec.,=20
>timeout 60 sec.), deferring ABORT (cmd_done_wait_count 0,=20
>cmd_finish_wait_count 1, internal 0, mcmd fn 6 (mcmd ffff88081b39e070))
>Dec  2 14:06:06 fc-rp1-targ10-s kernel: [0]: scst:=20
>scst_alloc_set_UA:7963:Queuing new UA ffff88101aa2ecc0 (6:29:7, d_sense=20
>0) to tgt_dev ffff88101a668000 (dev r10:prox2, initiator=20
>21:01:00:e0:8b:a6:d1:9f)
>Dec  2 14:06:06 fc-rp1-targ10-s kernel: [1669]:=20
>scst_call_dev_task_mgmt_fn_done:5221:Calling dev handler vdisk_blockio=20
>task_mgmt_fn_done(fn=3D6)
>Dec  2 14:06:06 fc-rp1-targ10-s kernel: [1669]:=20
>scst_call_dev_task_mgmt_fn_done:5224:Dev handler vdisk_blockio=20
>task_mgmt_fn_done() returned
>Dec  2 14:06:06 fc-rp1-targ10-s kernel: [1669]: scst:=20
>scst_set_mcmd_next_state:5434:cmd_finish_wait_count(1) not 0, preparing=20
>to wait
>Dec  2 14:06:12 fc-rp1-targ10-s kernel: [2043]:=20
>__scst_check_local_events:2785:ABORTED set, aborting cmd ffff880899830780
>Dec  2 14:06:12 fc-rp1-targ10-s kernel: [2043]:=20
>scst_xmit_process_aborted_cmd:8743:Aborted cmd ffff880899830780 done=20
>(cmd_ref 2)
>Dec  2 14:06:12 fc-rp1-targ10-s kernel: [2043]:=20
>scst_done_cmd_mgmt:5009:cmd ffff880899830780 done (tag 1222816)
>Dec  2 14:06:27 fc-rp1-targ10-s kernel: [0]:=20
>sqa_qla2xxx_handle_tmr:497:sqatgt(9/0): NEXUS_LOSS_SESS received.
>Dec  2 14:06:27 fc-rp1-targ10-s kernel: [0]: scst:=20
>scst_rx_mgmt_fn:6701:TM fn 6 (mcmd ffff880898543000, initiator=20
>21:01:00:e0:8b:a6:d1:9f, target 21:00:00:0e:1e:15:19:f1)
>Dec  2 14:06:27 fc-rp1-targ10-s kernel: [0]:=20
>scst_rx_mgmt_fn:6713:sess=3Dffff880899878000, tag_set 0, tag 0, lun_set 1,=
=20
>lun=3D0, cmd_sn_set 0, cmd_sn 0, priv ffff88101a6c6978
>Dec  2 14:06:27 fc-rp1-targ10-s kernel: [0]:=20
>scst_post_rx_mgmt_cmd:6629:Adding mgmt cmd ffff880898543000 to active=20
>mgmt cmd list
>Dec  2 14:06:27 fc-rp1-targ10-s kernel: [1669]:=20
>scst_tm_thread:6514:Deleting mgmt cmd ffff880898543000 from active cmd=20
>list
>Dec  2 14:06:27 fc-rp1-targ10-s kernel: [1669]:=20
>scst_abort_all_nexus_loss_sess:6023:Nexus loss or UNREG SESS for sess=20
>ffff880899878000 (mcmd ffff880898543000)
>Dec  2 14:06:27 fc-rp1-targ10-s kernel: [1669]: scst:=20
>scst_abort_cmd:5266:Aborting cmd ffff880899830780 (tag 1222816, op=20
>WRITE(10))
>Dec  2 14:06:27 fc-rp1-targ10-s kernel: [1669]: scst:=20
>scst_abort_cmd:5379:cmd ffff880899830780 (tag 1222816, sn 4294967276)=20
>being executed/xmitted (state 123, op WRITE(10), proc time 24 sec.,=20
>timeout 60 sec.), deferring ABORT (cmd_done_wait_count 0,=20
>cmd_finish_wait_count 1, internal 0, mcmd fn 6 (mcmd ffff880898543000))
>Dec  2 14:06:27 fc-rp1-targ10-s kernel: [1669]:=20
>scst_call_dev_task_mgmt_fn_done:5221:Calling dev handler vdisk_blockio=20
>task_mgmt_fn_done(fn=3D6)
>Dec  2 14:06:27 fc-rp1-targ10-s kernel: [1669]:=20
>scst_call_dev_task_mgmt_fn_done:5224:Dev handler vdisk_blockio=20
>task_mgmt_fn_done() returned
>Dec  2 14:06:27 fc-rp1-targ10-s kernel: [1669]: scst:=20
>scst_set_mcmd_next_state:5434:cmd_finish_wait_count(1) not 0, preparing=20
>to wait
>Dec  2 14:06:34 fc-rp1-targ10-s kernel: [0]:=20
>sqa_qla2xxx_handle_tmr:497:sqatgt(9/0): NEXUS_LOSS_SESS received.
>Dec  2 14:06:34 fc-rp1-targ10-s kernel: [0]: scst:=20
>scst_rx_mgmt_fn:6701:TM fn 6 (mcmd ffff880898543070, initiator=20
>21:01:00:e0:8b:a6:d1:9f, target 21:00:00:0e:1e:15:19:f1)
>Dec  2 14:06:34 fc-rp1-targ10-s kernel: [0]:=20
>scst_rx_mgmt_fn:6713:sess=3Dffff880899878000, tag_set 0, tag 0, lun_set 1,=
=20
>lun=3D0, cmd_sn_set 0, cmd_sn 0, priv ffff88101a6c6d60
>Dec  2 14:06:34 fc-rp1-targ10-s kernel: [0]:=20
>scst_post_rx_mgmt_cmd:6629:Adding mgmt cmd ffff880898543070 to active=20
>mgmt cmd list
>Dec  2 14:06:34 fc-rp1-targ10-s kernel: [1669]:=20
>scst_tm_thread:6514:Deleting mgmt cmd ffff880898543070 from active cmd=20
>list
>Dec  2 14:06:34 fc-rp1-targ10-s kernel: [1669]:=20
>scst_abort_all_nexus_loss_sess:6023:Nexus loss or UNREG SESS for sess=20
>ffff880899878000 (mcmd ffff880898543070)
>Dec  2 14:06:34 fc-rp1-targ10-s kernel: [1669]: scst:=20
>scst_abort_cmd:5266:Aborting cmd ffff880899830780 (tag 1222816, op=20
>WRITE(10))
>Dec  2 14:06:34 fc-rp1-targ10-s kernel: [1669]: scst:=20
>scst_abort_cmd:5379:cmd ffff880899830780 (tag 1222816, sn 4294967276)=20
>being executed/xmitted (state 123, op WRITE(10), proc time 31 sec.,=20
>timeout 60 sec.), deferring ABORT (cmd_done_wait_count 0,=20
>cmd_finish_wait_count 1, internal 0, mcmd fn 6 (mcmd ffff880898543070))
>Dec  2 14:06:34 fc-rp1-targ10-s kernel: [1669]:=20
>scst_call_dev_task_mgmt_fn_done:5221:Calling dev handler vdisk_blockio=20
>task_mgmt_fn_done(fn=3D6)
>Dec  2 14:06:34 fc-rp1-targ10-s kernel: [1669]:=20
>scst_call_dev_task_mgmt_fn_done:5224:Dev handler vdisk_blockio=20
>task_mgmt_fn_done() returned
>Dec  2 14:06:34 fc-rp1-targ10-s kernel: [1669]: scst:=20
>scst_set_mcmd_next_state:5434:cmd_finish_wait_count(1) not 0, preparing=20
>to wait
>
>
>SYSLOG:
>Dec  2 14:06:06 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83c:9:=20
>qla_target(0): Async event 0x8015 occurred (m[0]=3D8015, m[1]=3D45, m[2]=
=3D200,=20
>m[3]=3D0)
>Dec  2 14:06:06 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f826:9:=20
>qla_target(0): Port ID: 0x00:02:45 ELS opcode: 0x03
>Dec  2 14:06:06 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-10807:9:=20
>qla_target(0): Doing NEXUS_LOSS_SESS
>Dec  2 14:06:12 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f858:9:=20
>qla_target(0): CTIO with status 0xb received, state 1, se_cmd=20
>ffff880899899820, (LIP_RESET=3De, ABORTED=3D2, TARGET_RESET=3D17, TIMEOUT=
=3Db,=20
>INVALID_RX_ID=3D8)
>Dec  2 14:06:27 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f826:9:=20
>qla_target(0): Port ID: 0x00:02:45 ELS opcode: 0x03
>Dec  2 14:06:27 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-10807:9:=20
>qla_target(0): Doing NEXUS_LOSS_SESS
>Dec  2 14:06:34 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f826:9:=20
>qla_target(0): Port ID: 0x00:02:45 ELS opcode: 0x03
>Dec  2 14:06:34 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-10807:9:=20
>qla_target(0): Doing NEXUS_LOSS_SESS
>Dec  2 14:06:55 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f826:9:=20
>qla_target(0): Port ID: 0x00:02:45 ELS opcode: 0x03
>Dec  2 14:06:55 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-10807:9:=20
>qla_target(0): Doing NEXUS_LOSS_SESS
>Dec  2 14:07:14 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f814:9:=20
>qla_target(0): terminating exchange for aborted cmd=3Dffff880899899810=20
>(se_cmd=3Dffff880899899820, tag=3D1222816)
>Dec  2 14:07:14 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f813:9: TM=
=20
>response mcmd (ffff88101a6c6590) status 0x0 state 0x1
>Dec  2 14:07:14 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f813:9: TM=
=20
>response mcmd (ffff88101a6c6978) status 0x0 state 0x1
>Dec  2 14:07:14 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f813:9: TM=
=20
>response mcmd (ffff88101a6c6d60) status 0x0 state 0x1
>Dec  2 14:07:15 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f813:9: TM=
=20
>response mcmd (ffff88101a6c7148) status 0x0 state 0x1
>Dec  2 14:07:15 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9:=20
>qla_target(0): Port update async event 0x8014 occurred: updating the=20
>ports database (m[0]=3D8014, m[1]=3D3, m[2]=3D4, m[3]=3D600)
>Dec  2 14:07:15 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83e:9:=20
>Async MB 2: Got PLOGI Complete
>Dec  2 14:07:15 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83d:9:=20
>qla_target(0): Port update async event 0x8014 occurred: updating the=20
>ports database (m[0]=3D8014, m[1]=3D3, m[2]=3D4, m[3]=3D600)
>Dec  2 14:07:15 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f83e:9:=20
>Async MB 2: Got PLOGI Complete
>Dec  2 14:07:15 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f826:9:=20
>qla_target(0): Port ID: 0x00:02:45 ELS opcode: 0x20
>Dec  2 14:07:15 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-10807:9:=20
>qla_target(0): Doing NEXUS_LOSS_SESS
>Dec  2 14:07:15 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f813:9: TM=
=20
>response mcmd (ffff88101a6c7530) status 0x0 state 0x1
>Dec  2 14:07:15 fc-rp1-targ10-s kernel: qla2xxx [0000:02:00.3]-f826:9:=20
>qla_target(0): Port ID: 0x00:02:45 ELS opcode: 0x52
>--------------------------------------------------------------------------
>-
>
>The logs on the target are separated into two groups since the syslog
>group gets priority *.warn and above while messages are .info and
>.notice.
>
>As can be noted in the 'messages' log the SCST core is processing the
>NEXUS_LOSS_SESS event which was triggered by the sg_reset.  While
>doing that it defers the abort of a WRITE operation, presumably
>covered by the management command, since it believes it hasn't
>completed.  As I have noted previously all of this testing is being
>done with RAM based block devices so there should be no issue with
>backstorage delay unless something is happening in the I/O stack
>downward from the BLOCKIO device to the actual backing device.
>
>Also to be noted is that the target was hit with multiple
>NEXUS_LOSS_SESS events while all of this was going on (14:06:27,
>14:06:34, 14:06:55) which are not attributable to the initiator since
>its next I/O interruption injection was not scheduled until 14:07:46.
>We find it interesting that the number of events is equal to the
>number of sessions which we believe are attributable to the switch
>FCNS servers.
>
>By now everyone has run out of patience so I will leave the group to
>cogitate on all of the above.  We have anecdotal evidence that this
>error which gets thrown during TMF process occurs ONLY when the
>initiator is a native fibre-channel initiator.  We will be running the
>same test with an FCOE initiator to verify this.
>
>Hopefully the above information is helpful.  We will post the target
>driver patch later.
>
>Have a good evening.
>
>Greg
>
>}-- End of excerpt from Duane Grigsby
>
>As always,
>Dr. G.W. Wettstein, Ph.D.   Enjellic Systems Development, LLC.
>4206 N. 19th Ave.           Specializing in information infra-structure
>Fargo, ND  58102            development.
>PH: 701-281-1686
>FAX: 701-281-3949           EMAIL: greg@enjellic.com
>--------------------------------------------------------------------------
>----
>"As a software development model, Anarchy does not scale well."
>                                -- Dave Welch


--_000_2D7BBED629475F4BAA85CF6AB9702F1301088065E1AVMB1qlogicor_
Content-Disposition: attachment; filename="winmail.dat"
Content-Transfer-Encoding: base64
Content-Type: application/ms-tnef; name="winmail.dat"

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
GZ8ar56vD2+gz5C/ou8fv/8gzyHfIu8j/yUPmT8nLyg/fylPKl8rbyx/LY+hvy+nMf8wTzFfMm8z
fw7PNZ8Q7xH//xMPFB8VL8O/F085TzpfO2//G48cnx2vHr9G30fvSP88r/89vz7PP99A70H/Qw9E
H0Uv/01/To9Pn1CvSn9Lj0yfWw//XB9dL14/NL9S/yW/N+9iP/9jT2RfZW9R32ePU/9VD1Yf/1cv
WD/tH1pfaz9sT21fXp//X69gv2HPeM9533rvbp9vr/9wv3HPct9z73T/dg93H39v/4B/gY+Cn3xv
fX9+j4z/jg//jx+QL2avZ78ub2nflC+VP/+WT5dfg8+Zf4Xvhv+ID4kf64ovFnk37fVijH+dX55v
O59/oIdmkV+SZDaTTG+CZ5mwZCBPdXSp3/+q76v/rQ+gv6HPot+j76T//6YPpx+oL6k/sV+yb7N/
rX//ro+vn7Cvvx/AL8E/tO+1//+3D7gfuS+6P7tPWO+9b8WP/8afx6/Iv8K/w8/E39NP1F//1W/J
H8ovyz/MT81fzm/Pf//Qj9Gf0q/az9vf3O/W79f//9kP53/oj+mf6q+Yf5mPNv/5L3kwNe4/70Ph
4O+/8M//8d/y7/P/aO/2H/cv+D/5T9/6X/tv/H/0//6ZM/9fAG//AX8CjwOfBK/9LwbPB98I7/8J
/wsP3f8NL+Af4S/iP+NP9+RfWR+L9Tbm/xFfEm8Tf/+Qv5HPkt8d3x7vH/8hDxS//xXPFt8X7xj/
Gg8bHxwvHT//JY8mnyevIX8ijyOfJK8zH380LzU/C78p/w3fDu+b9TD/Ob86zzvfPO89/z8Pmk8P
X///T0NPRF9Fb0Z/R48Fr0mv/0IvS89M303vKT9QDytfLG//LX8ujy+fit/mb1O/VM9V3/9W7+u/
7M/t32F/Yo9jn1dP/1hfWW9af1uPXJ9dr16/X8//Z+9o/2oPax9lH2YvZz91r/92v3fPa39sj22f
bq9vv3DP/3Hfcu+9BjG/fJ99r36/f8//Nw84Hzkvii+LP4xPf/+BD/+CH4MvhD+FT4Zfh2+If4mP
/5Hfku+T/43Pjt+P755fn2//oH+hj08vlk9Ivw9vpY+mn/+nr6i/lS+q35dPmF+Zb5p/95uPMM90
lGGeH67/sA+xH/+iX6NvpH+7f7yPvZ++r7Jf/7NvtH+1j7aft6+4v7nPut//wy/EP8VPvx/AL8E/
wk/Qv3/Rz9LfqV/Hn6t/QL9S5TH/11/Yb9l/2o/G/9yvyR/KL//LP8xPzV+cn89/4F/hb+J//9O/
1M/V39bv7e/u//AP47//5M/l3+bv5//pD+of6y/sP//0j/Wf9q/3v/GP8p/zrwIf/wMvBD8FT9vP
+g9Rb97/CU//Cl8Lbwx/DY8On6wPUm8Rz/8S3xPvFP/43xcf+v/8D/0f//4v/z9znJ2PGp8brxy/
Hc//Bn8HjwifKC8pPypPHf8fD/8gHyEvIj8jTyRfJW8mfyeP/y/fMO8x/yvPLN8t7zxfPW//Pn8/
jzM/NE81XzZvN384j/85n858dH9D30TvRf9HD3nP/3rfe+9Rn1KvU79Hb0h/SY//Sp9Lr0y/Tc9O
30/vWA9ZH/9aL1s/VT9WT1dfZc9m32fv/1ufXK9dv17PX99g72H/Yw//Ow4Br20/bk9vX0BPam9C
b/9Df3rPe99873Cfca9yv3PP/3Tfde92/3gPeR+Bb4J/g4//hJ9+b39/gI+O/5APkR8Vf++F3xef
3k+thjWVr5a/l8//mN+Z75r/GB8ZLxGvnz+gT/+hX4U/o3+HX4hviX+Kj4uf/wAuZJ+nH6gvqT+q
T2nvav//bA+037Xvtv+qr6u/rM+t3/+u76//sQ+yH7Mvu0+8X71v/75/uH+5j7qfyQ/KH8svod//
v++j/w//nY/QD9Ef0i/ML/+/38Dvwf/DD8QfxS/GP40X/8ff2I/Zn9qv27/NL84/z0//5k/nX+hv
3B/dL94/30/gX//hb+J/44/kn+y/7c/u3+/v/+nv6v/sD/p/+4/8n9NP8V9/1W+lD9ePAX8CjwOf
BK4wsQW6QWRk9dL3gHP3AAsIcAhwOPSQODFhOVg2MmT0kPYAb/YAZ4PzIA/HOWY1M2MEoBAgdmlh
/uYtPmPR9iBja1//AGn1wPcwCdYAX24ZsV9hY2w+KPn/Cq8LvwzPBUQ0YscFz/JnD3Jpb24WMNYA
+CB3dxtwpqDwcBwhBNCqZQTQOBlgYQWwZJywcxHQ96Bsb6YAE3AAwDP9Y6BzHeH+5ggR8JFjoKYg
4G5maXJtALGmIJVDdxtSFCDzIHPzQPbC9UAp//OgDxD1QBTPFd8W7xf/De/7Dv8QBzEQrxG/Es8T
3yJP/yNfJG8lfxkvGj8bTwTRBNH11rAx1rAznLDxIC6AHXn/Y5EeWtawBNEffyCPIZ8tz38u3y/v
BM8yDwbvnI8JBzP/Op87rzy/Pc8+3z/vB39CD/9DH0QvRT9GT0dfSG/V/0qP/0ufTK9Nv07P8M9Q
7/Lv8//f9Q/2H/cvY4+Npjb531Uv/1Y/V0+Sf5OPlJ9hr2K/Y8//ZN9Yj1mfWq9bv1zPXd9e7/9f
/2EPaV9qb2t/ZU9mX2dv/2h/du93/3kPT49tz1GvQZ/9pkUwfY9+n3+vgL9tL4Lf/29PcF9xb3J/
c4/4XXWPhm//h3+Ij4mfet9773z/k/+VD/+WH4nPit+L74z/jg+PH5Av/5E/kk+TX5uvnL+dz5ef
mK//mb+oL6k/qk+rX4HfoB9Jn/+FD69fsG+xf7KPnv+0r6Ef/6Ivoz+kT6Vfxu2nX7g/uU//ul+7
b6yvrb+uz8XPxt/H7/+7n7yvvb++z7/fwO/B/8MP/8QfxS/Nf86Pz5/Jb8p/y4//2f/bD9wf3S/Q
39Hv0v/UD9/VH9Yv1z90r/lzYdm/4g//4x/kL93/3w/gH+6P75/wr//xv+Vv5n/nj+if6a/qv+vP
/+zf7e/2P/dP+F/yL/M/9E//9V8DzwTfBe+zL/qvtU9Sv/+3bwr/DA8NHw4vDz8QT4R//RJmMRL/
FA8VHxYv+g8YT//8L/0//k//XwBvpm8Cjxv//x0PHh8GzwffCO8J/ymPKp//K68fXyBvIX8ijyOf
JK8lv/8mzyffMC8xPzJPM18tLy4//y9PPb8+zz/fQO8XbzWvte//Gp9E70X/Rw9IHzSPSj82r/83
vzjPOd8679hfPQ9N707//1APQU9CX0NvRH9bf1yPXZ//UU9SX1NvVH9Vj1afV69Yv/9Zz2IfYy9k
P2VPXx9gL2E//2+vcL9xz3LfSV9KbxEfTI//dt9373j/eg9mf3wvaJ9pr69qv2vPbN8BuTfZNWJv
L++AD4Efgi+DN2Z0D3UUfOMITG9nfGBkIE91/nSMj42fjq+Pv4NvhH+Fj/+Gn4eviL+Jz4rfi++U
D5Uf/5YvkC+RP5JPk1+hz6Lfo+/fep+Yrxkffc99YjWoD6kf/6ovqz+X361fmf+bD5wfnS//nj87
3aA/sO+x/7MPtB+lj/+mn6evvq+/v8DPtH+1j7af/7evuL+5z7rfu++8/8Ufxi//xz/IT8JPw1/E
b9Lf0+/U//+rr8m/rc9Ln6/v2d/a79v//9X/ya/Kv8vPzN/N787/0A//bgfRr+Jf42/kf+WP1v/Y
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
ZwBzAGIAeQAAAB8AZQABAAAAMgAAAGQAdQBhAG4AZQAuAGcAcgBpAGcAcwBiAHkAQABxAGwAbwBn
AGkAYwAuAGMAbwBtAAAAAAAfAGQAAQAAAAoAAABTAE0AVABQAAAAAAACAUEAAQAAAHAAAAAAAAAA
gSsfpL6jEBmdbgDdAQ9UAgAAAIBEAHUAYQBuAGUAIABHAHIAaQBnAHMAYgB5AAAAUwBNAFQAUAAA
AGQAdQBhAG4AZQAuAGcAcgBpAGcAcwBiAHkAQABxAGwAbwBnAGkAYwAuAGMAbwBtAAAAHwACXQEA
AAAyAAAAZAB1AGEAbgBlAC4AZwByAGkAZwBzAGIAeQBAAHEAbABvAGcAaQBjAC4AYwBvAG0AAAAA
AB8A5V8BAAAAOgAAAHMAaQBwADoAZAB1AGEAbgBlAC4AZwByAGkAZwBzAGIAeQBAAHEAbABvAGcA
aQBjAC4AYwBvAG0AAAAAAB8AGgwBAAAAHAAAAEQAdQBhAG4AZQAgAEcAcgBpAGcAcwBiAHkAAAAf
AB8MAQAAADIAAABkAHUAYQBuAGUALgBnAHIAaQBnAHMAYgB5AEAAcQBsAG8AZwBpAGMALgBjAG8A
bQAAAAAAHwAeDAEAAAAKAAAAUwBNAFQAUAAAAAAAAgEZDAEAAABwAAAAAAAAAIErH6S+oxAZnW4A
3QEPVAIAAACARAB1AGEAbgBlACAARwByAGkAZwBzAGIAeQAAAFMATQBUAFAAAABkAHUAYQBuAGUA
LgBnAHIAaQBnAHMAYgB5AEAAcQBsAG8AZwBpAGMALgBjAG8AbQAAAB8AAV0BAAAAMgAAAGQAdQBh
AG4AZQAuAGcAcgBpAGcAcwBiAHkAQABxAGwAbwBnAGkAYwAuAGMAbwBtAAAAAAAfAPg/AQAAABwA
AABEAHUAYQBuAGUAIABHAHIAaQBnAHMAYgB5AAAAHwAjQAEAAAAyAAAAZAB1AGEAbgBlAC4AZwBy
AGkAZwBzAGIAeQBAAHEAbABvAGcAaQBjAC4AYwBvAG0AAAAAAB8AIkABAAAACgAAAFMATQBUAFAA
AAAAAAIB+T8BAAAAcAAAAAAAAACBKx+kvqMQGZ1uAN0BD1QCAAAAgEQAdQBhAG4AZQAgAEcAcgBp
AGcAcwBiAHkAAABTAE0AVABQAAAAZAB1AGEAbgBlAC4AZwByAGkAZwBzAGIAeQBAAHEAbABvAGcA
aQBjAC4AYwBvAG0AAAAfAAldAQAAADIAAABkAHUAYQBuAGUALgBnAHIAaQBnAHMAYgB5AEAAcQBs
AG8AZwBpAGMALgBjAG8AbQAAAAAAHwAxQAEAAAACAAAAAAAAAAsAQDoBAAAAHwAwQAEAAAACAAAA
AAAAAB8AGgABAAAAEgAAAEkAUABNAC4ATgBvAHQAZQAAAAAAAwDxPwkEAAALAEA6AQAAAAMA/T/k
BAAAAgELMAEAAAAQAAAAhAh8uMZJ5UyxyQo93xhn/QMAFwABAAAAQAA5AIB6gjZSD9ABQAAIMO0u
FjdSD9ABCwAAgAggBgAAAAAAwAAAAAAAAEYAAAAAFIUAAAEAAAAfAACAhgMCAAAAAADAAAAAAAAA
RgEAAAAeAAAAYQBjAGMAZQBwAHQAbABhAG4AZwB1AGEAZwBlAAAAAAABAAAADAAAAGUAbgAtAFUA
UwAAAAsAAIAIIAYAAAAAAMAAAAAAAABGAAAAAAaFAAAAAAAAHwA3AAEAAABgAAAAUgBlADoAIABb
AFMAYwBzAHQALQBkAGUAdgBlAGwAXQAgAE4AZQB3ACAAcQBsAGEAMgB4ADAAMAB0AGcAdAAgAEQA
cgBpAHYAZQByACAAUQB1AGUAcwB0AGkAbwBuAAAAHwA9AAEAAAAKAAAAUgBlADoAIAAAAAAAAwA2
AAAAAAAfAEIQAQAAAGAAAAA8ADIAMAAxADQAMQAyADAAMwAyADAANAA2AC4AcwBCADMASwBrAHgA
NwBsADAAMgA4ADYAMgA1AEAAdwBpAG4AZAAuAGUAbgBqAGUAbABsAGkAYwAuAGMAbwBtAD4AAAAC
AXEAAQAAABsAAAABAdAPOkgRx6JAL1grRqhJ1JntKkfnnH6F9oAAHwBwAAEAAABYAAAAWwBTAGMA
cwB0AC0AZABlAHYAZQBsAF0AIABOAGUAdwAgAHEAbABhADIAeAAwADAAdABnAHQAIABEAHIAaQB2
AGUAcgAgAFEAdQBlAHMAdABpAG8AbgAAAB8ANRABAAAAfAAAADwAMgBEADcAQgBCAEUARAA2ADIA
OQA0ADcANQBGADQAQgBBAEEAOAA1AEMARgA2AEEAQgA5ADcAMAAyAEYAMQAzADAAMQAwADgAOAAw
ADYANQBFADEAQABBAFYATQBCADEALgBxAGwAbwBnAGkAYwAuAG8AcgBnAD4AAAAfADkQAQAAAJYA
AAA8AGQAdQBhAG4AZQAuAGcAcgBpAGcAcwBiAHkAQABxAGwAbwBnAGkAYwAuAGMAbwBtAD4AIAA8
ADIAMAAxADQAMQAyADAAMwAyADAANAA2AC4AcwBCADMASwBrAHgANwBsADAAMgA4ADYAMgA1AEAA
dwBpAG4AZAAuAGUAbgBqAGUAbABsAGkAYwAuAGMAbwBtAD4AAAAAAAMA3j/kBAAAQAAHMHGpDDdS
D9ABAwAmAAAAAAACAUcAAQAAAC4AAABjPVVTO2E9IDtwPVFMb2dpYztsPUFWTUIxLTE0MTIwMzIz
MzgxN1otNjE5MTIAAAAfABUQAQAAAFgAAAAyAEIAOQBBADYARgA1ADQAQwBEADYAOAA0AEUANAA3
AEIAMAAxAEUANgA4ADYAMQA3ADIAOQA5ADkAQQA4ADgAQABxAGwAbwBnAGkAYwAuAGMAbwBtAAAA
AgEUMAEAAAAMAAAA3hIAAL3E4NtIAAAAHwD6PwEAAAAcAAAARAB1AGEAbgBlACAARwByAGkAZwBz
AGIAeQAAAB8AAICGAwIAAAAAAMAAAAAAAABGAQAAABYAAAB1AHMAZQByAC0AYQBnAGUAbgB0AAAA
AAABAAAARgAAAE0AaQBjAHIAbwBzAG8AZgB0AC0ATQBhAGMATwB1AHQAbABvAG8AawAvADEANAAu
ADQALgA2AC4AMQA0ADEAMQAwADYAAAAAAB8AAIAfpOszqHouQr57eeGpjlSzAQAAADgAAABDAG8A
bgB2AGUAcgBzAGEAdABpAG8AbgBJAG4AZABlAHgAVAByAGEAYwBrAGkAbgBnAEUAeAAAAAEAAAAw
AQAASQBJAD0AMAAxADAAMQBEADAAMABGADUAMgAzADcAMAA5ADgANQAwADkAOABBADkAQwA3AEUA
RQA2ADQAMQA5AEYARQAwAEIAOQAwAEEANwBGAEEARQAyADYAOQA1ADsAUwBCAE0ASQBEAD0AMwA7
AFMAMQA9ADwAMgAwADEANAAxADIAMAAzADIAMAA0ADYALgBzAEIAMwBLAGsAeAA3AGwAMAAyADgA
NgAyADUAQAB3AGkAbgBkAC4AZQBuAGoAZQBsAGwAaQBjAC4AYwBvAG0APgA7AFYAZQByAHMAaQBv
AG4APQBWAGUAcgBzAGkAbwBuACAAMQA0AC4AMgAgACgAQgB1AGkAbABkACAAMwA4ADcALgAwACkA
LAAgAFMAdABhAGcAZQA9AEgAMgAAAAMADTT9PwAAHwAAgIYDAgAAAAAAwAAAAAAAAEYBAAAAIAAA
AHgALQBtAHMALQBoAGEAcwAtAGEAdAB0AGEAYwBoAAAAAQAAAAIAAAAAAAAAHwAAgIYDAgAAAAAA
wAAAAAAAAEYBAAAAIgAAAHgALQBvAHIAaQBnAGkAbgBhAHQAaQBuAGcALQBpAHAAAAAAAAEAAAAY
AAAAWwAxADAALgAxAC4ANAAuADEAMABdAAAAHwAAgIYDAgAAAAAAwAAAAAAAAEYBAAAAFgAAAGQA
aQBzAGMAbABhAGkAbQBlAHIAAAAAAAEAAAAOAAAAYgB5AHAAYQBzAHMAAAAAANr1

--_000_2D7BBED629475F4BAA85CF6AB9702F1301088065E1AVMB1qlogicor_--
