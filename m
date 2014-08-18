From: Juergen Gross <jgross@suse.com>
Subject: Re: [Xen-devel] [PATCH V4 3/4] Introduce XEN scsiback module
Date: Mon, 18 Aug 2014 11:06:30 +0200
Message-ID: <53F1C216.9010109@suse.com>
References: <1407484194-31876-1-git-send-email-jgross@suse.com>	<1407484194-31876-4-git-send-email-jgross@suse.com>	<1407878022.27925.33.camel@haakon3.risingtidesystems.com>	<53EC7911.7040109@suse.com> <53EC8BE8.2030203@suse.com> <1408243108.30653.179.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1408243108.30653.179.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: linux-scsi@vger.kernel.org, JBottomley@parallels.com, xen-devel@lists.xen.org, hch@infradead.org, target-devel@vger.kernel.org, david.vrabel@citrix.com, JBeulich@suse.com
List-Id: linux-scsi@vger.kernel.org

On 08/17/2014 04:38 AM, Nicholas A. Bellinger wrote:
> On Thu, 2014-08-14 at 12:14 +0200, Juergen Gross wrote:
>> On 08/14/2014 10:53 AM, Juergen Gross wrote:
>>> Nicholas,
>>>
>>> just one more question (see below):
>>>
>>> On 08/12/2014 11:13 PM, Nicholas A. Bellinger wrote:
>>>> Hi Juergen & Co,
>>>>
>>>> Finally had a chance to review this code.  Comments are inline below..
>>>>
>>>> On Fri, 2014-08-08 at 09:49 +0200, jgross@suse.com wrote:
>>>
>>> ...
>>>
>>>>> +    if (IS_ERR(tv_nexus->tvn_se_sess)) {
>>>>> +        mutex_unlock(&tpg->tv_tpg_mutex);
>>>>> +        kfree(tv_nexus);
>>>>> +        return -ENOMEM;
>>>>> +    }
>>>>> +    se_sess = tv_nexus->tvn_se_sess;
>>>>> +    /*
>>>>> +     * Since we are running in 'demo mode' this call with generate a
>>>>> +     * struct se_node_acl for the scsiback struct se_portal_group with
>>>>> +     * the SCSI Initiator port name of the passed configfs group
>>>>> 'name'.
>>>>> +     */
>>>>> +    tv_nexus->tvn_se_sess->se_node_acl =
>>>>> core_tpg_check_initiator_node_acl(
>>>>> +                se_tpg, (unsigned char *)name);
>>>>> +    if (!tv_nexus->tvn_se_sess->se_node_acl) {
>>>>> +        mutex_unlock(&tpg->tv_tpg_mutex);
>>>>> +        pr_debug("core_tpg_check_initiator_node_acl() failed for %s\n",
>>>>> +             name);
>>>>> +        goto out;
>>>>> +    }
>>>
>>> Can I drop the call to core_tpg_check_initiator_node_acl() as well?
>>> Keeping it will result in failing to setup the nexus (which is to be
>>> expected IMHO).
>>
>> Obviously I can't. transport_lookup_cmd_lun() calls right at start
>> spin_lock_irqsave(&se_sess->se_node_acl->device_list_lock, flags);
>> resulting in a page fault...
>>
>> I guess the hint to just throw away all the node_acl related stuff has
>> to be adjusted somehow...
>>
>> So: what is needed, what can be removed?
>>
>
> The scsiback_make_nodeacl() + scsiback_drop_nodeacl() configfs callbacks
> can be safely dropped, along with scisback_ncal->iport_[wwpn,name].

Okay, thanks. This is working.

Juergen
