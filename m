From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [Bugme-new] [Bug 11792] New: Oops when reading /proc/megaraid/hba0/diskdrives-ch*
Date: Wed, 22 Oct 2008 16:57:40 +0200
Message-ID: <48FF3F64.4040901@panasas.com>
References: <4B6A08C587958942AA3002690DD4F8C32D2C5E4A@cosmail02.lsi.com> <48FF3690.2020806@panasas.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-ca.panasas.com ([66.104.249.162]:8036 "EHLO
	laguna.int.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754118AbYJVO5x (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Oct 2008 10:57:53 -0400
In-Reply-To: <48FF3690.2020806@panasas.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Yang, Bo" <Bo.Yang@lsi.com>
Cc: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, "pterjan@gmail.com" <pterjan@gmail.com>, "matthew@wil.cx" <matthew@wil.cx>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Patro, Sumant" <Sumant.Patro@lsi.com>, "bugme-daemon@bugzilla.kernel.org" <bugme-daemon@bugzilla.kernel.org>, "Austria, Winston" <Winston.Austria@lsi.com>

Boaz Harrosh wrote:
> Yang, Bo wrote:
>> Thanks TOMM.  If this is the case, it may affect some of other drivers like our 
>> MPT and SAS driver.  Is there a way kernel can fix it?
>>
>> Thanks,
>>
>> Bo Yang
>>
> 
> Hi Bo Yang
> 
> What are the source files for the MPT and SAS drivers from LSI?
> I have made a system wide search for such problems as below and could not
> find any more. But I might have missed them. If you tell me the file names
> I will inspect more closly.
> 
> Thanks
> Boaz

In megaraid_sas.c I do not see any places where megasas_cmd->scmd is set
other then at megasas_queue_command() which is the scsi .queue_command
vector. Commands that come from scsi-ml are guarantied to be fully allocated.
Other then that I do not see any places that privately allocate a scsi_cmnd
structure. So I would say megaraid_sas.c should be safe from this bug

Any other files I should inspect?

Boaz
 
