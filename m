From: "Hammer, Jack" <Jack_Hammer@adaptec.com>
Subject: Updated Patch for ServeRAID V7.12.02
Date: Mon, 25 Jul 2005 08:46:55 -0400
Message-ID: <A121ABA5B472B74EB59076B8E3C8F0190153437A@rtpe2k01.adaptec.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
	boundary="----_=_NextPart_001_01C59116.EFEC21E8"
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:43930 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S261152AbVGYMsj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Mon, 25 Jul 2005 08:48:39 -0400
Received: from redfish.adaptec.com (redfish.adaptec.com [162.62.50.11])
	by magic.adaptec.com (8.11.6/8.11.6) with ESMTP id j6PCmdc18598
	for <linux-scsi@vger.kernel.org>; Mon, 25 Jul 2005 05:48:39 -0700
Received: from rtpe2k01.adaptec.com (rtpe2k01.adaptec.com [10.110.12.40])
	by redfish.adaptec.com (8.11.6/8.11.6) with ESMTP id j6PCmcg23885
	for <linux-scsi@vger.kernel.org>; Mon, 25 Jul 2005 05:48:38 -0700
content-class: urn:content-classes:message
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

This is a multi-part message in MIME format.

------_=_NextPart_001_01C59116.EFEC21E8
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable


I am resubmitting the 2.6 kernel patch for the Version 7.12.02 ips
driver.
I have eliminated a couple of inappropriate changes pointed out by
Arjan.

Signed-off-by: Jack Hammer <jack_hammer@adaptec.com>

--- a/drivers/scsi/ips.c	Tue Jul 19 13:15:24 2005
+++ b/drivers/scsi/ips.c	Tue Jul 19 13:12:44 2005
@@ -133,10 +133,12 @@
 /* 6.10.00  - Remove 1G Addressing Limitations
*/
 /* 6.11.xx  - Get VersionInfo buffer off the stack !              DDTS
60401 */
 /* 6.11.xx  - Make Logical Drive Info structure safe for DMA      DDTS
60639 */
-/* 7.10.xx  - Add highmem_io flag in SCSI Templete for 2.4 kernels
*/
+/* 7.10.18  - Add highmem_io flag in SCSI Templete for 2.4 kernels
*/
 /*          - Fix path/name for scsi_hosts.h include for 2.6 kernels
*/
 /*          - Fix sort order of 7k
*/
 /*          - Remove 3 unused "inline" functions
*/
+/* 7.12.xx  - Use STATIC functions whereever possible
*/
+/*          - Clean up deprecated MODULE_PARM calls
*/
=20
/***********************************************************************
******/
=20
 /*
@@ -207,8 +209,8 @@
 /*
  * DRIVER_VER
  */
-#define IPS_VERSION_HIGH        "7.10"
-#define IPS_VERSION_LOW         ".18 "
+#define IPS_VERSION_HIGH        "7.12"
+#define IPS_VERSION_LOW         ".02 "
=20
 #if !defined(__i386__) && !defined(__ia64__) && !defined(__x86_64__)
 #warning "This driver has only been tested on the x86/ia64/x86_64
platforms"
--- a/drivers/scsi/ips.h	Tue Jul 19 13:15:31 2005
+++ b/drivers/scsi/ips.h	Tue Jul 19 12:49:03 2005
@@ -87,15 +87,14 @@
       #define scsi_set_pci_device(sh,dev) (0)
    #endif
=20
-   #if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
-  =20
-      #ifndef irqreturn_t
-         typedef void irqreturn_t;
-      #endif=20
-     =20
+   #ifndef IRQ_NONE
+      typedef void irqreturn_t;
       #define IRQ_NONE
       #define IRQ_HANDLED
       #define IRQ_RETVAL(x)
+   #endif
+  =20
+   #if LINUX_VERSION_CODE < KERNEL_VERSION(2,5,0)
       #define IPS_REGISTER_HOSTS(SHT)
scsi_register_module(MODULE_SCSI_HA,SHT)
       #define IPS_UNREGISTER_HOSTS(SHT)
