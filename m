From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH 1/4] sas: add flag for locally attached PHYs
Date: Wed, 19 Oct 2005 17:00:03 -0400
Message-ID: <4356B3D3.1010203@adaptec.com>
References: <91888D455306F94EBD4D168954A9457C048F08AE@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:10442 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S1751340AbVJSVAP (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Wed, 19 Oct 2005 17:00:15 -0400
In-Reply-To: <91888D455306F94EBD4D168954A9457C048F08AE@nacos172.co.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Cc: Christoph Hellwig <hch@lst.de>, jejb@steeleye.com, linux-scsi@vger.kernel.org

On 10/19/05 16:08, Moore, Eric Dean wrote:
> Luben:  He is adding support for linkerrors and link/phy reset;
> these for for CSMI/SDI API.
> 
> Can you in your driver retreive link errors for the links on the expanders?

Yes. (offloaded to user space)

You use the user space program called "expander_conf.c" to
send SMP requests and receive SMP responses.

An example output of "expander_conf.c" for a domain
is shown here: (everything you want to know about expanders):

http://linux.adaptec.com/sas/Announce_2.txt

The domain of the above is shown here:

http://linux.adaptec.com/sas/Announce_1.txt

> Same question for sending link and phy resets for expander phys? 

Yes, for both local phys and domain device phys, any device
claiming an SMP port.

Local phys
----------

If the LLDD provides this, it fills out the function stub:

	/* Phy management */
	int (*lldd_control_phy)(struct sas_phy *, enum phy_func);

in the "struct sas_ha_struct" structure before it registers
with the SAS Transport Layer.  See include/scsi/sas/sas_class.h
drivers/scsi/aic94xx/aic94xx_init.c::asd_register_sas_ha(), and
drivers/scsi/sas/README.

(When the SAS LLDD (aic94xx) registers with the SAS Transport
 layer, it declares all the phys the HA has; this is in
 struct sas_ha_struct::struct sas_phy  **sas_phy;  This is so
 that the SAS Transport layer can control the phys to form
 ports, etc, as stipulated in
 http://linux.adaptec.com/sas/Announce_0.txt.)

Then you do:

	sas_ha->lldd_control_phy(phy, func);

where,

	struct sas_ha_struct *sas_ha;
	struct sas_phy *phy;
	enum   phy_func func;

See
include/scsi/sas/sas.h and
include/scsi/sas/sas_class.h

Phys on Domain devices with an SMP port
---------------------------------------

Execute SCSI Command RPC is used to send
SMP tasks:

This is from drivers/scsi/sas/sas_expander.c:

<< line 480 >>
#define PC_REQ_SIZE  44
#define PC_RESP_SIZE 8

static int smp_phy_control(struct domain_device *dev, int phy_id,
			   enum phy_func phy_func)
{
	u8 *pc_req;
	u8 *pc_resp;
	int res;

	pc_req = alloc_smp_req(PC_REQ_SIZE);
	if (!pc_req)
		return -ENOMEM;

	pc_resp = alloc_smp_resp(PC_RESP_SIZE);
	if (!pc_resp) {
		kfree(pc_req);
		return -ENOMEM;
	}

	pc_req[1] = SMP_PHY_CONTROL;
	pc_req[9] = phy_id;
	pc_req[10]= phy_func;

	res = smp_execute_task(dev, pc_req, PC_REQ_SIZE, pc_resp,PC_RESP_SIZE);

	kfree(pc_resp);
	kfree(pc_req);
	return res;
}

Then you can look up the implementation of

static int smp_execute_task(struct domain_device *dev, void *req, int req_size,
			    void *resp, int resp_size)

on line 175 of drivers/scsi/sas/sas_expander.c, and you can follow
it up to
	task->dev->port->ha->lldd_execute_task(task, 1, GFP_KERNEL);

where lldd_execute_task() is implemented in
drivers/scsi/aic94xx/aic94xx_task.c, on line 555:

int asd_execute_task(struct sas_task *task, const int num,
		     unsigned long gfp_flags)

which immediately sends the task out on the interconnect.

(Nugget: "dev->port" doesn't _necessarily_ mean that
 "dev" /formed/ "port", but that "dev" is reachable
 /through/ "port". "dev" may or may not form "port".)

> If so, then perhaps that check should be removed, and lets let the lld
> decide whether these attibutes should return -EINVAL.

In the SAS Transport Layer, all this has been off loaded to user space.
See drivers/scsi/sas/README "Expander management from User Space"
section (bottom of file).

> For fusion, these new attributes only work for the phys on the hba.

For aic94xx, these attributes are supported for any SMP port,
i.e. local phys and any phys out there which claim SMP.

> The problem is the firmware implmentation for `link errors and 
> link/phy reset` is addressed only by the phy identifier for the phys
> attacted directly on the host adapter.  Doesn't work for phys on
> the expander. 

What you need is a general facility to send SMP tasks.

See drivers/scsi/sas/sas_expander.c,
    include/scsi/sas/sas_task.h      and
    drivers/scsi/aic94xx/aic94xx_task.c

>>You don't need to represent that.  While you can, you 
>>completely do not
>>need to do it.  All you should care about is the _port_.  Take a look
>>at SAS section 4.
>>
>>Also take a look at:
>>drivers/scsi/sas/sas_phy.c,
>>drivers/scsi/sas/sas_port.c and
>>drivers/scsi/sas/sas_discover.c .
> 
> 
> What and where can I get this?

http://linux.adaptec.com/sas/
Also see my sig.

	Luben
-- 
http://linux.adaptec.com/sas/
http://www.adaptec.com/sas/
