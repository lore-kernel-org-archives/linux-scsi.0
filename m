From: Takahiro Yasui <tyasui@redhat.com>
Subject: Re: [PATCH] scsi_devinfo: update Hitachi entries
Date: Mon, 01 Jun 2009 13:38:49 -0400
Message-ID: <4A241229.5050009@redhat.com>
References: <4A2405FD.3000901@redhat.com> <1243875275.4203.19.camel@mulgrave.int.hansenpartnership.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-2022-JP
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx2.redhat.com ([66.187.237.31]:43041 "EHLO mx2.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750952AbZFARf4 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Mon, 1 Jun 2009 13:35:56 -0400
In-Reply-To: <1243875275.4203.19.camel@mulgrave.int.hansenpartnership.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org

James Bottomley wrote:
> On Mon, 2009-06-01 at 12:46 -0400, Takahiro Yasui wrote:
>>  	{"HITACHI", "DISK-SUBSYSTEM", "*", BLIST_ATTACH_PQ3 | BLIST_SPARSELUN | BLIST_LARGELUN},
>> -	{"HITACHI", "OPEN-E", "*", BLIST_ATTACH_PQ3 | BLIST_SPARSELUN | BLIST_LARGELUN},
>> +	{"HITACHI", "OPEN-", "*", BLIST_REPORTLUN2},
> 
> Can we drop the BLIST_ATTACH_PQ3?  It was there for not only to get the
> sequential scan to work, but also so LUN0 would be registered with the
> OS (I think for some control purpose) which would no longer happen.

BLIST_ATTACH_PQ3 was added to "OPEN-E" in the following commit:
  commit: 13f7e5acc8b329080672c13f05f252ace5b79825

---
Unfortunately, SANs exist that are SCSI-2 and do NOT support REPORT_LUNS, but
report a unknown device with PQ 3 on LUN 0. We still need to scan them, and
most probably we even need BLIST_SPARSELUN (and BLIST_LARGELUN). See the bug
reference for an infamous example.
---

According to the commit, "OPEN-E" does not support REPORT_LUNS, but
"OPEN-E" can handle REPORT_LUNS. In addition, other "OPEN-" models
can do as well.

I would like to know in which case BLIST_ATTACH_PQ3 is required.

Thanks,
---
Takahiro Yasui
Hitachi Computer Products (America), Inc.
