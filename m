From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 4/7] scsi_dh: add EMC Clariion device handler
Date: Wed, 16 Apr 2008 11:29:00 -0500
Message-ID: <4806294C.9090703@cs.wisc.edu>
References: <20080416011818.19580.41106.sendpatchset@chandra-ubuntu>
	<20080416011842.19580.92056.sendpatchset@chandra-ubuntu>
Reply-To: device-mapper development <dm-devel@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <dm-devel-bounces@redhat.com>
In-Reply-To: <20080416011842.19580.92056.sendpatchset@chandra-ubuntu>
List-Unsubscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=unsubscribe>
List-Archive: <https://www.redhat.com/archives/dm-devel>
List-Post: <mailto:dm-devel@redhat.com>
List-Help: <mailto:dm-devel-request@redhat.com?subject=help>
List-Subscribe: <https://www.redhat.com/mailman/listinfo/dm-devel>,
	<mailto:dm-devel-request@redhat.com?subject=subscribe>
Sender: dm-devel-bounces@redhat.com
Errors-To: dm-devel-bounces@redhat.com
To: device-mapper development <dm-devel@redhat.com>
Cc: andmike@us.ibm.com, linux-scsi@vger.kernel.org, asson_ronald@emc.com, James.Bottomley@HansenPartnership.com, Benoit_Arthur@emc.com, jens.axboe@oracle.com, agk@redhat.com
List-Id: linux-scsi@vger.kernel.org

Chandra Seetharaman wrote:
> +
> +static int send_cmd(struct scsi_device *sdev, int cmd)
> +{
> +	struct request *rq = get_req(sdev, cmd);
> +
> +	if (!rq)
> +		return SCSI_DH_RES_TEMP_UNAVAIL;
> +
> +	return blk_execute_rq(sdev->request_queue, NULL, rq, 1);
> +}
> +

My only concerns are:

1. EMC and HP need to send a command to every device to transition them. 
Because we do blk_execute_rq from the dm multipath workqueue we can now 
only failover/failback for a couple devices at a time.

I am not sure if this is a big deal, because this the error handler path 
so it is going to be slower than the normal path. But it seems like 
customers are really picky about failover times and want them as fast as 
possible. If they have a couple hundred devices doing a couple at a time 
might be something that users see as a regression from the old code. I 
am not sure though. I just do not want the bugzillas when they come to 
work :)

2. EMC guys did you test the short vs long tress pass stuff? Do we need 
to add some code to handle the case where we send a short one, but we 
needed to send a long one. Is there some sense error or some inquiry 
data we can base this off of?
