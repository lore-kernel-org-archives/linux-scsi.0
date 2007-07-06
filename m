From: James Bottomley <James.Bottomley@SteelEye.com>
Subject: Re: [patch 0/3] clean gendisk out of scsi ULD structs
Date: Fri, 06 Jul 2007 15:02:49 -0500
Message-ID: <1183752169.3448.93.camel@localhost.localdomain>
References: <20070705140636.6dbabd6f.kristen.c.accardi@intel.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hancock.steeleye.com ([71.30.118.248]:55517 "EHLO
	hancock.sc.steeleye.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760277AbXGFUCw (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 6 Jul 2007 16:02:52 -0400
In-Reply-To: <20070705140636.6dbabd6f.kristen.c.accardi@intel.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Kristen Carlson Accardi <kristen.c.accardi@intel.com>
Cc: akpm@linux-foundation.org, jeff@garzik.org, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org

On Thu, 2007-07-05 at 14:06 -0700, Kristen Carlson Accardi wrote:
> Since gendisk will now become part of struct scsi_device, we don't need
> to store this value in any private data structs where they already store
> scsi_device.  This series cleans up a few drivers which did this.

Actually, as Al pointed out, we do have lifetime rules issues with doing
this.  The problem is that gendisk itself always has a shorter lifetime
than scsi_device (not much shorter, usually, but if you execute a legal
ULD unbind manoeuvre you'll end up with a dangling gendisk pointer).

The other problem with taking gendisk out of the ULD structure and
putting it into the scsi_device is that for the sg driver, we have two
of them (one for the attached ULD and one for the sg driver).

The fundamental issue seems to be that the gendisk is the holder of all
the other info (queue, ULD etc) not vice versa ... and this patch is
trying to reverse that relationship.

James


