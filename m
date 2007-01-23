From: Randy Dunlap <randy.dunlap@oracle.com>
Subject: Re: Linux Virtual SCSI HBAs and Virtual disks
Date: Tue, 23 Jan 2007 08:36:27 -0800
Message-ID: <20070123083627.9b4ddfe3.randy.dunlap@oracle.com>
References: <1e157f74d8578f24c762571c1016aab3@aboo.org>
	<b43c8fc9882e65d397a6465e6cb7c998@aboo.org>
	<45B4EAAC.5000008@s5r6.in-berlin.de>
	<45B60993.9070508@aboo.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from rgminet01.oracle.com ([148.87.113.118]:61201 "EHLO
	rgminet01.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932936AbXAWQkq (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 23 Jan 2007 11:40:46 -0500
In-Reply-To: <45B60993.9070508@aboo.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Aboo Valappil <aboo@aboo.org>
Cc: Stefan Richter <stefanr@s5r6.in-berlin.de>, dougg@torque.net, linux-scsi@vger.kernel.org

On Wed, 24 Jan 2007 00:11:47 +1100 Aboo Valappil wrote:

> Hi Stefan Richter,
> 
> Thanks everyone for their advice on this. As per your advice, I did the 
> following when the last user space target serving the scsi_host quits, 
> the queue command will do the following on the new commands coming through.
> 
>                 sc->result = DID_NO_CONNECT << 16;
>                 sc->resid = sc->request_bufflen;
>                 set_sensedata_commfailure(sc);  --------------------- 
> This sets the sense buffer with Device Not ready/Logical Unit 
> Commincation failure.
>                 done(sc);
> 
> The scsi_host will remain in the kernel. Let the EH thread handle the 
> queued commands (If any). If the user target wants to reconnects to the 
> same scsi_host, it can do so (Just re-run the user space target again 
> with same command line paramters).  This connection from newly started 
> target will make the HBA healthy again and start serving IO.
> 
> I implemented a new IOCTL to remove  this  scsi_host  if the user 
> process really needs to.  This removal  will first  finish all the SCSI 
> commands (With the above status results) queued on the scsi_host  (If at 
> all) and then remove the scsi_host.  Also the module unload will delete 
> all the scsi_hosts created after finishing all the commands queued with 
> the above status and sense information.
> 
> I also implemented passing of sense code information from user space to 
> sense_buffer. A little more work needs to be done on this.
> Also, I need to make sure that all the locking used inside is correctly 
> implemented to prevent dead locks and improve efficiency.
> 
> The new version is available http://vscsihba.aboo.org/vscsihbav204.gz

404: NOT FOUND

---
~Randy
