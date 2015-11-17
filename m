From: Himanshu Madhani <himanshu.madhani@qlogic.com>
Subject: Re: [PATCH, RESEND] qla2xxx: Fix rwlock recursion
Date: Tue, 17 Nov 2015 14:46:28 +0000
Message-ID: <D2707D94.C5671%himanshu.madhani@qlogic.com>
References: <564A663B.606@sandisk.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_000_D2707D94C5671himanshumadhaniqlogiccom_"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-0016ce01.pphosted.com ([67.231.148.157]:7659 "EHLO
	mx0a-0016ce01.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752163AbbKQOqa (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 17 Nov 2015 09:46:30 -0500
Received: from pps.filterd (m0045602.ppops.net [127.0.0.1])
	by mx0a-0016ce01.pphosted.com (8.15.0.59/8.15.0.59) with SMTP id tAHEgcJV006236
	for <linux-scsi@vger.kernel.org>; Tue, 17 Nov 2015 06:46:30 -0800
Received: from avcashub1.qlogic.com (avcashub1.qlogic.com [198.70.193.115])
	by mx0a-0016ce01.pphosted.com with ESMTP id 1y650241cq-1
	(version=TLSv1/SSLv3 cipher=AES128-SHA bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 17 Nov 2015 06:46:30 -0800
In-Reply-To: <564A663B.606@sandisk.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: James Bottomley <james.bottomley@hansenpartnership.com>, Giridhar Malavali <giridhar.malavali@qlogic.com>, Xose Vazquez Perez <xose.vazquez@gmail.com>, linux-scsi <linux-scsi@vger.kernel.org>

--_000_D2707D94C5671himanshumadhaniqlogiccom_
Content-Type: text/plain; charset="us-ascii"
Content-ID: <93C00BF363319944992A32C69E861D42@qlogic.com>
Content-Transfer-Encoding: quoted-printable


On 11/16/15, 3:26 PM, "Bart Van Assche" <bart.vanassche@sandisk.com> wrote:

>This patch fixes the following kernel bug:
>
>kernel:BUG: rwlock recursion on CPU#2, insmod/39333, ffff8803e998cb28
>kernel: Call Trace:
>kernel: [<ffffffff812bce44>] dump_stack+0x48/0x64
>kernel: [<ffffffff810a8047>] rwlock_bug+0x67/0x70
>kernel: [<ffffffff810a833a>] do_raw_write_lock+0x8a/0xa0
>kernel: [<ffffffff815f3033>] _raw_write_lock_irqsave+0x63/0x80
>kernel: [<ffffffffa08087c8>] qla82xx_rd_32+0xe8/0x140 [qla2xxx]
>kernel: [<ffffffffa0808845>] qla82xx_crb_win_lock+0x25/0x60 [qla2xxx]
>kernel: [<ffffffffa0808976>] qla82xx_wr_32+0xf6/0x150 [qla2xxx]
>kernel: [<ffffffffa0808ac0>] qla82xx_disable_intrs+0x50/0x80 [qla2xxx]
>kernel: [<ffffffffa080630a>] qla82xx_reset_chip+0x1a/0x20 [qla2xxx]
>kernel: [<ffffffffa07d6ef2>] qla2x00_initialize_adapter+0x132/0x420
>[qla2xxx]
>kernel: [<ffffffffa08087c8>] qla82xx_rd_32+0xe8/0x140 [qla2xxx]
>kernel: [<ffffffffa0808845>] qla82xx_crb_win_lock+0x25/0x60 [qla2xxx]
>kernel: [<ffffffffa0808976>] qla82xx_wr_32+0xf6/0x150 [qla2xxx]
>kernel: [<ffffffffa0808ac0>] qla82xx_disable_intrs+0x50/0x80 [qla2xxx]
>kernel: [<ffffffffa080630a>] qla82xx_reset_chip+0x1a/0x20 [qla2xxx]
>kernel: [<ffffffffa07d6ef2>] qla2x00_initialize_adapter+0x132/0x420
>[qla2xxx]
>kernel: [<ffffffffa07c964e>] qla2x00_probe_one+0xefe/0x2130 [qla2xxx]
>kernel: [<ffffffff8130052c>] local_pci_probe+0x4c/0xa0
>kernel: [<ffffffff81300603>] pci_call_probe+0x83/0xa0
>kernel: [<ffffffff813008cf>] pci_device_probe+0x7f/0xb0
>kernel: [<ffffffff813e2e83>] really_probe+0x133/0x390
>kernel: [<ffffffff813e3139>] driver_probe_device+0x59/0xd0
>kernel: [<ffffffff813e3251>] __driver_attach+0xa1/0xb0
>kernel: [<ffffffff813e0cdd>] bus_for_each_dev+0x8d/0xb0
>kernel: [<ffffffff813e28ee>] driver_attach+0x1e/0x20
>kernel: [<ffffffff813e2252>] bus_add_driver+0x1d2/0x290
>kernel: [<ffffffff813e3970>] driver_register+0x60/0xe0
>kernel: [<ffffffff813009e4>] __pci_register_driver+0x64/0x70
>kernel: [<ffffffffa04bc1cb>] qla2x00_module_init+0x1cb/0x21b [qla2xxx]
>kernel: [<ffffffff8100027d>] do_one_initcall+0xad/0x1c0
>kernel: [<ffffffff810e2859>] do_init_module+0x69/0x210
>kernel: [<ffffffff810e4e5c>] load_module+0x5cc/0x750
>kernel: [<ffffffff810e5162>] SyS_init_module+0x92/0xc0
>kernel: [<ffffffff815f37d7>] entry_SYSCALL_64_fastpath+0x12/0x6f
>
>Fixes: 8dfa4b5a9b44 ("qla2xxx: Fix sparse annotation")
>Signed-off-by: Bart Van Assche <bart.vanassche@sandisk.com>
>Reported-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
>Tested-by: Himanshu Madhani <himanshu.madhani@qlogic.com>
>Cc: Giridhar Malavali <giridhar.malavali@qlogic.com>
>Cc: Xose Vazquez Perez <xose.vazquez@gmail.com>
>Cc: stable <stable@vger.kernel.org> # v4.3+
>---
> drivers/scsi/qla2xxx/qla_nx.c | 3 ++-
> 1 file changed, 2 insertions(+), 1 deletion(-)
>
>diff --git a/drivers/scsi/qla2xxx/qla_nx.c b/drivers/scsi/qla2xxx/qla_nx.c
>index eb0cc54..b6b4cfd 100644
>--- a/drivers/scsi/qla2xxx/qla_nx.c
>+++ b/drivers/scsi/qla2xxx/qla_nx.c
>@@ -433,7 +433,7 @@ qla82xx_pci_get_crb_addr_2M(struct qla_hw_data *ha,
>ulong off_in,
> 	if (off_in < QLA82XX_PCI_CRBSPACE)
> 		return -1;
>=20
>-	*off_out =3D (void __iomem *)(off_in - QLA82XX_PCI_CRBSPACE);
>+	off_in -=3D QLA82XX_PCI_CRBSPACE;
>=20
> 	/* Try direct map */
> 	m =3D &crb_128M_2M_map[CRB_BLK(off_in)].sub_block[CRB_SUBBLK(off_in)];
>@@ -443,6 +443,7 @@ qla82xx_pci_get_crb_addr_2M(struct qla_hw_data *ha,
>ulong off_in,
> 		return 0;
> 	}
> 	/* Not in direct map, use crb window */
>+	*off_out =3D (void __iomem *)off_in;
> 	return 1;
> }
>=20
>--=20
>2.1.4

Looks Good.=20

Reviewed-by: Himanshu Madhani <himanshu.madhani@qlogic.com>


>


--_000_D2707D94C5671himanshumadhaniqlogiccom_
Content-Disposition: attachment; filename="winmail.dat"
Content-Transfer-Encoding: base64
Content-Type: application/ms-tnef; name="winmail.dat"

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
388fYW6BylDcVEB2GDDWwBUplC4FsGcmMCMgdtA0LjMrJyYt30AnJtmRRXMvBPAAkC+vJeDCSF9u
eCXwIHwiwCB0KyvfaDEoQdyRGZRkHSKwMi2iG4Es0XMoKz4pIrDi4AEAHnDHkigt78fnJyYN4AEg
IN9ApYAFQP88AOAP4RuukOef4RonJh2xLxAwwVCa0LqwNd6ALmL+NsWQiUAcYB6RNLA0x99B7+dv
6n8nROIgK+lv738nRNRAQOcANC5RN+IQ89T/85FgFoJCGDBzYWURoUFp4IgyTSgfYHJ1YwVAneFS
aDsAeJABkCAqEdD+LCcmrcACIClwyOFusff3bwMwAZEtoObwKPjkylAgCFFMQWBAWFhfUABDSV9D
UkJTUHhBQ0XH5/nT+eMJcHTzCHADoC0xFiD5Z97W+eMuKvjiCGAFQD3FwHZvnw3QlWEs0AeAHLAq
Kfpm/+5Q+w/8Ev4H3rD58gFGABBPAd/8Ef4P+cUvKjDReV8zgNUwLIDnUNMwcPewL7f5XBywABAm
ZQIOkDgf0Df2YK2AeKBb+8Ef4ExLwfplKV0uc3UKANyA4ywxCtNTVUILKgX385P989AsIwD0MA6h
9I/1n/avt/e/+M/83zAF+fnyXCBA/QauTiZwLaEH2SKwmWDjMf9lECZAHbEpMAiJA7T/jwCYfxOk
Fb39df36Frne1/6XMhguMS40xuJVTG9vymsn0EciMGQu/pbiVfPMoInwZXfRH9Iv0z/URzMhTCdt
fX3ioCnwHwBCAAEAAAAiAAAASABpAG0AYQBuAHMAaAB1ACAATQBhAGQAaABhAG4AaQAAAAAAHwBl
AAEAAAA4AAAAaABpAG0AYQBuAHMAaAB1AC4AbQBhAGQAaABhAG4AaQBAAHEAbABvAGcAaQBjAC4A
YwBvAG0AAAAfAGQAAQAAAAoAAABTAE0AVABQAAAAAAACAUEAAQAAAHwAAAAAAAAAgSsfpL6jEBmd
bgDdAQ9UAgAAAIBIAGkAbQBhAG4AcwBoAHUAIABNAGEAZABoAGEAbgBpAAAAUwBNAFQAUAAAAGgA
aQBtAGEAbgBzAGgAdQAuAG0AYQBkAGgAYQBuAGkAQABxAGwAbwBnAGkAYwAuAGMAbwBtAAAAHwAC
XQEAAAA4AAAAaABpAG0AYQBuAHMAaAB1AC4AbQBhAGQAaABhAG4AaQBAAHEAbABvAGcAaQBjAC4A
YwBvAG0AAAAfAOVfAQAAAEAAAABzAGkAcAA6AGgAaQBtAGEAbgBzAGgAdQAuAG0AYQBkAGgAYQBu
AGkAQABxAGwAbwBnAGkAYwAuAGMAbwBtAAAAHwAaDAEAAAAiAAAASABpAG0AYQBuAHMAaAB1ACAA
TQBhAGQAaABhAG4AaQAAAAAAHwAfDAEAAAA4AAAAaABpAG0AYQBuAHMAaAB1AC4AbQBhAGQAaABh
AG4AaQBAAHEAbABvAGcAaQBjAC4AYwBvAG0AAAAfAB4MAQAAAAoAAABTAE0AVABQAAAAAAACARkM
AQAAAHwAAAAAAAAAgSsfpL6jEBmdbgDdAQ9UAgAAAIBIAGkAbQBhAG4AcwBoAHUAIABNAGEAZABo
AGEAbgBpAAAAUwBNAFQAUAAAAGgAaQBtAGEAbgBzAGgAdQAuAG0AYQBkAGgAYQBuAGkAQABxAGwA
bwBnAGkAYwAuAGMAbwBtAAAAHwABXQEAAAA4AAAAaABpAG0AYQBuAHMAaAB1AC4AbQBhAGQAaABh
AG4AaQBAAHEAbABvAGcAaQBjAC4AYwBvAG0AAAAfAPg/AQAAACIAAABIAGkAbQBhAG4AcwBoAHUA
IABNAGEAZABoAGEAbgBpAAAAAAAfACNAAQAAADgAAABoAGkAbQBhAG4AcwBoAHUALgBtAGEAZABo
AGEAbgBpAEAAcQBsAG8AZwBpAGMALgBjAG8AbQAAAB8AIkABAAAACgAAAFMATQBUAFAAAAAAAAIB
+T8BAAAAfAAAAAAAAACBKx+kvqMQGZ1uAN0BD1QCAAAAgEgAaQBtAGEAbgBzAGgAdQAgAE0AYQBk
AGgAYQBuAGkAAABTAE0AVABQAAAAaABpAG0AYQBuAHMAaAB1AC4AbQBhAGQAaABhAG4AaQBAAHEA
bABvAGcAaQBjAC4AYwBvAG0AAAAfAAldAQAAADgAAABoAGkAbQBhAG4AcwBoAHUALgBtAGEAZABo
AGEAbgBpAEAAcQBsAG8AZwBpAGMALgBjAG8AbQAAAAsAQDoBAAAAHwAaAAEAAAASAAAASQBQAE0A
LgBOAG8AdABlAAAAAAADAPE/CQQAAAsAQDoBAAAAAwD9P+QEAAACAQswAQAAABAAAADtlXQwDEpi
S5HAVbw0waiMAwAXAAEAAABAADkAADpuvUYh0QFAAAgwIhTKvUYh0QELAACACCAGAAAAAADAAAAA
AAAARgAAAAAUhQAAAQAAAB8AAICGAwIAAAAAAMAAAAAAAABGAQAAAB4AAABhAGMAYwBlAHAAdABs
AGEAbgBnAHUAYQBnAGUAAAAAAAEAAAAMAAAAZQBuAC0AVQBTAAAACwAAgAggBgAAAAAAwAAAAAAA
AEYAAAAABoUAAAAAAAAfADcAAQAAAGQAAABSAGUAOgAgAFsAUABBAFQAQwBIACwAIABSAEUAUwBF
AE4ARABdACAAcQBsAGEAMgB4AHgAeAA6ACAARgBpAHgAIAByAHcAbABvAGMAawAgAHIAZQBjAHUA
cgBzAGkAbwBuAAAAHwA9AAEAAAAKAAAAUgBlADoAIAAAAAAAAwA2AAAAAAAfAEIQAQAAADYAAAA8
ADUANgA0AEEANgA2ADMAQgAuADYAMAA2AEAAcwBhAG4AZABpAHMAawAuAGMAbwBtAD4AAAAAAAIB
cQABAAAAGwAAAAEB0SDGSTyk9wXvghRMmULLKKWOdPWeoEvqgAAfAHAAAQAAAFwAAABbAFAAQQBU
AEMASAAsACAAUgBFAFMARQBOAEQAXQAgAHEAbABhADIAeAB4AHgAOgAgAEYAaQB4ACAAcgB3AGwA
bwBjAGsAIAByAGUAYwB1AHIAcwBpAG8AbgAAAB8ANRABAAAAWgAAADwARAAyADcAMAA3AEQAOQA0
AC4AQwA1ADYANwAxACUAaABpAG0AYQBuAHMAaAB1AC4AbQBhAGQAaABhAG4AaQBAAHEAbABvAGcA
aQBjAC4AYwBvAG0APgAAAAAAHwA5EAEAAAA2AAAAPAA1ADYANABBADYANgAzAEIALgA2ADAANgBA
AHMAYQBuAGQAaQBzAGsALgBjAG8AbQA+AAAAAAADAN4/n04AAEAABzAE8MK9RiHRAQMAJgAAAAAA
AgFHAAEAAAAvAAAAYz1VUzthPSA7cD1RTG9naWM7bD1BVk1CMy0xNTExMTcxNDQ2MjhaLTEwODAx
NAAAHwAVEAEAAABYAAAAOQAzAEMAMAAwAEIARgAzADYAMwAzADEAOQA5ADQANAA5ADkAMgBBADMA
MgBDADYAOQBFADgANgAxAEQANAAyAEAAcQBsAG8AZwBpAGMALgBjAG8AbQAAAAIBFDABAAAADAAA
AMkAAABKrs07TwAAAB8A+j8BAAAAIgAAAEgAaQBtAGEAbgBzAGgAdQAgAE0AYQBkAGgAYQBuAGkA
AAAAAB8AAICGAwIAAAAAAMAAAAAAAABGAQAAABYAAAB1AHMAZQByAC0AYQBnAGUAbgB0AAAAAAAB
AAAARgAAAE0AaQBjAHIAbwBzAG8AZgB0AC0ATQBhAGMATwB1AHQAbABvAG8AawAvADEANAAuADUA
LgA3AC4AMQA1ADEAMAAwADUAAAAAAB8AAIAfpOszqHouQr57eeGpjlSzAQAAADgAAABDAG8AbgB2
AGUAcgBzAGEAdABpAG8AbgBJAG4AZABlAHgAVAByAGEAYwBrAGkAbgBnAEUAeAAAAAEAAAAGAQAA
SQBJAD0AMAAxADAAMQBEADEAMgAxADQANgBCAEQANwA2AEEANAA0ADAAOABCADUANQBCADMARQBC
ADQAQQBCAEEAMwBEAEQARAA2ADQAQQA4AEUARQAxAEYARgAwADsAUwBCAE0ASQBEAD0ANAA7AFMA
MQA9ADwANQA2ADQAQQA2ADYAMwBCAC4ANgAwADYAQABzAGEAbgBkAGkAcwBrAC4AYwBvAG0APgA7
AFYAZQByAHMAaQBvAG4APQBWAGUAcgBzAGkAbwBuACAAMQA0AC4AMwAgACgAQgB1AGkAbABkACAA
MgAzADUALgAwACkALAAgAFMAdABhAGcAZQA9AEgAMgAAAAAAAwANNP0/AAAfAACAhgMCAAAAAADA
AAAAAAAARgEAAAAgAAAAeAAtAG0AcwAtAGgAYQBzAC0AYQB0AHQAYQBjAGgAAAABAAAAAgAAAAAA
AAAfAACAhgMCAAAAAADAAAAAAAAARgEAAAAiAAAAeAAtAG8AcgBpAGcAaQBuAGEAdABpAG4AZwAt
AGkAcAAAAAAAAQAAABgAAABbADEAMAAuADEALgA0AC4AMQAwAF0AAAAfAACAhgMCAAAAAADAAAAA
AAAARgEAAAAWAAAAZABpAHMAYwBsAGEAaQBtAGUAcgAAAAAAAQAAAA4AAABiAHkAcABhAHMAcwAA
AAAAfPA=

--_000_D2707D94C5671himanshumadhaniqlogiccom_--
