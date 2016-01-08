From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 4/4] ib_srpt: Convert acl lookup to modern
 get_initiator_node_acl usage
Date: Fri, 8 Jan 2016 10:35:35 +0100
Message-ID: <568F82E7.4020006@sandisk.com>
References: <1452237348-2277-1-git-send-email-nab@daterainc.com>
 <1452237348-2277-5-git-send-email-nab@daterainc.com>
 <568F78DB.9090404@sandisk.com>
 <1452244633.27508.21.camel@haakon3.risingtidesystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <1452244633.27508.21.camel@haakon3.risingtidesystems.com>
Sender: target-devel-owner@vger.kernel.org
To: "Nicholas A. Bellinger" <nab@linux-iscsi.org>
Cc: "Nicholas A. Bellinger" <nab@daterainc.com>, target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Sagi Grimberg <sagig@mellanox.com>, Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>, Andy Grover <agrover@redhat.com>, Vasu Dev <vasu.dev@linux.intel.com>, Vu Pham <vu@mellanox.com>
List-Id: linux-scsi@vger.kernel.org

On 01/08/2016 10:17 AM, Nicholas A. Bellinger wrote:
> On Fri, 2016-01-08 at 09:52 +0100, Bart Van Assche wrote:
>> On 01/08/2016 08:15 AM, Nicholas A. Bellinger wrote:
>>> @@ -2574,24 +2558,18 @@ static int srpt_cm_req_recv(struct ib_cm_id *cm_id,
>>>
>>>    	pr_debug("registering session %s\n", ch->sess_name);
>>>
>>> -	nacl = srpt_lookup_acl(sport, ch->i_port_id);
>>> -	if (!nacl) {
>>> +	se_acl = core_tpg_get_initiator_node_acl(&sport->port_tpg_1, ch->sess_name);
>>> +	if (!se_acl) {
>>>    		pr_info("Rejected login because no ACL has been"
>>>    			" configured yet for initiator %s.\n", ch->sess_name);
>>>    		rej->reason = cpu_to_be32(
>>> -			      SRP_LOGIN_REJ_CHANNEL_LIMIT_REACHED);
>>> +				SRP_LOGIN_REJ_CHANNEL_LIMIT_REACHED);
>>> +		transport_free_session(ch->sess);
>>>    		goto destroy_ib;
>>>    	}
>>> +	ch->sess->se_node_acl = se_acl;
>>
>> This is a backwards-incompatible change. Today the ib_srpt target driver
>> accepts initiator port names with and without leading "0x". With this
>> change the "0x" prefix becomes mandatory.
>
> The internally ib_srpt formatted ch->sess_name already needs to match
> se_node_acl->initiatorname for se_node_acl->acl_group configfs group
> shutdown reference..
>
> How does this patch become a backworks-incompatible change for that..?

Hello Nic,

Personally I'm not that worried about this change but I wanted to report 
it anyway. The current algorithm is as follows:
- When a directory is created in configfs for an initiator, the
   initiator name is parsed and stored in binary form in struct
   srpt_node_acl. The parsing function accepts both initiator
   names that start with a "0x" prefix and initiator names that
   do not have that prefix.
- During login the initiator port ID provided by the initiator in
   the SRP login request is compared with the binary initiator port ID
   in struct srpt_node_acl.

The patch at the start of this e-mail thread changes this behavior 
because core_tpg_get_initiator_node_acl() looks up the initiator port ID 
in a list that contains the ASCII representations of the initiator port 
ID. This means that the initiator port name will only be found by 
core_tpg_get_initiator_node_acl() if the name format used in the mkdir 
command matches the initiator name format used by the 
core_tpg_get_initiator_node_acl() caller, this means with "0x" prefix.

Bart.

Bart.
