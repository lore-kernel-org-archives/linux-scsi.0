From: Christoph Hellwig <hch@infradead.org>
Subject: Re: [BUG] 2.6.0-test4: call of slave_destroy missing
Date: Tue, 2 Sep 2003 18:39:48 +0100
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <20030902183948.A14587@infradead.org>
References: <200309021416.44765.heiko.carstens@de.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from pub234.cambridge.redhat.com ([213.86.99.234]:59149 "EHLO
	phoenix.infradead.org") by vger.kernel.org with ESMTP
	id S263860AbTIBRj6 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Tue, 2 Sep 2003 13:39:58 -0400
Content-Disposition: inline
In-Reply-To: <200309021416.44765.heiko.carstens@de.ibm.com>; from heiko.carstens@de.ibm.com on Tue, Sep 02, 2003 at 02:16:44PM +0200
List-Id: linux-scsi@vger.kernel.org
To: Heiko Carstens <heiko.carstens@de.ibm.com>
Cc: andmike@us.ibm.com, linux-scsi@vger.kernel.org

On Tue, Sep 02, 2003 at 02:16:44PM +0200, Heiko Carstens wrote:
> Hi,
> 
> the upgrade diff from test3 to test4 removed the call of slave_destroy from
> scsi_free_sdev, but didn't add it at any other place (scsi_remove_device?).
> So currently of the alloc/destroy pair just the alloc call happens... I'm
> not sure where the destroy call should be and therefore leave it to somebody
> else to fix this :)

This seems to be a merge error, see

	http://linux-scsi.bkbits.net:8080/scsi-misc-2.5/cset@1.1046.586.10?nav=index.html|ChangeSet@-8w

Mike moved the call to a different function which I merged with another
function in a different file.

The call should be in scsi_remove_device, but IMHO after setting the
SDEV_DEL bit and not before like in the old patch.

Mike, was there a reason you did this before setting the deleted bit?
I can't see how we can free the driver data safely before making sure
we don't call into the driver anymore.

-
To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
On Tue, Sep 02, 2003 at 02:16:44PM +0200, Heiko Carstens wrote:
> Hi,
> 
> the upgrade diff from test3 to test4 removed the call of slave_destroy from
> scsi_free_sdev, but didn't add it at any other place (scsi_remove_device?).
> So currently of the alloc/destroy pair just the alloc call happens... I'm
> not sure where the destroy call should be and therefore leave it to somebody
> else to fix this :)

This seems to be a merge error, see

	http://linux-scsi.bkbits.net:8080/scsi-misc-2.5/cset@1.1046.586.10?nav=index.html|ChangeSet@-8w

Mike moved the call to a different function which I merged with another
function in a different file.

The call should be in scsi_remove_device, but IMHO after setting the
SDEV_DEL bit and not before like in the old patch.

Mike, was there a reason you did this before setting the deleted bit?
I can't see how we can free the driver data safely before making sure
we don't call into the driver anymore.

