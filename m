From: "Martin K. Petersen" <martin.petersen@oracle.com>
Subject: Re: [PATCH scsi] Short the path length of scsi_cmd_to_driver()
Date: Thu, 27 Sep 2012 13:43:18 -0400
Message-ID: <yq1a9wb8iq1.fsf@sermon.lab.mkp.net>
References: <1348464626.2475.13.camel@ThinkPad-T420>
	<1348465493.2467.3.camel@dabdike>
	<1348470210.2475.47.camel@ThinkPad-T420>
	<1348472104.2467.8.camel@dabdike> <yq13924b4uw.fsf@sermon.lab.mkp.net>
	<1348721055.2509.0.camel@dabdike>
	<1348739495.3596.55.camel@ThinkPad-T420>
Mime-Version: 1.0
Content-Type: text/plain
Return-path: <linux-kernel-owner@vger.kernel.org>
In-Reply-To: <1348739495.3596.55.camel@ThinkPad-T420> (Li Zhong's message of
	"Thu, 27 Sep 2012 17:51:35 +0800")
Sender: linux-kernel-owner@vger.kernel.org
To: Li Zhong <zhong@linux.vnet.ibm.com>
Cc: James Bottomley <James.Bottomley@hansenpartnership.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, LKML <linux-kernel@vger.kernel.org>, linux-scsi@vger.kernel.org, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
List-Id: linux-scsi@vger.kernel.org

>>>>> "Li" == Li Zhong <zhong@linux.vnet.ibm.com> writes:

> @@ -845,8 +844,11 @@ static int scsi_send_eh_cmnd(struct scsi_cmnd *scmd, unsigned char *cmnd,
> 
> 	scsi_eh_restore_cmnd(scmd, &ses);
> 
>-	if (sdrv && sdrv->eh_action)
>-		rtn = sdrv->eh_action(scmd, cmnd, cmnd_size, rtn);
>+	if (scmd->request->cmd_type == REQ_TYPE_FS) {
>+		struct scsi_driver *sdrv = scsi_cmd_to_driver(scmd);
>+		if (sdrv->eh_action)
>+			rtn = sdrv->eh_action(scmd, cmnd, cmnd_size, rtn);
>+	}
> 
> 	return rtn;
> }

My only concern is whether our device lifetime rules guarantee that the
ULD is always attached when we service an error handling command?

-- 
Martin K. Petersen	Oracle Linux Engineering
