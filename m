From: Naveen Burmi <naveenb@cisco.com>
Subject: Re: Request for review of Linux iSCSI driver version 4.0.0.1
Date: Wed, 19 Nov 2003 20:49:36 +0530
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <03111920493602.15831@naveenb-lnx.cisco.com>
References: <200310231734.10263.krmurthy@cisco.com> <03111920183201.15831@naveenb-lnx.cisco.com> <20031119144809.A13541@infradead.org>
Reply-To: naveenb@cisco.com
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sj-iport-2-in.cisco.com ([171.71.176.71]:14231 "EHLO
	sj-iport-2.cisco.com") by vger.kernel.org with ESMTP
	id S264108AbTKSPQ2 (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Nov 2003 10:16:28 -0500
In-Reply-To: <20031119144809.A13541@infradead.org>
List-Id: linux-scsi@vger.kernel.org
Cc: Christoph Hellwig <hch@infradead.org>, linux-scsi@vger.kernel.org, davmyers@cisco.com

On Wednesday 19 November 2003 08:18 pm, Christoph Hellwig wrote:
> On Wed, Nov 19, 2003 at 08:18:32PM +0530, Naveen Burmi wrote:
> > On Monday 27 October 2003 09:09 pm, Christoph Hellwig wrote:
> > > iscsi-probe.c:
> > > 	- the whole iscsi_do_cmnd use looks very very strange.
> >
> > After a device gets detected by iSCSI LLD, it uses iscsi_do_cmnd to send
> > scsi commands to that device even before registering it with the scsi
> > mid-layer.
> >
> > For example user can configure in iscsi LLD configuration (iscsi.conf)
> > file what various LUNs of a particular target needs to be activated. To
> > acheive this we need to execute REPORT LUN command on target, to find out
> > what various luns are present and selectively issue scsi_add_device for
> > luns that needs to be activated.
>
> Couldn't you just use scsi_scan_host_selected from scsi_scan.c for that
> if it was exported?  We already have all that big and perfectly multi-lun
> capable probing code in the scsi midlayer and it would be a shame to not
> use it.

scsi_scan_host_selected can be used for activating LUNs, selectively.
But that is the second step.
First step is to execute the REPORT LUN command without registering a device 
with scsi mid-layer. That's what we are acheiving through iscsi_do_cmnd .
Once we know what all luns are available for a target,   
scsi_scan_host_selected can be used to activate the luns, selectively.


> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
