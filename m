From: Johannes Thumshirn <jthumshirn@suse.de>
Subject: Re: Uninitialized variable in bfad_im_bsg_els_ct_request
Date: Mon, 9 Jan 2017 09:54:52 +0100
Message-ID: <20170109085452.GA3711@linux-x5ow.site>
References: <a79c1e83-d5d4-ae9b-083c-ca72c3d8c62a@m4x.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <a79c1e83-d5d4-ae9b-083c-ca72c3d8c62a@m4x.org>
Sender: linux-kernel-owner@vger.kernel.org
To: Nicolas Iooss <nicolas.iooss_linux@m4x.org>
Cc: Anil Gurumurthy <anil.gurumurthy@qlogic.com>, Sudarsana Kalluru <sudarsana.kalluru@qlogic.com>, "James E.J. Bottomley" <jejb@linux.vnet.ibm.com>, "Martin K. Petersen" <martin.petersen@oracle.com>, linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org

On Sun, Dec 18, 2016 at 09:44:27PM +0100, Nicolas Iooss wrote:
> Hello,
> 
> Currently on Linus master tree and in linux-next [1],
> bfad_im_bsg_els_ct_request() code starts with the following code:
> 
> int
> bfad_im_bsg_els_ct_request(struct bsg_job *job)
> {
> 	/*...*/
> 	struct fc_bsg_request *bsg_request = bsg_request;
> 	struct fc_bsg_reply *bsg_reply = job->reply;
> 	uint32_t command_type = bsg_request->msgcode;
> 
> The local variable "bsg_request" is initialized to itself (which would
> usually mean it is uninitialized) but it is dereferenced in order to get
> its "msgcode" field. As I am quite new to the kernel code and
> dereferencing self-initialized local variables looks black magic to me,
> could you please describe why this code is valid?
> 
> It has recently been introduced by commit 01e0e15c8b3b ("scsi: don't use
> fc_bsg_job::request and fc_bsg_job::reply directly").
> 
> Thanks,
> Nicolas Iooss
> 
> [1]
> https://git.kernel.org/cgit/linux/kernel/git/next/linux-next.git/tree/drivers/scsi/bfa/bfad_bsg.c?id=06548160dfecd1983ffd9d6795242a5cda095da5#n3356

Yes this is wrong. bsg_request should point to job->request:

diff --git a/drivers/scsi/bfa/bfad_bsg.c b/drivers/scsi/bfa/bfad_bsg.c
index a9a0016..b2e8c0d 100644
--- a/drivers/scsi/bfa/bfad_bsg.c
+++ b/drivers/scsi/bfa/bfad_bsg.c
@@ -3363,7 +3363,7 @@ struct bfad_buf_info *
        struct bfad_fcxp    *drv_fcxp;
        struct bfa_fcs_lport_s *fcs_port;
        struct bfa_fcs_rport_s *fcs_rport;
-       struct fc_bsg_request *bsg_request = bsg_request;
+       struct fc_bsg_request *bsg_request = job->request;
        struct fc_bsg_reply *bsg_reply = job->reply;
        uint32_t command_type = bsg_request->msgcode;
        unsigned long flags;

I'll send out an official patch soon, thanks for the report.
	Johannes

-- 
Johannes Thumshirn                                          Storage
jthumshirn@suse.de                                +49 911 74053 689
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 Nürnberg
GF: Felix Imendörffer, Jane Smithard, Graham Norton
HRB 21284 (AG Nürnberg)
Key fingerprint = EC38 9CAB C2C4 F25D 8600 D0D0 0393 969D 2D76 0850
