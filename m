From: "Yang, Bo" <Bo.Yang@lsi.com>
Subject: RE: [Bugme-new] [Bug 11792] New: Oops when reading
 /proc/megaraid/hba0/diskdrives-ch*
Date: Wed, 22 Oct 2008 07:03:03 -0600
Message-ID: <4B6A08C587958942AA3002690DD4F8C32D2C5E17@cosmail02.lsi.com>
References: <20081022213418B.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:35022 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753387AbYJVNDo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 22 Oct 2008 09:03:44 -0400
In-Reply-To: <20081022213418B.fujita.tomonori@lab.ntt.co.jp>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, "bharrosh@panasas.com" <bharrosh@panasas.com>
Cc: "pterjan@gmail.com" <pterjan@gmail.com>, "matthew@wil.cx" <matthew@wil.cx>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Patro, Sumant" <Sumant.Patro@lsi.com>, "bugme-daemon@bugzilla.kernel.org" <bugme-daemon@bugzilla.kernel.org>, "Austria, Winston" <Winston.Austria@lsi.com>

I saw the latest working kernel: 2.6.24 and first failing kernel version: 2.6.27-rc8.  I understand there are lots of changes between those two kernels.  Can you take a look the changes from kernels to find out the root cause?  Also if you believe this is the driver issue and need LSI to help, can you report this issue to LSI?

Thanks.

Bo Yang

-----Original Message-----
From: FUJITA Tomonori [mailto:fujita.tomonori@lab.ntt.co.jp]
Sent: Wednesday, October 22, 2008 8:34 AM
To: bharrosh@panasas.com
Cc: fujita.tomonori@lab.ntt.co.jp; pterjan@gmail.com; matthew@wil.cx; akpm@linux-foundation.org; linux-scsi@vger.kernel.org; Patro, Sumant; Yang, Bo; bugme-daemon@bugzilla.kernel.org
Subject: Re: [Bugme-new] [Bug 11792] New: Oops when reading /proc/megaraid/hba0/diskdrives-ch*

On Wed, 22 Oct 2008 12:08:27 +0200
Boaz Harrosh <bharrosh@panasas.com> wrote:

