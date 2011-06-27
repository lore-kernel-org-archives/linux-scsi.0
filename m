From: <James_Giannoules@DELL.com>
Subject: RE: megaraid_sas driver issues
Date: Mon, 27 Jun 2011 13:06:24 -0500
Message-ID: <53E8A766EFC6CC4E9004422A0D4BE3D509540D7B@AUSX7MCPS306.AMER.DELL.COM>
References: <BANLkTiknooRPVHzPFjHu-w+db=EhG-sxXw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=Windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from ausc60pc101.us.dell.com ([143.166.85.206]:45295 "EHLO
	ausc60pc101.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753188Ab1F0SG1 convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 27 Jun 2011 14:06:27 -0400
In-Reply-To: <BANLkTiknooRPVHzPFjHu-w+db=EhG-sxXw@mail.gmail.com>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: demonccc@gmail.com, linux-scsi@vger.kernel.org

This message indicates the kernel gave up waiting on the 1078 to set th=
e 'F' bit in the VPD capabilities structure. Setting this flag is the h=
ardware's method to indicate to software that data is ready in the VPD =
data register. The PERC6/i and PERC6/E appear to have some bad behavior=
 in this area. This problem either resides in the controller firmware o=
r hardware, and only affects a very specific sequence of PCIe configura=
tion space operations. This does not indicate a more broad issue with n=
ormal controller access.=20

The megaraid_sas driver is not involved in this communication path. In =
fact, this is a PCI layer issue, not a SCSI problem.

It looks like more recent kernels starting querying this information, w=
hich is why the message starting appearing.

-Jim

-----Original Message-----
=46rom: linux-scsi-owner@vger.kernel.org [mailto:linux-scsi-owner@vger.=
kernel.org] On Behalf Of DemonCcC
Sent: Monday, June 27, 2011 12:48 PM
To: linux-scsi@vger.kernel.org
Subject: megaraid_sas driver issues

Hi all,

I have installed Debian on PowerEdge R710 Dell system.

I upgrade the storage controller (LSI MegaRAID SAS 1078) to the last fi=
rmware version that Dell provides (6.3.0-0001). The server has two stor=
age controllers, one internal (PERC 6/i Integrated) and other external =
( PERC 6/E Adapter).

With the kernels 2.6.35, 2.6.38 and 2.6.39 the kernel returns these mes=
sages:

Jun 24 21:41:44 mysql01 kernel: [   29.428857] megaraid_sas
0000:03:00.0: vpd r/w failed.  This is likely a firmware bug on this de=
vice.  Contact the card vendor for a firmware update.
Jun 24 21:41:45 mysql01 kernel: [   29.817765] megaraid_sas
0000:0a:00.0: vpd r/w failed.  This is likely a firmware bug on this de=
vice.  Contact the card vendor for a firmware update.

The kernel 2.6.32 doesn't return any error.

I tested with the pci=3Dnocrs, because I have read that the default is =
pci=3Duse_crs in the newest kernel and it could cause a timeout when th=
e kernel tries to read the vpd, but the kernel still logging these mess=
ages.

Also I compiled the latest megaraid_sas driver (00.00.05.38-rc1) but th=
ese messages keep appearing.

Do you know what could be the issue? Why the newest kernels log these m=
essages?

Regards.

Claudio C=E9sar S=E1nchez Tejeda
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n the body of a message to majordomo@vger.kernel.org More majordomo inf=
o at  http://vger.kernel.org/majordomo-info.html
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
