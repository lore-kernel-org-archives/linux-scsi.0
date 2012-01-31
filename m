From: "Nandigama, Nagalakshmi" <Nagalakshmi.Nandigama@lsi.com>
Subject: RE: scsi_scan.c reports 'target allocation failed, error -6' w/
 mptsas
Date: Tue, 31 Jan 2012 10:54:39 +0530
Message-ID: <A6888A6805518E4EA4AF7072A28264A6048BC1A714@inbmail02.lsi.com>
References: <20120118100635.GA19750@dot.freshdot.net>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="_002_A6888A6805518E4EA4AF7072A28264A6048BC1A714inbmail02lsic_"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from na3sys009aob106.obsmtp.com ([74.125.149.76]:38212 "EHLO
	na3sys009aog106.obsmtp.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751230Ab2AaFYp (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 31 Jan 2012 00:24:45 -0500
In-Reply-To: <20120118100635.GA19750@dot.freshdot.net>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Sander Smeenk <ssmeenk@freshdot.net>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

--_002_A6888A6805518E4EA4AF7072A28264A6048BC1A714inbmail02lsic_
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable

Sander, can you apply the attached patch and redo the test.

Regards,
Nagalakshmi


-----Original Message-----
From: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-owner@vger.kernel=
.org] On Behalf Of Sander Smeenk
Sent: Wednesday, January 18, 2012 3:37 PM
To: linux-scsi@vger.kernel.org
Subject: scsi_scan.c reports 'target allocation failed, error -6' w/ mptsas

Hi,

i'm experiencing issues while hot(re)plugging SAS-drives in a server
running 2.6.32-37 (stock Ubuntu Lucid). The disks are connected to an
LSI Logic / Symbios Logic SAS1064 PCI-X Fusion-MPT SAS HBA (1000:0500 r2)
Google has no information at all on this specific errormessage.

Situation:
The server is running on 4xSAS drives with the mptsas module, disks are
JBODed to the OS, the OS has them in mdadm software raid.

Each disk needs to be replaced so i unconfigure one in mdadm, ask the
kernel to 'delete' the device node:
| # echo 1 > /sys/block/sdN/device/delete

And then i pull the disk after which the kernel logs:
| scsi: killing requests for dead queue
| scsi target4:0:1: mptsas: ioc0: delete device: fw_channel 0, fw_id 1,
|                   phy 1, sas_addr 0x500000e019670902

When i reseat the replacement disk, nothing gets logged. When i then ask
the kernel to rescan the scsi bus on host4, the kernel logs an error:

| # echo '- - -' > /sys/class/scsi_host/host4/scan
| scsi target4:0:4: target allocation failed, error -6

The replacement drive will not be available to the OS until the system
is rebooted after which the drive works like a charm.=20

The error message is produced in drivers/scsi/scsi_scan.c but i believe
the target_alloc() call comes from the drivers/scsi/mtpsas/mptsas.c
driver. Unfortunately my kernelhack-fu is lacking to look into this
further. As stated, Google has no information about this either.

Anyone on this list with clues as to why this happens or how to
circumvent it from happening with the other three disks?

Thanks,
With regards,
-Sander.
--=20
| How do you write zero in Roman numerals?
| 4096R/20CC6CD2 - 6D40 1A20 B9AA 87D4 84C7  FBD6 F3A9 9442 20CC 6CD2
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html

--_002_A6888A6805518E4EA4AF7072A28264A6048BC1A714inbmail02lsic_
Content-Type: application/octet-stream;
	name="scsi-misc-2[1].6.git-3e84beba608dee5a7c7711a3503eb2f335c78fca.patch"
Content-Description: scsi-misc-2[1].6.git-3e84beba608dee5a7c7711a3503eb2f335c78fca.patch
Content-Disposition: attachment; filename=
	"scsi-misc-2[1].6.git-3e84beba608dee5a7c7711a3503eb2f335c78fca.patch";
	size=2024; creation-date="Tue, 31 Jan 2012 05:23:02 GMT";
	modification-date="Tue, 31 Jan 2012 05:23:02 GMT"
Content-Transfer-Encoding: base64

RnJvbSAzZTg0YmViYTYwOGRlZTVhN2M3NzExYTM1MDNlYjJmMzM1Yzc4ZmNhIE1vbiBTZXAgMTcg
MDA6MDA6MDAgMjAwMQpGcm9tOiBLZWkgVG9rdW5hZ2EgPHRva3VuYWdhLmtlaWljaEBqcC5mdWpp
dHN1LmNvbT4KRGF0ZTogV2VkLCA3IEFwciAyMDEwIDE5OjE3OjI0ICswOTAwClN1YmplY3Q6IFtQ
QVRDSF0gW1NDU0ldIG1wdHNhczogZml4ZWQgaG90LXJlbW92YWwgcHJvY2Vzc2luZwoKVGhpcyBw
YXRjaCBmaXhlcyBtcHRzYXMgZGlzayBob3QtcmVtb3ZhbCBwcm9jZXNzaW5nLiAgVGhlCmhvdC1y
ZW1vdmFsIHByb2Nlc3NpbmcgZG9lc24ndCBjb21wbGV0ZSBiZWNhdXNlIG9mIHRoaXMgY29uZGl0
aW9uLgoKICBkcml2ZXJzL21lc3NhZ2UvZnVzaW9uL21wdHNhcy5jOgogIG1wdHNhc190YXNrbWdt
dF9jb21wbGV0ZSgpCgogIGlmICgobXB0c2FzX2ZpbmRfdnRhcmdldChpb2MsIGNoYW5uZWwsIGlk
KSkgJiYgIWlvYy0+ZndfZXZlbnRzX29mZikKICAgIG1wdHNhc19xdWV1ZV9kZXZpY2VfZGVsZXRl
KC4uLik7CgptcHRzYXNfcXVldWVfZGV2aWNlX2RlbGV0ZSgpLCB3aGljaCBtdXN0IGJlIGNhbGxl
ZCBmb3IKaG90LXJlbW92YWwsIG5ldmVyIGdldHMgY2FsbGVkIGJlY2F1c2UgbXB0c2FzX2ZpbmRf
dnRhcmdldCgpCmFsd2F5cyByZXR1cm5zIDAgaGVyZS4gIEF0IHRoYXQgdGltZSwgdGhlIHZ0YXJn
ZXQgaGFzIGFscmVhZHkKYmVlbiBmcmVlZCBpbiBtcHRzYXNfdGFyZ2V0X2Rlc3Ryb3koKSwgYW5k
IGFsc28gdGhlIHNjc2lfZGV2aWNlCmhhcyBiZWVuIG1hcmtlZCBhcyBTREVWX0RFTC4KCkFzIGEg
cmVzdWx0IG9mIHRoZSBpc3N1ZSwgcG9ydCBkZWxldGlvbiBmdW5jdGlvbnMgd29uJ3QgZ2V0CmNh
bGxlZCBhbmQgdGhlIGRldmljZSBlbmRzIHVwIGJlaW5nIGluIGFuIGluY29tcGxldGUgc3RhdGUu
CihTb21lIGRhdGEgc3RydWN0dXJlcyBhbmQgc3lzZnMgZW50cmllcywgd2hpY2ggc2hvdWxkIGJl
CnJlbW92ZWQgaW4gaG90LXJlbW92YWwsIHJlbWFpbi4pICBPbmUgc2lkZSBlZmZlY3Qgb2YgdGhp
cyBpcwp0aGF0IGEgaG90LWFkZGl0aW9uIG9mIHRoZSBkZXZpY2UgKGJyaW5naW5nIHRoZSBkZXZp
Y2UgYmFjawpvbikgZmFpbHMuCgpUaGlzIHBhdGNoIGp1c3QgcmVtb3ZlcyBtcHRzYXNfZmluZF92
dGFyZ2V0KCkgZnJvbSB0aGUgaWYtc3RhdGUKY29uZGl0aW9uLgoKU2lnbmVkLW9mZi1ieTogS2Vp
IFRva3VuYWdhIDx0b2t1bmFnYS5rZWlpY2hAanAuZnVqaXRzdS5jb20+CkFja2VkLWJ5OiAiRGVz
YWksIEthc2h5YXAiIDxLYXNoeWFwLkRlc2FpQGxzaS5jb20+ClNpZ25lZC1vZmYtYnk6IEphbWVz
IEJvdHRvbWxleSA8SmFtZXMuQm90dG9tbGV5QHN1c2UuZGU+Ci0tLQogZHJpdmVycy9tZXNzYWdl
L2Z1c2lvbi9tcHRzYXMuYyB8ICAgIDIgKy0KIDEgZmlsZXMgY2hhbmdlZCwgMSBpbnNlcnRpb25z
KCspLCAxIGRlbGV0aW9ucygtKQoKZGlmZiAtLWdpdCBhL2RyaXZlcnMvbWVzc2FnZS9mdXNpb24v
bXB0c2FzLmMgYi9kcml2ZXJzL21lc3NhZ2UvZnVzaW9uL21wdHNhcy5jCmluZGV4IGY0Mjc4MWIu
LjQ2Y2M5MGMgMTAwNjQ0Ci0tLSBhL2RyaXZlcnMvbWVzc2FnZS9mdXNpb24vbXB0c2FzLmMKKysr
IGIvZHJpdmVycy9tZXNzYWdlL2Z1c2lvbi9tcHRzYXMuYwpAQCAtMTI2MSw3ICsxMjYxLDcgQEAg
bXB0c2FzX3Rhc2ttZ210X2NvbXBsZXRlKE1QVF9BREFQVEVSICppb2MsIE1QVF9GUkFNRV9IRFIg
Km1mLCBNUFRfRlJBTUVfSERSICptcikKIAkgKiBlbmFibGUgd29yayBxdWV1ZSB0byByZW1vdmUg
ZGV2aWNlIGZyb20gdXBwZXIgbGF5ZXJzCiAJICovCiAJbGlzdF9kZWwoJnRhcmdldF9yZXNldF9s
aXN0LT5saXN0KTsKLQlpZiAoKG1wdHNhc19maW5kX3Z0YXJnZXQoaW9jLCBjaGFubmVsLCBpZCkp
ICYmICFpb2MtPmZ3X2V2ZW50c19vZmYpCisJaWYgKCFpb2MtPmZ3X2V2ZW50c19vZmYpCiAJCW1w
dHNhc19xdWV1ZV9kZXZpY2VfZGVsZXRlKGlvYywKIAkJCSZ0YXJnZXRfcmVzZXRfbGlzdC0+c2Fz
X2V2ZW50X2RhdGEpOwogCi0tIAoxLjcuNi41Cgo=

--_002_A6888A6805518E4EA4AF7072A28264A6048BC1A714inbmail02lsic_--
