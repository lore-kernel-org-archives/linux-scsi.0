From: Krishna Murthy <krmurthy@cisco.com>
Subject: Re: Request for review of Linux iSCSI driver version 4.0.0.1
Date: Mon, 1 Dec 2003 17:40:09 +0530
Sender: linux-scsi-owner@vger.kernel.org
Message-ID: <200312011740.09693.krmurthy@cisco.com>
References: <200310231734.10263.krmurthy@cisco.com> <03111920183201.15831@naveenb-lnx.cisco.com> <20031119144809.A13541@infradead.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from india-ironport-1.cisco.com ([64.104.129.195]:36918 "EHLO
	india-ironport-1.cisco.com") by vger.kernel.org with ESMTP
	id S263189AbTLAMLg convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Mon, 1 Dec 2003 07:11:36 -0500
In-Reply-To: <20031119144809.A13541@infradead.org>
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-scsi@vger.kernel.org, davmyers@cisco.com

Hi,
	We could use probing code from mid layer provided 
scsi_scan_host_selected is exported. 

	iscsi driver does probe for devices at two places
a)Once after session establishment.
b)Whenever an iSCSI async message indicates a change in
"REPORTED LUNS DATA". (addition/deletion of luns on the target) 

	There are no issues in calling scsi_scan_host_selected() at a).
	Addition of luns could be handled by calling scsi_scan_host_selected 
with rescan parameter set to 1.
	Deletion of luns is not handled. scsi_scan_target does not worry about 
devices which were previously configured, but currently not available.Would 
you recommend handling this in scsi_scan_target (or a new API) or handle in 
iSCSI using scsi_request based interfaces?

Please let us know.

Thanx
N.C.Krishna Murthy
		

On Wednesday 19 Nov 2003 8:18 pm, Christoph Hellwig wrote:
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
>
> -
> To unsubscribe from this list: send the line "unsubscribe linux-scsi" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
