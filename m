From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [RFC][PATCH] 2.5 hosts.c and scsi_host list cleanup
Date: Thu, 5 Sep 2002 00:01:58 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20020905000158.A14644@infradead.org>
References: <20020904204310.GA3588@beaverton.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from hch by phoenix.infradead.org with local (Exim 4.10)
	id 17mj9r-0003yn-00
	for linux-scsi@vger.kernel.org; Thu, 05 Sep 2002 00:01:59 +0100
Content-Disposition: inline
In-Reply-To: <20020904204310.GA3588@beaverton.ibm.com>; from andmike@us.ibm.com on Wed, Sep 04, 2002 at 01:43:10PM -0700
List-Id: linux-scsi@vger.kernel.org
To: linux-scsi@vger.kernel.org

On Wed, Sep 04, 2002 at 01:43:10PM -0700, Mike Anderson wrote:
> I have created a patch against 2.5.33 that cleans up the scsi_host
> lists.
> 	- Switch scsi host template, name, host lists to struct
> 	  list_head's.
> 	- Moved all scsi_host related register / unregister functions
> 	  into hosts.c
> 	- Added list accessor interface and created a function similar
> 	  to driverfs bus_for_each_dev.
> 
> The patch is available at:
> http://www-124.ibm.com/storageio/gen-io/patch-scsi_hosts-2.5.33-1.gz

Any chance you could include it in the mail the next time?  Makes
readin and annotating a lot easier..


+	sh = scsi_shost_hn_get(hostnum);
+	
+	if (sh == NULL) /* This really shouldn't ever happen. */

The additional space between the two statements looks very strange

-	while(host != NULL && host->host_no != host_no)
-		host = host->next;
+	host = scsi_shost_hn_get(host_no);
 
 	if(host == NULL)

Dito.

  *  Updated to reflect the new initialization scheme for the higher 
  *  level of scsi drivers (sd/sr/st)
  *  September 17, 2000 Torben Mathiasen <tmm@image.dk>
+ *
+ *  Modified:
+ *  	Restructured scsi_host lists and associated functions.
+ *  		Mike Anderson (andmike@us.ibm.com)

Maybe you could follow the changelog style already present in the file?

  */
 
 
-/*
-static const char RCSid[] = "$Header: /vger/u4/cvs/linux/drivers/scsi/hosts.c,v 1.20 1996/12/12 19:18:32 davem Exp $";
-*/

Good to see this die!

-Scsi_Host_Template * scsi_hosts;
+	list_for_each_safe(lh, lh_sf, &scsi_shost_list) {
+		shost = list_entry(lh, struct Scsi_Host, sh_list);
+		if (shost->hostt == shost_tp) {
+			spin_unlock(&scsi_shost_list_lock);
+			(void)callback(shost);
+			spin_lock(&scsi_shost_list_lock);

The void cast isn't needed.

+		devfs_unregister (sdev->de);
+		put_device(&sdev->sdev_driverfs_dev);

Maybe make the coding style a little more consistent?  Yes, compared to the
old code you did a _really_ _really_ good job, but please take it to the end..

+	for (sdev = shost->host_queue; sdev;
+	     sdev = shost->host_queue) {

I wonder whether this wouldn't better be a do { } while loop.


+		scsi_release_commandblocks(sdev);
+
+		blk_cleanup_queue(&sdev->request_queue);
+		/* Next free up the Scsi_Device structures for this host */
+		shost->host_queue = sdev->next;
+		if (sdev->inquiry)
+			kfree(sdev->inquiry);
+		kfree((char *) sdev);

No need to cast.

+	/* Remove the instance of the individual hosts */
+	pcount = registered_shosts;
+	if (shost->hostt->release)
+		(*shost->hostt->release) (shost);
+	else {
+		/* This is the default case for the release function.
+		 * It should do the right thing for most correctly
+		 * written host adapters.
+		 */
+		if (shost->irq)
+			free_irq(shost->irq, NULL);
+		if (shost->dma_channel != 0xff)
+			free_dma(shost->dma_channel);
+		if (shost->io_port && shost->n_io_port)
+			release_region(shost->io_port, shost->n_io_port);

This code shouldn't be in generic code (again not your fault).  Move it to
a generic_scsi_host_release() function or so to nicely separate it out.

+	kfree((char *) shost);

See above.

+
+	len = strlen(name);
+	shost_name = (Scsi_Host_Name *) kmalloc(sizeof(Scsi_Host_Name),
+						GFP_KERNEL);

Cast isn't really needed again.


+	shost = (struct Scsi_Host *)kmalloc(sizeof(struct Scsi_Host) +
+					    xtr_bytes,
+					    (shost_tp->unchecked_isa_dma
+					     && xtr_bytes ?  GFP_DMA : 0)
+					    | GFP_KERNEL);

This is ugly as hell.  (Yes, I know it was in the old code).  What about
the following?

	gfp_mask = GFP_KERNEL;
	if (shost_tp->unchecked_isa_dma && xtr_bytes)
		gfp_mask |= __GFP_DMA;

	shost = kmalloc(sizeof(struct Scsi_Host) + xtr_bytes, gfp_mask);



+	if(!shost) {

small coding style oddities again..

+	if (!blk_nohighio)
+	shost->highmem_io = shost_tp->highmem_io;

Umm..


+
+	/*
+	 * detect should do its own locking
+	 * FIXME present is now set is scsi_register which breaks manual
+	 * registration code below.
+	 */
+	(void) shost_tp->detect(shost_tp);

No need for the cast again.

+			/*
+			 * The low-level driver failed to register a driver.
+			 * We can do this now.
+			 */
+			if(scsi_register(shost_tp, 0)==NULL)
+			{

Consistency.

+	(void) shost_tp_for_each_shost(shost_tp, shost_chk_and_release);

Again.

+void __init scsi_shost_hn_init(char *shost_hn)
+{
+	char *temp = shost_hn;
+
+	while (temp) {
+		while (*temp && (*temp != ':') && (*temp != ','))
+		    temp++;
+		if (!*temp)
+		    temp = NULL;
+		else
+		    *temp++ = 0;

Indentation consistency.


Except of those nitpacks the patch looks fine.  That code needed a big
overhaul badly.
