From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: SCSI scanning behavior
Date: Wed, 26 Aug 2015 06:52:45 -0700
Message-ID: <55DDC4AD.6040804@sandisk.com>
References: <55D65082.6020504@linux.vnet.ibm.com> <55DDB8F3.3020308@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail-bn1bon0071.outbound.protection.outlook.com ([157.56.111.71]:64327
	"EHLO na01-bn1-obe.outbound.protection.outlook.com"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755883AbbHZNwx (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 26 Aug 2015 09:52:53 -0400
In-Reply-To: <55DDB8F3.3020308@suse.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Hannes Reinecke <hare@suse.de>, Brian King <brking@linux.vnet.ibm.com>, linux-scsi <linux-scsi@vger.kernel.org>

On 08/26/15 06:02, Hannes Reinecke wrote:
> On 08/21/2015 12:11 AM, Brian King wrote:
>> However, I'm still left wondering why we are adding PQ=1, PDT=0 devices in the sequential LUN scan at all.
>> Are there media changer devices out there that we've seen respond like this? Even so, does it make sense
>> to add PQ=1, PDT=0 LUNs for LUN > 0?
>>
> Yes, unfortunately we need this. NetApp arrays have a habit of
> returning 'PQ=1' for unconnected LUN 0, even though higher LUNs are
> present. So we need to add devices for PQ=1, otherwise we wouldn't
> be able to scan them.
> We _might_ be able to tweak this by ignoring devices with PQ=1 and
> LUN!=0; however, it might break other things.

Hello Hannes,

The code in scsi_scan.c already skips LUNs with PQ=1 and PDT=0x1f. I'm 
not sure we should skip LUNS with PQ=1 and a PDT value other than 0x1f.

Thanks,

Bart.

