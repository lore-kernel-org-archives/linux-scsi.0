From: "Randy.Dunlap" <rddunlap@osdl.org>
Subject: Re: [PATCH] [v2] aha152x cmnd->device oops
Date: Tue, 28 Oct 2003 14:50:44 -0800
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20031028145044.29ff4d1f.rddunlap@osdl.org>
References: <20031027155713.GA28140@lst.de>
	<20031027160101.76d5291b.rddunlap@osdl.org>
	<20031028090600.GA7370@lst.de>
	<20031028124536.3ce82c23.rddunlap@osdl.org>
	<3F9EF2B4.9030708@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from fw.osdl.org ([65.172.181.6]:62925 "EHLO mail.osdl.org")
	by vger.kernel.org with ESMTP id S261821AbTJ1WzG (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Tue, 28 Oct 2003 17:55:06 -0500
In-Reply-To: <3F9EF2B4.9030708@us.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <mikenc@us.ibm.com>
Cc: hch@lst.de, James.Bottomley@SteelEye.com, linux-scsi@vger.kernel.org, fischer@norbit.de

On Tue, 28 Oct 2003 14:50:28 -0800 Mike Christie <mikenc@us.ibm.com> wrote:

| Hi Randy,
| 
| >  			if(!(DONE_SC->SCp.Status & not_issued)) {
| > -				Scsi_Cmnd *cmnd = kmalloc(sizeof(Scsi_Cmnd), GFP_ATOMIC);
| > +				Scsi_Cmnd *cmnd = scsi_get_command(DONE_SC->device, GFP_ATOMIC);
| 
| Do you need to add a scsi_put_command to balance this get when the 
| command completes?

Yes, if it continues to use scsi_get_command().  However, I'm
working on an alternate patch now.

| > +					cmnd->device          = ptr->device;
| 
| Don't even need this now. scsi_get_command will set the device for you.

Oh, of course.  device was passed to it.

Thanks.

--
~Randy
