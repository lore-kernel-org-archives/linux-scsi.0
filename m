From: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>
Subject: Re: [PATCH v8] ibmvscsis: Initial commit of IBM VSCSI Tgt Driver
Date: Wed, 29 Jun 2016 09:42:57 -0500
Message-ID: <008A3B47-6BAE-42FA-8D65-66D0F0C7747B@linux.vnet.ibm.com>
References: <1464274721-36453-1-git-send-email-bryantly@linux.vnet.ibm.com>
 <1467058632-1825-1-git-send-email-mikecyr@linux.vnet.ibm.com>
 <BB635617-87FA-4667-B1B0-657E2E9FF627@linux.vnet.ibm.com>
 <2aa7660d-2c9a-08bf-59f6-7282a0a7a6f4@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:25418 "EHLO
	mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752968AbcF2OnG convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 29 Jun 2016 10:43:06 -0400
Received: from pps.filterd (m0098409.ppops.net [127.0.0.1])
	by mx0a-001b2d01.pphosted.com (8.16.0.11/8.16.0.11) with SMTP id u5TEcjh8060835
	for <linux-scsi@vger.kernel.org>; Wed, 29 Jun 2016 10:43:05 -0400
Received: from e35.co.us.ibm.com (e35.co.us.ibm.com [32.97.110.153])
	by mx0a-001b2d01.pphosted.com with ESMTP id 23uwt7nb0q-1
	(version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 29 Jun 2016 10:43:05 -0400
Received: from localhost
	by e35.co.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
	for <linux-scsi@vger.kernel.org> from <bryantly@linux.vnet.ibm.com>;
	Wed, 29 Jun 2016 08:43:04 -0600
In-Reply-To: <2aa7660d-2c9a-08bf-59f6-7282a0a7a6f4@sandisk.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, Michael Cyr <mikecyr@linux.vnet.ibm.com>, "nab@linux-iscsi.org" <nab@linux-iscsi.org>, "joe@perches.com" <joe@perches.com>
Cc: "hch@infradead.org" <hch@infradead.org>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "tyreld@linux.vnet.ibm.com" <tyreld@linux.vnet.ibm.com>, "brking@linux.vnet.ibm.com" <brking@linux.vnet.ibm.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "seroyer@linux.vnet.ibm.com" <seroyer@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>



On 6/29/16, 12:49 AM, "Bart Van Assche" <target-devel-owner@vger.kernel=
=2Eorg on behalf of bart.vanassche@sandisk.com> wrote:

>> I was hoping someone in the community can help answer this:
>>
>> If I were to remove the masking off of the lun addressing method pri=
or to target_submit_cmd/target_submit_tmr then I get a hang within scsi=
 probe
>> on bootup. (srp->lun.scsi_lun[0] &=3D 0x3f; and srp_tsk->lun.scsi_lu=
n[0] &=3D 0x3f;)
>>
>> [    0.842648] ibmvscsi 3000000d: sent SRP login
>> [    0.842667] ibmvscsi 3000000d: SRP_LOGIN succeeded
>> [    0.842682] scsi 0:0:2:0: CD-ROM            AIX      VOPTA       =
          PQ: 0 ANSI: 4
>> [  OK  ] Started Show Plymouth Boot Screen.
>> [  OK  ] Reached target Paths.
>> [  OK  ] Reached target Basic System.
>> [    0.886179] sr 0:0:2:0: [sr0] scsi-1 drive
>> [    0.886199] cdrom: Uniform CD-ROM driver Revision: 3.20
>> [    0.888582] sd 0:0:1:0: [sda] 41943040 512-byte logical blocks: (=
21.4 GB/20.0 GiB)
>> [    0.888657] sd 0:0:1:0: [sda] Write Protect is off
>> [    0.888712] sd 0:0:1:0: [sda] Cache data unavailable
>> [    0.888722] sd 0:0:1:0: [sda] Assuming drive cache: write through
>> [    0.901443]  sda: sda1 sda2 sda3
>> [    0.901838] sd 0:0:1:0: [sda] Attached SCSI disk
>> [  124.522778] dracut-initqueue[353]: Warning: dracut-initqueue time=
out - starting timeout scripts
>> [  125.151242] dracut-initqueue[353]: Warning: dracut-initqueue time=
out - starting timeout scripts
>> [  125.662808] dracut-initqueue[353]: Warning: dracut-initqueue time=
out - starting timeout scripts
>>
>> Does anyone know of the reasoning for having to mask off the address=
ing method prior
>> to submitting to target?

> How long have you waited before giving up waiting? The SCSI initiator=
=20
> sends a REPORT LUN and other SCSI commands to LUN 0. If LUN 0 is miss=
ing=20
> these commands will time out but that should not cause a hang. Anyway=
,=20
> SysRq-w should help to determine the cause of the hang.

[    0.852777] ibmvscsi 30000002: SRP_LOGIN succeeded
[  OK  ] Reached target System Initialization.
         Starting dracut initqueue hook...
         Starting Show Plymouth Boot Screen...
[    0.872421] ibmvscsi 3000000d: SRP_VERSION: 16.a
[    0.872561] scsi 0:0:1:0: Direct-Access     AIX      VDASD          =
  0001 PQ: 0 ANSI: 3
[    0.872635] scsi host1: IBM POWER Virtual SCSI Adapter 1.5.9
[    0.872846] ibmvscsi 3000000d: partner initialization complete
[    0.872897] ibmvscsi 3000000d: host srp version: 16.a, host partitio=
n  (0), OS 2, max io 8388608
[    0.872917] ibmvscsi 3000000d: sent SRP login
[    0.872937] ibmvscsi 3000000d: SRP_LOGIN succeeded
[    0.872953] scsi 0:0:2:0: CD-ROM            AIX      VOPTA          =
       PQ: 0 ANSI: 4
[  OK  ] Started Show Plymouth Boot Screen.
[  OK  ] Reached target Paths.
[  OK  ] Reached target Basic System.
[    0.915670] sr 0:0:2:0: [sr0] scsi-1 drive
[    0.915690] cdrom: Uniform CD-ROM driver Revision: 3.20
[    0.917957] sd 0:0:1:0: [sda] 41943040 512-byte logical blocks: (21.=
4 GB/20.0 GiB)
[    0.918035] sd 0:0:1:0: [sda] Write Protect is off
[    0.918092] sd 0:0:1:0: [sda] Cache data unavailable
[    0.918104] sd 0:0:1:0: [sda] Assuming drive cache: write through
[    0.929717]  sda: sda1 sda2 sda3
[    0.930107] sd 0:0:1:0: [sda] Attached SCSI disk
[  124.662745] dracut-initqueue[353]: Warning: dracut-initqueue timeout=
 - starting timeout scripts
[  125.311128] dracut-initqueue[353]: Warning: dracut-initqueue timeout=
 - starting timeout scripts
[  125.822847] dracut-initqueue[353]: Warning: dracut-initqueue timeout=
 - starting timeout scripts
[  126.332803] dracut-initqueue[353]: Warning: dracut-initqueue timeout=
 - starting timeout scripts
[  126.842856] dracut-initqueue[353]: Warning: dracut-initqueue timeout=
 - starting timeout scripts
[  127.352800] dracut-initqueue[353]: Warning: dracut-initqueue timeout=
 - starting timeout scripts
[  127.862721] dracut-initqueue[353]: Warning: dracut-initqueue timeout=
 - starting timeout scripts
[  128.372729] dracut-initqueue[353]: Warning: dracut-initqueue timeout=
 - starting timeout scripts
[  128.882699] dracut-initqueue[353]: Warning: dracut-initqueue timeout=
 - starting timeout scripts
[  129.392709] dracut-initqueue[353]: Warning: dracut-initqueue timeout=
 - starting timeout scripts
[  129.902698] dracut-initqueue[353]: Warning: dracut-initqueue timeout=
 - starting timeout scripts
[  130.412724] dracut-initqueue[353]: Warning: dracut-initqueue timeout=
 - starting timeout scripts
[  130.922700] dracut-initqueue[353]: Warning: dracut-initqueue timeout=
 - starting timeout scripts
[  131.432729] dracut-initqueue[353]: Warning: dracut-initqueue timeout=
 - starting timeout scripts
[  131.942724] dracut-initqueue[353]: Warning: dracut-initqueue timeout=
 - starting timeout scripts
[  132.452690] dracut-initqueue[353]: Warning: dracut-initqueue timeout=
 - starting timeout scripts
[  132.962679] dracut-initqueue[353]: Warning: dracut-initqueue timeout=
 - starting timeout scripts
[  133.472687] dracut-initqueue[353]: Warning: dracut-initqueue timeout=
 - starting timeout scripts
[  133.982712] dracut-initqueue[353]: Warning: dracut-initqueue timeout=
 - starting timeout scripts
[  134.492676] dracut-initqueue[353]: Warning: dracut-initqueue timeout=
 - starting timeout scripts
[  135.002685] dracut-initqueue[353]: Warning: dracut-initqueue timeout=
 - starting timeout scripts
[  135.512703] dracut-initqueue[353]: Warning: dracut-initqueue timeout=
 - starting timeout scripts
[  136.031192] dracut-initqueue[353]: Warning: dracut-initqueue timeout=
 - starting timeout scripts
[  136.542927] dracut-initqueue[353]: Warning: dracut-initqueue timeout=
 - starting timeout scripts
[  137.061147] dracut-initqueue[353]: Warning: dracut-initqueue timeout=
 - starting timeout scripts
[  137.581052] dracut-initqueue[353]: Warning: dracut-initqueue timeout=
 - starting timeout scripts
[  138.092784] dracut-initqueue[353]: Warning: dracut-initqueue timeout=
 - starting timeout scripts
[  138.602771] dracut-initqueue[353]: Warning: dracut-initqueue timeout=
 - starting timeout scripts
[  139.121088] dracut-initqueue[353]: Warning: dracut-initqueue timeout=
 - starting timeout scripts
[  139.632833] dracut-initqueue[353]: Warning: dracut-initqueue timeout=
 - starting timeout scripts
[  140.142838] dracut-initqueue[353]: Warning: dracut-initqueue timeout=
 - starting timeout scripts
[  140.661084] dracut-initqueue[353]: Warning: dracut-initqueue timeout=
 - starting timeout scripts
[  141.172730] dracut-initqueue[353]: Warning: dracut-initqueue timeout=
 - starting timeout scripts
[  141.682787] dracut-initqueue[353]: Warning: dracut-initqueue timeout=
 - starting timeout scripts
[  142.192734] dracut-initqueue[353]: Warning: dracut-initqueue timeout=
 - starting timeout scripts
[  142.702783] dracut-initqueue[353]: Warning: dracut-initqueue timeout=
 - starting timeout scripts
[  143.212748] dracut-initqueue[353]: Warning: dracut-initqueue timeout=
 - starting timeout scripts
[  143.722734] dracut-initqueue[353]: Warning: dracut-initqueue timeout=
 - starting timeout scripts
[  144.232733] dracut-initqueue[353]: Warning: dracut-initqueue timeout=
 - starting timeout scripts
[  144.742790] dracut-initqueue[353]: Warning: dracut-initqueue timeout=
 - starting timeout scripts
[  145.252784] dracut-initqueue[353]: Warning: dracut-initqueue timeout=
 - starting timeout scripts
[  145.762777] dracut-initqueue[353]: Warning: dracut-initqueue timeout=
 - starting timeout scripts
[  146.272756] dracut-initqueue[353]: Warning: dracut-initqueue timeout=
 - starting timeout scripts
[  146.782800] dracut-initqueue[353]: Warning: dracut-initqueue timeout=
 - starting timeout scripts
[  147.292805] dracut-initqueue[353]: Warning: dracut-initqueue timeout=
 - starting timeout scripts
[  147.802770] dracut-initqueue[353]: Warning: dracut-initqueue timeout=
 - starting timeout scripts
[  148.312797] dracut-initqueue[353]: Warning: dracut-initqueue timeout=
 - starting timeout scripts
[  148.822804] dracut-initqueue[353]: Warning: dracut-initqueue timeout=
 - starting timeout scripts
[  149.332777] dracut-initqueue[353]: Warning: dracut-initqueue timeout=
 - starting timeout scripts
[  149.842781] dracut-initqueue[353]: Warning: dracut-initqueue timeout=
 - starting timeout scripts
[  150.361072] dracut-initqueue[353]: Warning: dracut-initqueue timeout=
 - starting timeout scripts
[  150.872765] dracut-initqueue[353]: Warning: dracut-initqueue timeout=
 - starting timeout scripts
[  151.382758] dracut-initqueue[353]: Warning: dracut-initqueue timeout=
 - starting timeout scripts
[  151.892803] dracut-initqueue[353]: Warning: dracut-initqueue timeout=
 - starting timeout scripts
[  152.402738] dracut-initqueue[353]: Warning: dracut-initqueue timeout=
 - starting timeout scripts
[  152.912787] dracut-initqueue[353]: Warning: dracut-initqueue timeout=
 - starting timeout scripts
[  153.422744] dracut-initqueue[353]: Warning: dracut-initqueue timeout=
 - starting timeout scripts
[  153.941075] dracut-initqueue[353]: Warning: dracut-initqueue timeout=
 - starting timeout scripts
[  154.461068] dracut-initqueue[353]: Warning: dracut-initqueue timeout=
 - starting timeout scripts
[  154.981113] dracut-initqueue[353]: Warning: dracut-initqueue timeout=
 - starting timeout scripts
[  155.492757] dracut-initqueue[353]: Warning: dracut-initqueue timeout=
 - starting timeout scripts
[  156.002744] dracut-initqueue[353]: Warning: dracut-initqueue timeout=
 - starting timeout scripts
[  156.512757] dracut-initqueue[353]: Warning: dracut-initqueue timeout=
 - starting timeout scripts
[  157.022779] dracut-initqueue[353]: Warning: dracut-initqueue timeout=
 - starting timeout scripts
[  157.532720] dracut-initqueue[353]: Warning: dracut-initqueue timeout=
 - starting timeout scripts
[  158.051090] dracut-initqueue[353]: Warning: dracut-initqueue timeout=
 - starting timeout scripts
[  158.563207] dracut-initqueue[353]: Warning: dracut-initqueue timeout=
 - starting timeout scripts
[  159.072854] dracut-initqueue[353]: Warning: dracut-initqueue timeout=
 - starting timeout scripts
[  159.583209] dracut-initqueue[353]: Warning: dracut-initqueue timeout=
 - starting timeout scripts
[  160.101149] dracut-initqueue[353]: Warning: dracut-initqueue timeout=
 - starting timeout scripts
[  160.612963] dracut-initqueue[353]: Warning: dracut-initqueue timeout=
 - starting timeout scripts
[  161.123115] dracut-initqueue[353]: Warning: dracut-initqueue timeout=
 - starting timeout scripts
[  161.632853] dracut-initqueue[353]: Warning: dracut-initqueue timeout=
 - starting timeout scripts
[  162.151180] dracut-initqueue[353]: Warning: dracut-initqueue timeout=
 - starting timeout scripts
ng timeout scripts
[  185.722864] dracut-initqueue[353]: Warning: dracut-initqueue timeout=
 - starting timeout scripts
[  185.723229] dracut-initqueue[353]: Warning: Could not boot.
[  185.725988] dracut-initqueue[353]: Warning: /dev/mapper/rhel_vscsi--=
bry-root does not exist
[  185.726216] dracut-initqueue[353]: Warning: /dev/rhel_vscsi-bry/root=
 does not exist
[  185.726446] dracut-initqueue[353]: Warning: /dev/rhel_vscsi-bry/swap=
 does not exist
         Starting Dracut Emergency Shell...
Warning: /dev/mapper/rhel_vscsi--bry-root does not exist
Warning: /dev/rhel_vscsi-bry/root does not exist
Warning: /dev/rhel_vscsi-bry/swap does not exist

Generating "/run/initramfs/rdsosreport.txt"


Entering emergency mode. Exit the shell to continue.
Type "journalctl" to view system logs.
You might want to save "/run/initramfs/rdsosreport.txt" to a USB stick =
or /boot
after mounting them and attach it to a bug report.


dracut:/# vim /run/initramfs/rdsosreport.txt

My mistake, it did not hang but the initiator doesn=E2=80=99t finish bo=
oting up. But this time I tried it with
a LUN 0 there instead of not having one.

/> ls
o- / ..................................................................=
=2E........... [...]
  o- backstores .......................................................=
=2E........... [...]
  | o- fileio ....................................................... [=
2 Storage Objects]
  | | o- LUN_0 ............................................. [5.0M, /tm=
p/tmp.img, in use]
  | | o- RHEL ................................. [19.0G, /home/sdn1/rhel=
_disk.img, in use]
  | o- iblock ........................................................ =
[0 Storage Object]
  | o- pscsi ......................................................... =
[0 Storage Object]
  | o- rd_mcp ........................................................ =
[0 Storage Object]
  o- ibmvscsis ........................................................=
=2E...... [1 Target]
  | o- 3000000e .......................................................=
=2E....... [enabled]
  |   o- luns .........................................................=
=2E........ [2 LUNs]
  |     o- lun0 ........................................... [fileio/LUN=
_0 (/tmp/tmp.img)]
  |     o- lun1 ................................ [fileio/RHEL (/home/sd=
n1/rhel_disk.img)]
  o- iscsi ............................................................=
=2E..... [0 Targets]
  o- loopback .........................................................=
=2E..... [0 Targets]
 [63903.512535] TARGET_CORE[ibmvscsis]: Detected NON_EXISTENT_LUN Acces=
s for 0x0000b660
[63903.512593] TARGET_CORE[ibmvscsis]: Detected NON_EXISTENT_LUN Access=
 for 0x0000b760
[63903.512654] TARGET_CORE[ibmvscsis]: Detected NON_EXISTENT_LUN Access=
 for 0x0000b860
[63903.512711] TARGET_CORE[ibmvscsis]: Detected NON_EXISTENT_LUN Access=
 for 0x0000b960
[63903.512771] TARGET_CORE[ibmvscsis]: Detected NON_EXISTENT_LUN Access=
 for 0x0000ba60
[63903.512828] TARGET_CORE[ibmvscsis]: Detected NON_EXISTENT_LUN Access=
 for 0x0000bb60
[63903.512888] TARGET_CORE[ibmvscsis]: Detected NON_EXISTENT_LUN Access=
 for 0x0000bc60
[63903.513659] TARGET_CORE[ibmvscsis]: Detected NON_EXISTENT_LUN Access=
 for 0x0000bd60
[63903.513730] TARGET_CORE[ibmvscsis]: Detected NON_EXISTENT_LUN Access=
 for 0x0000be60
[63903.513793] TARGET_CORE[ibmvscsis]: Detected NON_EXISTENT_LUN Access=
 for 0x0000bf60

But if I tried the same thing with the masking:

[  196.926548] TARGET_CORE[ibmvscsis]: Detected NON_EXISTENT_LUN Access=
 for 0x00003660
[  196.926607] TARGET_CORE[ibmvscsis]: Detected NON_EXISTENT_LUN Access=
 for 0x00003760
[  196.926663] TARGET_CORE[ibmvscsis]: Detected NON_EXISTENT_LUN Access=
 for 0x00003860
[  196.926723] TARGET_CORE[ibmvscsis]: Detected NON_EXISTENT_LUN Access=
 for 0x00003960
[  196.926783] TARGET_CORE[ibmvscsis]: Detected NON_EXISTENT_LUN Access=
 for 0x00003a60
[  196.926843] TARGET_CORE[ibmvscsis]: Detected NON_EXISTENT_LUN Access=
 for 0x00003b60
[  196.926900] TARGET_CORE[ibmvscsis]: Detected NON_EXISTENT_LUN Access=
 for 0x00003c60
[  196.926960] TARGET_CORE[ibmvscsis]: Detected NON_EXISTENT_LUN Access=
 for 0x00003d60
[  196.927019] TARGET_CORE[ibmvscsis]: Detected NON_EXISTENT_LUN Access=
 for 0x00003e60
[  196.927079] TARGET_CORE[ibmvscsis]: Detected NON_EXISTENT_LUN Access=
 for 0x00003f60

It looks like the masking fixes the device mapper=E2=80=99s ability to =
find the disk=E2=80=A6.

-Bryant


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
