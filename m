From: "Salyzyn, Mark" <mark_salyzyn@adaptec.com>
Subject: RE: 2.6.6 + Adaptec I2O
Date: Tue, 1 Jun 2004 14:39:19 -0400
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <547AF3BD0F3F0B4CBDC379BAC7E4189FAD5143@otce2k03.adaptec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:37568 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S265122AbUFASjV convert rfc822-to-8bit
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 1 Jun 2004 14:39:21 -0400
content-class: urn:content-classes:message
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <willy@debian.org>
Cc: Andi Kleen <ak@muc.de>, linux-scsi@vger.kernel.org

There are two parts to the dptsig needs, one is a runtime need by the
management tools, and other is a binary inspection tool.

Dptsig inspects the module binary under any OS. It also inspects all of
the other dpt products for all other operating systems as well. It was
standard started in 1992 by DPT for their binaries. There is no running
linux kernel for this information to be acquired by the binary itself.
One could run the dptsig tool on windows and inspect a linux module
binary.

The management tools could (but doesn't for linux, this is for sake of
argument) report the driver was built for an i386 processor, yet we
could be running on an i686 kernel. Other drivers from DPT/Adaptec for
other operating systems have the same ioctl call populated with the same
information.

The management tools themselves contain a hierarchy of dptsig
structures, each reporting the purpose, the compile environment and the
runtime environment of each product in layers. For instance, the public
domain raidutil will report the driver, ioctl engine as well as the
raidutil's dptsig information.

Sincerely -- Mark Salyzyn

-----Original Message-----
From: willy@www.linux.org.uk [mailto:willy@www.linux.org.uk] On Behalf
Of Matthew Wilcox
Sent: Tuesday, June 01, 2004 2:29 PM
To: Salyzyn, Mark
Cc: Andi Kleen; linux-scsi@vger.kernel.org
Subject: Re: 2.6.6 + Adaptec I2O

On Tue, Jun 01, 2004 at 02:27:44PM -0400, Salyzyn, Mark wrote:
> It's not the driver that needs to know, it's an information box on the
> RAID applications that need to know via a management ioctl (see the
> public domain raidutil tool for the cli variant). It's the `dptsig'
tool
> that reads the binary and provides version and processor type the
binary
> is compiled for.

Why can't it get this information via uname?

-- 
"Next the statesmen will invent cheap lies, putting the blame upon 
the nation that is attacked, and every man will be glad of those
conscience-soothing falsities, and will diligently study them, and
refuse
to examine any refutations of them; and thus he will by and by convince 
himself that the war is just, and will thank God for the better sleep 
he enjoys after this process of grotesque self-deception." -- Mark Twain
