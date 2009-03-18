From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH 2/3] scsi_dh: Change scsi device handler modules to	utilize
 modalias
Date: Wed, 18 Mar 2009 16:43:11 +0100
Message-ID: <49C1168F.6060900@s5r6.in-berlin.de>
References: <20090318013615.26548.36303.sendpatchset@chandra-ubuntu> <20090318013627.26548.27704.sendpatchset@chandra-ubuntu> <20090318134629.GB19448@mars.virtualiron.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hp3.statik.tu-cottbus.de ([141.43.120.68]:56897 "EHLO
	hp3.statik.tu-cottbus.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751300AbZCRPoh (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 18 Mar 2009 11:44:37 -0400
In-Reply-To: <20090318134629.GB19448@mars.virtualiron.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Konrad Rzeszutek <konrad@virtualiron.com>
Cc: Chandra Seetharaman <sekharan@us.ibm.com>, linux-scsi@vger.kernel.org, pjones@redhat.com, michaelc@cs.wisc.edu, James.Bottomley@HansenPartnership.com

Konrad Rzeszutek wrote:
> .. snip..
>> +	{TYPE_ANY, "HP", "HSV300" },
>> +	{TYPE_ANY, "IBM", "2107900" },
>> +	{TYPE_ANY, "IBM", "2145" },
>> +	{TYPE_ANY, "Pillar", "Axiom" },
>> +	{0, "", ""},
> 
> Is there a define for '0' value?

This is an array terminator.  Almost nobody uses cpp defines for
terminating values.  (In this case, the actual terminator is "" in the
2nd struct member.)

BTW, Peter,

>> --- linux-2.6.28.orig/drivers/scsi/device_handler/scsi_dh.c
>> +++ linux-2.6.28/drivers/scsi/device_handler/scsi_dh.c
>> @@ -75,7 +75,10 @@ static int scsi_dh_handler_lookup(struct
>>  {
>>  	int i, found = 0;
>>  
>> -	for(i = 0; scsi_dh->devlist[i].vendor; i++) {
>> +	for(i = 0; scsi_dh->devlist[i].vendor[0]; i++) {
>> +		if ((scsi_dh->devlist[i].type != TYPE_ANY) &&
>> +				(scsi_dh->devlist[i].type != sdev->type))
>> +			continue;
>>  		if (!strncmp(sdev->vendor, scsi_dh->devlist[i].vendor,
>>  			     strlen(scsi_dh->devlist[i].vendor)) &&
>>  		    !strncmp(sdev->model, scsi_dh->devlist[i].model,

AFAICS you could have kept the check for .vendor != NULL instead of
.vendor[0] != '\0' and write the terminator thusly:

	{},

Saves the space for a one byte long string in the object files.  :-)
-- 
Stefan Richter
-=====-==--= --== =--=-
http://arcgraph.de/sr/
