From: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Subject: Re: LSI SAS - SSDs with  DRAT and DZAT
Date: Fri, 11 Apr 2014 18:57:18 +0200
Message-ID: <53481EEE.3090405@itwm.fraunhofer.de>
References: <1391730975.3449.16.camel@sonic.justonedata.com>	 <yq1vbwqslek.fsf@sermon.lab.mkp.net>	 <1391806363.2761.8.camel@sonic.justonedata.com>	 <yq1mwi2skoz.fsf@sermon.lab.mkp.net>	 <1391808293.2761.9.camel@sonic.justonedata.com>	 <yq1iosqs8fx.fsf@sermon.lab.mkp.net>	 <1391984895.13523.13.camel@tardis.intricatesoftware.com> <1392172050.2761.37.camel@sonic.justonedata.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mailgw1.uni-kl.de ([131.246.120.220]:37250 "EHLO
	mailgw1.uni-kl.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759563AbaDKQ5W (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 11 Apr 2014 12:57:22 -0400
Received: from itwm2.itwm.fhg.de (itwm2.itwm.fhg.de [131.246.191.3])
	by mailgw1.uni-kl.de (8.14.3/8.14.3/Debian-9.4) with ESMTP id s3BGvKRv032720
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Fri, 11 Apr 2014 18:57:20 +0200
In-Reply-To: <1392172050.2761.37.camel@sonic.justonedata.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kurt Miller <kurt@intricatesoftware.com>, "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: linux-scsi@vger.kernel.org

On 02/12/2014 03:27 AM, Kurt Miller wrote:
> I can report that the Samsung 840 Pro*does*  support trim on the LSI
> SAS2008. As suspected it supports deterministic read zeros after trim.
>
> One other thing to note, in my testing the P16 LSI firmware has broken
> trim support. P14 and P15 report incorrect values for
> /sys/block/sdX/queue/discard_granularity. P17 and P18 appear to work
> fine and report correct values for discard_granularity.

We are just looking for SSDs for our new compute cluster and would like 
to get SSDs that support trim on LSI sas controllers out of the box.
Unfortunately, for a test sample of Samsungs MZ7WD240HCFV discard is not 
enabled by default, so probably DRAT and DZAT are missing
(I can't test that right now, as 'hdparm -I' does not seem to work with 
devices attached to the controller).

A colleague just told me that Samsung 840 Pro are also not an ideal 
option, as these have set overprovisioning to 0 bytes by default and 
there only seems to be windows tool to set it to a higher value. Not a 
nice idea if you want to do that for dozens or hundreds of drives.

Any other suggestions for ~240GB SSDs supporting DRAT and DZAT or 
trim-on-lsi-sas in general? The LSI support link sent by Kurt [1] is 
also not perfect with respect to trim, as it lists Intel510, although we 
definitely know that Intel510s are disabled by default and forcing 
write-same trim causes data corruption (unmap works, though).


Thanks in advance,
Bernd


[1]
> http://www.lsi.com/downloads/Public/Host%20Bus%20Adapters/Host%20Bus%20Adapters%20Common%20Files/LSI_6Gb_SAS_SATA_HBA_Compatibility_List.pdf


