From: Clay Haapala <chaapala@cisco.com>
Subject: Re: Request for review of Linux iSCSI driver version 4.0.0.1
Date: Wed, 03 Dec 2003 16:32:14 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <yqujbrqp1qj5.fsf@chaapala-lnx2.cisco.com>
References: <20031203221508.51C9B5DC7E@bambi.visi.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sj-iport-5.cisco.com ([171.68.10.87]:44814 "EHLO
	sj-iport-5.cisco.com") by vger.kernel.org with ESMTP
	id S262074AbTLCWcT (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 3 Dec 2003 17:32:19 -0500
In-Reply-To: <20031203221508.51C9B5DC7E@bambi.visi.com> (Scott M. Ferris's
 message of "Wed, 3 Dec 2003 16:15:08 -0600 (CST)")
List-Id: linux-scsi@vger.kernel.org
To: "Scott M. Ferris" <sferris@acm.org>
Cc: James Bottomley <James.Bottomley@steeleye.com>, naveenb@cisco.com, Roman Zippel <zippel@linux-m68k.org>, hch@infradead.org, SCSI Mailing List <linux-scsi@vger.kernel.org>, davmyers@cisco.com

Thanks, Scott!

On Wed, 3 Dec 2003, Scott M. Ferris uttered the following:
> Clay Haapala wrote:
>> 
>> A couple of related SCSI (not necessarily iSCSI) questions:
>> 
>> "If the allowed count has not been exceeded" - The first two
>> commands after a connection has been estabilished will fail with
>> Unit_Attention. What if that first command then also gets a crc
>> error (Aborted_command)?  Will the retry count be large enough?
> 
> The high-level driver picks the allowed count for each command,
> which indicates how many times that command will be issued to the
> low-level driver before being failed back to the high-level driver.
> For disks, that's been 5 at least as far back as 2.2 kernels.
> 
>> Does the retry also apply to tape?  Without proper tape error
>> recovery, retrying the command could result in duplicate records
>> written to tape.
> 
> The tape driver sets the allowed count to 0 for commands that change
> the media, in order to disable any retries that would cause tape
> positioning problems.  Only commands like test unit ready and read
> block limits get retries for tape.
> 
> It would be a serious bug for the iSCSI driver to retry a command
> with an allowed count of zero.

-- 
Clay Haapala (chaapala@cisco.com) Cisco Systems SRBU +1 763-398-1056
   6450 Wedgwood Rd, Suite 130 Maple Grove MN 55311 PGP: C89240AD
   Active dissent has been part of American government since the
         Boston Tea Party, and will be until its end.
