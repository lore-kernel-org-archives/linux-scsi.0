From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: SG_ALL definition
Date: Mon, 23 Aug 2010 20:57:12 +0300
Message-ID: <4C72B678.8020707@panasas.com>
References: <201008200918.40405.bs_lists@aakef.fastmail.fm>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from daytona.panasas.com ([67.152.220.89]:41052 "EHLO
	daytona.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751547Ab0HWR5P (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 23 Aug 2010 13:57:15 -0400
In-Reply-To: <201008200918.40405.bs_lists@aakef.fastmail.fm>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Bernd Schubert <bs_lists@aakef.fastmail.fm>
Cc: linux-scsi@vger.kernel.org

On 08/20/2010 10:18 AM, Bernd Schubert wrote:
> From ancient times SG_ALL was defined as 0xff = 255. Rather likely for that 
> reason we see lots of IO requests of size 1020 from drivers that do not 
> support sg-chaining yet. 

No, it's not chaining related. For example on 64 bit the max before chaining is
128. A 255 will give you two chain segments. (The last one max-1 entries).
At the time there was an host bit to say no_chaining, once all drivers where
converted it was dropped.

I have an ancient tree that removes the definition of SG_ALL. Each driver
has a specific use of it. From easy to hard dependency these are the rough
groups.

a. infinity, these where converted to ~0
b. There is other limiting number like max_sectors so this indicates an,
   at the time, infinity.
c. Resources are dynamically allocated up to that size
d. Resources statically allocated before hand to this size.
e. Some random crazy code

> And IO sizes of 1020 are a nightmare for DDN 
> hardware. Is there a chance to increase that to 256 by default? 
> Lustre includes a kernel patch to that for RHEL5 kernel and it greatly helps 
> to get correct IO sizes. 
> 

Do you mean on the Lustre user-mode target machine? The surgery must be per
LLD driver. Most of the ones people care about where fixed.

(You might be able to inspect it here:
   git://git.bhalevy.com/linux-open-osd boaz-scsi/z__OLD_SG_ALL
 Tell me if you want something more public.)

Have you checked out the block layer nubs for setting maximum request sizes?

> 
> Thanks,
> Bernd
> 

Boaz
