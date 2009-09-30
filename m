From: bugzilla-daemon@bugzilla.kernel.org
Subject: [Bug 14242] MPT SAS Fails on heavy operations
Date: Wed, 30 Sep 2009 23:29:25 GMT
Message-ID: <200909302329.n8UNTP0X016141@demeter.kernel.org>
References: <bug-14242-11613@http.bugzilla.kernel.org/>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from demeter.kernel.org ([140.211.167.39]:43006 "EHLO
	demeter.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754995AbZI3X3V convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 30 Sep 2009 19:29:21 -0400
Received: from demeter.kernel.org (localhost.localdomain [127.0.0.1])
	by demeter.kernel.org (8.14.2/8.14.2) with ESMTP id n8UNTPBS016142
	for <linux-scsi@vger.kernel.org>; Wed, 30 Sep 2009 23:29:25 GMT
In-Reply-To: <bug-14242-11613@http.bugzilla.kernel.org/>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

http://bugzilla.kernel.org/show_bug.cgi?id=3D14242





--- Comment #2 from Denys Fedoryshchenko <nuclearcat@nuclearcat.com>  2=
009-09-30 23:29:24 ---
If i just copy fusion directory from previous kernel it works.
Most probably changes what trigger that is (just diff between kernels):


+static void
+mpt_add_sge_64bit(void *pAddr, u32 flagslength, dma_addr_t dma_addr)
+{
+       SGESimple64_t *pSge =3D (SGESimple64_t *) pAddr;
+       pSge->Address.Low =3D cpu_to_le32
+                       (lower_32_bits((unsigned long)(dma_addr)));
+       pSge->Address.High =3D cpu_to_le32
+                       (upper_32_bits((unsigned long)dma_addr));
+       pSge->FlagsLength =3D cpu_to_le32
+                       ((flagslength | MPT_SGE_FLAGS_64_BIT_ADDRESSING=
));
+}

-       } else {
-               SGESimple32_t *pSge =3D (SGESimple32_t *) pAddr;
-               pSge->FlagsLength =3D cpu_to_le32(flagslength);
-               pSge->Address =3D cpu_to_le32(dma_addr);
+/**
+ *     mpt_add_sge_64bit_1078 - Place a simple 64 bit SGE at address p=
Addr
(1078 workaround).
+ *     @pAddr: virtual address for SGE
+ *     @flagslength: SGE flags and data transfer length
+ *     @dma_addr: Physical address
+ *
+ *     This routine places a MPT request frame back on the MPT adapter=
's
+ *     FreeQ.
+ **/
+static void
+mpt_add_sge_64bit_1078(void *pAddr, u32 flagslength, dma_addr_t dma_ad=
dr)
+{
+       SGESimple64_t *pSge =3D (SGESimple64_t *) pAddr;
+       u32 tmp;
+
+       pSge->Address.Low =3D cpu_to_le32
+                       (lower_32_bits((unsigned long)(dma_addr)));
+       tmp =3D (u32)(upper_32_bits((unsigned long)dma_addr));
+

=46ollowing patch in upstream (but not in latest stable kernel) seems f=
ixing my
issue. Probably it must be pushed to stable kernels?

commit=C2=A0=C2=A0c55b89fba9872ebcd5ac15cdfdad29ffb89329f0

[SCSI] mptsas : PAE Kernel more than 4 GB kernel panic

This patch is solving problem for PAE kernel DMA operation.
On PAE system dma_addr and unsigned long will have different
values.
Now dma_addr is not type casted using unsigned long.

--=20
Configure bugmail: http://bugzilla.kernel.org/userprefs.cgi?tab=3Demail
------- You are receiving this mail because: -------
You are watching the assignee of the bug.--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
