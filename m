From: =?ISO-8859-1?Q?Adrien_Corbi=E8re?= <corbiere@iutc3.unicaen.fr>
Subject: Re: Problem with 2.6 kernel and sym53c8xx driver
Date: Wed, 01 Mar 2006 19:59:26 +0100
Message-ID: <4405EF0E.1090403@iutc3.unicaen.fr>
References: <440481D2.6030107@iutc3.unicaen.fr> <20060301132055.GA1598@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sizun.unicaen.fr ([193.55.130.147]:53721 "EHLO sizun.unicaen.fr")
	by vger.kernel.org with ESMTP id S1751802AbWCAS73 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 1 Mar 2006 13:59:29 -0500
In-Reply-To: <20060301132055.GA1598@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: linux-scsi@vger.kernel.org

Matthew Wilcox a =E9crit :

>This looks like a problem with the BROWNIE device,  as I've found a
>similar problem here:
>http://lists.suse.com/archive/suse-amd64/2004-Mar/0069.html
>
>This is with an Adaptec card, so chances are it's the device at
>fault, not the driver.  Looks to me like a bad implementation of
>REPORT_LUN, so this patch should remove those annoying messages:
>
>Index: ./drivers/scsi/scsi_devinfo.c
>=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>RCS file: /var/cvs/linux-2.6/drivers/scsi/scsi_devinfo.c,v
>retrieving revision 1.16
>diff -u -p -r1.16 scsi_devinfo.c
>--- ./drivers/scsi/scsi_devinfo.c	17 Jan 2006 14:51:49 -0000	1.16
>+++ ./drivers/scsi/scsi_devinfo.c	1 Mar 2006 13:17:21 -0000
>@@ -126,6 +126,7 @@ static struct {
> 	{"ADAPTEC", "Adaptec 5400S", NULL, BLIST_FORCELUN},
> 	{"AFT PRO", "-IX CF", "0.0>", BLIST_FORCELUN},
> 	{"BELKIN", "USB 2 HS-CF", "1.95",  BLIST_FORCELUN | BLIST_INQUIRY_36=
},
>+	{"BROWNIE", "1600U3P", NULL, BLIST_NOREPORTLUN},
> 	{"CANON", "IPUBJD", NULL, BLIST_SPARSELUN},
> 	{"CBOX3", "USB Storage-SMC", "300A", BLIST_FORCELUN | BLIST_INQUIRY_=
36},
> 	{"CMD", "CRA-7280", NULL, BLIST_SPARSELUN},	/* CMD RAID Controller *=
/
>
Thanks a lot! I've applyed the patch on kernel 2.6.15.4, and it works=20
very well ! The ouput of dmesg is :

PCI: Found IRQ 9 for device 0000:01:03.0
sym0: <1010-66> rev 0x1 at pci 0000:01:03.0 irq 9
sym0: Symbios NVRAM, ID 7, Fast-80, LVD, parity checking
sym0: open drain IRQ line driver, using on-chip SRAM
sym0: using LOAD/STORE-based firmware.
sym0: handling phase mismatch from SCRIPTS.
sym0: SCSI BUS has been reset.
scsi0 : sym-2.2.1
  Vendor: BROWNIE   Model: 1600U3P           Rev: 0001
  Type:   Direct-Access                      ANSI SCSI revision: 03
 target0:0:1: tagged command queuing enabled, command queue depth 16.
 target0:0:1: Beginning Domain Validation
 target0:0:1: asynchronous.
 target0:0:1: wide asynchronous.
 target0:0:1: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 31)
 target0:0:1: FAST-80 WIDE SCSI 160.0 MB/s DT (12.5 ns, offset 31)
 target0:0:1: Domain Validation skipping write tests
 target0:0:1: Ending Domain Validation
  Vendor: COMPAQ    Model: SDT-10000         Rev: 1.14
  Type:   Sequential-Access                  ANSI SCSI revision: 02
 target0:0:5: Beginning Domain Validation
 target0:0:5: asynchronous.
 target0:0:5: wide asynchronous.
 target0:0:5: FAST-20 WIDE SCSI 40.0 MB/s ST (50 ns, offset 15)
 target0:0:5: Domain Validation skipping write tests
 target0:0:5: Ending Domain Validation
SCSI device sda: 2568192000 512-byte hdwr sectors (1314914 MB)
SCSI device sda: drive cache: write back
SCSI device sda: 2568192000 512-byte hdwr sectors (1314914 MB)
SCSI device sda: drive cache: write back
 sda: sda1 sda2
sd 0:0:1:0: Attached scsi disk sda


--=20
Adrien CORBIERE                            Tel: 02.31.52.55.26
IUT de Caen - Campus III                   Fax: 02.31.52.55.22
Rue Anton Tchekhov
B.P. 53
14123 Ifs=20

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
