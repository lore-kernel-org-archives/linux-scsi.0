From: Mike Christie <michaelc@cs.wisc.edu>
Subject: Re: [PATCH 3/8] be2iscsi : Fix IRQ_Affinity support in driver.
Date: Sat, 01 Feb 2014 16:46:46 -0600
Message-ID: <52ED7956.6000901@cs.wisc.edu>
References: <1390979807-16718-1-git-send-email-Jayamohan.Kallickal@emulex.com> <1390979807-16718-3-git-send-email-Jayamohan.Kallickal@emulex.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from sabe.cs.wisc.edu ([128.105.6.20]:53239 "EHLO sabe.cs.wisc.edu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932453AbaBAWrJ (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Sat, 1 Feb 2014 17:47:09 -0500
In-Reply-To: <1390979807-16718-3-git-send-email-Jayamohan.Kallickal@emulex.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Jayamohan Kallickal <jayamohank@gmail.com>
Cc: jbottomley@parallels.com, linux-scsi@vger.kernel.org, Jayamohan Kallickal <jayamohan.kallickal@emulex.com>, John Soni Jose <sony.john-n@emulex.com>

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

It seems we set num_cpus in find_num_cpus. It can be the number of
online or some driver limited value. We then loop for (i = 0; i <
num_cpus i++). Above, then if the cpu is not online then you just set it
to the online cpu mask instead of a specific cpu.

Is it possible num_cpus can be 7, but it is possible the online cpus are
0 to 5 and 8. So, when you loop the last vec is set to all online cpus
instead of 8 when it is possible to set it to a specific cpu?

Do you want to be doing a for_each_online_cpu to loop instead?
