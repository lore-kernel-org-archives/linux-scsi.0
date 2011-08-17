From: Peter Chang <dpf@google.com>
Subject: Re: mpt2sas driver behaving strange with a failed SATA disk behind
 SAS expander.
Date: Wed, 17 Aug 2011 10:08:09 -0700
Message-ID: <CAF2xp_FOjZOxs1fbhvCsB3=uqvQG4=1cqkfiO0BptH_5oQvCaw@mail.gmail.com>
References: <4E4BCF54.8090408@swip.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from smtp-out.google.com ([216.239.44.51]:62719 "EHLO
	smtp-out.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754273Ab1HQRIc convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 17 Aug 2011 13:08:32 -0400
Received: from hpaq2.eem.corp.google.com (hpaq2.eem.corp.google.com [172.25.149.2])
	by smtp-out.google.com with ESMTP id p7HH8UIZ030810
	for <linux-scsi@vger.kernel.org>; Wed, 17 Aug 2011 10:08:31 -0700
Received: from ywf9 (ywf9.prod.google.com [10.192.6.9])
	by hpaq2.eem.corp.google.com with ESMTP id p7HH7dKg031240
	(version=TLSv1/SSLv3 cipher=RC4-SHA bits=128 verify=NOT)
	for <linux-scsi@vger.kernel.org>; Wed, 17 Aug 2011 10:08:29 -0700
Received: by ywf9 with SMTP id 9so1015672ywf.32
        for <linux-scsi@vger.kernel.org>; Wed, 17 Aug 2011 10:08:29 -0700 (PDT)
In-Reply-To: <4E4BCF54.8090408@swip.net>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Fredrik Lindgren <fli@swip.net>
Cc: "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>

Le 17 ao=FBt 2011 07:25, Fredrik Lindgren <fli@swip.net> a =E9crit :
> When doing disk IO on the disks (they are all configured in MD raids)
> suddenly IO will
> stop and these messages are printed on the console about once every s=
econd:
>
> mpt2sas0: log_info(0x31110610): originator(PL), code(0x11), sub_code(=
0x0610)
>
> From what I understand this means:
>
> PL_LOGINFO_CODE_RESET (0x00110000)
> PL_LOGINFO_SUB_CODE_SATA_NON_NCQ_RW_ERR_BIT_SET (0x00000600)
>
> So a disk is acting up, generating errors? What does the last "10" me=
an in
> the sub_code,
> is that an identifier for which disk it is?

no, the bottom bts are still part of the error code.

i haven't run w/ your exact fw/driver setup, but i think you'll find
that you're in a 'loop' where the driver is returning DID_RESET and
the scsi layer is retrying w/o going through the retry counter logic
(the command that fails is one that the firmware issued).

\p
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
