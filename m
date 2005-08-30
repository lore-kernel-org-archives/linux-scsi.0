From: Albert Lee <albertcc@tw.ibm.com>
Subject: Re: [RFC] libata new EH document
Date: Tue, 30 Aug 2005 17:10:17 +0800
Message-ID: <43142279.3070004@tw.ibm.com>
References: <20050829061124.GA2725@htj.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20050829061124.GA2725@htj.dyndns.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: Jeff Garzik <jgarzik@pobox.com>, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org, Doug Maxey <dwm@maxeymade.com>
List-Id: linux-scsi@vger.kernel.org

Tejun Heo wrote:

> Hello, Jeff, Albert & ATA developers.
>
> This is the final one of recent document series for libata EH - SCSI
>EH, ATA exceptions, libata EH and, this one - libata new EH.
>
> This document tries to discuss how to implement new advanced EH.  It
>also describes some proposed mechanisms in detail.  I'm aware that
>things are vague without actual code, but I still think this document
>alone can at least help discussion if nothing else.  As long as some
>consensus is reached regarding general desing, I'll follow up with
>patches.
>
> Jeff, a lot are from my previous new EH/NCQ patchset but also quite
>a bit has changed (for better, I hope).
>
> Thanks.
>
>
>libata new EH
>======================================
>
> As discussed in the previous libata EH doc, the current libata EH
>needs some improvements.  This document discusses goals of new libata
>EH and how to reach them.  Please read SCSI EH, ATA exceptions and
>libata EH documents first.
>
>TABLE OF CONTENTS
>
>[1] Goals & design choices
>    [1-1] Use SCSI hostt->eh_strategy_handler()
>    [1-2] Unified error path in an EH thread
>    [1-3] Synchronization
>    [1-4] Clean mechanism to hand off qc's to EH
>    [1-5] Separate EH qc
>    [1-6] SCSI/libata separation
>[2] Designs
>    [2-1] Handoff of failed qc's
>    [2-2] Timed out scmd's and qc's
>    [2-3] Summary of [2-1] and [2-2]
>    [2-4] EH processing & completion
>[3] Ideas
>    [3-1] Using EH for non-error exceptions and dynamic reconfiguration
>    [3-2] Using EH for host_set level exclusion
>[4] Implementation plan
>
>
>[1] Goals & design choices
>
> The final goal is implementing advanced error handling as described
>in ATA exceptions document including NCQ EH, dynamic transport
>reconfiguration and non-error exception handling for power management
>and hot plugging.
>
> The followings are sub goals and design choices to reach the final
>goal.
>
>
>[1-1] Use SCSI hostt->eh_strategy_handler()
>
>    We have two other alternatives here - one is using fine-grained
>    SCSI EH callbacks and the other is implementing separate EH for
>    libata.
>
>    Using fine-grained SCSI EH callbacks is possible, but it has too
>    much SCSI/SPI assumptions in it - ATA error handling can be quite
>    different from SCSI error handling.  Also, as described in the
>    SCSI EH doc, it issues several SCSI commands for recovery.  They
>    can be translated but recovery through translation is a bit
>    creepy, IMHO.
>
>    The second option - private EH implementation - is attractive in
>    that it will be better integrated into libata.  However,
>    implementing a full EH when a generic framwork is already in place
>    doesn't make a lot of people happy.  And, I think integration
>    problems can be worked around without too much trouble.
>
>    The basic semantics of eh_strategy_handler() are
>
>    - Full context EH.
>
>    - After EH is started, all normal command processing is suspended
>      until EH is complete.
>
>    - Once EH is determined to be necessary, active commands are
>      drained by suppressing all command issuing and waiting for
>      in-flight commands.  When EH is finally entered, all active
>      commands are failed commands.
>
>    IMO, above semantics are fairly fundamental to block device error
>    handling and, in the future, to whatever framework libata
>    migrates, assuming above semantics shouldn't hurt too much.
>
>
>[1-2] Unified error path in an EH thread
>
>    Currently EH is scattered around several places including the
>    interrupt handler and polling tasks.  This is problemetic for the
>    following reasons.
>
>    a. Full EH context is required for error handling.
>
>       Advanced recovery usually involves resetting, command issuing
>       and other blocking operations.
>
>    b. Simple errors may trigger complex error handling behavior.
>
>       For example, when an ABRT error occurs, reporting to upper
>       layer is sufficent for most cases; however, repeated ABRT
>       errors for known-to-be-supported commands might indicate too
>       high transmission speed.  In such cases, full EH context is
>       required to perform error handling.
>
>    c. Scattered complex EH is difficult to implement and maintain.
>
>       EH logic can be somewhat complex and scattering won't help
>       implementing and maintaining it.  Also, libata low level
>       drivers are allowed to override callbacks where part of EH
>       logic may reside making matters worse.
>
>
>[1-3] Synchronization
>
>    A simple & concrete qc synchronization model to make sure that EH
>    and any other processing don't occur concurrently is needed.
>
>
>[1-4] Clean mechanism to hand off qc's to EH
>
>    For EH to handle errors and timeouts, letting EH deal with and
>    complete both errored and timed out qc's is good for simplicity
>    and consistency.  To achieve this, we need a mechanism to hand off
>    a qc to EH.
>
>    Currently, libata EH has a similar mechanism to hand off a failed
>    ATAPI qc to EH.  As described in libata EH doc, such qc is
>    half-completed and used as place holder until EH is kicked in and
>    handles it.
>
>    This half-completion isn't very clean semantically and requires
>    calling splitted internal completion routines directly.  Also, as
>    such qc's are not explicitly marked as failed, not-very-intuitive
>    stuff has to be done to avoid spurious interrupts or other events
>    from messing with it after error has occurred.
>
>
>[1-5] Separate EH qc
>
>    EH needs to issue qc's for recovery.  There can be several ways to
>    allocate EH qc.
>
>    a. reserve one extra qc for internal/EH commands
>    b. reserve one of normal qc's
>    c. use failed qc
>    d. complete failed qc first and reuse it
>
>    The preferred choice is #a for the following reasons.
>
>    - Allowing only one concurrent internal command is okay as long as
>      proper allocation mechanism is implemented or only one user is
>      guaranteed.
>
>    - EH commands are restricted to non-NCQ commands, so reserving an
>      extra qc won't break qc to tag mapping.
>
>    - #b is impossible for non-NCQ devices because only one qc is
>      available.
>
>    - #c requires dancing with qc's internals.  No real nerd likes
>       dancing.
>
>    - It may be necessary to issue commands to determine whether to
>      finish or retry a qc, so #d is out.
>
>
>[1-6] SCSI/libata separation
>
>    Internal libata EH logic implementation should be free from SCSI
>    considerations.  All glueing work should be localized to EH
>    frontend and once in the actual error handling EH should only deal
>    with qc's.
>
>
>[2] Designs
>
> This section proposes detailed design of several important mechanisms
>to help discussion and verification.
>
>
>[2-1] Handoff of failed qc's
>
> As described above, when normal command processing determines that a
>qc has failed, those qc's have to be handed off to EH without being
>lost.
>
> A new qc flag ATA_QCFLAG_ERROR is defined to mark qc's which have
>failed and ata_qc_error() is defined to be used by command processing
>to mark failed qc and schedule EH.  ata_qc_error() has to be called
>under the same condition as ata_qc_complete() - under host_lock - and
>performs the following.
>
> 1. First check if the command is already marked with
>    ATA_QCFLAG_ERROR.  If so, this isn't the first error completion
>    attempt, just return.
>
> 2. Mark the qc with ATA_QCFLAG_ERROR.
>
> 3. As, currently, SCSI command issuing is not atomic with respect to
>    SHOST_RECOVERY flag, we need a separate atomic mechanism to plug
>    command issuing.  Per-port flag ATA_FLAG_ERROR is set here to
>    prevent further command issuing.
>
> 4. Corresponding scmd's result code is set to
>    SAM_STAT_CHECK_CONDITION and qc->scsidone() callback is called
>    directly.  As we haven't filled sense data,
>    scsi_determine_disposition() will return FAILED and SCSI EH will
>    be scheduled.  Note that as we directly call qc->scsidone(), qc is
>    left intact.
>  
>

