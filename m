From: Douglas Gilbert <dougg@torque.net>
Subject: Re: [PATCH] sd: implement stop_on_shutdown
Date: Fri, 19 Jan 2007 18:34:13 -0500
Message-ID: <45B15575.5090806@torque.net>
References: <20070119170122.GS10987@htj.dyndns.org>
Reply-To: dougg@torque.net
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-ide-owner@vger.kernel.org>
In-Reply-To: <20070119170122.GS10987@htj.dyndns.org>
Sender: linux-ide-owner@vger.kernel.org
To: Tejun Heo <htejun@gmail.com>
Cc: James.Bottomley@SteelEye.com, Jeff Garzik <jgarzik@pobox.com>, hmh@hmh.eng.br, linux-ide@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

Tejun Heo wrote:
> sd doesn't stop (unload head) on shutdown.  This behavior is necessary
> for multi initiator cases.  Unloading head by powering off stresses
> the drive and sometimes produces distinct clunking noise which
> apparently disturbs users considering multiple reports on different
> distributions.  halt(8) usually puts the drives to sleep prior to
> shutdown but the implementation is fragile and it doesn't work with
> sleep-to-disk.
> 
> This patch implements sd attribute stop_on_shutdown.  If set to 1, sd
> stops the drive on non-restarting shutdown.  stop_on_shutdown is
> initialized from sd parameter stop_on_shutdown_default which defaults
> to 0.  So, this patch does not change the default behavior.

Tejun,
The IMMED bit in the START STOP UNIT cdb is not being set
when your patch stops a drive:

Advantage:
  - the power won't be dropped immediately after sending
    the command to the drive (assuming the drive gets
    its power from the same power supply that shutdown
    turns off)

Disadvantage:
  - it will delay shutdown proportional to the number of
    drives with the stop_on_shutdown attribute set. Say
    5 seconds per disk.
Disadvantage (with or without IMMED bit set):
  - if another initiator (e.g. on another machine) was
    using a different partition on that disk, then it might
    get upset (especially if it was running Linux).
    [I'm not sure why you say this patch is necessary
     in this case.]

BTW SCSI disks typically have a lower start-stop lifetime
rating than ATA disks. This reflects that SCSI disks are
designed to be on 168 hours per week.

Doug Gilbert

