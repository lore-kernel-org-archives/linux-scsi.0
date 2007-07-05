From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [patch 0/3] clean gendisk out of scsi ULD structs
Date: Thu, 05 Jul 2007 18:14:06 -0500
Message-ID: <1183677246.3448.71.camel@localhost.localdomain>
References: <20070705140636.6dbabd6f.kristen.c.accardi@intel.com>
	 <20070705230251.GS21478@ftp.linux.org.uk>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:35447 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760182AbXGEXOI (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Thu, 5 Jul 2007 19:14:08 -0400
In-Reply-To: <20070705230251.GS21478@ftp.linux.org.uk>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Al Viro <viro@ftp.linux.org.uk>
Cc: Kristen Carlson Accardi <kristen.c.accardi@intel.com>, akpm@linux-foundation.org, jeff@garzik.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Fri, 2007-07-06 at 00:02 +0100, Al Viro wrote:
> On Thu, Jul 05, 2007 at 02:06:36PM -0700, Kristen Carlson Accardi wrote:
> > Since gendisk will now become part of struct scsi_device, we don't need
> > to store this value in any private data structs where they already store
> > scsi_device.  This series cleans up a few drivers which did this.
> 
> What the hell?  gendisks are *NOT* supposed to be embedded into other
> data structures, you'll screw up the lifetime rules for them.

Don't panic .. they're not ... we have a pointer to the gendisk in our
SCSI structures (properly refcounted).  The reason is historical and
actually goes back to 2002 when we first got rid of the static arrays of
structures we used to keep around.

Doug ... don't think 'disk' when you see 'gendisk' just think of it as a
useful infrastructure library.

James


