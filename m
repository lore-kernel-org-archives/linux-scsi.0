From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 4/5] convert st to use scsi_execte_async
Date: Sat, 17 Sep 2005 10:55:33 -0500
Message-ID: <432C3C75.5090405@cs.wisc.edu>
References: <1126845599.9276.44.camel@max> <Pine.LNX.4.61.0509171428410.9258@kai.makisara.local> <432C39BC.1030105@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:41936 "EHLO sabe.cs.wisc.edu")
	by vger.kernel.org with ESMTP id S1751089AbVIQRzj (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Sat, 17 Sep 2005 13:55:39 -0400
In-Reply-To: <432C39BC.1030105@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kai Makisara <Kai.Makisara@kolumbus.fi>
Cc: linux-scsi@vger.kernel.org

Mike Christie wrote:
> Kai Makisara wrote:
> 
>>
>> I think I may have found the problem: scsi_execute_async does not use 
>> the parameter retries (the same applies to scsi_execute btw). This 
>> leads to retrying the reads at filemark and this is not correct. I 
>> added the hack below to scsi_execute_async and after this the simple 
>> tests succeed.
> 
> 
> ah ok. I think when we prep the command we need to copy the retries from 
> the command. So in st.c st_init_command callout we need to copy that 
> value (we are just copying the timeout today).

oh I guess there is not retries count on the request like there is for 
timeout :)

But it looks like retried is always 0. I guess st's init_command could 
just do

SCpnt->allowed = 0;
