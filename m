Received: from mout01.posteo.de (mout01.posteo.de [185.67.36.65])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D99F45D8EF
	for <linux-scsi@vger.kernel.org>; Sun, 11 Feb 2024 19:29:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=185.67.36.65
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1707679762; cv=none; b=JCz3M9LMDpTLzxxbiwyVt++cYmz2cZnr2VMW2Vp556mJMBnIKV3iLRiTMytyhCfeyoG3q8e/GAJEvbmk9cm0ng484RI9Yyxd6X/e7oCXtyEvISxmZvwQYeu1NtXUgEygDhg/ZH2GhGLw3fBJE6OOWXnvejIPySZO7uLfHedbPFo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1707679762; c=relaxed/simple;
	bh=+Zb8bamCtLicaeu4poS1aXR+HhWfYaoB0OpmtlP2pxY=;
	h=MIME-Version:Content-Type:Date:From:To:Cc:Subject:Message-ID; b=hihsVzYGbFVQ+p9oRHHD8sKIqeBNZuqqPmcFmXH/mHAcpoTJcbp2/wKLMX9Vxtn58cmXZNzg3/KYvi207zbNNx88sJRhc9KoIKLBcz7YF2q9bHShcNg5GVAj/BVxocU1MpbZyMm2FrVe10KLhVGG7H5TY3Qm+pVIvldAnnj//nY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.de; spf=pass smtp.mailfrom=posteo.de; dkim=pass (2048-bit key) header.d=posteo.de header.i=@posteo.de header.b=a4BTclVL; arc=none smtp.client-ip=185.67.36.65
Authentication-Results: smtp.subspace.kernel.org; dmarc=pass (p=none dis=none) header.from=posteo.de
Authentication-Results: smtp.subspace.kernel.org; spf=pass smtp.mailfrom=posteo.de
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=posteo.de header.i=@posteo.de header.b="a4BTclVL"
Received: from submission (posteo.de [185.67.36.169]) 
	by mout01.posteo.de (Postfix) with ESMTPS id B25D1240027
	for <linux-scsi@vger.kernel.org>; Sun, 11 Feb 2024 20:29:11 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=posteo.de; s=2017;
	t=1707679751; bh=+Zb8bamCtLicaeu4poS1aXR+HhWfYaoB0OpmtlP2pxY=;
	h=MIME-Version:Content-Type:Content-Transfer-Encoding:Date:From:To:
	 Cc:Subject:Message-ID:From;
	b=a4BTclVL+Sn5JeYD/YjU2QJ5NCE/maqV4zLERUuBNF78rYcUv0cj8nJ3LGEk9NATz
	 0qB5AUt4niwA/r+0hD8fs4+wfbaKCMQ6TGH6r6+dERYNJZ3YFnjc1a++KpGIv2n6C1
	 oNx2SwDphxMtAPMLNWBNagYXgbpmxef1/4ZNFi1uRf9WS62AG6pHasAnwEDk5AsQNa
	 QgwYNfGLRaVkUd54OqsI6c3MwogjT/dM4DhrAqmhbafWDv+iNCl/C5RCOivXt8LYld
	 YaP89Pf2SueoqeWa9lDv7OQpXqm0hPmM4NeY9X1uWNANcuAydIyaYU7k0FKwBBUi0K
	 6S+Dhuzc9mU1A==
Received: from customer (localhost [127.0.0.1])
	by submission (posteo.de) with ESMTPSA id 4TXyMB4rGWz6tm8;
	Sun, 11 Feb 2024 20:29:10 +0100 (CET)
Precedence: bulk
X-Mailing-List: linux-scsi@vger.kernel.org
List-Id: <linux-scsi.vger.kernel.org>
List-Subscribe: <mailto:linux-scsi+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:linux-scsi+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Sun, 11 Feb 2024 19:29:10 +0000
From: ffp@posteo.de
To: lduncan@suse.com, cleech@redhat.com, michael.christie@oracle.com,
 phil@philpotter.co.uk, oneukum@suse.com
Cc: open-iscsi@googlegroups.com, linux-scsi@vger.kernel.org,
 linux-usb@vger.kernel.org
