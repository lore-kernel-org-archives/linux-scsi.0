From: Matthew Wilcox <matthew@wil.cx>
Subject: Re: [PATCH 7/24] advansys: Convert to EISA driver model
Date: Fri, 27 Jul 2007 08:22:21 -0600
Message-ID: <20070727142221.GF21219@parisc-linux.org>
References: <20070727134038.GC21219@parisc-linux.org> <11855437533612-git-send-email-matthew@wil.cx> <46A9FE83.4000403@garzik.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from palinux.external.hp.com ([192.25.206.14]:54009 "EHLO
	mail.parisc-linux.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760628AbXG0OWW (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Fri, 27 Jul 2007 10:22:22 -0400
Content-Disposition: inline
In-Reply-To: <46A9FE83.4000403@garzik.org>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jeff Garzik <jeff@garzik.org>
Cc: linux-scsi@vger.kernel.org

On Fri, Jul 27, 2007 at 10:17:39AM -0400, Jeff Garzik wrote:
> >+static __devexit int advansys_eisa_remove(struct device *dev)
> >+{
> >+	int i, ioport;
> >+	struct eisa_scsi_data *data = dev_get_drvdata(dev);
> >+
> >+	for (i = 0; i < 2; i++) {
> >+		struct Scsi_Host *shost = data->host[i];
> >+		if (!shost)
> >+			continue;
> >+		ioport = shost->io_port;
> >+		advansys_remove(data->host[i]);
> 
> what is the point of assigning ioport a never-used value?

It gets used in the next patch:

                ioport = shost->io_port;
                advansys_release(data->host[i]);
                release_region(ioport, ASC_IOADR_GAP);

I can move that one line between patches (and clearly, I should use 'shost'
instead of 'data->host[i]').  Guess I missed it when shuffling patches

-- 
"Bill, look, we understand that you're interested in selling us this
operating system, but compare it to ours.  We can't possibly take such
a retrograde step."
