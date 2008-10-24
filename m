From: "Yang, Bo" <Bo.Yang@lsi.com>
Subject: RE: [Bugme-new] [Bug 11792] New: Oops when reading
 /proc/megaraid/hba0/diskdrives-ch*
Date: Fri, 24 Oct 2008 07:31:27 -0600
Message-ID: <4B6A08C587958942AA3002690DD4F8C32D34135E@cosmail02.lsi.com>
References: <20081024092127D.fujita.tomonori@lab.ntt.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mail0.lsil.com ([147.145.40.20]:49183 "EHLO mail0.lsil.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752169AbYJXNdD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 24 Oct 2008 09:33:03 -0400
In-Reply-To: <20081024092127D.fujita.tomonori@lab.ntt.co.jp>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>, "pterjan@gmail.com" <pterjan@gmail.com>, "James.Bottomley@hansenpartnership.com" <James.Bottomley@hansenpartnership.com>
Cc: "bharrosh@panasas.com" <bharrosh@panasas.com>, "matthew@wil.cx" <matthew@wil.cx>, "akpm@linux-foundation.org" <akpm@linux-foundation.org>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "Patro, Sumant" <Sumant.Patro@lsi.com>, "bugme-daemon@bugzilla.kernel.org" <bugme-daemon@bugzilla.kernel.org>, "Austria, Winston" <Winston.Austria@lsi.com>

Tom,

I will update you as soon as LSI verifies it.  Not today, next week will be safe.

Regards,

Bo Yang

-----Original Message-----
From: FUJITA Tomonori [mailto:fujita.tomonori@lab.ntt.co.jp]
Sent: Thursday, October 23, 2008 8:21 PM
To: pterjan@gmail.com; James.Bottomley@hansenpartnership.com
Cc: fujita.tomonori@lab.ntt.co.jp; bharrosh@panasas.com; matthew@wil.cx; akpm@linux-foundation.org; linux-scsi@vger.kernel.org; Patro, Sumant; Yang, Bo; bugme-daemon@bugzilla.kernel.org
Subject: Re: [Bugme-new] [Bug 11792] New: Oops when reading /proc/megaraid/hba0/diskdrives-ch*

On Fri, 24 Oct 2008 00:49:07 +0200
"Pascal Terjan" <pterjan@gmail.com> wrote:

> On Wed, Oct 22, 2008 at 2:33 PM, FUJITA Tomonori
> <fujita.tomonori@lab.ntt.co.jp> wrote:
> >
> > diff --git a/drivers/scsi/megaraid.c b/drivers/scsi/megaraid.c
> > index 28c9da7..7dc62de 100644
> > --- a/drivers/scsi/megaraid.c
> > +++ b/drivers/scsi/megaraid.c
> > @@ -4402,6 +4402,10 @@ mega_internal_command(adapter_t *adapter, megacmd_t *mc, mega_passthru *pthru)
> >        scb_t   *scb;
> >        int     rval;
> >
> > +       scmd = scsi_allocate_command(GFP_KERNEL);
> > +       if (!scmd)
> > +               return -ENOMEM;
> > +
> >        /*
> >         * The internal commands share one command id and hence are
> >         * serialized. This is so because we want to reserve maximum number of
> > @@ -4412,12 +4416,11 @@ mega_internal_command(adapter_t *adapter, megacmd_t *mc, mega_passthru *pthru)
> >        scb = &adapter->int_scb;
> >        memset(scb, 0, sizeof(scb_t));
> >
> > -       scmd = &adapter->int_scmd;
> > -       memset(scmd, 0, sizeof(Scsi_Cmnd));
> > -
> >        sdev = kzalloc(sizeof(struct scsi_device), GFP_KERNEL);
> >        scmd->device = sdev;
> >
> > +       memset(adapter->int_cdb, 0, sizeof(adapter->int_cdb));
> > +       scmd->cmnd = adapter->int_cdb;
> >        scmd->device->host = adapter->host;
> >        scmd->host_scribble = (void *)scb;
> >        scmd->cmnd[0] = MEGA_INTERNAL_CMD;
> > @@ -4456,6 +4459,8 @@ mega_internal_command(adapter_t *adapter, megacmd_t *mc, mega_passthru *pthru)
> >
> >        mutex_unlock(&adapter->int_mtx);
> >
> > +       scsi_free_command(GFP_KERNEL, scmd);
> > +
> >        return rval;
> >  }
> >
> > diff --git a/drivers/scsi/megaraid.h b/drivers/scsi/megaraid.h
> > index ee70bd4..795201f 100644
> > --- a/drivers/scsi/megaraid.h
> > +++ b/drivers/scsi/megaraid.h
> > @@ -888,8 +888,8 @@ typedef struct {
> >
> >        u8      sglen;  /* f/w supported scatter-gather list length */
> >
> > +       unsigned char int_cdb[MAX_COMMAND_SIZE];
> >        scb_t                   int_scb;
> > -       Scsi_Cmnd               int_scmd;
> >        struct mutex            int_mtx;        /* To synchronize the internal
> >                                                commands */
> >        struct completion       int_waitq;      /* wait queue for internal
> >
>
> I confirm that this patch fixes the oops and I can now read the usual info

Thanks!

LSI people, can I get the ack on this?


=
From: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Subject: [PATCH] megaraid: fix mega_internal_command oops

scsi_cmnd->cmnd was changed from a static array to a pointer post
2.6.25. It breaks mega_internal_command():

static int
mega_internal_command(adapter_t *adapter, megacmd_t *mc, mega_passthru *pthru)
{
...
        scb = &adapter->int_scb;
        memset(scb, 0, sizeof(scb_t));

        scmd = &adapter->int_scmd;
        memset(scmd, 0, sizeof(Scsi_Cmnd));

        sdev = kzalloc(sizeof(struct scsi_device), GFP_KERNEL);
        scmd->device = sdev;

        scmd->device->host = adapter->host;
        scmd->host_scribble = (void *)scb;
        scmd->cmnd[0] = MEGA_INTERNAL_CMD;

mega_internal_command() uses scsi_cmnd allocated internally so
scmd->cmnd is NULL here. This patch adds a static array for cdb to
adapter_t and uses it here. This also uses
scsi_allocate_command/scsi_free_command, the recommended way to
allocate struct scsi_cmnd since the driver might use sense_buffer in
struct scsi_cmnd.

Signed-off-by: FUJITA Tomonori <fujita.tomonori@lab.ntt.co.jp>
Reviewed-by: Boaz Harrosh <bharrosh@panasas.com>
Tested-by: Pascal Terjan <pterjan@gmail.com>
Reported-by: Pascal Terjan <pterjan@gmail.com>
---
 drivers/scsi/megaraid.c |   11 ++++++++---
 drivers/scsi/megaraid.h |    2 +-
 2 files changed, 9 insertions(+), 4 deletions(-)

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
--
1.5.5.GIT

