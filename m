From: "Suresh Kr N" <suresh@veritas.com>
Subject: RE: eata irq abuse (was: Re: Linux 2.5.60)
Date: Thu, 13 Feb 2003 00:41:20 +0530
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <JOEEIMDPCNOOJCHLMKHMKEEKCKAA.suresh@veritas.com>
References: <3E4A7043.1070200@pobox.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from vxindia.veritas.com (unverified) by mtvmime03.VERITAS.COM
 (Content Technologies SMTPRS 4.2.10) with ESMTP id <T605e0e7ad70a891155930@mtvmime03.VERITAS.COM> for <linux-scsi@vger.kernel.org>;
 Wed, 12 Feb 2003 10:47:47 -0800
Received: from floyd (floyd.vxindia.veritas.com [10.212.96.111])
	by vxindia.veritas.com (8.11.6+Sun/8.9.3) with SMTP id h1CIlZr13395
	for <linux-scsi@vger.kernel.org>; Thu, 13 Feb 2003 00:17:35 +0530 (IST)
In-Reply-To: <3E4A7043.1070200@pobox.com>
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

hi everyone

I am working on a san management application for a linux. My application
sends zoning commands to the fabric to zone in a disk to a host ,  so i need
to have that disk acessible to the host without a reboot of the host.

I need to do this from the user space. Is there a way to ask the scsi
midlayer for a rescan ?
In solaris , i invoke a command called "drvconfig" to achieve this.

I have seen in the linux-scsi archive that this is kind of possible,  but
the discussion didnt seem to state how.
I am attaching the above thread here in the mail.

I have verified that echo "scsi add-single-device a b c d" > /proc/scsi/scsi
works fine . But this does involve parameters which cant be found out
programmatically.

Also a side question here :In a FC world, to get the target number for above
command , can i find out the current maximum target number of the scsi
devices, and increase it by one ? or  does the FC devices have actually a
preknown target no , which would be collected by the FC card driver ?

Could someone please help ? ( even a "non-standard" way should be good
enough" )

Thanks
Suresh



--------------------------------------------------------
Message 2 in thread
From: Alan Cox (alan@lxorguk.ukuu.org.uk)
Subject: Re: Hot plugging a disk in runtime
View this article only
Newsgroups: mlist.linux.scsi
Date: 2002-05-20 05:32:38 PST


> 1.. How is it possible to signal SCSI mid-layer (or other layers) of a
> presence of a newly hot-plugged disk ?

aacraid is one example that does this, but via its config tools.

> 2.. Can an adapter's device driver trigger SCSI subsystem to scan
> channels for new LUNs / Targets ?

It is designed so user space can do so - so yes

> 3.. Is this can be handled in a kernel level ? is there a user space
> application that can be triggered to start scanning adapters (obviously
> through SCSI subsystem) and registering new LUNs / Targets etc... ?

echo "scsi-add-single-device a b c d" /proc/scsi/scsi

if I remember it right


entire thread is at

http://groups.google.com/groups?hl=en&lr=&ie=UTF-8&threadm=linux.scsi.200205
201420.g4KEK3x01892%40localhost.localdomain&rnum=7&prev=/groups%3Fq%3Dhot%2B
plug%2B%2BSCSI%2Bfibre-channel%2BLinux%26hl%3Den%26lr%3D%26ie%3DUTF-8%26selm
%3Dlinux.scsi.200205201420.g4KEK3x01892%2540localhost.localdomain%26rnum%3D7

