From: Peter Chang <dpf@google.com>
Subject: Re: mpt2sas driver behaving strange with a failed SATA disk behind
 SAS expander.
Date: Wed, 17 Aug 2011 11:49:28 -0700
Message-ID: <CAF2xp_Gp5mtqJYA_HYqQeFvw0dOM6Jj_f1iYEyrjOL1t97gSpw@mail.gmail.com>
References: <4E4BCF54.8090408@swip.net> <CAF2xp_FOjZOxs1fbhvCsB3=uqvQG4=1cqkfiO0BptH_5oQvCaw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:48646 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753177Ab1HQStv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Aug 2011 14:49:51 -0400
Received: from hpaq12.eem.corp.google.com (hpaq12.eem.corp.google.com [172.25.149.12])
	by smtp-out.google.com with ESMTP id p7HInogJ007860
	for <linux-scsi@vger.kernel.org>; Wed, 17 Aug 2011 11:49:50 -0700
Received: from iye16 (iye16.prod.google.com [10.241.50.16])
	by hpaq12.eem.corp.google.com with ESMTP id p7HImZXm027412
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 17 Aug 2011 11:49:48 -0700
Received: by iye16 with SMTP id 16so2393098iye.1
        for <linux-scsi@vger.kernel.org>; Wed, 17 Aug 2011 11:49:48 -0700 (PDT)
In-Reply-To: <CAF2xp_FOjZOxs1fbhvCsB3=uqvQG4=1cqkfiO0BptH_5oQvCaw@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Fredrik Lindgren <fli@swip.net>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Le 17 ao=FBt 2011 10:08, Peter Chang <dpf@google.com> a =E9crit :
> Le 17 ao=FBt 2011 07:25, Fredrik Lindgren <fli@swip.net> a =E9crit :
>> When doing disk IO on the disks (they are all configured in MD raids=
)
>> suddenly IO will
>> stop and these messages are printed on the console about once every =
second:
>>
>> mpt2sas0: log_info(0x31110610): originator(PL), code(0x11), sub_code=
(0x0610)
>>
>> From what I understand this means:
>>
>> PL_LOGINFO_CODE_RESET (0x00110000)
>> PL_LOGINFO_SUB_CODE_SATA_NON_NCQ_RW_ERR_BIT_SET (0x00000600)
>>
>> So a disk is acting up, generating errors? What does the last "10" m=
ean in
>> the sub_code,
>> is that an identifier for which disk it is?
>
> no, the bottom bts are still part of the error code.
>
> i haven't run w/ your exact fw/driver setup, but i think you'll find
> that you're in a 'loop' where the driver is returning DID_RESET and
> the scsi layer is retrying w/o going through the retry counter logic
> (the command that fails is one that the firmware issued).

since someone else gave the error code (i didn't check if i just had
some other magic header)...

the problem is probably a combination of the disk and controller
firmwares. when an NCQ request fails the firmware will do a READ LOG
EXT(10) to figure out why. some disks don't do handle this sequence
the way the firmware expects so it starts the COMRESET dance w/ the
disk and returns an event w/ the loginfo to the driver/kernel.

the 'fix' (really a workaround) is in
mpt2sas_scsih.c:_scsih_io_done(). in the case for
MPI2_IOCSTATUS_SCSI_TASK_TERMINATED change the DID_RESET to
DID_SOFT_ERROR and the rest of the scsi layer will go down the regular
retry handling and you'll get out of the 'loop'.

lsi supposed to have this fix coming soon.

disabling NCQ will 'fix' this as well.


\p
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
