From: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Subject: Re: [patch 0/7] Asynchronous Notification for ATAPI devices (v2) -
 resend
Date: Fri, 4 May 2007 13:36:45 -0700
Message-ID: <20070504133645.7d053549.kristen.c.accardi@intel.com>
References: <20070504111222.c2e373cf.kristen.c.accardi@intel.com>
	<1178310603.3711.54.camel@mulgrave.il.steeleye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <1178310603.3711.54.camel@mulgrave.il.steeleye.com>
Sender: linux-ide-owner@vger.kernel.org
To: James Bottomley <James.Bottomley@SteelEye.com>
Cc: jeff@garzik.org, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org, linux-ide@vger.kernel.org, htejun@gmail.com, akpm@linux-foundation.org
List-Id: linux-scsi@vger.kernel.org

On Fri, 04 May 2007 15:30:03 -0500
James Bottomley <James.Bottomley@SteelEye.com> wrote:

> On Fri, 2007-05-04 at 11:12 -0700, Kristen Carlson Accardi wrote:
> > This patch series implements Asynchronous Notification (AN) for SATA
> > ATAPI devices as defined in SATA 2.5 and AHCI 1.1 and higher.  Drives
> > which support this feature will send a notification when new media is
> > inserted and removed, preventing the need for user space to poll for
> > new media.  This support is exposed to user space via a flag that will
> > be set in /sys/block/sr*/capability_flags.  If the flag is set, user
> > space can disable polling for the new media, and the genhd driver will
> > send a KOBJ_CHANGE event with the envp set to MEDIA_CHANGE_EVENT=1.
> > 
> > Note that this patch only implements support for directly attached
> > drives - AN with drives attached to a port multiplier requires 
> > additional changes.
> 
> I seem to remember when this came up before, the observation was made
> that AENs occur for many more things than simple media change notices,
> so we should probably have a more generic AEN handling mechanism.  Is
> there any plan to move in this direction
> 
> James
> 
In this implementation, we use kobject_uevent_env (vs. just 
kobject_uevent in the original implementation) to send a KOBJ_CHANGE
with the enviroment value of MEDIA_CHANGE=1.  For other asynchronous
events, you could still use KOBJ_CHANGE with a different env value.
