From: Hannes Reinecke <hare@suse.de>
Subject: Re: [PATCH 4/6] target: Send UA on ALUA target port group change
Date: Fri, 19 Jun 2015 15:09:34 +0200
Message-ID: <5584148E.5050503@suse.de>
References: <1434009689-112909-1-git-send-email-hare@suse.de> <1434009689-112909-5-git-send-email-hare@suse.de> <20150619130519.GA7783@lst.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: QUOTED-PRINTABLE
Return-path: <linux-scsi-owner@vger.kernel.org>
Received: from cantor2.suse.de ([195.135.220.15]:48545 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752829AbbFSNJg (ORCPT <rfc822;linux-scsi@vger.kernel.org>);
	Fri, 19 Jun 2015 09:09:36 -0400
In-Reply-To: <20150619130519.GA7783@lst.de>
Sender: linux-scsi-owner@vger.kernel.org
List-Id: linux-scsi@vger.kernel.org
To: Christoph Hellwig <hch@lst.de>
Cc: Nic Bellinger <nab@daterainc.com>, target-devel@vger.kernel.org, linux-scsi@vger.kernel.org

On 06/19/2015 03:05 PM, Christoph Hellwig wrote:
>> --- a/drivers/target/target_core_alua.c
>> +++ b/drivers/target/target_core_alua.c
>> @@ -1880,12 +1880,19 @@ static void core_alua_put_tg_pt_gp_from_name=
(
>>  static void __target_attach_tg_pt_gp(struct se_lun *lun,
>>  		struct t10_alua_tg_pt_gp *tg_pt_gp)
>>  {
>> +	struct se_dev_entry *se_deve;
>> +
>>  	assert_spin_locked(&lun->lun_tg_pt_gp_lock);
>> =20
>>  	spin_lock(&tg_pt_gp->tg_pt_gp_lock);
>>  	lun->lun_tg_pt_gp =3D tg_pt_gp;
>>  	list_add_tail(&lun->lun_tg_pt_gp_link, &tg_pt_gp->tg_pt_gp_lun_lis=
t);
>>  	tg_pt_gp->tg_pt_gp_members++;
>> +	spin_lock_bh(&lun->lun_deve_lock);
>> +	list_for_each_entry(se_deve, &lun->lun_deve_list, lun_link)
>> +		core_scsi3_ua_allocate(se_deve, 0x3f,
>> +				       ASCQ_3FH_INQUIRY_DATA_HAS_CHANGED);
>> +	spin_unlock_bh(&lun->lun_deve_lock);
>>  	spin_unlock(&tg_pt_gp->tg_pt_gp_lock);
>=20
> Taking a _bh lock inside a regular spinlock is completely broken.
>=20
> Fortunately I don't think lun_deve_lock needs to disable bottom halve=
s,
> but this needs to be fixed first.
>=20
This harks back to my previous mail:
Under which circumstances will there be more than one se_dev_entry
structures in lun_deve_list?
Isn't there a 1:1 relationship?

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
