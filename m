From: James Bottomley <James.Bottomley@steeleye.com>
Subject: Re: [PATCH] fix scsi add-single-device
Date: 27 Jan 2003 10:07:40 -0600
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <1043683662.2292.15.camel@mulgrave>
References: <1043604061.12324.59.camel@mulgrave>
	<20030127081535.GA7780@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: (from root@localhost)
	by pogo.mtv1.steeleye.com (8.9.3/8.9.3) id IAA14971
	for <linux-scsi@vger.kernel.org>; Mon, 27 Jan 2003 08:07:45 -0800
In-Reply-To: <20030127081535.GA7780@beaverton.ibm.com>
List-Id: linux-scsi@vger.kernel.org
To: Mike Anderson <andmike@us.ibm.com>
Cc: linux-scsi@vger.kernel.org

On Mon, 2003-01-27 at 02:15, Mike Anderson wrote:
> James Bottomley [James.Bottomley@steeleye.com] wrote:
> > diff -Nru a/drivers/scsi/scsi_scan.c b/drivers/scsi/scsi_scan.c
> > --- a/drivers/scsi/scsi_scan.c	Sun Jan 26 11:58:46 2003
> > +++ b/drivers/scsi/scsi_scan.c	Sun Jan 26 11:58:46 2003
> > @@ -1758,7 +1758,7 @@
> >  	shost = scsi_host_hn_get(host);
> >  	if (!shost)
> >  		return -ENODEV;
> > -	if(scsi_find_device(shost, channel, id, lun) != NULL)
> > +	if(scsi_find_device(shost, channel, id, lun) == NULL)
> >  		goto out;
> 
> The previous condition seemed to be correct as you want to exit if
> scsi_find_device finds a scsi_device at the nexus you are trying to add.
> 
> The patch below fixed the interface for me.  Though I only tested in
> with scsi_debug under UML YMMV.

Yes, sorry (long week last week).  It is indeed the semantics of
scsi_find_device() that are broken.

Thanks,

James


