From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH] Add ALUA hardware handler
Date: Wed, 10 Oct 2007 13:45:02 -0500
Message-ID: <470D1DAE.1000900@cs.wisc.edu>
References: <470CCBB0.2020904@suse.de>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <470CCBB0.2020904@suse.de>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: Hannes Reinecke <hare@suse.de>
Cc: device-mapper development <dm-devel@redhat.com>, christophe varoqui <christophe.varoqui@free.fr>, SCSI Mailing List <linux-scsi@vger.kernel.org>, Alasdair G Kergon <agk@redhat.com>
List-Id: linux-scsi@vger.kernel.org

Hannes Reinecke wrote:
> Hi Alasdair,
> 
> this is a patch to add a SPC-3 hardware handler. SPC-3 ALUA has
> provisioning for 'explicit' port group state change via the
> SET TARGET GROUP STATES command, and some newer storage
> arrays do benefit from this.
> Eg HP EVAs and newer EMC Clariions already support explicit ALUA.
> 
> Please apply.
> 
> Cheers,
> 
> Hannes
> 

Does this also work for adaptec or snap iscsi targets or whatever they 
are called targets?



Just some quick higher level comments

+static int submit_std_inquiry(struct alua_handler *h)
+{
+	struct request *rq;
+	unsigned err = (DRIVER_ERROR << 24);
+
+	rq = prepare_req(h, h->inq, TPGS_INQUIRY_SIZE, READ);


I do not think you want to use GFP_KERNEL allocations in this path, so 
all the prepare_req allocs should be changed. GFP_NOIO is probably best.


+	if (!rq)
+		return err;
+
+	/* Prepare the command. */
+	rq->cmd[0] = INQUIRY;
+	rq->cmd[1] = 0;
+	rq->cmd[2] = 0;
+	rq->cmd[4] = TPGS_INQUIRY_SIZE;
+	rq->cmd_len = COMMAND_SIZE(INQUIRY);
+
+	blk_execute_rq(rq->q, NULL, rq, 1);

There is only one workqueue for all the dm devices, so you do not want 
to do one command (or how many processors there are) at a time and wait 
for each one to complete with blk_execute_rq. You should use the async 
one, blk_execute_rq_nowait, like rdac.

+	err = rq->errors;
+	blk_put_request(rq);
+
+	return err;
+}
