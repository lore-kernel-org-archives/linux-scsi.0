From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 4/5] convert st to use scsi_execte_async
Date: Thu, 22 Sep 2005 22:20:12 -0500
Message-ID: <4333746C.2030704@cs.wisc.edu>
References: <1126845599.9276.44.camel@max>  <Pine.LNX.4.61.0509171428410.9258@kai.makisara.local>  <432C39BC.1030105@cs.wisc.edu>  <432C3C75.5090405@cs.wisc.edu>  <1126974325.10413.5.camel@max>  <Pine.LNX.4.61.0509181456370.14776@kai.makisara.local>  <432D81BD.9080803@cs.wisc.edu> <432D8515.9010809@cs.wisc.edu>  <Pine.LNX.4.61.0509182031090.15507@kai.makisara.local> <1127061365.800.1.camel@max> <432D97F2.5040508@cs.wisc.edu> <Pine.LNX.4.61.0509182155350.15507@kai.makisara.local> <432D9D53.3070706@cs.wisc.edu> <Pine.LNX.4.61.0509192040360.4404@kai.makisara.local> <432F100D.7050007@cs.wisc.edu> <Pine.LNX.4.61.0509202149180.4741@kai.makisara.local> <Pine.LNX.4.61.0509222309390.6022@kai.makisara.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:2794 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1751262AbVIWDUT (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 22 Sep 2005 23:20:19 -0400
In-Reply-To: <Pine.LNX.4.61.0509222309390.6022@kai.makisara.local>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: linux-scsi@vger.kernel.org

Kai Makisara wrote:
> On Tue, 20 Sep 2005, Kai Makisara wrote:
> 
> ...
> 
>>If I try 5121 kB, write fails as is expected but not completely nicely. 
>>Here are some test printks:
>>
>>scsi_req_map_sg: q->back_merge failed, i=10
>>st 1:0:5:0: extraneous data discarded.
>>st 1:0:5:0: COMMAND FAILED (87 0 1).
>>sym: cmd: 0x0a 0x00 0x50 0x04 0x00 0x00
>>st: cmd=0x0a result=0x70000 resid=0 sense[0]=0x00 sense[2]=0x00
>>
>>scsi_req_map_sg fails as it should but still a bogus SCSI command is sent. 
>>I think the reason for this is simple but I don't want to delay the good 
>>news by trying to debug this.
>>
> 
> The reason was simple: scsi_req_map_sg did not set err when q->back_merge 
> failed. The patch at the end fixes the problem (I am not sure what would 
> be the correct error code).

yeah :) thanks.
