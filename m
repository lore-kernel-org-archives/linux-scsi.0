From: Steve Byan <smb@egenera.com>
Subject: Re: remove-single-device removes mounted HDDs (kernel 2.6)
Date: Wed, 7 Sep 2005 13:48:57 -0400
Message-ID: <5b5253d4000c9c780b80964e344bd382@egenera.com>
References: <20050906212801.GB14057@cs.umn.edu>	<20050907104932.GA14200@lst.de>	<20050907124504.GA13614@cs.umn.edu> <20050907215816C.fujita.tomonori@lab.ntt.co.jp> <431F20AA.1090101@cs.wisc.edu>
Mime-Version: 1.0 (Apple Message framework v622)
Content-Type: text/plain; charset=US-ASCII; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from roadrunner-base.egenera.com ([63.160.166.46]:11667 "EHLO
	roadrunner-base.egenera.com") by vger.kernel.org with ESMTP
	id S1751257AbVIGRtA (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 7 Sep 2005 13:49:00 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
	by roadrunner.egenera.com (Postfix) with ESMTP id BA112A0510
	for <linux-scsi@vger.kernel.org>; Wed,  7 Sep 2005 13:48:59 -0400 (EDT)
Received: from roadrunner-base.egenera.com ([127.0.0.1])
 by localhost (coyote.egenera.com [127.0.0.1]) (amavisd-new, port 10024)
 with ESMTP id 07198-07 for <linux-scsi@vger.kernel.org>;
 Wed,  7 Sep 2005 13:48:58 -0400 (EDT)
Received: from [172.23.2.91] (southeast.egenera.com [63.160.166.4])
	by roadrunner.egenera.com (Postfix) with ESMTP id 10A4CA050E
	for <linux-scsi@vger.kernel.org>; Wed,  7 Sep 2005 13:48:58 -0400 (EDT)
In-Reply-To: <431F20AA.1090101@cs.wisc.edu>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On Sep 6, 2005, at 11:43 AM, Christoph Hellwig wrote:
> On Thu, Aug 11, 2005 at 06:50:03PM +0200, Harald Seipp wrote:
>> Christoph Hellwig wrote on 11.08.2005 18:40:03:
>>> On Thu, Aug 11, 2005 at 05:44:46PM +0200, Harald Seipp wrote:
>>>> Thank you for your quick responses! It finally looks like the task 
>>>> I need
>>>> to do - fully rescan all hosts for newly attached/changed devices - 
>>>> must
>>>> include the logic to skip devices with mounted fs for 2.6.
>>>
>>> Why do you want to rescan a full bus anyway?  What SCSI transport do 
>>> you
>>> want this for?  All transports where new targets can be hot-plugged 
>>> should
>>> be doing automatic scanning already.
>> Old-fashioned parallel SCSI bus and FC/SAN where there are no hot-plug
>> events AFAIK.
>
> In FC you get per-target events, although none for new LUs showing up
> on a given target (in fact no SAM transport does the latter)

I believe some Fibre Channel storage arrays generate RSCN's when new 
logical units are created (although I don't know if the existing Linux 
Fibre Channel HBA drivers propagate these registered state change 
notifications to the hot-plug subsystem).

I understand that many iSCSI storage arrays will generate a SCSI 
Asynchronous Event Notification for the REPORTED LUNS DATA HAS CHANGED 
Unit Attention condition that SPC-3 says shall be generated when a 
target changes its logical unit inventory, provided that AEN's are 
enabled in the control mode page.

So there are SAM transports that generate events when a new LU shows up.

I'm curious as to what plans, if any, exist for handling these events 
in Linux.

Regards,
-Steve
--------
Steve Byan <smb@egenera.com>
Software Architect
Egenera, Inc.
165 Forest Street
Marlboro, MA 01752
(508) 858-3125

