From: Jeff Garzik <jgarzik@pobox.com>
Subject: Re: [PATCH] libata: scsi error handling
Date: Tue, 04 Oct 2005 07:33:52 -0400
Message-ID: <434268A0.3080108@pobox.com>
References: <43114DE1.7090406@torque.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <43114DE1.7090406@torque.net>
Sender: linux-ide-owner@vger.kernel.org
To: dougg@torque.net
Cc: linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Douglas Gilbert wrote:
> Jeff,
> Here is a follow on patch based on lk 2.6.13-rc7
> plus the start_stop_unit patch and the rw_zero_length
> patch.
> 
> It adds more general error processing, typically for
> problems (or an early finish) detected while a
> SCSI command is being processed prior to an ATA
> command being executed.
> 
> Changelog:
>   - add extern ata_scsi_set_sense() to build SCSI
>     sense data and corresponding status
>   - this allows removal of extern ata_scsi_badcmd()
>     and static inline ata_bad_scsiop() and ata_bad_cdb()
>   - change "xlat" functions in libata-scsi so they
>     are responsible for SCSI status and sense data
>     when they return 1. This allows GOOD status or a
>     specialized error to be set.
>   - set DRIVER_SENSE when SAM_STAT_CHECK_CONDITION
>     is flagged in scsi_cmnd::result
>   - yield an error for mode sense requests for saved
>     values [sat-r05]
>   - change recent rw_zero_length patch to do nothing
>     (yield GOOD status) when transfer_length==0 for
>     10 and 16 byte READ and WRITE commands (SBC-2).

All this is OK, though in the future, please split changes such as the 
creation and explicit use of ata_scsi_set_sense() to a separate patch. 
We need to separate logical changes.  Patches get applied more quickly 
when they are split up, too.


However, I really wanted to go ahead and merge the C/H/S support patch, 
which updates the R/W xlat function, causing conflicts with your patch 
in several places.  (as a side effect, C/H/S updates clean up the R/W 
xlat function rather nicely)


If you would be kind enough to rediff against the 'upstream' branch of
rsync://rsync.kernel.org/pub/scm/linux/kernel/git/jgarzik/libata-dev.git

I would really appreciate it.  I'll merge it as soon as I receive the 
rediff.

	Jeff


