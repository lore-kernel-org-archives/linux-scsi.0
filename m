From: Patrick Mansfield <patmans@us.ibm.com>
Subject: Re: Multiple CDRW's on one bus blocking each other
Date: Thu, 2 May 2002 09:27:26 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020502092726.A14365@eng2.beaverton.ibm.com>
References: <5.0.2.1.2.20020502145414.0354c230@pop.puretec.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
In-Reply-To: <5.0.2.1.2.20020502145414.0354c230@pop.puretec.de>; from sancho@dauskardt.de on Thu, May 02, 2002 at 04:16:38PM +0200
List-Id: linux-scsi@vger.kernel.org
To: Sancho Dauskardt <sancho@dauskardt.de>
Cc: linux-scsi@vger.kernel.org

Have you tried using scsi logging? That might give a better idea of what 
is happening in linux scsi layers.

If you haven't run it before: be careful, it will flood your logs forever
if you leave the log daemon running (logging the logging). To try keep from
flooding the console and log files, I kill syslog, sync, turn on logging,
run commands of interest, then turn off logging.

scsi.c says:

/*
 * Usage: echo "scsi log token #N" > /proc/scsi/scsi
 * where token is one of [error,scan,mlqueue,mlcomplete,llqueue,
 * llcomplete,hlqueue,hlcomplete]
 */

Or just turn everything on or off using (AFAICR):

	echo scsi log all > /proc/scsi/scsi
	echo scsi log none > /proc/scsi/scsi

-- Patrick

On Thu, May 02, 2002 at 04:16:38PM +0200, Sancho Dauskardt wrote:

> My problem is that all CDRW's sitting on the same bus somehow block each 
> other when sending eject tray / load tray commands to the drive:
> 
