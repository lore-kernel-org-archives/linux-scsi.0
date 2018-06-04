From: Evan Green <evgreen@chromium.org>
Subject: Re: [PATCH 1/7] scsi: ufs: Add Configuration Descriptor to sysfs
Date: Mon, 4 Jun 2018 08:39:08 -0700
Message-ID: <CAE=gft5tx6my6f=PVfFwPvVy_3kcuH6y6+4oRrS9x3rydxJ9vA@mail.gmail.com>
References: <20180529181740.195362-1-evgreen@chromium.org> <20180529181740.195362-2-evgreen@chromium.org>
 <cfb43e6138a62889fd5ba9683c93e10ee32635df.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <cfb43e6138a62889fd5ba9683c93e10ee32635df.camel@wdc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart.VanAssche@wdc.com
Cc: jejb@linux.vnet.ibm.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, martin.petersen@oracle.com, Vinayak Holikatti <vinholikatti@gmail.com>, Stanislav.Nijnikov@wdc.com, Gwendal Grignou <gwendal@chromium.org>
List-Id: linux-scsi@vger.kernel.org

On Mon, Jun 4, 2018 at 1:31 AM Bart Van Assche <Bart.VanAssche@wdc.com> wrote:
>
> On Tue, 2018-05-29 at 11:17 -0700, Evan Green wrote:
> > This change adds the configuration descriptor to the UFS
> > sysfs interface. This is done in preparation for making the
> > interface writable, which will enable provisioning UFS devices
> > via Linux.
> >
> > The configuration descriptor is laid out as a header, then a set of
> > (usually 8) copies of the same descriptor for each unit. Rather than
> > creating 8 sets of the same attribute, this interface adds a cfg_unit
> > file, which can be set as an index that defines which of the 8
> > configuration unit descriptors are being shown through sysfs.
>
> I don't know any other example of a sysfs attribute that controls the
> contents of another sysfs attribute so I don't know whether this kind
> of behavior is acceptable for sysfs attributes. Additionally, how can
> these two sysfs attributes be used together from concurrently running
> processes without triggering a race condition?
>
> Bart.

Hi Bart,
I was following the example of rpm_lvl and spm_lvl in this driver,
whose values control what is shown in rpm_target_dev_state and
rpm_target_link_state (and spm equivalents). My original thinking was
that provisioning the high level storage configuration of a UFS disk
is by definition a single threaded one-time-only activity. However
Stanislav and others have also expressed concerns about this
mechanism, so it sounds like I should revise it. I'm hoping Stanislav
will comment on one of two possible approaches I suggested in the
cover letter.

-Evan
