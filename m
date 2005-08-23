From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH] minimal SAS transport class
Date: Tue, 23 Aug 2005 19:28:59 +0200
Message-ID: <430B5CDB.9070204@s5r6.in-berlin.de>
References: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7A4B@xbl3.ma.emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:8078 "EHLO
	einhorn.in-berlin.de") by vger.kernel.org with ESMTP
	id S932205AbVHWR3W (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 23 Aug 2005 13:29:22 -0400
Received: from [192.168.0.41] ([62.180.98.151])
	(authenticated bits=0)
	by einhorn.in-berlin.de (8.12.10/8.12.10/Debian-4) with ESMTP id j7NHT40M016114
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Tue, 23 Aug 2005 19:29:12 +0200
In-Reply-To: <9BB4DECD4CFE6D43AA8EA8D768ED51C21D7A4B@xbl3.ma.emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

James.Smart@Emulex.Com wrote:
>>As others stated, id is already a tag/label. You should be 
>>able to pass
>>whatever id you want to scsi_scan_target, like the FC ID 
>>(port_id),
[...]
> If the port id changes during run time, what are you to do ?
[...]
> This approach only works as long as the transport's id fits within
> the target id (an int). How would the SAS address(8byte wwn) utilize
> such a scheme ?

I don't understand exactly what is being discussed here. But if 
anybody's intention is to extend the concept of target ID to also 
provide the concept of transport specific, persistent, globally unique 
identifiers*, then the datatype of target ID needs to be extended 
accordingly.

Otherwise the LLDs have to implement a mapping between target IDs and 
these unique identifiers. This mapping does not need to be persistent. 
Persistent mappings for whatever purpose can and should be implemented 
in userspace. (This is how it has always been e.g. with SBP-2.)


*) examples of transport specific, persistent, globally unique 
identifiers: obviously 8 Byte address from SAS, 8 Byte EUI from SBP-2/ 
IEEE 1394/ ISO/IEC 13213, or maybe 88 bit GUI from ISO/IEC 13213
-- 
Stefan Richter
-=====-=-=-= =--- =-===
http://arcgraph.de/sr/
