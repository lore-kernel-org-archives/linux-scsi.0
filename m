From: Stefan Richter <stefanr@s5r6.in-berlin.de>
Subject: Re: [Comments Needed] scan vs remove_target deadlock
Date: Tue, 11 Apr 2006 10:53:36 +0200
Message-ID: <443B6E90.4020705@s5r6.in-berlin.de>
References: <1144693508.3820.33.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hp3.statik.TU-Cottbus.De ([141.43.120.68]:28291 "EHLO
	hp3.statik.tu-cottbus.de") by vger.kernel.org with ESMTP
	id S932358AbWDKIyo (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 11 Apr 2006 04:54:44 -0400
In-Reply-To: <1144693508.3820.33.camel@localhost.localdomain>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: James.Smart@Emulex.Com
Cc: linux-scsi@vger.kernel.org

James Smart wrote:
> In the case
> where the block/unblock interfaces are being used (fc transport), the
> request queue can be stopped - which stops scanning.  If the same or
> unrelated sdev is then to be removed, we enter a deadlock waiting for
> the scan mutex to be released.

Another driver which uses a block/unblock interface is sbp2. It blocks
shosts (because one shost == one SBP-2 LU at the moment) during 1394 bus
reset/ 1394 nodes rescan/ SBP-2 reconnect phases. I learned the hard way
that an shost (or sdev if you will) *must not be blocked* when an shost
(or sdev) is to be removed. This is generally true, not only during
scanning, because SCSI command set drivers' shutdown methods go into
deadlock as well if an shost (or sdev) is blocked. I posted an addition
for Documentation/scsi/scsi_mid_low_api.txt a while ago to document this
pitfall.

IOW before a transport may remove an sdev or shost, it has to unblock it
and it also has to make sure that all commands that were enqueued before
the blocking are being completed. But isn't it rather a responsibility
of the SCSI core to get a LU's or target's state transitions right? When
an sdev is "blocked" and the transport tells the core to transition it
to "to be removed", then the core should know that the sdev's LU cannot
be reached anymore and act accordingly.
-- 
Stefan Richter
-=====-=-==- -=-- -=-==
http://arcgraph.de/sr/
