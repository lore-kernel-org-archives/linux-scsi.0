From: Minh Duc Tran <MinhDuc.Tran@Emulex.Com>
Subject: RE: [PATCH 1/4] be2iscsi : Fix the retry count for boot targets
Date: Wed, 17 Dec 2014 05:21:27 +0000
Message-ID: <820584e9-38f8-411f-8962-d326d1485371@CMEXHTCAS1.ad.emulex.com>
References: <0cb35f54-b286-4416-971f-b0fd9d389ce7@CMEXHTCAS1.ad.emulex.com>
 <5490636C.5050706@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.emulex.com ([138.239.224.100]:37865 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750995AbaLQFVx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Dec 2014 00:21:53 -0500
In-Reply-To: <5490636C.5050706@cs.wisc.edu>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>, Sony John-N <Sony.John-N@Emulex.Com>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Jayamohan Kallickal <Jayamohan.Kallickal@Emulex.Com>

>On 12/16/14, 8:33 PM, John Soni Jose wrote:
>> +#define GET_BOOT_RETRIES	45
>> +#define GET_BOOT_TO		20
>>   /**

>Does beiscsi_get_boot_info() succeed when the fw is able to log into the target (go into iscsi full feature phase) or just able to reach it (ICMP ping the port or something like that)?
It should be in full feature phase.

> It was not clear why the above values were selected. Was it meant to detect when the target could be down for extended periods due to something like maintenance or a reboot, 
>or is just handling some shorter settle period where the link is up but the fw could not reach the target port due to needing to do some other network setup.
This is the time it takes for fw to login to boot target starting at Linkup in certain environments.  Special cases such as MPIO where one port has LinkDown before boot but eventually
became LinkUp while OS is running.  The total time since LinkUp to successful target login by fw is calculated based on:   port on switch became ready + DHCP address assignment + fw login.

>Also, I think you want to add some sort of BEISCSI or at least BE prefix to the names to avoid collisions since they are pretty generic.
Will do.
