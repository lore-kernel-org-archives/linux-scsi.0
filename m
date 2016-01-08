From: Bart Van Assche <bart.vanassche@sandisk.com>
Subject: Re: [PATCH 1/4] target: Obtain se_node_acl->acl_kref during
 get_initiator_node_acl
Date: Fri, 8 Jan 2016 09:31:14 +0100
Message-ID: <568F73D2.2090808@sandisk.com>
References: <1452237348-2277-1-git-send-email-nab@daterainc.com>
 <1452237348-2277-2-git-send-email-nab@daterainc.com>
 <20160108081412.GA32138@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8;
	format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <target-devel-owner@vger.kernel.org>
In-Reply-To: <20160108081412.GA32138@lst.de>
Sender: target-devel-owner@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>, "Nicholas A. Bellinger" <nab@daterainc.com>
Cc: target-devel <target-devel@vger.kernel.org>, linux-scsi <linux-scsi@vger.kernel.org>, lkml <linux-kernel@vger.kernel.org>, Sagi Grimberg <sagig@mellanox.com>, Hannes Reinecke <hare@suse.de>, Andy Grover <agrover@redhat.com>, Vasu Dev <vasu.dev@linux.intel.com>, Vu Pham <vu@mellanox.com>, Nicholas Bellinger <nab@linux-iscsi.org>
List-Id: linux-scsi@vger.kernel.org

On 01/08/2016 09:14 AM, Christoph Hellwig wrote:
>>   	mutex_lock(&tpg->acl_node_mutex);
>>   	acl =3D __core_tpg_get_initiator_node_acl(tpg, initiatorname);
>> +	/*
>> +	 * Obtain the acl_kref now, which will be dropped upon the
>> +	 * release of se_sess memory within transport_free_session().
>> +	 */
>> +	if (acl)
>> +		kref_get(&acl->acl_kref);
>
> =D0=86 think the comment is highly confusing as it's about one of the
> callers, while the function has many.
>
> I'd suggest you move it to core_tpg_check_initiator_node_acl instead.
>
> Also I think iscsit_build_sendtargets_response will need a put on
> the nacl, otherwise you'll leak references.

Indeed. All error paths in all target drivers will have to be modified=20
to avoid that an acl reference leak is triggered if=20
transport_init_session() fails after core_tpg_check_initiator_node_acl(=
)=20
succeeded.

Bart.
