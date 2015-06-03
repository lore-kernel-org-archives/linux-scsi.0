From: Joe Carnuccio <joe.carnuccio@qlogic.com>
Subject: RE: bisected regression: qla2xxx endianness on sparc64
Date: Wed, 3 Jun 2015 19:39:02 +0000
Message-ID: <86A17A977688E04689F40F6B1EC20EC601940E06A9@AVMB1.qlogic.org>
References: <alpine.DEB.2.03.1411022004230.3979@cyber.ee>
 <alpine.OSX.2.00.1411031508560.1960@administrators-macbook-pro.local>
 <20141110141519.GA12347@infradead.org>
 <alpine.LRH.2.11.1506031116120.16353@math.ut.ee>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_000_86A17A977688E04689F40F6B1EC20EC601940E06A9AVMB1qlogicor_"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:33467 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751980AbbFCTjG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 3 Jun 2015 15:39:06 -0400
Received: from pps.filterd (m0045602.ppops.net [127.0.0.1])
	by mx0a-0016ce01.pphosted.com (8.14.5/8.14.5) with SMTP id t53JaOSr026364
	for <linux-scsi@vger.kernel.org>; Wed, 3 Jun 2015 12:39:05 -0700
Received: from avcashub1.qlogic.com (avcashub3.qlogic.com [198.70.193.117])
	by mx0a-0016ce01.pphosted.com with ESMTP id 1usj1a1fbs-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 03 Jun 2015 12:39:04 -0700
In-Reply-To: <alpine.LRH.2.11.1506031116120.16353@math.ut.ee>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Meelis Roos <mroos@linux.ee>, Christoph Hellwig <hch@infradead.org>
Cc: Chad Dupuis <chad.dupuis@qlogic.com>, Saurav Kashyap <saurav.kashyap@qlogic.com>, Christoph Hellwig <hch@lst.de>, Dept-Eng QLA2xxx Upstream <qla2xxx-upstream@qlogic.com>, "James E.J. Bottomley" <JBottomley@parallels.com>, linux-scsi <linux-scsi@vger.kernel.org>, linux-kernel <linux-kernel@vger.kernel.org>

--_000_86A17A977688E04689F40F6B1EC20EC601940E06A9AVMB1qlogicor_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Meelis,

Yes, please revert that patch (it should never have deleted the calls to __=
constant_cpu_to_le16 (those fields are all LE in the HW/nvram)).

-Joe

-----Original Message-----
From: mroos@math.ut.ee [mailto:mroos@math.ut.ee] On Behalf Of Meelis Roos
Sent: Wednesday, June 03, 2015 1:21 AM
To: Christoph Hellwig
Cc: Chad Dupuis; Joe Carnuccio; Saurav Kashyap; Christoph Hellwig; Dept-Eng=
 QLA2xxx Upstream; James E.J. Bottomley; linux-scsi; linux-kernel
Subject: Re: bisected regression: qla2xxx endianness on sparc64

On Mon, 10 Nov 2014, Christoph Hellwig wrote:

> On Mon, Nov 03, 2014 at 03:09:47PM -0500, Chad Dupuis wrote:
> > We should revert that change. What were some of the other failures=20
> > you were seeing?
>=20
> Can you please send me the revert ASAP?

Since QLogic is still silent on this one, I will send it to you:

Revert change that breaks QLA2XXX on big-endian systems,
__constant_cpu_to_le16() is still needed.

Signed-off-by: Meelis Roos <mroos@linux.ee>

