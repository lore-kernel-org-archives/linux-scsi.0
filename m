From: Jayamohan Kallickal <Jayamohan.Kallickal@Emulex.Com>
Subject: RE: [PATCH 3/8] be2iscsi : Fix IRQ_Affinity support in driver.
Date: Wed, 5 Feb 2014 05:09:15 +0000
Message-ID: <876b2b96-8c51-4b6d-ac3d-8d1f8985296d@CMEXHTCAS1.ad.emulex.com>
References: <1390979807-16718-1-git-send-email-Jayamohan.Kallickal@emulex.com>
 <1390979807-16718-3-git-send-email-Jayamohan.Kallickal@emulex.com>
 <52ED7956.6000901@cs.wisc.edu>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cmexedge2.ext.emulex.com ([138.239.224.100]:47791 "EHLO
	CMEXEDGE2.ext.emulex.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750906AbaBEFJT convert rfc822-to-8bit (ORCPT
	<rfc822;linux-scsi@vger.kernel.org>); Wed, 5 Feb 2014 00:09:19 -0500
In-Reply-To: <52ED7956.6000901@cs.wisc.edu>
Content-Language: en-US
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Mike Christie <michaelc@cs.wisc.edu>, Jayamohan Kallickal <jayamohank@gmail.com>
Cc: "jbottomley@parallels.com" <jbottomley@parallels.com>, "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>, Sony John-N <Sony.John-N@Emulex.Com>



-----Original Message-----
From: Mike Christie [mailto:michaelc@cs.wisc.edu] 
Sent: Saturday, February 01, 2014 2:47 PM
To: Jayamohan Kallickal
Cc: jbottomley@parallels.com; linux-scsi@vger.kernel.org; Jayamohan Kallickal; Sony John-N
Subject: Re: [PATCH 3/8] be2iscsi : Fix IRQ_Affinity support in driver.

On 01/29/2014 01:16 AM, Jayamohan Kallickal wrote:
> +
> +	if (msix_vec) {
> +		if (cpu_online(cpu_index))
> +			cpumask_set_cpu(cpu_index,
> +					&phba->msix_cpu_map[
> +					cpu_index].affinity_mask);
> +		else
> +			cpumask_copy(&phba->msix_cpu_map[
> +				     cpu_index].affinity_mask,
> +				     cpu_online_mask);
> +

I think this code works, but I am not sure if this what you wanted to do.

It seems we set num_cpus in find_num_cpus. It can be the number of online or some driver limited value. We then loop for (i = 0; i < num_cpus i++). Above, then if the cpu is not online then you just set it to the online cpu mask instead of a specific cpu.

Is it possible num_cpus can be 7, but it is possible the online cpus are
0 to 5 and 8. So, when you loop the last vec is set to all online cpus instead of 8 when it is possible to set it to a specific cpu?

Do you want to be doing a for_each_online_cpu to loop instead?


Yes, the original code  could have the behavior you had explained.

I want to rewrite that portion  and will send this as as part of the next patchset.

For now, I want to withdraw this patch i.e PATCH 3/8.

Thanks
Jay

--l 
