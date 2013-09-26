From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: SCSI's heuristics for enabling WRITE SAME still need work [was: dm mpath: disable WRITE SAME if it fails]
Date: Thu, 26 Sep 2013 10:42:00 -0400
Message-ID: <yq1r4cbablz.fsf@sermon.lab.mkp.net>
References: <20130919161043.GA27081@redhat.com>
	<20130920212142.GA17898@redhat.com>
	<yq1eh8jf8wq.fsf@sermon.lab.mkp.net>
	<1379960325.4010.32.camel@localhost.localdomain>
	<52412581.2010909@suse.de> <20130924123449.GA16083@redhat.com>
	<yq1hadaba87.fsf@sermon.lab.mkp.net> <52434D0C.1090008@fastmail.fm>
	<yq1vc1o9ztd.fsf@sermon.lab.mkp.net> <5243C880.6050609@interlog.com>
	<52443992.4040806@fastmail.fm>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from userp1040.oracle.com ([156.151.31.81]:22283 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750909Ab3IZOmP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Sep 2013 10:42:15 -0400
In-Reply-To: <52443992.4040806@fastmail.fm> (Bernd Schubert's message of "Thu,
	26 Sep 2013 15:41:38 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bernd Schubert <bernd.schubert@fastmail.fm>
Cc: dgilbert@interlog.com, "Martin K. Petersen" <martin.petersen@oracle.com>, Mike Snitzer <snitzer@redhat.com>, Hannes Reinecke <hare@suse.de>, emilne@redhat.com, device-mapper development <dm-devel@redhat.com>, linux-scsi@vger.kernel.org, Sumit.Saxena@lsi.com

>>>>> "Bernd" == Bernd Schubert <bernd.schubert@fastmail.fm> writes:

Bernd,

Bernd> Both types of systems we have in-house neither block limits vpd
Bernd> nor READ_CAP16 return anything that would indicate discard is
Bernd> supported. But UNMAP and WRITE SAME unmap(*) just work fine.

I have a collection of different SSDs in a tray connected to an LSI
SAS2008 ASIC. The 510 is the only drive that does not have LBPME=1.
Chances are it's because DRAT and RZAT are not set but it could also be
that the 510 is blacklisted.


Bernd> I certainly don't want to cause any more write-same trouble, but
Bernd> as all layers initially have to assume write same is supported
Bernd> anyway and need to dynamically disable it if it fails, can't we
Bernd> also enable discard by default with WRITE SAME16 unmap?  

No thanks :)

But you can force discards on by doing a:

 # echo -n unmap > /sys/class/scsi_disk/x:y:z:n/provisioning_mode

or

 # echo -n writesame_16 > /sys/class/scsi_disk/x:y:z:n/provisioning_mode

Create a udev rule if you like.

In any case I wouldn't recommend using TRIM on that drive...


Bernd> PS: LSI SATL with FWv17 seems to have an unmap bug - I cannot
Bernd> unmap the last sector:

Yes, it appears there's an off-by-one bug in the UNMAP translation.
Sumit, is this something you guys can look into?

-- 
Martin K. Petersen	Oracle Linux Engineering
