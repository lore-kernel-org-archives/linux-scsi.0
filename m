From: Noriyuki Fujii <n-fujii@np.css.fujitsu.com>
Subject: Re: [PATCH 2nd try] PCI legacy I/O port free driver - Making MegaRAID
 SAS driver
Date: Tue, 01 Dec 2009 10:15:34 +0900
Message-ID: <4B146E36.7080506@np.css.fujitsu.com>
References: <4AD52367.7050500@np.css.fujitsu.com> <1259614182.11762.5.camel@mulgrave.site>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fgwmail5.fujitsu.co.jp ([192.51.44.35]:48474 "EHLO
	fgwmail5.fujitsu.co.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750828AbZLABQP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 30 Nov 2009 20:16:15 -0500
Received: from m6.gw.fujitsu.co.jp ([10.0.50.76])
	by fgwmail5.fujitsu.co.jp (Fujitsu Gateway) with ESMTP id nB11GKHx023702
	for <linux-scsi@vger.kernel.org> (envelope-from n-fujii@np.css.fujitsu.com);
	Tue, 1 Dec 2009 10:16:20 +0900
Received: from smail (m6 [127.0.0.1])
	by outgoing.m6.gw.fujitsu.co.jp (Postfix) with ESMTP id 1ED5745DE4E
	for <linux-scsi@vger.kernel.org>; Tue,  1 Dec 2009 10:16:20 +0900 (JST)
Received: from s6.gw.fujitsu.co.jp (s6.gw.fujitsu.co.jp [10.0.50.96])
	by m6.gw.fujitsu.co.jp (Postfix) with ESMTP id 021B945DE4C
	for <linux-scsi@vger.kernel.org>; Tue,  1 Dec 2009 10:16:20 +0900 (JST)
Received: from s6.gw.fujitsu.co.jp (localhost.localdomain [127.0.0.1])
	by s6.gw.fujitsu.co.jp (Postfix) with ESMTP id D0D7C1DB8041
	for <linux-scsi@vger.kernel.org>; Tue,  1 Dec 2009 10:16:19 +0900 (JST)
Received: from ml0.s.css.fujitsu.com (ml0.s.css.fujitsu.com [10.23.4.190])
	by s6.gw.fujitsu.co.jp (Postfix) with ESMTP id 8C3601DB8038
	for <linux-scsi@vger.kernel.org>; Tue,  1 Dec 2009 10:16:19 +0900 (JST)
In-Reply-To: <1259614182.11762.5.camel@mulgrave.site>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James Bottomley <James.Bottomley@suse.de>
Cc: megaraidlinux@lsi.com, linux-scsi@vger.kernel.org

James,

 > I need a Signed-off-by for this (see Documentation/SubmittingPatches).

 > This is taking away a tab and substituting spaces ... our style is to
 > use tabs.  You can run the patch through scripts/checkpatch.pl and it
 > will advise on problems like this.

I've already posted the patch obeying the community rules.
Could you see the following URL?

http://marc.info/?l=linux-scsi&m=125870212508167&w=2

Thanks,
Noriyuki Fujii

> On Wed, 2009-10-14 at 10:03 +0900, Noriyuki Fujii wrote:
>> Hi,
>>
>> Here's my 2nd try of the following post.
>>
>> http://marc.info/?l=linux-scsi&m=124962265606425&w=2
>>
>> I made a patch for MegaRAID sas driver to make PCI legacy I/O port free.
>>
>> The way to make PCI legacy I/O port free is the same as Fusion-MPT
>> driver's and it has been merged into 2.6.30.4.
>>
>> This has already been fixed in e1000 and lpfc.
>>
>> As a result of the above, the driver can handle its device even when
>> there are a huge number of PCI devices being used on the system and no
>> I/O port region assigned to the device.
>>
>> I'm not in the linux-scsi mailing list.
>> Please reply to the following address.
> 
> I need a Signed-off-by for this (see Documentation/SubmittingPatches).
> 
>>  E-Mail: n-fujii@np.css.fujitsu.com
>>
>> Thanks,
>> Noriyuki Fujii
>>
>> plain text document attachment
>> (linux-2.6-scsi-megaraid-sas-make-legacy-i-o-port-free.patch)
>> --- megaraid_sasOrg.c	2009-07-02 16:31:17.000000000 +0900
>> +++ megaraid_sasMod.c	2009-08-06 11:24:42.000000000 +0900
>> @@ -2573,7 +2573,9 @@ static int megasas_init_mfi(struct megas
>>  		instance->base_addr = pci_resource_start(instance->pdev, 0);
>>  	}
>>  
>> -	if (pci_request_regions(instance->pdev, "megasas: LSI")) {
>> +        if (pci_request_selected_regions(instance->pdev,
> 
> This is taking away a tab and substituting spaces ... our style is to
> use tabs.  You can run the patch through scripts/checkpatch.pl and it
> will advise on problems like this.
> 
> James
> 
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> 
> 


