From: Mike Christie <mikenc@us.ibm.com>
Subject: Re: Initio 9100u -- Mike Christie's 2.6.0-test11 Patch -- Kernel
 Errors
Date: Mon, 22 Dec 2003 15:42:15 -0800 (PST)
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <Pine.LNX.4.44.0312221530460.6621-200000@dyn319634.beaverton.ibm.com>
References: <1072021603.1952.10.camel@mulgrave>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="789150742-1771436102-1072136535=:6621"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e2.ny.us.ibm.com ([32.97.182.102]:64210 "EHLO e2.ny.us.ibm.com")
	by vger.kernel.org with ESMTP id S264581AbTLVXqB (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 22 Dec 2003 18:46:01 -0500
In-Reply-To: <1072021603.1952.10.camel@mulgrave>
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@steeleye.com>
Cc: James Daniel <jdaniel@dakotacom.net>, SCSI Mailing List <linux-scsi@vger.kernel.org>

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.
  Send mail to mime@docserver.cac.washington.edu for more info.

--789150742-1771436102-1072136535=:6621
Content-Type: TEXT/PLAIN; charset=US-ASCII

On 21 Dec 2003, James Bottomley wrote:

> On Fri, 2003-12-19 at 05:15, Mike Christie wrote:
> > Here is another try. It should compile against 2.6.0-test11/2.6.0.
> 
> That's great thanks.  I've put it in the scsi tree.
> 
> I did notice in the diffs between this one and the previous patch things
> like:
> 
> 
> -			pSG->SG_Ptr = cpu_to_le32((u32)sg_dma_address(pSrbSG));
> -			TotalLen += pSG->SG_Len = cpu_to_le32((u32)sg_dma_len(pSrbSG));
> +			pSG->SG_Ptr = (u32)sg_dma_address(pSrbSG);
> +			TotalLen += pSG->SG_Len = (u32)sg_dma_len(pSrbSG);
> 
> Which is obviously incorrect, since sg_dma_address() does return the
> address in CPU endianness (and the device SG list needs to be in PCI
> endiannes), 

I read the docs and added the cpu_to_le32 calls, but when the patch failed 
for JamesD I looked at the Initio driver that was already converted and noticed
it was not managing the endiannes so I put 2 and 2 together and got 3.

but I think, since it was hard enough to find anyone with
> one of these things, that the chances of finding one on a non-x86 box
> are zero.
> 

The attached patch adds the cpu_to_le32 calls just in case. It was built 
against my previous patch.


mike

--789150742-1771436102-1072136535=:6621
Content-Type: TEXT/PLAIN; charset=US-ASCII; name="ini9100_le.patch"
Content-Transfer-Encoding: BASE64
Content-ID: <Pine.LNX.4.44.0312221542150.6621@dyn319634.beaverton.ibm.com>
Content-Description: 
Content-Disposition: attachment; filename="ini9100_le.patch"

LS0tIGxpbnV4LTIuNi4wLXRlc3QxMS1vcmlnL2RyaXZlcnMvc2NzaS9pbmk5
MTAwdS5jCTIwMDMtMTItMjIgMTU6MzA6MTUuOTI3ODYxOTQzIC0wODAwDQor
KysgbGludXgtMi42LjAtdGVzdDExLXdvcmsvZHJpdmVycy9zY3NpL2luaTkx
MDB1LmMJMjAwMy0xMi0yMiAxNToyODoyOC4zOTMyOTM0MTIgLTA4MDANCkBA
IC00ODQsNyArNDg0LDcgQEAgc3RhdGljIHZvaWQgaTkxdUJ1aWxkU0NCKEhD
UyAqIHBIQ0IsIFNDQg0KIAlkbWFfYWRkciA9IGRtYV9tYXBfc2luZ2xlKCZw
SENCLT5wY2lfZGV2LT5kZXYsIFNDcG50LT5zZW5zZV9idWZmZXIsDQogCQkJ
CSAgU0VOU0VfU0laRSwgRE1BX0ZST01fREVWSUNFKTsNCiAJcFNDQi0+U0NC
X1NlbnNlUHRyID0gY3B1X3RvX2xlMzIoKHUzMilkbWFfYWRkcik7DQotCXBT
Q0ItPlNDQl9TZW5zZUxlbiA9IFNFTlNFX1NJWkU7DQorCXBTQ0ItPlNDQl9T
ZW5zZUxlbiA9IGNwdV90b19sZTMyKFNFTlNFX1NJWkUpOw0KIAlTQ3BudC0+
U0NwLnB0ciA9IChjaGFyICopKHVuc2lnbmVkIGxvbmcpZG1hX2FkZHI7DQog
DQogCXBTQ0ItPlNDQl9DREJMZW4gPSBTQ3BudC0+Y21kX2xlbjsNCkBAIC01
MDIsNyArNTAyLDcgQEAgc3RhdGljIHZvaWQgaTkxdUJ1aWxkU0NCKEhDUyAq
IHBIQ0IsIFNDQg0KIAkJZG1hX2FkZHIgPSBkbWFfbWFwX3NpbmdsZSgmcEhD
Qi0+cGNpX2Rldi0+ZGV2LCAmcFNDQi0+U0NCX1NHTGlzdFswXSwNCiAJCQkJ
CSAgc2l6ZW9mKHN0cnVjdCBTR19TdHJ1YykgKiBUT1RBTF9TR19FTlRSWSwN
CiAJCQkJCSAgRE1BX0JJRElSRUNUSU9OQUwpOw0KLQkJcFNDQi0+U0NCX0J1
ZlB0ciA9IGRtYV9hZGRyOw0KKwkJcFNDQi0+U0NCX0J1ZlB0ciA9IGNwdV90
b19sZTMyKCh1MzIpZG1hX2FkZHIpOw0KIAkJU0NwbnQtPlNDcC5kbWFfaGFu
ZGxlID0gZG1hX2FkZHI7DQogDQogCQlwU3JiU0cgPSAoc3RydWN0IHNjYXR0
ZXJsaXN0ICopIFNDcG50LT5yZXF1ZXN0X2J1ZmZlcjsNCkBAIC01MTIsOCAr
NTEyLDggQEAgc3RhdGljIHZvaWQgaTkxdUJ1aWxkU0NCKEhDUyAqIHBIQ0Is
IFNDQg0KIAkJcFNDQi0+U0NCX0ZsYWdzIHw9IFNDRl9TRzsJLyogVHVybiBv
biBTRyBsaXN0IGZsYWcgICAgICAgKi8NCiAJCWZvciAoaSA9IDAsIFRvdGFs
TGVuID0gMCwgcFNHID0gJnBTQ0ItPlNDQl9TR0xpc3RbMF07CS8qIDEuMDFn
ICovDQogCQkgICAgIGkgPCBwU0NCLT5TQ0JfU0dMZW47IGkrKywgcFNHKyss
IHBTcmJTRysrKSB7DQotCQkJcFNHLT5TR19QdHIgPSAodTMyKXNnX2RtYV9h
ZGRyZXNzKHBTcmJTRyk7DQotCQkJVG90YWxMZW4gKz0gcFNHLT5TR19MZW4g
PSAodTMyKXNnX2RtYV9sZW4ocFNyYlNHKTsNCisJCQlwU0ctPlNHX1B0ciA9
IGNwdV90b19sZTMyKCh1MzIpc2dfZG1hX2FkZHJlc3MocFNyYlNHKSk7DQor
CQkJVG90YWxMZW4gKz0gcFNHLT5TR19MZW4gPSBjcHVfdG9fbGUzMigodTMy
KXNnX2RtYV9sZW4ocFNyYlNHKSk7DQogCQl9DQogDQogCQlwU0NCLT5TQ0Jf
QnVmTGVuID0gKFNDcG50LT5yZXF1ZXN0X2J1ZmZsZW4gPiBUb3RhbExlbikg
Pw0KQEAgLTUyMyw4ICs1MjMsOCBAQCBzdGF0aWMgdm9pZCBpOTF1QnVpbGRT
Q0IoSENTICogcEhDQiwgU0NCDQogCQkJCQkgIFNDcG50LT5yZXF1ZXN0X2J1
ZmZsZW4sDQogCQkJCQkgIFNDcG50LT5zY19kYXRhX2RpcmVjdGlvbik7DQog
CQlTQ3BudC0+U0NwLmRtYV9oYW5kbGUgPSBkbWFfYWRkcjsNCi0JCXBTQ0It
PlNDQl9CdWZQdHIgPSAodTMyKWRtYV9hZGRyOw0KLQkJcFNDQi0+U0NCX0J1
ZkxlbiA9ICh1MzIpU0NwbnQtPnJlcXVlc3RfYnVmZmxlbjsNCisJCXBTQ0It
PlNDQl9CdWZQdHIgPSBjcHVfdG9fbGUzMigodTMyKWRtYV9hZGRyKTsNCisJ
CXBTQ0ItPlNDQl9CdWZMZW4gPSBjcHVfdG9fbGUzMigodTMyKVNDcG50LT5y
ZXF1ZXN0X2J1ZmZsZW4pOw0KIAkJcFNDQi0+U0NCX1NHTGVuID0gMDsNCiAJ
fSBlbHNlIHsNCiAJCXBTQ0ItPlNDQl9CdWZMZW4gPSAwOw0K
--789150742-1771436102-1072136535=:6621--
