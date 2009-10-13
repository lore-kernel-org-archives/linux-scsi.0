From: James Smart <James.Smart@Emulex.Com>
Subject: Re: [patch 2/5] zfcp: Handle WWPN mismatch in PLOGI payload
Date: Tue, 13 Oct 2009 14:09:12 -0400
Message-ID: <4AD4C248.3040406@emulex.com>
References: <20091013084406.630890000@de.ibm.com> <20091013084944.777367000@de.ibm.com> <4AD4B01B.2010100@cisco.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from emulex.emulex.com ([138.239.112.1]:43380 "EHLO
	emulex.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760849AbZJMSJ4 (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 13 Oct 2009 14:09:56 -0400
In-Reply-To: <4AD4B01B.2010100@cisco.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Joe Eykholt <jeykholt@cisco.com>
Cc: Christof Schmitt <christof.schmitt@de.ibm.com>, James Bottomley <James.Bottomley@suse.de>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>, "schwidefsky@de.ibm.com" <schwidefsky@de.ibm.com>, "heiko.carstens@de.ibm.com" <heiko.carstens@de.ibm.com>



Joe Eykholt wrote:
> Christof Schmitt wrote:
>   
>> From: Christof Schmitt <christof.schmitt@de.ibm.com>
>>
>> For ports, zfcp gets the DID from the FC nameserver and tries to open
>> the port. If the open succeeds, zfcp compares the WWPN from the
>> nameserver with the WWPN in the PLOGI payload. In case of a mismatch,
>> zfcp assumes that the DID of the port just changed and we opened the
>> wrong port. This means that zfcp has to forget the DID, lookup the DID
>> again and retry.
>>     
>
> Does this happen very often?  Would you get an RSCN if a target's WWPN changed?
>   
You should - as it is supposed to re-login with the fabric, thus the 
fabric login will update the nameserver, and nameserver will generate 
the RSCN. But, there's no guarantee as to how quickly you will see the 
RSCN.   If you were on FC-AL, this happens all the time and never w/ an 
RSCN.

> Just wondering how this happens and whether libfc needs similar defenses.
> Is it due to a broken target?
>   

Libfc needs a similar defense.  You may not need to compare against the 
"nameserver" values, but you had better compare against same N_Port_ID, 
different WWPN. or vice-versa.   Its common to have RSCN events delayed, 
allowing discovery to occur in between events that may be outstanding 
(e.g. tgt plugs in - RSCN-1 event, tgt moves to another port (user error 
-kicks out and replugs) or an array failover such that WWPN moves to new 
switch port/N_Port_ID - RSCN-2 event;  and your ADISC/PLOGI based on 
RSCN-1 arrives and is responded to sooner than the nameserver propagates 
its updates and you receive RSCN-2)

-- james s