> FUJITA Tomonori wrote:
> > On Wed, 22 Oct 2008 11:04:44 +0200
> > Boaz Harrosh <bharrosh@panasas.com> wrote:
> >
> >> FUJITA Tomonori wrote:
> >>> On Tue, 21 Oct 2008 22:22:37 +0200
> >>> "Pascal Terjan" <pterjan@gmail.com> wrote:
> >>>
> >>>> On Tue, Oct 21, 2008 at 9:54 PM, Matthew Wilcox <matthew@wil.cx> wrote:
> >>>>> On Tue, Oct 21, 2008 at 12:47:01PM -0700, Andrew Morton wrote:
> >>>>>>> Latest working kernel version: 2.6.24
> >>>>>>> Earliest failing kernel version: 2.6.27-rc8
> >>>>>> It's a regression.
> >>>>>>
> >>>>>>> Pid: 2319, comm: diff Not tainted (2.6.27-server-0.rc8.2mnb #1)
> >>>>> It's also a distro kernel by the looks of things.  Can it be reproduced
> >>>>> with an upstream kernel?
> >>>> I will try booting the server on vanilla kernel but I'm not sure when
> >>>> (we already rebooted it 2 times recently and users won't enjoy it).
> >>>>
> >>>> This is a distro kernel but I don't see patches that could impact this :
> >>>> http://svn.mandriva.com/cgi-bin/viewvc.cgi/packages/cooker/kernel/current/PATCHES/patches/
> >>>>
> >>>> Machine is a old HP NetServer LT 6000
> >>>>
> >>>> 04:03.1 I2O: Intel Corporation 80960RP (i960RP) Microprocessor (rev
> >>>> 09) (prog-if 01)
> >>>>  Subsystem: Hewlett-Packard Company MegaRAID, Integrated NetRAID
> >>>>  Flags: bus master, fast Back2Back, medium devsel, latency 64, IRQ 11
> >>>>  Memory at f4000000 (32-bit, prefetchable) [size=64M]
> >>>>  [virtual] Expansion ROM at a8130000 [disabled] [size=32K]
> >>>>  Capabilities: [80] Power Management version 2
> >>>>  Kernel driver in use: megaraid_legacy
> >>>>  Kernel modules: i2o_core, megaraid
> >>> This patch helps?
> >>>
> >>>
> >>> diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
> >>> index 28c9da7..9294ed8 100644
> >>> --- a/drivers/scsi/megaraid.c
> >>> +++ b/drivers/scsi/megaraid.c
> >>> @@ -4414,12 +4414,14 @@ mega_internal_command(adapter_t *adapter, megacmd_t *mc, mega_passthru *pthru)
> >>>
> >>>   scmd = &adapter->int_scmd;
> >>>   memset(scmd, 0, sizeof(Scsi_Cmnd));
> >>> + memset(adapter->int_cdb, 0, sizeof(adapter->int_cdb));
> >>>
> >>>   sdev = kzalloc(sizeof(struct scsi_device), GFP_KERNEL);
> >>>   scmd->device = sdev;
> >>>
> >>>   scmd->device->host = adapter->host;
> >>>   scmd->host_scribble = (void *)scb;
> >>> + scmd->cmnd = adapter->int_cdb;
> >>>   scmd->cmnd[0] = MEGA_INTERNAL_CMD;
> >>>
> >>>   scb->state |= SCB_ACTIVE;
> >>> diff --git a/drivers/scsi/megaraid.h b/drivers/scsi/megaraid.h
> >>> index ee70bd4..5ffec15 100644
> >>> --- a/drivers/scsi/megaraid.h
> >>> +++ b/drivers/scsi/megaraid.h
> >>> @@ -889,6 +889,7 @@ typedef struct {
> >>>   u8      sglen;  /* f/w supported scatter-gather list length */
> >>>
> >>>   scb_t                   int_scb;
> >>> + unsigned char           int_cdb[MAX_COMMAND_SIZE];
> >>>   Scsi_Cmnd               int_scmd;
> >>>   struct mutex            int_mtx;        /* To synchronize the internal
> >>>                                           commands */
> >>>
> >>> --
> >> Hi TOMO.
> >>
> >> This might not be enough for example I don't see the allocation of sense_buffer.
> >> It might be much easer to allocate using the new command allocation API James
> >> did, just for such cases. These are: scsi_allocate_command/scsi_free_command
> >
> > Yeah, it might be. It's fine by me too. But this code path is used
> > only for issuing internal special commands. It doesn't use the great
> > portion of scsi_cmnd. For example, these commands don't use sense
> > buffer, I think. The code path uses scsi_cmnd just for hooking scb_t,
> > a structure that megaraid allocates per command.
>
> OK Thanks.
> I was not sure because it looks like in mega_cmd_done(), if the status is
> 0x2 (CHECK_CONDITION) then it would set the sense_buffer. But from what
> you say, the HW will never return 0x2 in case of an Internal-Command. I
> Just wanted to make sure.

I thought that all internal commands are non SCSI command but seems
that there is one exception (issuing INQUIRY as an internal command).
I'm not sure I understand correctly the driver but anyway here is a
version using scsi_allocate_command and scsi_free_command.

I guess that we need to check the kzalloc failure too but it is
supposed to be fixed by a different patch.


diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
index 28c9da7..7dc62de 100644
--- a/drivers/scsi/megaraid.c
+++ b/drivers/scsi/megaraid.c
@@ -4402,6 +4402,10 @@ mega_internal_command(adapter_t *adapter, megacmd_t *mc, mega_passthru *pthru)
        scb_t   *scb;
        int     rval;

+       scmd = scsi_allocate_command(GFP_KERNEL);
+       if (!scmd)
+               return -ENOMEM;
+
        /*
         * The internal commands share one command id and hence are
         * serialized. This is so because we want to reserve maximum number of
@@ -4412,12 +4416,11 @@ mega_internal_command(adapter_t *adapter, megacmd_t *mc, mega_passthru *pthru)
        scb = &adapter->int_scb;
        memset(scb, 0, sizeof(scb_t));

-       scmd = &adapter->int_scmd;
-       memset(scmd, 0, sizeof(Scsi_Cmnd));
-
        sdev = kzalloc(sizeof(struct scsi_device), GFP_KERNEL);
        scmd->device = sdev;

+       memset(adapter->int_cdb, 0, sizeof(adapter->int_cdb));
+       scmd->cmnd = adapter->int_cdb;
        scmd->device->host = adapter->host;
        scmd->host_scribble = (void *)scb;
        scmd->cmnd[0] = MEGA_INTERNAL_CMD;
@@ -4456,6 +4459,8 @@ mega_internal_command(adapter_t *adapter, megacmd_t *mc, mega_passthru *pthru)

        mutex_unlock(&adapter->int_mtx);

+       scsi_free_command(GFP_KERNEL, scmd);
+
        return rval;
 }

diff --git a/drivers/scsi/megaraid.h b/drivers/scsi/megaraid.h
index ee70bd4..795201f 100644
--- a/drivers/scsi/megaraid.h
+++ b/drivers/scsi/megaraid.h
@@ -888,8 +888,8 @@ typedef struct {

        u8      sglen;  /* f/w supported scatter-gather list length */

+       unsigned char int_cdb[MAX_COMMAND_SIZE];
        scb_t                   int_scb;
-       Scsi_Cmnd               int_scmd;
        struct mutex            int_mtx;        /* To synchronize the internal
                                                commands */
        struct completion       int_waitq;      /* wait queue for internal
