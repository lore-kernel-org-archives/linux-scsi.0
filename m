From: Steffen Maier <maier@linux.ibm.com>
Subject: Re: [PATCH] [SCSI] mpt3sas: Fix secure erase premature termination
 (v2)
Date: Tue, 24 Apr 2018 11:09:03 +0200
Message-ID: <10db11e2-1e15-2b16-f5e6-81fbf2581683@linux.ibm.com>
References: <2179ecb8-183f-a500-4d65-10f64f0f43cc@suse.de>
 <1478045394-19536-1-git-send-email-andrey2805@gmail.com>
 <dbeededa-e2fc-53d3-997c-34ba1129a80b@suse.de>
 <CAK=zhgpYj0TcrPK8kQ-TTqGfU=JHZbXr+2-szGf1w_XcOU3p9Q@mail.gmail.com>
 <CAJphD_qrQftfCOn_uzXCfdX=Xv9BYvVQ60AZ4DR2rc3gfXQa_Q@mail.gmail.com>
 <30w645ulbhlofxrk1h4a9q3s.1478144944778@email.android.com>
 <CAK=zhgra2zDZon5fuW1OwQfJ_2ExkAzcsKGiuBJaLYX6sMoTCQ@mail.gmail.com>
 <38e3e634-6e08-58bd-bc11-8a0a470b78d9@suse.de>
 <yq1k2cjw6dn.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8BIT
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <yq1k2cjw6dn.fsf@sermon.lab.mkp.net>
Content-Language: en-US
Sender: stable-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>
Cc: Sreekanth Reddy <sreekanth.reddy@broadcom.com>, Igor Rybak <igor@media-clone.com>, Andrey Grodzovsky <andrey2805@gmail.com>, Ezra Kohavi <ezra@media-clone.com>, PDL-MPT-FUSIONLINUX <MPT-FusionLinux.pdl@broadcom.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Sathya Prakash <sathya.prakash@broadcom.com>, Chaitra P B <chaitra.basappa@broadcom.com>, Suganath Prabu Subramani <suganath-prabu.subramani@broadcom.com>, "stable@vger.kernel.org" <stable@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org


On 11/04/2016 05:35 PM, Martin K. Petersen wrote:
>>>>>> "Hannes" == Hannes Reinecke <hare@suse.de> writes:
> 
> Hannes> Checking with SAT-3 (section 6.2.4: Commands the SATL queues
> Hannes> internally) the implemented behaviour is standards conformant,
> Hannes> although the standard also allows for returning 'TASK SET FULL'
> Hannes> or 'BUSY' in these cases.  Doing so would nicely solve this
> Hannes> issue.
> 
> I agree with Hannes that it would be appropriate for the SATL to report
> busy when it makes an non-queued command queueable.

Wouldn't this potentially still cause problems if the secure erase takes 
longer than max_retries * scmd_tmo. I.e. the command timing out by 
default after 180 seconds as in 
https://www.spinics.net/lists/linux-block/msg24837.html ?

The fix approach here seems to also handle this gracefully.

-- 
Mit freundlichen Grüßen / Kind regards
Steffen Maier

Linux on z Systems Development

IBM Deutschland Research & Development GmbH
Vorsitzende des Aufsichtsrats: Martina Koederitz
Geschaeftsfuehrung: Dirk Wittkopp
Sitz der Gesellschaft: Boeblingen
Registergericht: Amtsgericht Stuttgart, HRB 243294