Subject: Optical drive (CD/DVD/Blu-ray), connected via USB, passed-through
 SCSI, distributed via iSCSI, error messages in dmesg every second, slower
 average read speed at 2 MB/s, normal behavior with Microsoft Initiator
Message-ID: <1e0495285aa5a8041da884c2f1621cbd@posteo.de>

[1.] One line summary of the problem:

Optical drive (CD/DVD/Blu-ray), connected via USB, passed-through SCSI, 
distributed via iSCSI, error messages in dmesg every second, slower 
average read speed at 2 MB/s, normal behavior with Microsoft Initiator

[2.] Full description of the problem/report:

Hello everyone,

I hope I am writing to the right people and describing the problem 
reasonably well, this is my first bug report. I have been trying to find 
a solution at program level for two months now, which is unfortunately 
proving difficult. I think that the error can be narrowed down to the 
kernel, there are indications of this, but I can't prove it with 100% 
certainty as I don't understand the C language myself.

Let me break down the current structure:
optical drive---> via USB3---> ESXi8 host---> pass-through to VM---> 
Debian 12 with kernel 6.1.0 and self-compiled kernel 6.7.4--->tgt iSCSI 
target---> SCSI pass-through---> Ethernet/ WiFi with TCP---> Debian 12 
Stable or Testing with open-iscsi Initiator---> Programs

(drive already removed from enclosure and connected to physical PC with 
mini-SATA, tgt set up, same error pattern)

Problem description:

I search for the target via iscsiadm and log in. The optical drive is 
recognized and initialized, see dmesg:

[ 6204.436754] scsi host0: iSCSI Initiator over TCP/IP
[ 6204.452976] scsi 0:0:0:0: RAID              IET      Controller       
0001 PQ: 0 ANSI: 5
[ 6204.483159] scsi 0:0:0:0: Attached scsi generic sg0 type 12
[ 6204.486988] scsi 0:0:0:1: CD-ROM            NECVMWar VMware SATA CD00 
1.00 PQ: 0 ANSI: 5
[ 6204.534459] sr 0:0:0:1: [sr0] scsi-1 drive
[ 6204.598759] sr 0:0:0:1: Attached scsi CD-ROM sr0
[ 6204.598905] sr 0:0:0:1: Attached scsi generic sg1 type 5
[ 6208.550055] sr 0:0:0:1: [sr0] tag#96 FAILED Result: hostbyte=DID_OK 
driverbyte=DRIVER_OK cmd_age=0s
[ 6208.550064] sr 0:0:0:1: [sr0] tag#96 Sense Key : Hardware Error 
[current]
[ 6208.550067] sr 0:0:0:1: [sr0] tag#96 Add. Sense: Internal target 
failure
[ 6208.550071] sr 0:0:0:1: [sr0] tag#96 CDB: Read(10) 28 00 00 00 00 82 
00 00 7e 00
[ 6208.550073] critical target error, dev sr0, sector 520 op 0x0:(READ) 
flags 0x80700 phys_seg 63 prio class 2
[ 6208.763308] sr 0:0:0:1: [sr0] tag#96 FAILED Result: hostbyte=DID_OK 
driverbyte=DRIVER_OK cmd_age=0s
[ 6208.763316] sr 0:0:0:1: [sr0] tag#96 Sense Key : Hardware Error 
[current]
[ 6208.763319] sr 0:0:0:1: [sr0] tag#96 Add. Sense: Internal target 
failure
[ 6208.763322] sr 0:0:0:1: [sr0] tag#96 CDB: Read(10) 28 00 01 65 d3 00 
00 00 80 00
[ 6208.763324] critical target error, dev sr0, sector 93801472 op 
0x0:(READ) flags 0x80700 phys_seg 64 prio class 2
[ 6212.108642] sr 0:0:0:1: [sr0] tag#98 FAILED Result: hostbyte=DID_OK 
driverbyte=DRIVER_OK cmd_age=0s
[ 6212.108650] sr 0:0:0:1: [sr0] tag#98 Sense Key : Hardware Error 
[current]
[ 6212.108653] sr 0:0:0:1: [sr0] tag#98 Add. Sense: Internal target 
failure
[ 6212.108656] sr 0:0:0:1: [sr0] tag#98 CDB: Read(10) 28 00 01 65 d3 80 
00 00 80 00
[ 6212.108658] critical target error, dev sr0, sector 93801984 op 
0x0:(READ) flags 0x80700 phys_seg 64 prio class 2

