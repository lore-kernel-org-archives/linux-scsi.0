From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: RAID-10 keeps aborting
Date: Wed, 05 Jun 2013 15:11:21 -0400
Message-ID: <yq1vc5spe3q.fsf@sermon.lab.mkp.net>
References: <51AC1440.7020505@zytor.com>
	<CAA9_cmddLfReYeAhgwh5=j6ELMBNx5Oq7Gg8K+fo0PneaEfrVA@mail.gmail.com>
	<51AC3283.4000403@zytor.com>
	<CAA9_cme6tYpYnrZDbrDduwPCjVn+PFbx_rZNPFazBEU9EF0upw@mail.gmail.com>
	<51ACBAA0.40604@zytor.com>
	<CAA9_cmc3Gs91C4aV6okUw-=q+fACm1+dooyafOZi+Lnj+Ne_ig@mail.gmail.com>
	<51ACD511.4030604@zytor.com> <yq1y5art543.fsf@sermon.lab.mkp.net>
	<51AD2485.9000601@zytor.com>
	<alpine.DEB.2.02.1306041132260.19072@jlaw-desktop.mno.stratus.com>
	<51AF0CCF.8000909@itwm.fraunhofer.de>
	<51AF232C.8060209@itwm.fraunhofer.de>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from aserp1040.oracle.com ([141.146.126.69]:17033 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756491Ab3FETLG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Jun 2013 15:11:06 -0400
In-Reply-To: <51AF232C.8060209@itwm.fraunhofer.de> (Bernd Schubert's message
	of "Wed, 05 Jun 2013 13:38:20 +0200")
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bernd Schubert <bernd.schubert@itwm.fraunhofer.de>
Cc: Joe Lawrence <joe.lawrence@stratus.com>, "H. Peter Anvin" <hpa@zytor.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Dan Williams <dan.j.williams@gmail.com>, linux-raid <linux-raid@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>

>>>>> "Bernd" == Bernd Schubert <bernd.schubert@itwm.fraunhofer.de> writes:

Bernd> And I also don't see any driver setting max_ws_blocks, so
Bernd> everything except of libata gets the default of
Bernd> SD_MAX_WS10_BLOCKS. 

Yes. That's intentional. Unless the device provides MAXIMUM WRITE SAME
BLOCKS in the BLOCK LIMITS VPD.


Bernd> As the correct handling in the md layer seems to be difficult,
Bernd> can we send a fake request at device configuration time to figure
Bernd> out if the device really support write-same?

The problem is that WRITE SAME is destructive. And unfortunately a block
count of 0 means "write entire device".

-- 
Martin K. Petersen	Oracle Linux Engineering
