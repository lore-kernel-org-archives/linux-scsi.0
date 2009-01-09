From: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Subject: [Open/iSCSI] Memory leak in repetitive --login/--logout with
	v2.0-870.1
Date: Fri, 09 Jan 2009 14:22:36 -0800
Message-ID: <1231539756.4560.1028.camel@haakon2.linux-iscsi.org>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp123.sbc.mail.sp1.yahoo.com ([69.147.64.96]:48090 "HELO
	smtp123.sbc.mail.sp1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932088AbZAIWXD (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 9 Jan 2009 17:23:03 -0500
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Open iSCSI <open-iscsi@googlegroups.com>, linux-scsi <linux-scsi@vger.kernel.org>
Cc: Mike Christie <michaelc@cs.wisc.edu>, Hannes Reinecke <hare@suse.de>

Greetings Mike, Hannes and Co,

During some recent testing using the Open/iSCSI Initiator v2.0-870.1,
against the LIO-Target v3.0 tree, I noticed that while running the
following script:

while [ 1 ]; do
	iscsiadm -m node -T $TARGETNAME -p $PORTAL --login
	iscsiadm -m node -T $TARGETNAME -p $PORTAL --logout
done

for an extended period of time that I started getting OOM failures on
the VMs running Open/iSCSI.   Upon closer examination, this is what I
found:

<Open-iSCSI Node 1>

Linux ubuntu 2.6.27.10 #2 SMP Tue Jan 6 18:33:00 PST 2009 i686 GNU/Linux

Using open-iscsi-2.0-870.1:

[78196.520214] scsi7981 : iSCSI Initiator over TCP/IP
[78284.175307] scsi7982 : iSCSI Initiator over TCP/IP
[78338.568656] scsi7983 : iSCSI Initiator over TCP/IP
[78405.888822] scsi7984 : iSCSI Initiator over TCP/IP

Output from slaptop:

  OBJS ACTIVE  USE OBJ SIZE  SLABS OBJ/SLAB CACHE SIZE NAME                   
1037001 1036598  99%    0.03K   9177      113     36708K size-32

-------------------------------------------------------------------------

<Open-iSCSI Node 2>

Linux opensuse 2.6.22.5-31-default #1 SMP 2007/09/21 22:29:00 UTC i686 i686 i386 GNU/Linux

scsi7046 : iSCSI Initiator over TCP/IP
scsi7047 : iSCSI Initiator over TCP/IP
scsi7048 : iSCSI Initiator over TCP/IP
scsi7049 : iSCSI Initiator over TCP/IP

Output from slabtop:

  OBJS ACTIVE  USE OBJ SIZE  SLABS OBJ/SLAB CACHE SIZE NAME                   
914057 913581  99%    0.03K   8089      113     32356K size-32

-------------------------------------------------------------------------

So it appears that memory is getting leaked in the size-32 range with
each --login + --logout invocation.  I also tried the same test with the
shipping Open/iSCSI code in Debian v4 and OpenSuse 10.3 and these also
suffer from the same issue.

Also of interest is that running the following script for Discovery
SendTargets *DOES NOT* reproduce the leak.

while [ 1 ]; do
	iscsiadm -m discovery -t sendtargets -p $PORTAL
done

Please let me know if there is anything else I can do to help diagnose
the issue.

Many thanks for your most valuable of time,

--nab



