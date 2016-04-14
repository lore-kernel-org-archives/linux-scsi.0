From: Dan Carpenter <dan.carpenter@oracle.com>
Subject: Re: [patch] scsi_dh_alua: uninitialized variable in alua_rtpg()
Date: Thu, 14 Apr 2016 21:20:49 +0300
Message-ID: <20160414182049.GG4247@mwanda>
References: <20160414093917.GA16891@mwanda>
 <570FBB0E.9030902@sandisk.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <570FBB0E.9030902@sandisk.com>
Sender: linux-kernel-owner@vger.kernel.org
To: Bart Van Assche <bart.vanassche@sandisk.com>
Cc: "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, Hannes Reinecke <hare@suse.de>, Johannes Thumshirn <jthumshirn@suse.de>, Ewan Milne <emilne@redhat.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Thu, Apr 14, 2016 at 08:45:18AM -0700, Bart Van Assche wrote:
> On 04/14/2016 02:39 AM, Dan Carpenter wrote:
> >It's possible to use "err" without initializing it.  If it happens to be
> >a 2 which is SCSI_DH_RETRY then that could cause a bug.
> >
> >Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> >
> >diff --git a/drivers/scsi/device_handler/scsi_dh_alua.c b/drivers/scsi/device_handler/scsi_dh_alua.c
> >index 8eaed05..f3c994f 100644
> >--- a/drivers/scsi/device_handler/scsi_dh_alua.c
> >+++ b/drivers/scsi/device_handler/scsi_dh_alua.c
> >@@ -513,7 +513,8 @@ static int alua_rtpg(struct scsi_device *sdev, struct alua_port_group *pg)
> >  	struct alua_port_group *tmp_pg;
> >  	int len, k, off, valid_states = 0, bufflen = ALUA_RTPG_SIZE;
> >  	unsigned char *desc, *buff;
> >-	unsigned err, retval;
> >+	unsigned int err = 0;
> >+	unsigned int retval;
> >  	unsigned int tpg_desc_tbl_off;
> >  	unsigned char orig_transition_tmo;
> >  	unsigned long flags;
> 
> Hello Dan,
> 
> The code that uses the 'err' variable occurs in a loop. I think the
> initialization of 'err' should occur after the "retry:" label.

It looks like you're right.  I'll resend.  I don't know this code very
well, obviously and it's a static checker fix not something I have
tested.

regards,
dan carpenter
