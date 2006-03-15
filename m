From: Vladislav Bolkhovitin <vst@vlnb.net>
Subject: Re: SCSI target and IO-throttling
Date: Wed, 15 Mar 2006 20:15:21 +0300
Message-ID: <44184BA9.90202@vlnb.net>
References: <OF586A820A.80375000-ON8825712A.00712235-8825712A.00815110@us.ibm.com> <440EF9AC.7070903@vlnb.net> <D2BA8EC0-6B20-40EF-B9C5-88CABB1B7CDD@egenera.com> <440F1920.1050608@vlnb.net> <43998989-7BD3-4F3F-A10A-17385D63411E@egenera.com> <441075D4.6010109@vlnb.net> <80454C34-75B9-409B-A454-B8AB0DB1AF4D@egenera.com> <4411C99C.9040200@vlnb.net> <44172D88.6070201@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from out-relay-02.infobox.ru ([195.208.234.171]:48574 "EHLO
	out-relay-02.infobox.ru") by vger.kernel.org with ESMTP
	id S1750738AbWCORPf (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 15 Mar 2006 12:15:35 -0500
In-Reply-To: <44172D88.6070201@torque.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: dougg@torque.net
Cc: Steve Byan <smb@egenera.com>, Bryan Henderson <hbryan@us.ibm.com>, linux-scsi@vger.kernel.org

Douglas Gilbert wrote:
> Vladislav Bolkhovitin wrote:
> 
>>Steve Byan wrote:
> 
> 
> <snip>
> 
>>BTW, do you have any statistic how many modern SCSI disks support those
>>features (ORDERED, ACA, UA_INTLCK_CTL, etc)? Few years ago none of
>>available for us SCSI hardware, including tape libraries, supported ACA.
>>It was not very modern for that time, though
> 
> 
> Vlad,
> Here is part of the control mode page from a
> recent SCSI disk (Cheetah 15k.4) :
> 
> # sdparm -p co /dev/sdb -ll
>     /dev/sdb: SEAGATE   ST336754SS        0003
>     Direct access device specific parameters: WP=0  DPOFUA=1
> Control mode page [PS=1]:
>   TST         0  [cha: n, def:  0, sav:  0]  Task set type
>         0: lu maintains one task set for all I_T nexuses
>         1: lu maintains separate task sets for each I_T nexus
>   TMF_ONLY    0  [cha: n, def:  0, sav:  0]  Task management functions only
>   D_SENSE     0  [cha: n, def:  0, sav:  0]  Descriptor format sense data
>   GLTSD       0  [cha: y, def:  1, sav:  0]  Global logging target save disable
>   RLEC        0  [cha: y, def:  0, sav:  0]  Report log exception condition
>   QAM         0  [cha: y, def:  0, sav:  0]  Queue algorithm modifier
>         0: restricted re-ordering; 1: unrestricted
>   QERR        0  [cha: n, def:  0, sav:  0]  Queue error management
>         0: only affected task gets CC; 1: affected tasks aborted
>         3: affected tasks aborted on same I_T nexus
>   RAC         0  [cha: n, def:  0, sav:  0]  Report a check
>   UA_INTLCK   0  [cha: n, def:  0, sav:  0]  Unit attention interlocks control
>         0: unit attention cleared with check condition status
>         2: unit attention not cleared with check condition status
>         3: as 2 plus ua on busy, task set full or reservation conflict
>   SWP         0  [cha: n, def:  0, sav:  0]  Software write protect
>   ATO         0  [cha: n, def:  0, sav:  0]  Application tag owner
>   TAS         0  [cha: n, def:  0, sav:  0]  Task aborted status
>         0: tasks aborted without response to app client
>         1: any other I_T nexuses receive task aborted
> 
> So it doesn't support UA_INTLCK ("cha: n" implies the user
> cannot change that value). QAM can be changed to allow
> unrestricted re-ordering (of task with the SIMPLE task
> attribute).
> 
> The NormACA bit in the standard INQUIRY response is 0 so
> it doesn't support ACA either.

Thanks! This is exactly what we've seen in the our small investigation. 
Perhaps, those features are really not needed, if nobody still use them.

Vlad
