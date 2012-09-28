From: James Bottomley <James.Bottomley@HansenPartnership.com>
Subject: Re: [PATCH scsi] Short the path length of scsi_cmd_to_driver()
Date: Fri, 28 Sep 2012 08:45:32 +0100
Message-ID: <1348818332.2411.6.camel@dabdike.int.hansenpartnership.com>
References: <1348464626.2475.13.camel@ThinkPad-T420>
	 <1348465493.2467.3.camel@dabdike> <1348470210.2475.47.camel@ThinkPad-T420>
	 <1348472104.2467.8.camel@dabdike> <yq13924b4uw.fsf@sermon.lab.mkp.net>
	 <1348721055.2509.0.camel@dabdike> <1348739495.3596.55.camel@ThinkPad-T420>
	 <yq1a9wb8iq1.fsf@sermon.lab.mkp.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <yq1a9wb8iq1.fsf@sermon.lab.mkp.net>
Sender: linux-kernel-owner@vger.kernel.org
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Li Zhong <zhong@linux.vnet.ibm.com>, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

On Thu, 2012-09-27 at 13:43 -0400, Martin K. Petersen wrote:
> >>>>> "Li" == Li Zhong <zhong@linux.vnet.ibm.com> writes:
> 
> > @@ -845,8 +844,11 @@ static int scsi_send_eh_cmnd(struct scsi_cmnd *scmd, unsigned char *cmnd,
> > 
> > 	scsi_eh_restore_cmnd(scmd, &ses);
> > 
> >-	if (sdrv && sdrv->eh_action)
> >-		rtn = sdrv->eh_action(scmd, cmnd, cmnd_size, rtn);
> >+	if (scmd->request->cmd_type == REQ_TYPE_FS) {
> >+		struct scsi_driver *sdrv = scsi_cmd_to_driver(scmd);
> >+		if (sdrv->eh_action)
> >+			rtn = sdrv->eh_action(scmd, cmnd, cmnd_size, rtn);
> >+	}
> > 
> > 	return rtn;
> > }
> 
> My only concern is whether our device lifetime rules guarantee that the
> ULD is always attached when we service an error handling command?

Yes, they are.  We can only get REQ_TYPE_FS through a filesystem, which
must be mounted on a block device, which is provided by the ULD.  You
can't unmount with outstanding I/O (which people complain about when it
goes into error handling, I'll admit), so the ULD has to stay bound.

James
