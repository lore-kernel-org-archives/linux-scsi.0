From: Ram Pai <linuxram@us.ibm.com>
Subject: Re: [PATCH v2] mpt3sas: Force request partial completion alignment
Date: Thu, 26 Jan 2017 09:02:34 -0800
Message-ID: <20170126170234.GD5657@ram.oc3035372033.ibm.com>
References: <1485272838-23180-1-git-send-email-gpiccoli@linux.vnet.ibm.com>
 <yq1a8aebt4q.fsf@oracle.com>
 <5889FA49.4030802@linux.vnet.ibm.com>
Reply-To: Ram Pai <linuxram@us.ibm.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from mx0a-001b2d01.pphosted.com ([148.163.156.1]:46852 "EHLO
        mx0a-001b2d01.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1752479AbdAZRCw (ORCPT
        <rfc822;linux-scsi@vger.kernel.org>);
        Thu, 26 Jan 2017 12:02:52 -0500
Received: from pps.filterd (m0098404.ppops.net [127.0.0.1])
        by mx0a-001b2d01.pphosted.com (8.16.0.20/8.16.0.20) with SMTP id v0QGwbOl010684
        for <linux-scsi@vger.kernel.org>; Thu, 26 Jan 2017 12:02:47 -0500
Received: from e18.ny.us.ibm.com (e18.ny.us.ibm.com [129.33.205.208])
        by mx0a-001b2d01.pphosted.com with ESMTP id 287jhk81mr-1
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=NOT)
        for <linux-scsi@vger.kernel.org>; Thu, 26 Jan 2017 12:02:46 -0500
Received: from localhost
        by e18.ny.us.ibm.com with IBM ESMTP SMTP Gateway: Authorized Use Only! Violators will be prosecuted
        for <linux-scsi@vger.kernel.org> from <linuxram@us.ibm.com>;
        Thu, 26 Jan 2017 12:02:45 -0500
Content-Disposition: inline
In-Reply-To: <5889FA49.4030802@linux.vnet.ibm.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Guilherme G. Piccoli" <gpiccoli@linux.vnet.ibm.com>
Cc: "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, MPT-FusionLinux.pdl@broadcom.com, sathya.prakash@broadcom.com, chaitra.basappa@broadcom.com, suganath-prabu.subramani@broadcom.com, sreekanth.reddy@broadcom.com, brking@linux.vnet.ibm.com, mauricfo@linux.vnet.ibm.com

On Thu, Jan 26, 2017 at 11:31:53AM -0200, Guilherme G. Piccoli wrote:
> On 01/25/2017 09:46 PM, Martin K. Petersen wrote:
> >>>>>> "Guilherme" == Guilherme G Piccoli <gpiccoli@linux.vnet.ibm.com> writes:
> > 
> > Hi Guilherme,
> 
> Hi Martin, thanks for the review!
> 
> 
> > 
> > diff --git a/drivers/scsi/mpt3sas/mpt3sas_scsih.c b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> > index 75f3fce..e52c942 100644
> > --- a/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> > +++ b/drivers/scsi/mpt3sas/mpt3sas_scsih.c
> > @@ -4657,6 +4657,8 @@ _scsih_io_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
> >  	struct MPT3SAS_DEVICE *sas_device_priv_data;
> >  	u32 response_code = 0;
> >  	unsigned long flags;
> > +	unsigned int sector_sz;
> > +	struct request *req;
> > 
> >  	mpi_reply = mpt3sas_base_get_reply_virt_addr(ioc, reply);
> >  	scmd = _scsih_scsi_lookup_get_clear(ioc, smid);
> > @@ -4715,6 +4717,21 @@ _scsih_io_done(struct MPT3SAS_ADAPTER *ioc, u16 smid, u8 msix_index, u32 reply)
> >  	}
> > 
> >  	xfer_cnt = le32_to_cpu(mpi_reply->TransferCount);
> > +
> > +	/* In case of bogus fw or device, we could end up having
> > +	 * unaligned partial completion. We can force alignment here,
> > +	 * then scsi-ml does not need to handle this misbehavior.
> > +	 */
> > +	sector_sz = scmd->device->sector_size;
> > +	req = scmd->request;
> > +	if (unlikely(sector_sz && req && (req->cmd_type == REQ_TYPE_FS) &&
> > +		    (xfer_cnt % sector_sz))) {
> > 
> > Maybe a bit zealous on the sanity checking...
> 
> A bit...? heheh
> Too much I'd say. Since this is dealing with a bogus FW scenario, I
> found more safe to check everything...of course we can remove checks if
> it's sure req isn't NULL ever. The sector_sz check is avoiding
> degenerate cases, since our division below.
> 
> 
> > 
> > +		sdev_printk(KERN_INFO, scmd->device,
> > +			"unaligned partial completion avoided (xfer_cnt=%u, sector_sz=%u)\n",
> > +			xfer_cnt, sector_sz);
> > +		xfer_cnt = (xfer_cnt / sector_sz) * sector_sz;
> > 
> > Not so keen on divisions. xfer_cnt = round_down(xfer_cnt, sector_sz), maybe?
> >
> 
> Martin, I might be completely wrong here (please correct me if this is
> the case), but isn't C standard integer division a truncation that acts
> like a round down? I checked (what I think is) the specification of C
> language (ISO/IEC 9899:1999), and it seems the division proposed by Ram
> Pai is accurate in this case. Also, both variables are unsigned.

Guilherme,  Its better to use round_down() instead of division. Among
other things it saves a few nanoseconds.

RP

