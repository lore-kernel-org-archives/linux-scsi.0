From: Jeremy Linton <jlinton@tributary.com>
Subject: Re: [PATCH 01/16] scsi_dh_alua: Improve error handling
Date: Thu, 6 Mar 2014 17:43:44 -0600
Message-ID: <53190830.2020300@tributary.com>
References: <1391160600-19652-1-git-send-email-hare@suse.de> <1391160600-19652-2-git-send-email-hare@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from relay.ihostexchange.net ([66.46.182.58]:17136 "EHLO
	relay.ihostexchange.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751065AbaCFXnv (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 6 Mar 2014 18:43:51 -0500
In-Reply-To: <1391160600-19652-2-git-send-email-hare@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

On 1/31/2014 3:29 AM, Hannes Reinecke wrote:
> Improve error handling and use standard logging functions
> instead of hand-crafted ones.
>=20
> @@ -182,11 +185,13 @@ static unsigned submit_rtpg(struct scsi_device =
*sdev, struct alua_dh_data *h,
>  			    bool rtpg_ext_hdr_req)

	Can you shorten the timeouts for this?

	I think submit_rtpg failures are causing a boot failure on a SLES 11 S=
P2
machine (3.0.101-0.7.17-default). The basic configuration is an ACNC je=
tstor,
mapped as a raw LUN through a vmware (esxi 5.5) virtual mptsas adapter.=
 The sd
driver seems to be jamming up udev's creation of the boot /dev entries =
with a
~360 second delay probing /dev/sdb. This causes the /dev/sda entry for =
the root
partition (on another device) not to show up in time.


(output from a screen capture sent to me/ocr'ed)

[ 2.918164] sdev dma_alignment 511
[ 3.917810] mptsas2 ioc02 attaching ssp device2 fw_channel 0, fu_id 1, =
phg 1,
sas_addr 0x5000
c29f6c78b0af
[ 3.920204] scsi target0:0:1: mptsas2: ioc02: add device: fw_channel 0,=
 fw_id 1,
phy 1, sas_add
r 0x5000c29f6c78b0af
[ 3.921923] scsi 02021202 Direct-Access JetStor VMB-00 R001 PQ: 0 ANSI:=
 5
[ 4.824734] scsi 02021202 mptscsih: ioc0: qdepth=3D64, tagged=3D1, simp=
le=3D1,
ordered:0, scsi_level:6, cmd_que=3D1
[ 4.827184] sdev dma_alignment 511
[ 4.828006] scsi 02021202 alua: supports implicit TPGS
[ 4.828897] scsi 02021202 alua: target naa.2000001B4D01CA59 port group =
01 rel
port 1b
[ 4.830084] scsi 02021202 alua: Attached
[ 4.834297] sd 0:0:0:0: [sda] 33554432 512-byte logical blocks: (17.1 G=
B/16.0 GiB)
[ 4.835141] sd 02020202 [sda] Write Protect is off
[ 4.835954] sd 02020202 [sda] Mode Sense2 61 00 00 00
[ 4.835994] sd 02020202 [sda] Cache data unavailable
[ 4.836808] sd 02020202 [sda] Assuming drive cache2 write through
[ 4.837718] sd 0:0:1:02 [sdb] 390623744 512-byte logical blocks: (199 G=
B/186 GiB)
[ 4.837756] sd 02020202 [sda] Cache data unavailable
[ 4.837758] sd 02020202 [sda] Assuming drive cache2 write through
[ 4.870098] sda2 sdal sda2
[ 4.871675] sd 02020202 [sda] Cache data unavailable
[ 4.872461] sd 02020202 [sda] Assuming drive cache2 write through
[ 4.873243] sd 02020202 [sda] Attached SCSI disk
[ 5.622838] sd 02021202 [sdb] Write Protect is off
[ 5.624410] sd 02021202 [sdb] Mode Sense2 bf 00 00 08
[ 5.624654] sd 02021202 [sdb] Write cache2 enabled, read cache2 enabled=
, doesn=92t
support DPO or FUA
[ 364.290276] sd 02021202 timing out command, waited 360s
[ 364.291495] sd 02021202 alua2 rtpg failed, Result2 hostbgte=3DDID_OK
driuerbgte:DRIVER_OK
[ 364.309198] sdb: sdbl
[ 367.890274] sd 02021202 [sdb] Attached SCSI disk


vmware says this about the disk:

naa.6001b4d4373468630000000000000000
   Device Display Name: JetStor Fibre Channel Disk (naa.6001b4d43734686=
300000000
                                            00000000)
   Storage Array Type: VMW_SATP_ALUA
   Storage Array Type Device Config: {implicit_support=3Don;explicit_su=
pport=3Doff;

explicit_allow=3Don;alua_followover=3Don;{TPG_id=3D1,TPG_state=3DANO}}
   Path Selection Policy: VMW_PSP_MRU
   Path Selection Policy Device Config: Current Path=3Dvmhba5:C0:T0:L1
   Path Selection Policy Device Custom Config:
   Working Paths: vmhba5:C0:T0:L1
   Is Local SAS Device: false
   Is Boot USB Device: false


--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
