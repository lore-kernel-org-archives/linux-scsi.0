From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [PATCH ]  scsi-misc-2.6:  File System going into read-only mode
Date: Wed, 04 Nov 2009 02:40:04 +0100
Message-ID: <4AF0DB74.8010906@s5r6.in-berlin.de>
References: <4F2B1A2459C7AD4D96A23CE911C352CB1E914C8572@CHN-HCLT-EVS07.HCLT.CORP.HCL.IN> <1257259243.2728.4.camel@mulgrave.site> <4AF0D7AE.200@s5r6.in-berlin.de> <4AF0D9CE.2050407@s5r6.in-berlin.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from einhorn.in-berlin.de ([192.109.42.8]:48207 "EHLO
	einhorn.in-berlin.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753591AbZKDBkK (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 3 Nov 2009 20:40:10 -0500
In-Reply-To: <4AF0D9CE.2050407@s5r6.in-berlin.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: "Penchala Narasimha Reddy Chilakala, TLS-Chennai" <narasimhareddyc@hcl.in>, "'linux-scsi@vger.kernel.org'" <linux-scsi@vger.kernel.org>, ServeRAID Driver <ServeRAIDDriver@hcl.in>

Stefan Richter wrote:
> Stefan Richter wrote:
>> Before:
>>
>> if (upsg->sg[i].count > (dev->adapter_info.options & AAC_OPT_NEW_COMM)
>>         ? (dev->scsi_host_ptr->max_sectors << 9) : 65536) {
> 
> Doesn't make sense.  dev->adapter_info.options is a __le32 bitfield.
> 
>> After:
>>
>> if (upsg->sg[i].count > (
>>           (dev->adapter_info.options & AAC_OPT_NEW_COMM)
>>                  ? (dev->scsi_host_ptr->max_sectors << 9) : 65536
>>     )) {
> 
> Makes sense.  Don't know if it's correct.

PS:  These things wouldn't happen if
  a) the coding wouldn't be as deeply nested,
  b) sparse with endianess check would be used for QA.
(OK, it's apparently a decade old code.)
-- 
Stefan Richter
-=====-==--= =-== --=--
http://arcgraph.de/sr/
