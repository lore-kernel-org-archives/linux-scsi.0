From: Brian King <brking@linux.vnet.ibm.com>
Subject: Re: scsi_host_alloc does not check for used shost->host_no
Date: Tue, 15 Jul 2008 15:31:47 -0500
Message-ID: <487D0933.1010201@linux.vnet.ibm.com>
References: <48775DCD.5010202@linux.vnet.ibm.com> <487D059C.60400@linux.vnet.ibm.com> <20080715202507.GI14894@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e35.co.us.ibm.com ([32.97.110.153]:40126 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757615AbYGOUcS (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 15 Jul 2008 16:32:18 -0400
Received: from d03relay04.boulder.ibm.com (d03relay04.boulder.ibm.com [9.17.195.106])
	by e35.co.us.ibm.com (8.13.8/8.13.8) with ESMTP id m6FKWGPG026138
	for <linux-scsi@vger.kernel.org>; Tue, 15 Jul 2008 16:32:16 -0400
Received: from d03av02.boulder.ibm.com (d03av02.boulder.ibm.com [9.17.195.168])
	by d03relay04.boulder.ibm.com (8.13.8/8.13.8/NCO v9.0) with ESMTP id m6FKW2up136120
	for <linux-scsi@vger.kernel.org>; Tue, 15 Jul 2008 14:32:05 -0600
Received: from d03av02.boulder.ibm.com (loopback [127.0.0.1])
	by d03av02.boulder.ibm.com (8.12.11.20060308/8.13.3) with ESMTP id m6FKW1xe014431
	for <linux-scsi@vger.kernel.org>; Tue, 15 Jul 2008 14:32:02 -0600
In-Reply-To: <20080715202507.GI14894@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Daniel Debonzi <debonzi@linux.vnet.ibm.com>, linux-scsi@vger.kernel.org

Matthew Wilcox wrote:
> Or we could make the host_no a u64 and avoid the problem ever happening
> in our lifetimes.  I'm amazed that anyone's had the time to do 4 billion
> add/removes, to be honest.  Assuming it takes 1 second per add/remove
> cycle, and there's not even time to scan a bus in that time, that's
> still 136 years.

That was my thought as well, until I checked struct scsi_host and saw
that hostno is actually defined as a short there, which makes the problem
slightly easier to hit. So, we could just increase both of them to u64's
and be done with it...

-Brian

-- 
Brian King
Linux on Power Virtualization
IBM Linux Technology Center


