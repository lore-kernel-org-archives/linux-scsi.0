From: Luben Tuikov <luben_tuikov@adaptec.com>
Subject: Re: [PATCH 1/4] sas: add flag for locally attached PHYs
Date: Thu, 20 Oct 2005 11:55:45 -0400
Message-ID: <4357BE01.5060501@adaptec.com>
References: <91888D455306F94EBD4D168954A9457C048F0E34@nacos172.co.lsil.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from magic.adaptec.com ([216.52.22.17]:38554 "EHLO magic.adaptec.com")
	by vger.kernel.org with ESMTP id S932344AbVJTPzu (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>);
	Thu, 20 Oct 2005 11:55:50 -0400
In-Reply-To: <91888D455306F94EBD4D168954A9457C048F0E34@nacos172.co.lsil.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Moore, Eric Dean" <Eric.Moore@lsil.com>
Cc: Christoph Hellwig <hch@lst.de>, jejb@steeleye.com, linux-scsi@vger.kernel.org

On 10/20/05 11:25, Moore, Eric Dean wrote:
> 
> I had a very good discussion with Luben over the 
> phone last night.
> 
> Luben clarified this for me in regards to expanders:
> 
> http://www.t10.org/drafts.htm#sas2 
> The linkerrors can be done by issuing a SMP passthru
> sending SMP_REPORT_ERROR_LOG. Section 10.4.3.6

Example of it being used is shown in this user space program
drivers/scsi/sas/expanders_conf.c:343:
static int report_phy_error_log(char *smp_portal_name, int phy_id)

> The link/phy reset can be done by issuing a SMP passthru
> sending SMP_PHY_CONTROL. Section 10.4.3.10

Example of it being use is shown in
drivers/scsi/sas/sas_expander.c:484:
static int smp_phy_control(struct domain_device *dev, int phy_id,
			   enum phy_func phy_func)

> The mpt fusion f/w supports smp passthru, and we could for
> these attributes do SMP passthru if we wanted to return
> this data for expanders.

> Our f/w only provides a easy special 
> wrapper config page for hba phys.

And this is correct in in line with SDI/SAS.

This method can be used by drivers/scsi/sdi.c.
And it fits both yours and our simplementation.

Dispatching to your implementation would go to FW, whose
interface you'll have to implement.  Remember you have
2 tasks: drivers/scsi/sdi.c and the FW dependent way
of dispatching this to the FW for LSI.

As to ours, it would go to

	/* Phy management */
	int (*lldd_control_phy)(struct sas_phy *, enum phy_func);

function stub in the of the sas_ha_struct structure as I showed
yesterday in this thread.

> For expanders, we
> are going to have to do smp passthru.

Makes sense.

> So Christoph what should we do in driver?  Ignore returning
> data for expanders?  
> 
> Luben suggestion(correct me if I'm wrong) is this should be 
> done thru user space, instead of exporting this in the 
> /sys/class/sas_phy attributes.  Thus we need to export a 
> SMP_PASSTHRU mechanism.  I believe there is discussion
> by Christoph ( and I believe Luben backs this idea) of doing 
> all this thru the /dev/sg interface.

sg would be a good choice if the ioctl headers can be "translated"
easily into sg headers -- this would make the whole task
so much easier and straightforward.

	Luben
-- 
http://linux.adaptec.com/sas/
http://www.adaptec.com/sas/
