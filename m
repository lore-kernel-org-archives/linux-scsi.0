From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: scsi_scan.c
Date: Thu, 25 Jul 2002 14:04:30 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020725140430.A3356@eng2.beaverton.ibm.com>
References: <3D40629A.5EE2D7B2@splentec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <3D40629A.5EE2D7B2@splentec.com>; from luben@splentec.com on Thu, Jul 25, 2002 at 04:42:02PM -0400
List-Id: linux-scsi@vger.kernel.org
To: Luben Tuikov <luben@splentec.com>
Cc: linux-scsi <linux-scsi@vger.kernel.org>

On Thu, Jul 25, 2002 at 04:42:02PM -0400, Luben Tuikov wrote:
> What is the status of scsi_scan.c in 2.4.latest
> and in 2.5.latest (28)?
> 
> I thought that Patric Mansfield's version would be
> used? It looks to me (2.5.28) that some mixture
> of old and new (P.M.) code is used. (Judging by
> the the use of the old ``if (SDpnt != oldSDpnt) ...''
> along with the new scsi_scan_target() by P.M.)

The REPORT LUNS support and scsi_scan_target are there, I didn't push my
scsi_scan.c cleanup, I'm re-rolling right now to 2.5.28 - generally, merging
with the driverfs stuff Mike Sullivan added (plus his patches that apply
to scsi_scan.c).

> Currently select_queue_depths() gets quite confused
> setting the queue depths unless extended effort
> is used on SDpnt to see that it is the ``next''
> device to be later scanned... (going through the devices)
> 
> ???

Do you mean for the "hardcoded" scanning via /proc/scsi/scsi? Doug Ledford
has a nice patch for this via the slave_attach/slave_detach calls - 
slave_attach can set the queue depth.

I still think all queue depth setting/handling could be done in the
mid-layer, or at a minimum have some common queue depth setting/handling
code.

In any case, select_queue_depths is broken for hardcoded scanning, since
queue depths can't be adjusted.

-- Patrick Mansfield

> -- 
> Luben
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
