From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH v8] ibmvscsis: Initial commit of IBM VSCSI Tgt Driver
Date: Wed, 29 Jun 2016 07:49:10 +0200
Message-ID: <2aa7660d-2c9a-08bf-59f6-7282a0a7a6f4@sandisk.com>
References: <1464274721-36453-1-git-send-email-bryantly@linux.vnet.ibm.com>
 <1467058632-1825-1-git-send-email-mikecyr@linux.vnet.ibm.com>
 <BB635617-87FA-4667-B1B0-657E2E9FF627@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <BB635617-87FA-4667-B1B0-657E2E9FF627@linux.vnet.ibm.com>
Sender: target-devel-owner@vger.kernel.org
To: "Bryant G. Ly" <bryantly@linux.vnet.ibm.com>, Michael Cyr <mikecyr@linux.vnet.ibm.com>, "nab@linux-iscsi.org" <nab@linux-iscsi.org>, "joe@perches.com" <joe@perches.com>
Cc: "hch@infradead.org" <hch@infradead.org>, "James.Bottomley@HansenPartnership.com" <James.Bottomley@HansenPartnership.com>, "tyreld@linux.vnet.ibm.com" <tyreld@linux.vnet.ibm.com>, "brking@linux.vnet.ibm.com" <brking@linux.vnet.ibm.com>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>, "seroyer@linux.vnet.ibm.com" <seroyer@linux.vnet.ibm.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "target-devel@vger.kernel.org" <target-devel@vger.kernel.org>, "martin.petersen@oracle.com" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On 06/28/2016 10:57 PM, Bryant G. Ly wrote:
> I was hoping someone in the community can help answer this:
>
> If I were to remove the masking off of the lun addressing method prior to target_submit_cmd/target_submit_tmr then I get a hang within scsi probe
> on bootup. (srp->lun.scsi_lun[0] &= 0x3f; and srp_tsk->lun.scsi_lun[0] &= 0x3f;)
>
> [    0.842648] ibmvscsi 3000000d: sent SRP login
> [    0.842667] ibmvscsi 3000000d: SRP_LOGIN succeeded
> [    0.842682] scsi 0:0:2:0: CD-ROM            AIX      VOPTA                 PQ: 0 ANSI: 4
> [  OK  ] Started Show Plymouth Boot Screen.
> [  OK  ] Reached target Paths.
> [  OK  ] Reached target Basic System.
> [    0.886179] sr 0:0:2:0: [sr0] scsi-1 drive
> [    0.886199] cdrom: Uniform CD-ROM driver Revision: 3.20
> [    0.888582] sd 0:0:1:0: [sda] 41943040 512-byte logical blocks: (21.4 GB/20.0 GiB)
> [    0.888657] sd 0:0:1:0: [sda] Write Protect is off
> [    0.888712] sd 0:0:1:0: [sda] Cache data unavailable
> [    0.888722] sd 0:0:1:0: [sda] Assuming drive cache: write through
> [    0.901443]  sda: sda1 sda2 sda3
> [    0.901838] sd 0:0:1:0: [sda] Attached SCSI disk
> [  124.522778] dracut-initqueue[353]: Warning: dracut-initqueue timeout - starting timeout scripts
> [  125.151242] dracut-initqueue[353]: Warning: dracut-initqueue timeout - starting timeout scripts
> [  125.662808] dracut-initqueue[353]: Warning: dracut-initqueue timeout - starting timeout scripts
>
> Does anyone know of the reasoning for having to mask off the addressing method prior
> to submitting to target?

How long have you waited before giving up waiting? The SCSI initiator 
sends a REPORT LUN and other SCSI commands to LUN 0. If LUN 0 is missing 
these commands will time out but that should not cause a hang. Anyway, 
SysRq-w should help to determine the cause of the hang.

Bart.
