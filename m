From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: [PATCH] [SCSI] aic7xxx: Fix warnings with CONFIG_PM=n
Date: Thu, 08 Nov 2007 16:17:25 -0800
Message-ID: <4733A715.70008@oracle.com>
References: <1194563028-19364-1-git-send-email-frank@lichtenheld.de> <20071108155834.7751f2f6.randy.dunlap@oracle.com> <20071109001201.GW2961@planck.djpig.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from agminet02.oracle.com ([141.146.126.229]:53261 "EHLO
	agminet02.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754652AbXKIEzy (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 8 Nov 2007 23:55:54 -0500
Received: from agminet01.oracle.com (agminet01.oracle.com [141.146.126.228])
	by agminet02.oracle.com (Switch-3.2.4/Switch-3.1.7) with ESMTP id lA90Y35S018410
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=NO)
	for <linux-scsi@vger.kernel.org>; Thu, 8 Nov 2007 18:34:04 -0600
In-Reply-To: <20071109001201.GW2961@planck.djpig.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Frank Lichtenheld <frank@lichtenheld.de>
Cc: Hannes Reinecke <hare@suse.de>, linux-scsi@vger.kernel.org

Frank Lichtenheld wrote:
> On Thu, Nov 08, 2007 at 03:58:34PM -0800, Randy Dunlap wrote:
>> Hi,
>> The preferred method of fixing this type of warning is to
>> (warning, not a full patch here):
>>
>> a.  change the struct pci_driver not to use #ifdef CONFIG_PM/#endif;
>> instead, it always says:
>>
>> 	.suspend	= ahd_linux_pci_dev_suspend,
>> 	.resume		= ahd_linux_pci_dev_resume,
>>
>> and those pointers are built depending on CONFIG_PM like so:
>>
>> #ifdef CONFIG_PM
>> 	... functions as they are now ...
>> #else
>> #define ahd_linux_pci_dev_suspend	NULL
>> #define ahd_linux_pci_dev_resume	NULL
>> #endif
>>
>> so the ifdef/endif blocks are localized to one place in each driver.
> 
> Hmm, technically _two_ places since you still need them around both
> declaration and definition of the functions, right?

OK, that's the case without any code movement.
But "ideally" the functions would be defined before the
struct pci_driver data, so the prototypes for them could be removed.

-- 
~Randy