At first it seems as if it is recognized and initialized without any 
problems, about 3-5 seconds after connection the first error messages 
are thrown.
For example, when I run rsync -av -P on the mounted drive, dmesg is 
flooded with this kind of error message and the transfer rate is 2.0 - 
2.5 MB/s. This behavior does NOT continue to occur when I use dd 
if=/dev/sr0 of=/test.img to read the disc bit by bit. To my surprise, 
the disc is then read at the full speed of the drive (between 20.0 and 
24.0 MB/s).

In principle, this is also the complete error pattern, with open-iscsi 
as the initiator.

I have now run some tests to find a solution at program level, which has 
not been found.
Among other things, I have counter-tested with Windows (10/11/Server 
2022) and the initiator used there can establish a connection with 
default settings and mount the drive into the system. Completely 
error-free. The programs there can read it at full speed.

I have also tested another Debian-based distribution (virtualized), 
Ubuntu 22.04, which also has this error.I have also tested various 
kernel versions, namely kernel 6.7.4 (self-compiled), 6.6.13, 6.5.0, 
4.19.306 and 4.0.0 (Debian Stretch Alpha).
This error occurs in all kernel versions mentioned. In the first four, 
exactly the same. With kernel 4.0.0 the drive is initialized in dmesg 
apparently without errors, only when I start a read operation (e.g. with 
rsync) is dmesg flooded.
I also read the disc on the VM on which tgt is running with dd 1:1 and 
wrote it to a hard disk. I then entered the hard disk in targets.conf 
using SCSI passthrough and mounted it on the client with 
open-iscsi-initiator.
Now I have used various programs to read out this created image on the 
client and copied it to file level. This worked without any problems, 
neither in dmesg nor with the speed, which means for me that the error 
is not generally due to open-iscsi.
On Friday I bought a brand new optical drive which also works fine on 
Windows to rule out the error of an unlikely hardware defect.

IMPORTANT NOTE: Both drives work flawlessly when I connect them to my 
Linux clients via USB(2/3) OR pass them through to a guest VM via ESXi8.

How can the error be reproduced?

Set up tgt, connect a DVD/Blu-ray-capable drive via USB/SATA.
Enter it in /etc/tgt/conf.d/targets.conf:

default-driver iscsi

<target iqn.1993-08.org.brd-srv:vbrd.target1>
   <backing-store "/dev/sg1">
       device-type pt
       bs-type sg
   </backing-store>
</target>

Restart tgt: systemctl restart tgt

On the client:

iscsiadm --mode discovery --portal target_ip --type sendtargets
iscsiadm -m node --targetname=targetname --login

The configuration file: /etc/iscsi/node/target-iqn/ip-address/default
can be left unchanged, the change of various parameters did not affect 
the error.

Mount the drive and the disk:
mount /dev/sr0 /cdrom/

Start a copy process such as rsync -av -P /cdrom /home/user/disc/
and run dmesg -w at the same time.

I hope this report is enough to get you started, please contact me if 
you need more information.

Best regards

[3.] Keywords (i.e., modules, networking, kernel):

Networking, SCSI, iSCSI, Kernel, cdrom, sr, tgt

[4.] Kernel information
[4.1.] Kernel version (from /proc/version):
[4.2.] Kernel .config file:
[5.] Most recent kernel version which did not have the bug:
[6.] Output of Oops.. message (if applicable) with symbolic information
      resolved (see Documentation/admin-guide/oops-tracing.rst)
[7.] A small shell script or example program which triggers the
      problem (if possible)
[8.] Environment
[8.1.] Software (add the output of the ver_linux script here)
[8.2.] Processor information (from /proc/cpuinfo):
[8.3.] Module information (from /proc/modules):
[8.4.] Loaded driver and hardware information (/proc/ioports, 
/proc/iomem)
[8.5.] PCI information ('lspci -vvv' as root)
[8.6.] SCSI information (from /proc/scsi/scsi)
[8.7.] Other information that might be relevant to the problem
        (please look in /proc and include all information that you
        think to be relevant):