diff --git a/drivers/scsi/qla2xxx/qla_fw.h b/drivers/scsi/qla2xxx/qla_fw.h =
index 42bb357..88d3143 100644
--- a/drivers/scsi/qla2xxx/qla_fw.h
+++ b/drivers/scsi/qla2xxx/qla_fw.h
@@ -91,7 +91,7 @@ struct nvram_24xx {
 	/* Firmware Initialization Control Block. */
 	uint16_t version;
 	uint16_t reserved_1;
-	__le16 frame_payload_size;
+	uint16_t frame_payload_size;
 	uint16_t execution_throttle;
 	uint16_t exchange_count;
 	uint16_t hard_address;
diff --git a/drivers/scsi/qla2xxx/qla_init.c b/drivers/scsi/qla2xxx/qla_ini=
t.c index 285cb20..ed973a1 100644
--- a/drivers/scsi/qla2xxx/qla_init.c
+++ b/drivers/scsi/qla2xxx/qla_init.c
@@ -2658,18 +2658,18 @@ qla2x00_nvram_config(scsi_qla_host_t *vha)
 			nv->firmware_options[1] =3D BIT_7 | BIT_5;
 			nv->add_firmware_options[0] =3D BIT_5;
 			nv->add_firmware_options[1] =3D BIT_5 | BIT_4;
-			nv->frame_payload_size =3D 2048;
+			nv->frame_payload_size =3D __constant_cpu_to_le16(2048);
 			nv->special_options[1] =3D BIT_7;
 		} else if (IS_QLA2200(ha)) {
 			nv->firmware_options[0] =3D BIT_2 | BIT_1;
 			nv->firmware_options[1] =3D BIT_7 | BIT_5;
 			nv->add_firmware_options[0] =3D BIT_5;
 			nv->add_firmware_options[1] =3D BIT_5 | BIT_4;
-			nv->frame_payload_size =3D 1024;
+			nv->frame_payload_size =3D __constant_cpu_to_le16(1024);
 		} else if (IS_QLA2100(ha)) {
 			nv->firmware_options[0] =3D BIT_3 | BIT_1;
 			nv->firmware_options[1] =3D BIT_5;
-			nv->frame_payload_size =3D 1024;
+			nv->frame_payload_size =3D __constant_cpu_to_le16(1024);
 		}
=20
 		nv->max_iocb_allocation =3D __constant_cpu_to_le16(256); @@ -2705,7 +270=
5,7 @@ qla2x00_nvram_config(scsi_qla_host_t *vha)
 	 * are valid.
 	 */
 	if (ia64_platform_is("sn2")) {
-		nv->frame_payload_size =3D 2048;
+		nv->frame_payload_size =3D __constant_cpu_to_le16(2048);
 		if (IS_QLA23XX(ha))
 			nv->special_options[1] =3D BIT_7;
 	}
@@ -5022,7 +5022,7 @@ qla24xx_nvram_config(scsi_qla_host_t *vha)
 		memset(nv, 0, ha->nvram_size);
 		nv->nvram_version =3D __constant_cpu_to_le16(ICB_VERSION);
 		nv->version =3D __constant_cpu_to_le16(ICB_VERSION);
-		nv->frame_payload_size =3D 2048;
+		nv->frame_payload_size =3D __constant_cpu_to_le16(2048);
 		nv->execution_throttle =3D __constant_cpu_to_le16(0xFFFF);
 		nv->exchange_count =3D __constant_cpu_to_le16(0);
 		nv->hard_address =3D __constant_cpu_to_le16(124); @@ -5969,7 +5969,7 @@ =
qla81xx_nvram_config(scsi_qla_host_t *vha)
 		memset(nv, 0, ha->nvram_size);
 		nv->nvram_version =3D __constant_cpu_to_le16(ICB_VERSION);
 		nv->version =3D __constant_cpu_to_le16(ICB_VERSION);
-		nv->frame_payload_size =3D 2048;
+		nv->frame_payload_size =3D __constant_cpu_to_le16(2048);
 		nv->execution_throttle =3D __constant_cpu_to_le16(0xFFFF);
 		nv->exchange_count =3D __constant_cpu_to_le16(0);
 		nv->port_name[0] =3D 0x21;

--
Meelis Roos (mroos@linux.ee)

