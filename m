From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH v3 59/77] ncr5380: Fix autosense bugs
Date: Tue, 22 Dec 2015 08:57:44 +0100
Message-ID: <56790278.1090301@suse.de>
References: <20151222011737.980475848@telegraphics.com.au>
 <20151222011754.046134198@telegraphics.com.au>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <20151222011754.046134198@telegraphics.com.au>
Sender: linux-kernel-owner@vger.kernel.org
To: Finn Thain <fthain@telegraphics.com.au>, "James E.J. Bottomley" <JBottomley@odin.com>, Michael Schmitz <schmitzmic@gmail.com>, linux-m68k@vger.kernel.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, "Martin K. Petersen" <martin.petersen@oracle.com>
List-Id: linux-scsi@vger.kernel.org

On 12/22/2015 02:18 AM, Finn Thain wrote:
> NCR5380_information_transfer() may re-queue a command for autosense,
> after calling scsi_eh_prep_cmnd(). This creates several possibilities=
:
>
> 1. Reselection may intervene before the re-queued command gets proces=
sed.
>     If the reconnected command then undergoes autosense, this causes =
the
>     scsi_eh_save data from the previous command to be overwritten.
>
> 2. After NCR5380_information_transfer() calls scsi_eh_prep_cmnd(),
>     a new REQUEST SENSE command may arrive. This would be queued ahea=
d
>     of any command already undergoing autosense, which means the
>     scsi_eh_save data might be restored to the wrong command.
>
> 3. After NCR5380_information_transfer() calls scsi_eh_prep_cmnd(),
>     eh_abort_handler() may abort the command. But the scsi_eh_save da=
ta is
>     not discarded, which means the scsi_eh_save data might be incorre=
ctly
>     restored to the next REQUEST SENSE command issued.
>
> This patch adds a new autosense list so that commands that are re-que=
ued
> because of a CHECK CONDITION result can be kept apart from the REQUES=
T
> SENSE commands that arrive via queuecommand.
>
> This patch also adds a function dedicated to dequeueing and preparing=
 the
> next command for processing. By refactoring the main loop in this way=
,
> scsi_eh_save takes place when an autosense command is dequeued rather
> than when re-queued.
>
> Signed-off-by: Finn Thain <fthain@telegraphics.com.au>
>
> ---
>   drivers/scsi/NCR5380.c       |  194 +++++++++++++++++++------------=
---
>   drivers/scsi/NCR5380.h       |    2
>   drivers/scsi/atari_NCR5380.c |  239 ++++++++++++++++++++++++-------=
------------
>   3 files changed, 249 insertions(+), 186 deletions(-)
>
Reviewed-by: Hannes Reinecke <hare@suse.com>

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		      zSeries & Storage
hare@suse.de			      +49 911 74053 688
SUSE LINUX Products GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: J. Hawn, J. Guild, F. Imend=F6rffer, HRB 16746 (AG N=FCrnberg)
