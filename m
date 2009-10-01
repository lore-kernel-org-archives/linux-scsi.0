From: Joe Eykholt <jeykholt@cisco.com>
Subject: Re: Why does SCSI mid layer mark the LUN offline in this situation?
Date: Wed, 30 Sep 2009 23:31:18 -0700
Message-ID: <4AC44CB6.1050304@cisco.com>
References: <da0ca6030909302246s4527cc98v6e3b37d7ca3bba2d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sj-iport-1.cisco.com ([171.71.176.70]:36605 "EHLO
	sj-iport-1.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393AbZJAGbP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 1 Oct 2009 02:31:15 -0400
In-Reply-To: <da0ca6030909302246s4527cc98v6e3b37d7ca3bba2d@mail.gmail.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: G S <gogman69-linuxscsi@yahoo.com>
Cc: linux-scsi@vger.kernel.org

G S wrote:
> Howdy,
> 
> I have a Linux (2.6) using Emulex and QLogic FC HBA's to a disk array
> product, with a single LUN presented, say LUN 1.
> 
> The dsf is created for LUN 1 and i can send SCSI commands to LUN 1.
> And i'm using "sg".
> 
> If i delete LUN 1 from disk array.  Reboot the disk array.  Array
> boots up only with LUN 0.
> 
> I have recreated LUN 1 on the target storage array.
> 
> But any attempt to send SCSI command to LUN 1 fails because LUN 1 has
> been marked offline by SCSI mid layer.
> 
> Why?  Is it because RSCN seen by HBA driver is passed up to SCSI mid
> layer to trigger re-scan?  And re-scan no longer finds LUN 1, so LUN 1
> kernel structures are torned down, and LUN 1 marked offline by SCSI
> mid layer?

If I understand your sequence correctly, rebooting the disk array
would cause a RSCN to the HBA, and that would cause it to delete LUN 0 and 1.
When the disk array comes up and logs into the fabric again, another
RSCN goes to the HBA and it sees the target (array) and presents
it to the transport layer and SCSI.  It scans LUN0 (does REPORT LUNS)
and it reports no other LUNs.  No LUN 1 at this point.

Then you add LUN 1 on the array.  There's no event caused by that
as far as I know.   I'm not a complete expert on this and it
depends on your array, I think.  It may cause an check condition
on the next I/O that goes to LUN0, but that may never happen.
So nothing happens on the server.   It doesn't cause an RSCN because
the array didn't re-login to the fabric (that would be disruptive
for other initiators).

> Doing following to add back LUN 1 will bring it back for access,
> 
> # echo "scsi add-single-device <H> <B> <T> <L>" > /proc/scsi/scsi
> 
> Above "echo" seems to cause a blind re-scan by sending SCSI INQUIRY to
> LUN 1 on the h/b/t/l hardware path.  That SCSI INQUIRY succeeds.  And
> that success seems to cause LUN 1 to be marked online again.

OK.  I think you can also echo 1 to /sys/class/scsi_host/hostX/scan

I hope that helps and someone will correct me if any of this is wrong.

	Joe