scsi_unregister_module(MODULE_SCSI_HA,SHT)
       #define IPS_ADD_HOST(shost,device)
@@ -123,6 +122,10 @@
    #ifndef min
       #define min(x,y) ((x) < (y) ? x : y)
    #endif
+  =20
+   #ifndef __iomem       /* For clean compiles in earlier kernels
without __iomem annotations */
+      #define __iomem
+   #endif
=20
    #define pci_dma_hi32(a)         ((a >> 16) >> 16)
    #define pci_dma_lo32(a)         (a & 0xffffffff)
@@ -1206,13 +1209,13 @@
=20
 #define IPS_VER_MAJOR 7
 #define IPS_VER_MAJOR_STRING "7"
-#define IPS_VER_MINOR 10
-#define IPS_VER_MINOR_STRING "10"
-#define IPS_VER_BUILD 18
-#define IPS_VER_BUILD_STRING "18"
-#define IPS_VER_STRING "7.10.18"
+#define IPS_VER_MINOR 12
+#define IPS_VER_MINOR_STRING "12"
+#define IPS_VER_BUILD 02
+#define IPS_VER_BUILD_STRING "02"
+#define IPS_VER_STRING "7.12.02"
 #define IPS_RELEASE_ID 0x00020000
-#define IPS_BUILD_IDENT 731
+#define IPS_BUILD_IDENT 761
 #define IPS_LEGALCOPYRIGHT_STRING "(C) Copyright IBM Corp. 1994, 2002.
All Rights Reserved."
 #define IPS_ADAPTECCOPYRIGHT_STRING "(c) Copyright Adaptec, Inc. 2002
to 2004. All Rights Reserved."
 #define IPS_DELLCOPYRIGHT_STRING "(c) Copyright Dell 2004. All Rights
Reserved."
@@ -1223,12 +1226,12 @@
 #define IPS_VER_SERVERAID2 "2.88.13"
 #define IPS_VER_NAVAJO "2.88.13"
 #define IPS_VER_SERVERAID3 "6.10.24"
-#define IPS_VER_SERVERAID4H "7.10.11"
-#define IPS_VER_SERVERAID4MLx "7.10.18"
-#define IPS_VER_SARASOTA "7.10.18"
-#define IPS_VER_MARCO "7.10.18"
-#define IPS_VER_SEBRING "7.10.18"
-#define IPS_VER_KEYWEST "7.10.18"
+#define IPS_VER_SERVERAID4H "7.12.02"
+#define IPS_VER_SERVERAID4MLx "7.12.02"
+#define IPS_VER_SARASOTA "7.12.02"
+#define IPS_VER_MARCO "7.12.02"
+#define IPS_VER_SEBRING "7.12.02"
+#define IPS_VER_KEYWEST "7.12.02"
=20
 /* Compatability IDs for various adapters */
 #define IPS_COMPAT_UNKNOWN ""

------_=_NextPart_001_01C59116.EFEC21E8
Content-Type: application/octet-stream;
	name="ips_v7.12_patch.bz2"
Content-Transfer-Encoding: base64
Content-Description: ips_v7.12_patch.bz2
Content-Disposition: attachment;
	filename="ips_v7.12_patch.bz2"

