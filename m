From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: SG_IO permissions
Date: Wed, 02 Jul 2008 09:51:02 -0500
Message-ID: <1215010262.3330.19.camel@localhost.localdomain>
References: <1215004850.5058.101.camel@pcitfio23.cern.ch>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from accolon.hansenpartnership.com ([76.243.235.52]:48109 "EHLO
	accolon.hansenpartnership.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753304AbYGBOvE (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 2 Jul 2008 10:51:04 -0400
In-Reply-To: <1215004850.5058.101.camel@pcitfio23.cern.ch>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Arne Wiebalck <arne.wiebalck@cern.ch>
Cc: linux-scsi@vger.kernel.org

On Wed, 2008-07-02 at 15:20 +0200, Arne Wiebalck wrote:
> Hi all,
> 
> I am trying to replace some read/write calls in our application
> by SG_IO commands in order to have access to the sense bytes in 
> case of an error. The underlying devices are tape drives. 
> 
> Part of our application, such as positioning or reading labels
> from the tape, are run as root. This seems to work fine, I get 
> the data I expect and the sense bytes in case of an error. 
> 
> However, the actual data transfer from and to the device is run 
> under a user's ID. This part does not work anymore when switching
> from read/write to SG_IO: 'Operation not permitted'. 
> 
> Does a user need some special rights to issue SG_IO (read) commands
> (on a file descriptor that he opened for reading and that he 
> can use without problems for read() calls)? 
> 
> The device node that the processes are accessing is a char special
> file owned by the user and with all user bits set. This special file
> is created on a per tape request basis. I also tried to use /dev/nst0
> instead, but that made no difference. 
> 
> I am running a relatively old kernel (2.6.9 based), could that cause
> any problem?
> 
> BTW, why does it say "except st" on the permission requirements table on
> http://sg.torque.net/sg/sg_io.html ? :)
> 
> 
> Any hints appreciated.

SG_IO access requires CAP_SYS_RAWIO to defeat the command verifier.

James


