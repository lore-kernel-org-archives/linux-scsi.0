From: Boaz Harrosh <bharrosh@panasas.com>
Subject: Re: [PATCH 0/4] more gdth patches for your amusement
Date: Tue, 25 Sep 2007 14:17:44 +0200
Message-ID: <46F8FC68.4020002@panasas.com>
References: <20070721203410.GA1004@havoc.gtf.org> <1189865576.3339.0.camel@localhost.localdomain> <46F85578.70503@garzik.org> <20070925082027.GA9587@infradead.org> <46F8DA11.6030103@panasas.com> <20070925115608.GR10625@parisc-linux.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from gw-colo-pa.panasas.com ([66.238.117.130]:19079 "EHLO
	cassoulet.panasas.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752435AbXIYMSG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Tue, 25 Sep 2007 08:18:06 -0400
In-Reply-To: <20070925115608.GR10625@parisc-linux.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Matthew Wilcox <matthew@wil.cx>
Cc: Christoph Hellwig <hch@infradead.org>, Jeff Garzik <jeff@garzik.org>, James Bottomley <James.Bottomley@SteelEye.com>, linux-scsi@vger.kernel.org, achim_leubner@adaptec.com, Andrew Morton <akpm@linux-foundation.org>

On Tue, Sep 25 2007 at 13:56 +0200, Matthew Wilcox <matthew@wil.cx> wrote:
> On Tue, Sep 25, 2007 at 11:51:13AM +0200, Boaz Harrosh wrote:
>> On top of that I have my own agenda of cleaning the !use_sg code paths and getting
>> rid of scsi_cmnd abuse, so there is also that.
> 
> This seems like a good time to post my own patch that removes the use of
> ->scsi_done from gdth.  I have a plan to remove the ->scsi_done() callback
> (drivers will simply call the scsi_done() function directly), and fixing
> the half-dozen drivers that override it is part of that.
> 
> I haven't looked at Christoph's, Jeff's or your patches yet, so this
> patch may be entirely worthless.  My goal with it was not to clean up
> the driver (though it does a little), but to get gdth out of the way of
> cleaning up scsi_cmnd.
> 
> commit 06142e2394d83929b8b25feab70caab47ddfb791
> Author: Matthew Wilcox <willy@linux.intel.com>
> Date:   Sat Sep 22 22:57:06 2007 -0400
> 
>     gdth: Make one abuse of scsi_cmnd less obvious
>     
>     Rather than having internal commands abuse scsi_done to call
>     gdth_scsi_done, have all the places that use to call scsi_done directly
>     call gdth_scsi_done, which now checks whether the command was internal,
>     and calls scsi_done if not.
>     
>     Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
> 
> diff --git a/drivers/scsi/gdth.c b/drivers/scsi/gdth.c
> index b20c188..8a6a5f8 100644
> --- 

Hi Matthew!
This patch looks grate, Thanks. It is very good for the direction
I'm going to. However it does have a smallish conflict with One
of Jeff's patches where he completely removes the 2.4.x support.

If it is OK with you I will add your patch to my patchset with your
Singed-off-by, minus the conflict?
 
Boaz