QlpoOTFBWSZTWVYwjE8AAer/gF+wBSh5///9////4L/v/+BQBeyGxlXhuwBtgyddYSSJok2QBoam
mp+qNoNGiG0mQDNTE0yYmmQwmgahpqbU1Mie1T1DQA0ADQAPUHlABkADQBIiUwU2k0yNTQZPUaD1
MjQAAPUAPUAAAOaYjIyaZNAMhoyGTIAAAZGmRoGEMgSQhNAEEzSTU8o9R6jQaGgAAGgBoG0nqDDX
AX3YF084z9u7Sz49FQZZsubshTnqytqtLldIz5nujUMh3jv+dWDK7rVoabRwFqrq2H+XmwVnC1xG
lNkO3K7ECN1DNhw0IRoN+ESiuaM7EzQDL3T1GA76kwONjrcu2VRsVgJi55K60lr0lEfJwpP+u++d
udsE0cURFFFDt7bIi0MwN2UD2OF1/GzuCzwW8E/nkFkFXEbRRlJgzkX7Dh0/BOz90OK809TIusru
WM1dPFmGparhm0tJvXsmveTrFVdWB8l6Mez/9eSEXGoZGoPNZ+tUWspVvkOgOQo2EHbOuK+XCEl5
GGJFAtu46YQB0TNFvHDmvYDdf2jK6obl34rXuZ4roXGqzV00W5x3EwHLY2bxB4GY9+Nu+7DcGkYG
lpNiNPKzypbmRttjkiG24iG4IhtuV434h4IbmEOI64wsZ3i/WOqbqq1XiMj3OuHml09HJI5u7G+/
LAzEZJ5VNB/IbPGhVmN0dyz9XTF0N0R9Lyp9EGMYSYZDxbFfjNqlrjNxbZEROfym9vUVhXntTTfS
JEmNQLua9+M0LmaKJY8jAbpBCDcHwZKCNxDsw/40IVcoYTWmdmbwyM1jxCiuFyxYZhw6SEie08nH
ZDFXiwUaWzB22YmFcNVEZ6O5SvLbWEohPDAb94zNfShMlOSkTHUwKOK2reJ06YYVxhmRJKisHiAH
wbBlY198QXtVqsXzZuVd3yUH0dU2PgSl14ENaYhBAWbRhquVllsY7zGcvY1ZpqdHJuQwmYBgqrhk
pnBbt/NkRQKpbdclfBahaMZBcoy+wJhags+6cxfOYXfAbmhi+QMfHegeVMqlakQlCmZ5IGqpoXIA
gVESLWFbUOdlwPMxtNhNNaEE5kiV5o5kpTGN6XkGAsEwWDALxlkydVcrQXVswQxLidRoBaEJj2p5
z2iYjkZryiYFzhoXAUQkXk4I+xrkwrjZBXQWnNTFVJQMOYn9Y2UA2lO8avxcnk5UxBYzHDjGRBQX
b0BomkbRhOnJMNwXMbyWFaoEZXLIMHTCgLLF3LVBwZuFLC4GQItTLeBYFo4winrHA3GQDEipbW4t
EQdSBG00G3BIeTFrCMxi6ilceDyBtFVYGBSzbLQTJAZzzNw3E2LQsXhNpcMMYjl5/cGcyrjlJDoJ
k5DwQMBXUbhmToOwHiPSSxStgLabeW61k7Bk/8mWBjSzcAgIIIgXD6i1SH3RFULpf1XQj2SCNULD
KBMK1czJyqslNtAHP+sNCo6XZVlOgSP8QC7ldx8GrWIcwn4w8Rv1LASGxDu2y4F3b0SWbc415zjG
dtLnKLFan30xEJMdlAxR6B2HLkit/Q+6MjdvB4D4dq34rZT35zJK/JjDEWsnGUMdLkuT+KYIXIsD
gOLJhy0kBbQ85ZVqx19MGvlKSpAoDWXSoDqh58isXp0YUqpfVCpp2KbiZsKAUrLRs+y2h04VroaC
sXSa/WkF5HPgxVQpCR7K2TzwJPdTAmvPp11NfeqzVZHI6CnmLgbC+4sJjGElY0SiHkuPhlsNwVRC
EKgTHHayuNYBuVtBtNTI6OoouG+cMwQqhyYk0dGuYx2RhNfJF2Zn2JhjzWBtG0rE0UQxjtwzh1tv
/LFXd+SHuuVoRGCgT6utQwMmkq2XWW0rpmFtwaYgC6l3t+xKqe2MUAWRWjnctjJwwksqN7kMNnKN
GiYzT3QMUvgaJ3posVM+3Df3w6/mDnOk25mobuds5OZ3p0YModBnAG8RgOKtU7l89EMWzV1LKHIX
/F3JFOFCQVjCMTw=

------_=_NextPart_001_01C59116.EFEC21E8--
