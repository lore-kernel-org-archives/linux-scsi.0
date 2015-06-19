From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 5/6] target: Send UA upon LUN RESET tmr completion
Date: Fri, 19 Jun 2015 15:07:41 +0200
Message-ID: <5584141D.1060400@suse.de>
References: <1434009689-112909-1-git-send-email-hare@suse.de> <1434009689-112909-6-git-send-email-hare@suse.de> <20150619130601.GB7783@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48267 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751154AbbFSNHn (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Jun 2015 09:07:43 -0400
In-Reply-To: <20150619130601.GB7783@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Nic Bellinger <nab@daterainc.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org

On 06/19/2015 03:06 PM, Christoph Hellwig wrote:
> On Thu, Jun 11, 2015 at 10:01:28AM +0200, Hannes Reinecke wrote:
>> SAM mandates that an BUS DEVICE RESET FUNCTION OCCURRED
>> UA needs to be send after a LUN RESET tmr has completed.
>>
>> Signed-off-by: Hannes Reinecke <hare@suse.de>
>> ---
>>  drivers/target/target_core_transport.c | 11 +++++++++++
>>  1 file changed, 11 insertions(+)
>>
>> diff --git a/drivers/target/target_core_transport.c b/drivers/target=
/target_core_transport.c
>> index a0e0d3a..bb60c0c4 100644
>> --- a/drivers/target/target_core_transport.c
>> +++ b/drivers/target/target_core_transport.c
>> @@ -3064,6 +3064,17 @@ static void target_tmr_work(struct work_struc=
t *work)
>>  		ret =3D core_tmr_lun_reset(dev, tmr, NULL, NULL);
>>  		tmr->response =3D (!ret) ? TMR_FUNCTION_COMPLETE :
>>  					 TMR_FUNCTION_REJECTED;
>> +		if (tmr->response =3D=3D TMR_FUNCTION_COMPLETE) {
>> +			struct se_dev_entry *deve;
>> +
>> +			rcu_read_lock();
>> +			deve =3D target_nacl_find_deve(cmd->se_sess->se_node_acl,
>> +						     cmd->orig_fe_lun);
>> +			if (deve)
>> +				core_scsi3_ua_allocate(deve, 0x29,
>> +					ASCQ_29H_BUS_DEVICE_RESET_FUNCTION_OCCURRED);
>> +			rcu_read_unlock();
>=20
> This should use the target_ua_allocate_lun helper.
>=20
Yep, will be doing so.

Cheers,

Hannes
--=20
Dr. Hannes Reinecke		               zSeries & Storage
hare@suse.de			               +49 911 74053 688
SUSE LINUX GmbH, Maxfeldstr. 5, 90409 N=FCrnberg
GF: F. Imend=F6rffer, J. Smithard, J. Guild, D. Upmanyu, G. Norton
HRB 21284 (AG N=FCrnberg)
--
To unsubscribe from this list: send the line "unsubscribe linux-scsi" i=
n