--_000_86A17A977688E04689F40F6B1EC20EC601940E06A9AVMB1qlogicor_
Content-Disposition: attachment; filename="winmail.dat"
Content-Transfer-Encoding: base64
Content-Type: application/ms-tnef; name="winmail.dat"

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
v5+2oL+hz57Po+WgRTR/q8+dzIOfn8EB0DQ4ghupP++qT2KvY7SrUimkX54HRfC/BZAHMaa/oCCw
TwMwfUUAjycgGeAGkCTASVNfPgL5AdAwKJzRZBB4HJ3Pou/9n+MyoEV/l7b/uA+fn6Q//6VPuD+j
376vv7+nD6gfrF//rW9HsXfAq5/Gz62/rs9j8P/IorA/tI8+Ah6Rtg/Jj8AP/70Gb6C539Evw5/B
H8Y/yn//yF/Jb9k/y4/Mn82vzrB4N7ffrtWyAMB4joB7UGKLMJ8nEHtQelTdr693NTbfcPt2spkQ
N01QdjLmBZo/m0/vnF94lXuQKcN2ehFlF+o2/3u8tSIHMEZAg9ALYAAwGvEBjoBzKCJzbjIi/9BK
2CfcL6rP2xvwL90/rw/3sB/s9rVlM2CQ0BPUb7Fv/7yPiYzgp3XSTWC1wHYy/aX/5vV30eef6K/4
v1exYgASEP4oG2AjIE2BEdDV0HdkgdI/9m/VlHdkfSX0j2OHSUMAQl9WRVJTSU/+TgQ/1ZQGDwcf
CC/vf/N///GfDa/zvwrv9d/hrYYfEm/xY3gweEYYoRRfFWaIyv8W7xf4GO/VlIr6Gz/eqN9S4eWz
NTk2Of3jIWTm9Pw4Mf8fAC8BPwJPA18dH/8Ffx8vC88Irwm/Kk8rXwzv/xDvDw8QHzHvEj8TTyx/
FW//Fn8b3xifGa8avzsvHN/VhfZw7hBjMG6DobkUPDDP0G/79pL34MVnCihn3CUGfQZ9YoBHIAAf
AEIAAQAAABwAAABKAG8AZQAgAEMAYQByAG4AdQBjAGMAaQBvAAAAHwBlAAEAAAAyAAAAagBvAGUA
LgBjAGEAcgBuAHUAYwBjAGkAbwBAAHEAbABvAGcAaQBjAC4AYwBvAG0AAAAAAB8AZAABAAAACgAA
AFMATQBUAFAAAAAAAAIBQQABAAAAcAAAAAAAAACBKx+kvqMQGZ1uAN0BD1QCAAAAgEoAbwBlACAA
QwBhAHIAbgB1AGMAYwBpAG8AAABTAE0AVABQAAAAagBvAGUALgBjAGEAcgBuAHUAYwBjAGkAbwBA
AHEAbABvAGcAaQBjAC4AYwBvAG0AAAAfAAJdAQAAADIAAABqAG8AZQAuAGMAYQByAG4AdQBjAGMA
aQBvAEAAcQBsAG8AZwBpAGMALgBjAG8AbQAAAAAAHwDlXwEAAAA6AAAAcwBpAHAAOgBqAG8AZQAu
AGMAYQByAG4AdQBjAGMAaQBvAEAAcQBsAG8AZwBpAGMALgBjAG8AbQAAAAAAHwAaDAEAAAAcAAAA
SgBvAGUAIABDAGEAcgBuAHUAYwBjAGkAbwAAAB8AHwwBAAAAMgAAAGoAbwBlAC4AYwBhAHIAbgB1
AGMAYwBpAG8AQABxAGwAbwBnAGkAYwAuAGMAbwBtAAAAAAAfAB4MAQAAAAoAAABTAE0AVABQAAAA
AAACARkMAQAAAHAAAAAAAAAAgSsfpL6jEBmdbgDdAQ9UAgAAAIBKAG8AZQAgAEMAYQByAG4AdQBj
AGMAaQBvAAAAUwBNAFQAUAAAAGoAbwBlAC4AYwBhAHIAbgB1AGMAYwBpAG8AQABxAGwAbwBnAGkA
YwAuAGMAbwBtAAAAHwABXQEAAAAyAAAAagBvAGUALgBjAGEAcgBuAHUAYwBjAGkAbwBAAHEAbABv
AGcAaQBjAC4AYwBvAG0AAAAAAB8A+D8BAAAAHAAAAEoAbwBlACAAQwBhAHIAbgB1AGMAYwBpAG8A
AAAfACNAAQAAADIAAABqAG8AZQAuAGMAYQByAG4AdQBjAGMAaQBvAEAAcQBsAG8AZwBpAGMALgBj
AG8AbQAAAAAAHwAiQAEAAAAKAAAAUwBNAFQAUAAAAAAAAgH5PwEAAABwAAAAAAAAAIErH6S+oxAZ
nW4A3QEPVAIAAACASgBvAGUAIABDAGEAcgBuAHUAYwBjAGkAbwAAAFMATQBUAFAAAABqAG8AZQAu
AGMAYQByAG4AdQBjAGMAaQBvAEAAcQBsAG8AZwBpAGMALgBjAG8AbQAAAB8ACV0BAAAAMgAAAGoA
bwBlAC4AYwBhAHIAbgB1AGMAYwBpAG8AQABxAGwAbwBnAGkAYwAuAGMAbwBtAAAAAAALAEA6AQAA
AB8AGgABAAAAEgAAAEkAUABNAC4ATgBvAHQAZQAAAAAAAwDxPwkEAAALAEA6AQAAAAMA/T/kBAAA
AgELMAEAAAAQAAAAPsenwNWiakCr+YDrobpv3AMAFwABAAAAQAA5AADPcfE0ntABQAAIMCvR3PE0
ntABCwApAAAAAAALACMAAAAAAB8AAICGAwIAAAAAAMAAAAAAAABGAQAAAB4AAABhAGMAYwBlAHAA
dABsAGEAbgBnAHUAYQBnAGUAAAAAAAEAAAAMAAAAZQBuAC0AVQBTAAAACwAAgAggBgAAAAAAwAAA
AAAAAEYAAAAABoUAAAAAAAAfADcAAQAAAG4AAABSAEUAOgAgAGIAaQBzAGUAYwB0AGUAZAAgAHIA
ZQBnAHIAZQBzAHMAaQBvAG4AOgAgAHEAbABhADIAeAB4AHgAIABlAG4AZABpAGEAbgBuAGUAcwBz
ACAAbwBuACAAcwBwAGEAcgBjADYANAAAAAAAHwA9AAEAAAAKAAAAUgBFADoAIAAAAAAAAwA2AAAA
AAADAC4AAAAAAB8AQhABAAAAYgAAADwAYQBsAHAAaQBuAGUALgBMAFIASAAuADIALgAxADEALgAx
ADUAMAA2ADAAMwAxADEAMQA2ADEAMgAwAC4AMQA2ADMANQAzAEAAbQBhAHQAaAAuAHUAdAAuAGUA
ZQA+AAAAAAACAXEAAQAAABsAAAABAdCd1cMet8Uo+RKVToAu4AKO14vknZstelAAHwBwAAEAAABm
AAAAYgBpAHMAZQBjAHQAZQBkACAAcgBlAGcAcgBlAHMAcwBpAG8AbgA6ACAAcQBsAGEAMgB4AHgA
eAAgAGUAbgBkAGkAYQBuAG4AZQBzAHMAIABvAG4AIABzAHAAYQByAGMANgA0AAAAAAAfADUQAQAA
AHwAAAA8ADgANgBBADEANwBBADkANwA3ADYAOAA4AEUAMAA0ADYAOAA5AEYANAAwAEYANgBCADEA
RQBDADIAMABFAEMANgAwADEAOQA0ADAARQAwADYAQQA5AEAAQQBWAE0AQgAxAC4AcQBsAG8AZwBp
AGMALgBvAHIAZwA+AAAAHwA5EAEAAACYAQAAPABhAGwAcABpAG4AZQAuAEQARQBCAC4AMgAuADAA
MwAuADEANAAxADEAMAAyADIAMAAwADQAMgAzADAALgAzADkANwA5AEAAYwB5AGIAZQByAC4AZQBl
AD4AIAA8AGEAbABwAGkAbgBlAC4ATwBTAFgALgAyAC4AMAAwAC4AMQA0ADEAMQAwADMAMQA1ADAA
OAA1ADYAMAAuADEAOQA2ADAAQABhAGQAbQBpAG4AaQBzAHQAcgBhAHQAbwByAHMALQBtAGEAYwBi
AG8AbwBrAC0AcAByAG8ALgBsAG8AYwBhAGwAPgAgADwAMgAwADEANAAxADEAMQAwADEANAAxADUA
MQA5AC4ARwBBADEAMgAzADQANwBAAGkAbgBmAHIAYQBkAGUAYQBkAC4AbwByAGcAPgAgADwAYQBs
AHAAaQBuAGUALgBMAFIASAAuADIALgAxADEALgAxADUAMAA2ADAAMwAxADEAMQA2ADEAMgAwAC4A
MQA2ADMANQAzAEAAbQBhAHQAaAAuAHUAdAAuAGUAZQA+AAAAAwDeP59OAAALAACACCAGAAAAAADA
AAAAAAAARgAAAAADhQAAAAAAAAMAAIAIIAYAAAAAAMAAAAAAAABGAAAAAAGFAAAAAAAAAwCAEP//
//9AAAcwaQ7Y8TSe0AELAAIAAQAAAAMAJgAAAAAACwArAAAAAAACAUcAAQAAAC4AAABjPVVTO2E9
IDtwPVFMb2dpYztsPUFWTUIxLTE1MDYwMzE5MzkwMlotMTQxMDgAAAACARAwAQAAAEYAAAAAAAAA
+QzviWK60BGRqwCgJN2M4QcAEf7GdsYu0BGRkwCgJN2M4QAAABiCNwAAEfDvw9fZjUuV96UAjS/A
ggEtARdR7QAAAAAfAPo/AQAAABwAAABKAG8AZQAgAEMAYQByAG4AdQBjAGMAaQBvAAAAAwAJWQEA
AAADAACACCAGAAAAAADAAAAAAAAARgAAAAAQhQAAAAAAAAsAAIAIIAYAAAAAAMAAAAAAAABGAAAA
AA6FAAAAAAAAAwAAgAggBgAAAAAAwAAAAAAAAEYAAAAAGIUAAAAAAAALAACACCAGAAAAAADAAAAA
AAAARgAAAACChQAAAAAAAB8AAIAIIAYAAAAAAMAAAAAAAABGAAAAANiFAAABAAAAEgAAAEkAUABN
AC4ATgBvAHQAZQAAAAAAAwANNP0/AAAfAACAhgMCAAAAAADAAAAAAAAARgEAAAAgAAAAeAAtAG0A
cwAtAGgAYQBzAC0AYQB0AHQAYQBjAGgAAAABAAAAAgAAAAAAAAAfAACAhgMCAAAAAADAAAAAAAAA
RgEAAAAiAAAAeAAtAG8AcgBpAGcAaQBuAGEAdABpAG4AZwAtAGkAcAAAAAAAAQAAABgAAABbADEA
MAAuADEALgA0AC4AMQAwAF0AAAAfAACAhgMCAAAAAADAAAAAAAAARgEAAAAWAAAAZABpAHMAYwBs
AGEAaQBtAGUAcgAAAAAAAQAAAA4AAABiAHkAcABhAHMAcwAAAAAA2tM=

--_000_86A17A977688E04689F40F6B1EC20EC601940E06A9AVMB1qlogicor_--
