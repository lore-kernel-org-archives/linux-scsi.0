From: Matthew Wilcox <willy@infradead.org>
Subject: Re: [PATCH -next] advansys: remove set but not used variable
 'srb_tag' in adv_isr_callback
Date: Wed, 17 Oct 2018 06:00:22 -0700
Message-ID: <20181017130022.GA3575@bombadil.infradead.org>
References: <20181017123432.18304-1-yuehaibing@huawei.com>
 <4950b4fe-61b5-e1c3-9d16-7643107857a5@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <4950b4fe-61b5-e1c3-9d16-7643107857a5@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
To: Johannes Thumshirn <jthumshirn@suse.de>
Cc: YueHaibing <yuehaibing@huawei.com>, hare@suse.com, jejb@linux.vnet.ibm.com, martin.petersen@oracle.com, linux-kernel@vger.kernel.org, linux-scsi@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Wed, Oct 17, 2018 at 02:49:50PM +0200, Johannes Thumshirn wrote:
> On 17/10/18 14:34, YueHaibing wrote:
> > -	srb_tag = le32_to_cpu(scsiqp->srb_tag);
> >  	scp = scsi_host_find_tag(boardp->shost, scsiqp->srb_tag);
> 
> Shouldn't this be:
> 	scp = scsi_host_find_tag(boardp->shost,
> 					le32_to_cpu(scsiqp->srb_tag));

I don't think so.  Look at how scsiqp->srb_tag is set:

 adv_build_req(struct asc_board *boardp, struct scsi_cmnd *scp,
              ADV_SCSI_REQ_Q **adv_scsiqpp)
 {
+       u32 srb_tag = scp->request->tag;
...
+       scsiqp->srb_tag = srb_tag;

If we're not converting it to le32 on the way in, we probably don't want
to convert it back on the way out.

Please don't make me power up my PA-RISC machine with an Advansys card
in it, just to find out ...