Could we get the sense data before calling qc->scsidone()?  (Using the 
proposed separate
EH qc can keep the original qc intact.)

The issue:
When a DVD drive returns MEDIUM_ERROR in the sense data, libata doesn't 
retry the command.

For libata, when scsi_softirq() calls scsi_decide_disposition() and 
scsi_check_sense() to determine
how to handle the result, scsi_check_sense() always returns "fail" since 
the sense data is not there
yet. The sense data is requested later in the libata error handler. But 
the command has already been
considered as an "error".

By having the sense data ready before calling qc->scsidone(), we can 
make the
NEEDS_RETRY work in scsi_softirq().  So, for things like MEDIUM_ERROR, 
the device has
a chance to retry/recover the error. This seems to be important for 
devices with built-in
defect management system.

> After above function is complete, the following conditions are true.
>
> a. The qc has ATA_QCFLAG_ERROR set and no further normal qc
>    processing will happen for the command.
>
> b. No new qc will be issued for the port.
>
> c. EH is scheduled.
>
> d. Corresponding scmd and qc are left alone until EH processes them.
>
> Note that to achieve above behavior, we need to modify other places
>too.  e.g. ata_qc_complete() needs to be modified to ignore failed
>qc's and command issuing part to fail issuing if ATA_FLAG_ERROR is
>set.
>
>
>  
>


