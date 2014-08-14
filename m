From: Juergen Gross <jgross@suse.com>
Subject: Re: Re: [Xen-devel] [PATCH V4 3/4] Introduce XEN scsiback module
Date: Thu, 14 Aug 2014 10:53:37 +0200
Message-ID: <53EC7911.7040109@suse.com>
References: <1407484194-31876-1-git-send-email-jgross@suse.com>	<1407484194-31876-4-git-send-email-jgross@suse.com> <1407878022.27925.33.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:52716 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754773AbaHNIxm (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Thu, 14 Aug 2014 04:53:42 -0400
In-Reply-To: <1407878022.27925.33.camel@haakon3.risingtidesystems.com>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi@vger.kernel.org, JBottomley@parallels.com, xen-devel@lists.xen.org, hch@infradead.org, target-devel@vger.kernel.org, david.vrabel@citrix.com, JBeulich@suse.com

Nicholas,

just one more question (see below):

On 08/12/2014 11:13 PM, Nicholas A. Bellinger wrote:
> Hi Juergen & Co,
>
> Finally had a chance to review this code.  Comments are inline below..
>
> On Fri, 2014-08-08 at 09:49 +0200, jgross@suse.com wrote:

...

>> +	if (IS_ERR(tv_nexus->tvn_se_sess)) {
>> +		mutex_unlock(&tpg->tv_tpg_mutex);
>> +		kfree(tv_nexus);
>> +		return -ENOMEM;
>> +	}
>> +	se_sess = tv_nexus->tvn_se_sess;
>> +	/*
>> +	 * Since we are running in 'demo mode' this call with generate a
>> +	 * struct se_node_acl for the scsiback struct se_portal_group with
>> +	 * the SCSI Initiator port name of the passed configfs group 'name'.
>> +	 */
>> +	tv_nexus->tvn_se_sess->se_node_acl = core_tpg_check_initiator_node_acl(
>> +				se_tpg, (unsigned char *)name);
>> +	if (!tv_nexus->tvn_se_sess->se_node_acl) {
>> +		mutex_unlock(&tpg->tv_tpg_mutex);
>> +		pr_debug("core_tpg_check_initiator_node_acl() failed for %s\n",
>> +			 name);
>> +		goto out;
>> +	}

Can I drop the call to core_tpg_check_initiator_node_acl() as well?
Keeping it will result in failing to setup the nexus (which is to be
expected IMHO).

I suppose the name of the nexus is just for reference and should be
stored somewhere to be able to print it in _show_nexus()?


Juergen

