From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: [PATCH 2/4] scsi: bfa: remove ScsiResult macro
Date: Fri, 6 Jul 2018 10:08:38 +0200
Message-ID: <20180706080838.gxdevbhsx2sxl5ou@linux-x5ow.site>
References: <20180705110140.19545-1-jthumshirn@suse.de>
 <20180705110140.19545-3-jthumshirn@suse.de>
 <1f5d6a4266daabfd49bad726f17524d80fdab524.camel@wdc.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1f5d6a4266daabfd49bad726f17524d80fdab524.camel@wdc.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <Bart.VanAssche@wdc.com>
Cc: "martin.petersen@oracle.com" <martin.petersen@oracle.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
List-Id: linux-scsi@vger.kernel.org

On Thu, Jul 05, 2018 at 05:00:10PM +0000, Bart Van Assche wrote:
> On Thu, 2018-07-05 at 13:01 +0200, Johannes Thumshirn wrote:
> > -	cmnd->result = ScsiResult(DID_OK, SCSI_STATUS_GOOD);
> > +	cmnd->result = DID_OK << 16 | SCSI_STATUS_GOOD;
> 
> Please consider to remove the SCSI_STATUS_GOOD constant since it is
> non-standard and since it used by the bfa driver only. Additionally, since
> SCSI_STATUS_GOOD == 0, please leave out "| SCSI_STATUS_GOOD".

Can we agree on using SAM_STAT_GOOD here? I really don't want to leave
out the trailing "| 0" parts in this stage of the refactoring yet. I'm
still undecided if I don't want a set_scsi_cmnd_status(cmnd, foo, bar,
baz, frob); function in an intermediate step.

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
