From: Mike Anderson <andmike@us.ibm.com>
Subject: Re: [BUG] 2.6.0-test4: call of slave_destroy missing
Date: Tue, 2 Sep 2003 11:18:31 -0700
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030902181831.GA1232@beaverton.ibm.com>
References: <200309021416.44765.heiko.carstens@de.ibm.com> <20030902183948.A14587@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from e34.co.us.ibm.com ([32.97.110.132]:64140 "EHLO
	e34.co.us.ibm.com") by vger.kernel.org with ESMTP id S264054AbTIBSPK
	(ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Sep 2003 14:15:10 -0400
Content-Disposition: inline
In-Reply-To: <20030902183948.A14587@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, linux-scsi@vger.kernel.org

Christoph Hellwig [hch@infradead.org] wrote:
> On Tue, Sep 02, 2003 at 02:16:44PM +0200, Heiko Carstens wrote:
> > Hi,
> > 
> > the upgrade diff from test3 to test4 removed the call of slave_destroy from
> > scsi_free_sdev, but didn't add it at any other place (scsi_remove_device?).
> > So currently of the alloc/destroy pair just the alloc call happens... I'm
> > not sure where the destroy call should be and therefore leave it to somebody
> > else to fix this :)
> 
> This seems to be a merge error, see
> 
> 	http://linux-scsi.bkbits.net:8080/scsi-misc-2.5/cset@1.1046.586.10?nav=index.html|ChangeSet@-8w
> 
> Mike moved the call to a different function which I merged with another
> function in a different file.
> 
> The call should be in scsi_remove_device, but IMHO after setting the
> SDEV_DEL bit and not before like in the old patch.
> 
> Mike, was there a reason you did this before setting the deleted bit?
> I can't see how we can free the driver data safely before making sure
> we don't call into the driver anymore.
> 

Doing it after the setting the deleted (SDEV_DEL) is probably better.
You are going to add it scsi_remove_device which is where SDEV_DEL is
set so might as well call it after.

Previously we could not call into the LLDD as prior to this call we have
stopped the queucommand from being called (SHOST_CANCEL is set) and the
error handler is not running.

-andmike
--
Michael Anderson
andmike@us.ibm.com

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
Christoph Hellwig [hch@infradead.org] wrote:
> On Tue, Sep 02, 2003 at 02:16:44PM +0200, Heiko Carstens wrote:
> > Hi,
> > 
> > the upgrade diff from test3 to test4 removed the call of slave_destroy from
> > scsi_free_sdev, but didn't add it at any other place (scsi_remove_device?).
> > So currently of the alloc/destroy pair just the alloc call happens... I'm
> > not sure where the destroy call should be and therefore leave it to somebody
> > else to fix this :)
> 
> This seems to be a merge error, see
> 
> 	http://linux-scsi.bkbits.net:8080/scsi-misc-2.5/cset@1.1046.586.10?nav=index.html|ChangeSet@-8w
> 
> Mike moved the call to a different function which I merged with another
> function in a different file.
> 
> The call should be in scsi_remove_device, but IMHO after setting the
> SDEV_DEL bit and not before like in the old patch.
> 
> Mike, was there a reason you did this before setting the deleted bit?
> I can't see how we can free the driver data safely before making sure
> we don't call into the driver anymore.
> 

Doing it after the setting the deleted (SDEV_DEL) is probably better.
You are going to add it scsi_remove_device which is where SDEV_DEL is
set so might as well call it after.

Previously we could not call into the LLDD as prior to this call we have
stopped the queucommand from being called (SHOST_CANCEL is set) and the
error handler is not running.

-andmike
--
Michael Anderson
andmike@us.ibm.com

