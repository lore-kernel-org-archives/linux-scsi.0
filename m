From: Bernd Schubert <bernd.schubert@fastmail.fm>
Subject: Re: SCSI's heuristics for enabling WRITE SAME still need work [was:
 dm mpath: disable WRITE SAME if it fails]
Date: Thu, 26 Sep 2013 17:34:07 +0200
Message-ID: <524453EF.6040404@fastmail.fm>
References: <20130919161043.GA27081@redhat.com>	<20130920212142.GA17898@redhat.com>	<yq1eh8jf8wq.fsf@sermon.lab.mkp.net>	<1379960325.4010.32.camel@localhost.localdomain>	<52412581.2010909@suse.de> <20130924123449.GA16083@redhat.com>	<yq1hadaba87.fsf@sermon.lab.mkp.net> <52434D0C.1090008@fastmail.fm>	<yq1vc1o9ztd.fsf@sermon.lab.mkp.net> <5243C880.6050609@interlog.com>	<52443992.4040806@fastmail.fm> <yq1r4cbablz.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailgw1.uni-kl.de ([131.246.120.220]:46308 "EHLO
	mailgw1.uni-kl.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751078Ab3IZPeM (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 26 Sep 2013 11:34:12 -0400
Received: from itwm2.itwm.fhg.de (itwm2.itwm.fhg.de [131.246.191.3])
	by mailgw1.uni-kl.de (8.14.3/8.14.3/Debian-9.4) with ESMTP id r8QFY9Ae025491
	(version=TLSv1/SSLv3 cipher=EDH-RSA-DES-CBC3-SHA bits=168 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Thu, 26 Sep 2013 17:34:10 +0200
In-Reply-To: <yq1r4cbablz.fsf@sermon.lab.mkp.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: dgilbert@interlog.com, Mike Snitzer <snitzer@redhat.com>, Hannes Reinecke <hare@suse.de>, emilne@redhat.com, device-mapper development <dm-devel@redhat.com>, linux-scsi@vger.kernel.org, Sumit.Saxena@lsi.com

On 09/26/2013 04:42 PM, Martin K. Petersen wrote:
>>>>>> "Bernd" == Bernd Schubert <bernd.schubert@fastmail.fm> writes:
>
> Bernd,
>
> Bernd> Both types of systems we have in-house neither block limits vpd
> Bernd> nor READ_CAP16 return anything that would indicate discard is
> Bernd> supported. But UNMAP and WRITE SAME unmap(*) just work fine.
>
> I have a collection of different SSDs in a tray connected to an LSI
> SAS2008 ASIC. The 510 is the only drive that does not have LBPME=1.
> Chances are it's because DRAT and RZAT are not set but it could also be
> that the 510 is blacklisted.
>
>
> Bernd> I certainly don't want to cause any more write-same trouble, but
> Bernd> as all layers initially have to assume write same is supported
> Bernd> anyway and need to dynamically disable it if it fails, can't we
> Bernd> also enable discard by default with WRITE SAME16 unmap?
>
> No thanks :)
>
> But you can force discards on by doing a:
>
>   # echo -n unmap > /sys/class/scsi_disk/x:y:z:n/provisioning_mode
>
> or
>
>   # echo -n writesame_16 > /sys/class/scsi_disk/x:y:z:n/provisioning_mode

D'oh, I didn't know about this parameter! THANKS a lot!

>
> Create a udev rule if you like.

Definitely, we have rules anyway.

>
> In any case I wouldn't recommend using TRIM on that drive...

Hmm yeah, the problem is that that these SSDs are used in our compute 
nodes (but we as file system group can also sometimes use it for 
benchmarking) and these SSDs slow down rather quickly without trim. The 
current procedure is to remove everything, to sg_unmap the full device 
and to re-create anything. So anything that would allow us to do it on 
the fly is very welcome. I don't think we need DRAT and RZAT, as we only 
use raid0 for these nodes.

So thanks a lot for your hint about the provisioning_mode!

>
>
> Bernd> PS: LSI SATL with FWv17 seems to have an unmap bug - I cannot
> Bernd> unmap the last sector:
>
> Yes, it appears there's an off-by-one bug in the UNMAP translation.
> Sumit, is this something you guys can look into?
>


Thanks again,
Bernd


